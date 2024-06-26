CREATE TYPE grade_enum AS ENUM('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'S', 'U', 'Incomplete');

CREATE TABLE enrolled (
    PID VARCHAR(10),
    section_id VARCHAR(20),
    course_number VARCHAR(50),
    grade grade_enum,
    num_units INT,
    PRIMARY KEY (PID, section_id, course_number),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE,
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE
);


-- Create function to check enrollment limit
CREATE OR REPLACE FUNCTION check_enrollment()
RETURNS TRIGGER AS $$
BEGIN
    -- Check the current number of students enrolled in the class
    IF (SELECT COUNT(*) FROM enrolled
        WHERE section_id = NEW.section_id
        AND course_number = NEW.course_number) >= 
       (SELECT enrollment_limit FROM classes
        WHERE section_id = NEW.section_id
        AND course_number = NEW.course_number) THEN
        RAISE EXCEPTION 'Enrollment limit reached for class % %', NEW.section_id, NEW.course_number;
    END IF;

    IF NOT EXISTS(
        SELECT * FROM teaches t WHERE t.section_id = NEW.section_id AND t.course_number = NEW.course_number 
    ) THEN
        RAISE EXCEPTION ' NO ONE IS TEACHING THIS CLASS % %', NEW.section_id, NEW.course_number;
    END IF;

    IF EXISTS(
        SELECT * FROM enrolled e WHERE e.PID = new.PID AND e.course_number = NEW.course_number
    ) THEN
        RAISE EXCEPTION 'STUDENT HAS ALREADY ENROLLED IN COURSE %', NEW.course_number;
    END IF;

    -- IF EXISTS (
    --     (SELECT prereq_course FROM prerequisite WHERE course_number = NEW.course_number) EXCEPT (SELECT course_number FROM enrolled e WHERE e.PID = NEW.PID)
    -- )
    -- THEN RAISE EXCEPTION 'A prereq not satisfied for %', NEW.course_number;
    -- END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that calls the function before insert
CREATE TRIGGER check_enrollment_before_insert
BEFORE INSERT ON enrolled
FOR EACH ROW
EXECUTE FUNCTION check_enrollment();
