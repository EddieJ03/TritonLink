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
