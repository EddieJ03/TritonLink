CREATE TABLE waitlisted (
    PID VARCHAR(10),
    section_id VARCHAR(20),
    course_number VARCHAR(50) REFERENCES course(course_number) ON DELETE CASCADE,
    PRIMARY KEY (PID, section_id, course_number),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE,
);