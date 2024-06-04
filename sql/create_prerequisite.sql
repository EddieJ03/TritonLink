CREATE TABLE prerequisite (
    course_number VARCHAR(50),
    prereq_course VARCHAR(50),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (prereq_course) REFERENCES course(course_number) ON DELETE CASCADE
);

-- Create function to check prereqs
CREATE OR REPLACE FUNCTION check_prereq()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.course_number = NEW.prereq_course THEN RAISE EXCEPTION 'Course number cannot be prereq of itself!'; END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that calls the function before insert
CREATE TRIGGER check_prereq_before_insert
BEFORE INSERT ON prerequisite
FOR EACH ROW
EXECUTE FUNCTION check_prereq();

