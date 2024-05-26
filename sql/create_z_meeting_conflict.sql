CREATE OR REPLACE FUNCTION check_new_weekly_meeting_conflict() RETURNS TRIGGER AS $$
DECLARE
    conflicting_weekly_meeting_a VARCHAR(20);
    conflicting_weekly_meeting_b VARCHAR(20);
    conflicting_weekly_review_meeting_a VARCHAR(20);
    conflicting_weekly_review_meeting_b VARCHAR(20);
BEGIN
    -- Check for weekly meeting conflicts
    SELECT wm1.section_id, NEW.section_id INTO conflicting_weekly_meeting_a, conflicting_weekly_meeting_b
        FROM weekly_meeting wm1
        WHERE wm1.day_of_week = NEW.day_of_week 
            AND (
                (NEW.section_id = wm1.section_id AND wm1.meeting_type <> NEW.meeting_type) 
                OR (NEW.section_id <> wm1.section_id AND wm1.location = NEW.location)
            ) AND (wm1.start_time, wm1.end_time) OVERLAPS (NEW.start_time, NEW.end_time);

    -- Check for weekly meeting conflicts with review meetings
    WITH day_mappings AS (
        SELECT unnest(ARRAY['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) AS day_name,
            generate_series(1, 7) AS day_number
    ),
    weekly_meeting_times as (SELECT NEW.section_id, t.day::date, NEW.start_time, NEW.end_time, NEW.location
        FROM generate_series(
            NEW.start_date + ((((SELECT day_number FROM day_mappings WHERE day_name::day_enum = NEW.day_of_week) - EXTRACT(DOW FROM NEW.start_date) + 7) % 7) || ' days')::interval,
            NEW.end_date, interval  '1 week') AS t(day)
        order by t.day::date
    )
    SELECT wmt.section_id, rm.section_id INTO conflicting_weekly_review_meeting_a, conflicting_weekly_review_meeting_b
    FROM weekly_meeting_times wmt
    JOIN review_meeting rm ON wmt.location = rm.location OR wmt.section_id = rm.section_id
    WHERE (rm.start_time::time, rm.end_time::time) OVERLAPS (wmt.start_time, wmt.end_time)
        AND wmt.day = rm.start_time::date;

    IF conflicting_weekly_meeting_a IS NOT NULL AND conflicting_weekly_meeting_b IS NOT NULL THEN
        RAISE EXCEPTION 'A conflict between weekly meetings in % and % was detected.', conflicting_weekly_meeting_a, conflicting_weekly_meeting_b;
    ELSIF conflicting_weekly_review_meeting_a IS NOT NULL AND conflicting_weekly_review_meeting_b IS NOT NULL THEN
        RAISE EXCEPTION 'A conflict between weekly meetings and review meetings in % and % was detected.', conflicting_weekly_review_meeting_a, conflicting_weekly_review_meeting_b;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_new_review_meeting_conflict() RETURNS TRIGGER AS $$
DECLARE
    conflicting_weekly_review_meeting_a VARCHAR(20);
    conflicting_weekly_review_meeting_b VARCHAR(20);
    conflicting_review_meeting_a VARCHAR(20);
    conflicting_review_meeting_b VARCHAR(20);
BEGIN

    -- Check for weekly meeting conflicts with review meetings
    WITH day_mappings AS (
        SELECT unnest(ARRAY['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) AS day_name,
            generate_series(1, 7) AS day_number
    ),
    weekly_meeting_times as (SELECT wm.section_id, t.day::date, wm.start_time, wm.end_time, wm.location
        FROM weekly_meeting wm 
        CROSS JOIN generate_series(
            wm.start_date + ((((SELECT day_number FROM day_mappings WHERE day_name::day_enum = wm.day_of_week) - EXTRACT(DOW FROM wm.start_date) + 7) % 7) || ' days')::interval,
            wm.end_date, interval  '1 week') AS t(day)
        order by t.day::date
    )
    SELECT wmt.section_id, NEW.section_id INTO conflicting_weekly_review_meeting_a, conflicting_weekly_review_meeting_b
    FROM weekly_meeting_times wmt
    WHERE (wmt.location = NEW.location OR wmt.section_id = NEW.section_id)
    AND (NEW.start_time::time, NEW.end_time::time) OVERLAPS (wmt.start_time, wmt.end_time)
        AND wmt.day = NEW.start_time::date;
    
    -- Check for review meeting conflicts with review meetings
    SELECT rm1.section_id, NEW.section_id INTO conflicting_review_meeting_a, conflicting_review_meeting_b
        FROM review_meeting rm1
    WHERE (rm1.start_time, rm1.end_time) OVERLAPS (NEW.start_time, NEW.end_time)
        AND (rm1.location = NEW.location OR rm1.section_id = NEW.section_id);


    IF conflicting_weekly_review_meeting_a IS NOT NULL AND conflicting_weekly_review_meeting_b IS NOT NULL THEN
        RAISE EXCEPTION 'A conflict between weekly meetings and review meetings in % and % was detected.', conflicting_weekly_review_meeting_a, conflicting_weekly_review_meeting_b;
    ELSIF conflicting_review_meeting_a IS NOT NULL AND conflicting_review_meeting_b IS NOT NULL THEN
        RAISE EXCEPTION 'A conflict between review meetings in % and % was detected.', conflicting_review_meeting_a, conflicting_review_meeting_b;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_weekly_meeting_conflict
BEFORE INSERT OR UPDATE ON weekly_meeting
FOR EACH ROW
EXECUTE FUNCTION check_new_weekly_meeting_conflict();

CREATE TRIGGER trigger_check_review_meeting_conflict
BEFORE INSERT OR UPDATE ON review_meeting
FOR EACH ROW
EXECUTE FUNCTION check_new_review_meeting_conflict();