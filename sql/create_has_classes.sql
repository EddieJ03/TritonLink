CREATE TABLE has_classes (
    course_number VARCHAR(50),
    section_id VARCHAR(50),
    FOREIGN KEY (course_number) REFERENCES course(course_number),
    FOREIGN KEY (section_id) REFERENCES classes(section_id)
);
