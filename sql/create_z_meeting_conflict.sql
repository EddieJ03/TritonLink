CREATE OR REPLACE FUNCTION check_new_meeting_conflict() RETURNS TRIGGER AS $$
DECLARE
    conflicting_weekly_meeting_a VARCHAR(20);
    conflicting_weekly_meeting_b VARCHAR(20);
    conflicting_weekly_review_meeting_a VARCHAR(20);
    conflicting_weekly_review_meeting_b VARCHAR(20);
    conflicting_review_meeting_a VARCHAR(20);
    conflicting_review_meeting_b VARCHAR(20);
BEGIN
    -- Check for weekly meeting conflicts
    SELECT wm1.section_id, wm2.section_id INTO conflicting_weekly_meeting_a, conflicting_weekly_meeting_b
        FROM weekly_meeting wm1
            JOIN weekly_meeting wm2 ON wm1.day_of_week = wm2.day_of_week 
                AND (
                    (wm2.section_id = wm1.section_id AND wm1.meeting_type <> wm2.meeting_type) 
                    OR (wm2.section_id <> wm1.section_id AND wm1.location = wm2.location)
                )
    WHERE (wm1.start_time, wm1.end_time) OVERLAPS (wm2.start_time, wm2.end_time);

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
    SELECT wmt.section_id, rm.section_id INTO conflicting_weekly_review_meeting_a, conflicting_weekly_review_meeting_b
    FROM weekly_meeting_times wmt
    JOIN review_meeting rm ON wmt.location = rm.location OR wmt.section_id = rm.section_id
    WHERE (rm.start_time::time, rm.end_time::time) OVERLAPS (wmt.start_time, wmt.end_time)
        AND wmt.day = rm.start_time::date;
    
    -- Check for review meeting conflicts with review meetings
    SELECT rm1.section_id, rm2.section_id INTO conflicting_review_meeting_a, conflicting_review_meeting_b
        FROM review_meeting rm1 CROSS JOIN review_meeting rm2
    WHERE rm1 <> rm2 
        AND (rm1.start_time, rm1.end_time) OVERLAPS (rm2.start_time, rm2.end_time)
        AND (rm1.location = rm2.location OR rm1.section_id = rm2.section_id);

    IF conflicting_weekly_meeting_a IS NOT NULL AND conflicting_weekly_meeting_b IS NOT NULL THEN
        RAISE EXCEPTION 'A conflict between weekly meetings in % and % was detected.', conflicting_weekly_meeting_a, conflicting_weekly_meeting_b;
    ELSIF conflicting_weekly_review_meeting_a IS NOT NULL AND conflicting_weekly_review_meeting_b IS NOT NULL THEN
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
EXECUTE FUNCTION check_new_meeting_conflict();

CREATE TRIGGER trigger_check_review_meeting_conflict
BEFORE INSERT OR UPDATE ON review_meeting
FOR EACH ROW
EXECUTE FUNCTION check_new_meeting_conflict();