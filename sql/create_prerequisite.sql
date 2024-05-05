CREATE TABLE prerequisite (
    course_number VARCHAR(50),
    prereq_course VARCHAR(50),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (prereq_course) REFERENCES course(course_number) ON DELETE CASCADE
);




