CREATE TABLE has_classes (
    course_number VARCHAR(50),
    section_id VARCHAR(50),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES classes(section_id) ON DELETE CASCADE
);
