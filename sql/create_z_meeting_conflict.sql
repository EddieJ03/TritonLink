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
        AND (rm1.location = NEW.location OR rm1.section_id = NEW.section_id) 
        AND NOT (rm1.section_id = NEW.section_id AND rm1.course_number = NEW.course_number AND rm1.start_time = NEW.start_time);


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

---------------------------------------------------------------------------------------

-- BELOW IS FOR CHECKING INSERTS/UPDATES WITH MEETINGS THE PROF CURRENTLY TEACHES

CREATE OR REPLACE FUNCTION weekly_with_current_prof_weekly_or_review() RETURNS TRIGGER AS $$
DECLARE
    conflicting_weekly_meeting BOOLEAN;
    conflicting_review_meeting BOOLEAN;
    common_date DATE := '2000-01-01'; -- just for OVERLAPS comparison with TIME, otherwise it doesn't work I think
BEGIN
    -- Check for conflicts between weekly meetings
    SELECT EXISTS (
        -- ASSUME CLASS CAN ONLY BE TAUGHT BY ONE PROF
        WITH professor_name AS (
            SELECT faculty_name FROM teaches t
            WHERE t.section_id = NEW.section_id AND t.course_number = NEW.course_number
        ),

        /* 
        Step 1: Identify All Weekly Meetings Of Classes The Teacher is Currently Teaching
        */
        CurrentTeachingMeetings AS (
            SELECT * FROM teaches t
            JOIN weekly_meeting wm1 ON t.section_id = wm1.section_id AND t.course_number = wm1.course_number
            WHERE t.faculty_name = (SELECT faculty_name FROM professor_name) 
            AND wm1.section_id != NEW.section_id AND wm1.course_number != NEW.course_number AND wm1.meeting_type != NEW.meeting_type AND wm1.day_of_week != NEW.day_of_week
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT ctm.*
        FROM CurrentTeachingMeetings ctm 
        WHERE ctm.day_of_week = NEW.day_of_week AND (common_date + ctm.start_time, common_date + ctm.end_time) OVERLAPS (common_date + NEW.start_time, common_date + NEW.end_time)
    ) INTO conflicting_weekly_meeting;

    -- Check for conflicts between review meetings
    SELECT EXISTS (
        -- ASSUME CLASS CAN ONLY BE TAUGHT BY ONE PROF
        WITH professor_name AS (
            SELECT faculty_name FROM teaches t
            WHERE t.section_id = NEW.section_id AND t.course_number = NEW.course_number
        ),

        /* 
        Step 1: Identify All Review Meetings Of Classes The Teacher is Currently Teaching
        */
        CurrentReviewMeetings AS (
            SELECT * FROM teaches t
            JOIN review_meeting rm1 ON t.section_id = rm1.section_id AND t.course_number = rm1.course_number
            WHERE t.faculty_name = (SELECT faculty_name FROM professor_name) 
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT crm.*
        FROM CurrentReviewMeetings crm 
        WHERE NEW.day_of_week = TO_CHAR(crm.start_time, 'Dy')::day_enum AND (NEW.start_time, NEW.end_time) OVERLAPS (TO_CHAR(crm.start_time, 'HH24:MI:SS')::TIME, TO_CHAR(crm.end_time, 'HH24:MI:SS')::TIME)
    ) INTO conflicting_review_meeting;


    IF conflicting_weekly_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a weekly meeting that conflicts with this weekly meeting.', NEW.faculty_name;
    END IF;

    IF conflicting_review_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a review meeting that conflicts with this review meeting.', NEW.faculty_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_weekly_with_current_prof_weekly_or_review_conflict
BEFORE INSERT OR UPDATE ON weekly_meeting
FOR EACH ROW
EXECUTE FUNCTION weekly_with_current_prof_weekly_or_review();





CREATE OR REPLACE FUNCTION review_with_current_prof_weekly_or_review() RETURNS TRIGGER AS $$
DECLARE
    conflicting_weekly_meeting BOOLEAN;
    conflicting_review_meeting BOOLEAN;
    common_date DATE := '2000-01-01'; -- just for OVERLAPS comparison with TIME, otherwise it doesn't work I think
BEGIN
    -- Check for conflicts between weekly meetings
    SELECT EXISTS (
        -- ASSUME CLASS CAN ONLY BE TAUGHT BY ONE PROF
        WITH professor_name AS (
            SELECT faculty_name FROM teaches t
            WHERE t.section_id = NEW.section_id AND t.course_number = NEW.course_number
        ),

        /* 
        Step 1: Identify All Meetings Of Classes The Teacher is Currently Teaching
        */
        CurrentTeachingMeetings AS (
            SELECT * FROM teaches t
            JOIN weekly_meeting wm1 ON t.section_id = wm1.section_id AND t.course_number = wm1.course_number
            WHERE t.faculty_name = (SELECT faculty_name FROM professor_name) 
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT ctm.*
        FROM CurrentTeachingMeetings ctm 
        WHERE ctm.day_of_week = TO_CHAR(NEW.start_time, 'Dy')::day_enum AND (ctm.start_time, ctm.end_time) OVERLAPS (TO_CHAR(NEW.start_time, 'HH24:MI:SS')::TIME, TO_CHAR(NEW.end_time, 'HH24:MI:SS')::TIME)
    ) INTO conflicting_weekly_meeting;

    -- Check for conflicts between review meetings
    SELECT EXISTS (
        -- ASSUME CLASS CAN ONLY BE TAUGHT BY ONE PROF
        WITH professor_name AS (
            SELECT faculty_name FROM teaches t
            WHERE t.section_id = NEW.section_id AND t.course_number = NEW.course_number
        ),

        /* 
        Step 1: Identify All Review Meetings Of Classes The Teacher is Currently Teaching
        */
        CurrentReviewMeetings AS (
            SELECT * FROM teaches t
            JOIN review_meeting rm1 ON t.section_id = rm1.section_id AND t.course_number = rm1.course_number
            WHERE t.faculty_name = (SELECT faculty_name FROM professor_name) 
            AND rm1.section_id != NEW.section_id AND rm1.course_number != NEW.course_number AND rm1.start_time != NEW.start_time
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT crm.*
        FROM CurrentReviewMeetings crm
        WHERE (crm.start_time, crm.end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) INTO conflicting_review_meeting;

    IF conflicting_weekly_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a weekly meeting that conflicts with this review meeting.', NEW.faculty_name;
    END IF;

    IF conflicting_review_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a review meeting that conflicts with this review meeting.', NEW.faculty_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_review_with_current_prof_weekly_or_review_conflict
BEFORE INSERT OR UPDATE ON review_meeting
FOR EACH ROW
EXECUTE FUNCTION review_with_current_prof_weekly_or_review();