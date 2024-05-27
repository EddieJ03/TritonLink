CREATE TABLE teaches (
    faculty_name VARCHAR(100),
    section_id VARCHAR(20),
    course_number VARCHAR(50),
    PRIMARY KEY (faculty_name, section_id, course_number),
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_meeting_conflict() RETURNS TRIGGER AS $$
DECLARE
    class_already_taught BOOLEAN;
    conflicting_weekly_meeting BOOLEAN;
    conflicting_review_meeting BOOLEAN;
    conflicting_weekly_and_review_meeting BOOLEAN;
    common_date DATE := '2000-01-01'; -- just for OVERLAPS comparison with TIME, otherwise it doesn't work I think
BEGIN
    SELECT EXISTS (
        SELECT * FROM Teaches t WHERE t.course_number = NEW.course_number AND t.section_id = NEW.section_id
    ) INTO class_already_taught;

    -- Check for conflicts between weekly meetings
    SELECT EXISTS (
        /* 
        Step 1: Identify All Meetings Of Classes The Teacher is Currently Teaching
        */
        WITH CurrentTeachingMeetings AS (
            SELECT * FROM teaches t
            JOIN weekly_meeting wm1 ON t.section_id = wm1.section_id AND t.course_number = wm1.course_number
            WHERE t.faculty_name = NEW.faculty_name
        )

        /* 
        Step 2: Identify All Meetings Of Class Teacher WANTS to teach
        */
        , WantsToTeachMeetings AS (
            SELECT *
            FROM weekly_meeting wm
            WHERE wm.section_id = NEW.section_id AND wm.course_number = NEW.course_number
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT ctm.*, wttm.*
        FROM CurrentTeachingMeetings ctm, WantsToTeachMeetings wttm 
        WHERE ctm.day_of_week = wttm.day_of_week AND (common_date + ctm.start_time, common_date + ctm.end_time) OVERLAPS (common_date + wttm.start_time, common_date + wttm.end_time)
    ) INTO conflicting_weekly_meeting;

    -- Check for conflicts between review meetings
    SELECT EXISTS (
        /* 
        Step 1: Identify All Review Meetings Of Classes The Teacher is Currently Teaching
        */
        WITH CurrentReviewMeetings AS (
            SELECT * FROM teaches t
            JOIN review_meeting rm1 ON t.section_id = rm1.section_id AND t.course_number = rm1.course_number
            WHERE t.faculty_name = NEW.faculty_name
        )

        /* 
        Step 2: Identify All Review Meetings Of Class Teacher WANTS to teach
        */
        , WantsToTeachReviewMeetings AS (
            SELECT *
            FROM review_meeting rm
            WHERE rm.section_id = NEW.section_id AND rm.course_number = NEW.course_number
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT crm.*, wttrm.*
        FROM CurrentReviewMeetings crm, WantsToTeachReviewMeetings wttrm 
        WHERE (crm.start_time, crm.end_time) OVERLAPS (wttrm.start_time, wttrm.end_time)
    ) INTO conflicting_review_meeting;

    SELECT EXISTS (
        /* 
        Step 1: Identify All Review Meetings Of Classes The Teacher is Currently Teaching
        */
        WITH CurrentReviewMeetings AS (
            SELECT * FROM teaches t
            JOIN review_meeting rm1 ON t.section_id = rm1.section_id AND t.course_number = rm1.course_number
            WHERE t.faculty_name = NEW.faculty_name
        )

        /* 
        Step 2: Identify All Meetings Of Class Teacher WANTS to teach
        */
        , WantsToTeachMeetings AS (
            SELECT *
            FROM weekly_meeting wm
            WHERE wm.section_id = NEW.section_id AND wm.course_number = NEW.course_number
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT crm.*, wttm.*
        FROM CurrentReviewMeetings crm, WantsToTeachMeetings wttm 
        WHERE wttm.day_of_week = TO_CHAR(crm.start_time, 'Dy')::day_enum AND (wttm.start_time, wttm.end_time) OVERLAPS (TO_CHAR(crm.start_time, 'HH24:MI:SS')::TIME, TO_CHAR(crm.end_time, 'HH24:MI:SS')::TIME)
    ) OR EXISTS (
        /* 
        Step 1: Identify All Weekly Meetings Of Classes The Teacher is Currently Teaching
        */
        WITH CurrentTeachingMeetings AS (
            SELECT * FROM teaches t
            JOIN weekly_meeting wm1 ON t.section_id = wm1.section_id AND t.course_number = wm1.course_number
            WHERE t.faculty_name = NEW.faculty_name
        )

        /* 
        Step 2: Identify All Review Meetings Of Class Teacher WANTS to teach
        */
        , WantsToTeachReviewMeetings AS (
            SELECT *
            FROM review_meeting rm
            WHERE rm.section_id = NEW.section_id AND rm.course_number = NEW.course_number
        )

        /*
        Step 3: Find Overlapping Sections
        Find sections that have overlapping meeting times with the profs current sections.
        */
        SELECT ctm.*, wttrm.*
        FROM CurrentTeachingMeetings ctm, WantsToTeachReviewMeetings wttrm 
        WHERE ctm.day_of_week = TO_CHAR(wttrm.start_time, 'Dy')::day_enum AND (ctm.start_time, ctm.end_time) OVERLAPS (TO_CHAR(wttrm.start_time, 'HH24:MI:SS')::TIME, TO_CHAR(wttrm.end_time, 'HH24:MI:SS')::TIME)
    ) INTO conflicting_weekly_and_review_meeting;

    IF class_already_taught THEN
        RAISE EXCEPTION 'This class is already being taught!';
    END IF;

    IF conflicting_weekly_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a weekly meeting that conflicts with the weekly meeting of the new class.', NEW.faculty_name;
    END IF;

    IF conflicting_review_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a review meeting that conflicts with the review meeting of the new class.', NEW.faculty_name;
    END IF;

    IF conflicting_weekly_and_review_meeting THEN
        RAISE EXCEPTION 'Professor % currently has a review meeting or regular meeting that conflicts with the weekly meeting or review meeting of the new class. (or vice versa)', NEW.faculty_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_meeting_conflict
BEFORE INSERT OR UPDATE ON teaches
FOR EACH ROW
EXECUTE FUNCTION check_meeting_conflict();
