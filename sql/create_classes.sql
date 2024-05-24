CREATE TYPE quarter_enum AS ENUM('Fall', 'Winter', 'Spring', 'Summer');

CREATE TABLE classes (
    section_id VARCHAR(20),
    course_number VARCHAR(50),
    title VARCHAR(100),
    quarter quarter_enum,
    year INT,
    enrollment_limit INT NOT NULL CHECK (enrollment_limit > 0),
    PRIMARY KEY (section_id, course_number),
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE
);
