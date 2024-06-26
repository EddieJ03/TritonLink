CREATE TABLE category_course (
    course_number VARCHAR(50),
    category_id VARCHAR(20),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);