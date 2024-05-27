CREATE TYPE quarter_enum AS ENUM('Fall', 'Winter', 'Spring', 'Summer');

CREATE TABLE classes (
    section_id VARCHAR(20),
    course_number VARCHAR(50),
    title VARCHAR(100),
    quarter quarter_enum,
    year INT,
    enrollment_limit INT NOT NULL CHECK (enrollment_limit > 0),
    PRIMARY KEY (section_id, course_number),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_new_enrollment_limit()
RETURNS TRIGGER AS $$
DECLARE
    current_enrollment INT;
BEGIN
    SELECT COUNT(*)
    INTO current_enrollment
    FROM enrolled
    WHERE enrolled.section_id = NEW.section_id
      AND enrolled.course_number = NEW.course_number;

    IF NEW.enrollment_limit < current_enrollment THEN
        RAISE EXCEPTION 'New enrollment limit % cannot be less than current enrollment %', NEW.enrollment_limit, current_enrollment;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_new_enrollment_limit
BEFORE UPDATE OF enrollment_limit ON classes
FOR EACH ROW
EXECUTE FUNCTION check_new_enrollment_limit();