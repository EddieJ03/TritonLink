CREATE TABLE waitlisted (
    PID VARCHAR(10),
    course_number VARCHAR(50),
    PRIMARY KEY (PID, course_number),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE
);