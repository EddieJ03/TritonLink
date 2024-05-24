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
    conflicting_weekly_meeting BOOLEAN;
BEGIN
    -- Check for weekly meeting conflicts
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
        WHERE ctm.day_of_week = wttm.day_of_week AND (ctm.start_time, ctm.end_time) OVERLAPS (wttm.start_time, wttm.end_time)
    ) INTO conflicting_weekly_meeting;

    IF conflicting_weekly_meeting THEN
        RAISE EXCEPTION 'Professor % has a weekly meeting conflict with the new class.', NEW.faculty_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_meeting_conflict
BEFORE INSERT OR UPDATE ON teaches
FOR EACH ROW
EXECUTE FUNCTION check_meeting_conflict();
