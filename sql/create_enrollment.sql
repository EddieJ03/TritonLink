CREATE TYPE grade_enum AS ENUM('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'S', 'U', 'Incomplete');

CREATE TABLE enrolled (
    PID VARCHAR(10),
    course_number INT,
    grade grade_enum,
    PRIMARY KEY (PID, course_number),
    FOREIGN KEY (PID) REFERENCES student(PID),
    FOREIGN KEY (course_number) REFERENCES course(course_number)
);
