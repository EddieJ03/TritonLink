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
    conflicting_review_meeting BOOLEAN;
BEGIN
    -- Check for weekly meeting conflicts
    SELECT EXISTS (
        SELECT *
        FROM teaches t
        JOIN weekly_meeting wm1 ON t.section_id = wm1.section_id AND t.course_number = wm1.course_number
        JOIN weekly_meeting wm2 ON wm2.section_id = NEW.section_id AND wm2.course_number = NEW.course_number
        WHERE t.faculty_name = NEW.faculty_name
          AND wm1.day_of_week = wm2.day_of_week
          AND wm1.meeting_type = wm2.meeting_type
          AND (wm1.start_time, wm1.end_time) OVERLAPS (wm2.start_time, wm2.end_time)
    ) INTO conflicting_weekly_meeting;

    -- Check for review meeting conflicts
    SELECT EXISTS (
        SELECT *
        FROM teaches t
        JOIN review_meeting rm1 ON t.section_id = rm1.section_id AND t.course_number = rm1.course_number
        JOIN review_meeting rm2 ON rm2.section_id = NEW.section_id AND rm2.course_number = NEW.course_number
        WHERE t.faculty_name = NEW.faculty_name
          AND (rm1.start_time, rm1.end_time) OVERLAPS (rm2.start_time, rm2.end_time)
    ) INTO conflicting_review_meeting;

    IF conflicting_weekly_meeting THEN
        RAISE EXCEPTION 'Professor % has a weekly meeting conflict with the new class.', NEW.faculty_name;
    ELSIF conflicting_review_meeting THEN
        RAISE EXCEPTION 'Professor % has a review meeting conflict with the new class.', NEW.faculty_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_meeting_conflict
BEFORE INSERT OR UPDATE ON teaches
FOR EACH ROW
EXECUTE FUNCTION check_meeting_conflict();
