CREATE TABLE teaches (
    faculty_name VARCHAR(100),
    section_id VARCHAR(20),
    course_number VARCHAR(50),
    PRIMARY KEY (faculty_name, section_id, course_number),
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE
);
