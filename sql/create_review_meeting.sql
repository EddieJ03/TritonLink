CREATE TYPE day_enum AS ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');

CREATE TABLE review_meeting (
    section_id VARCHAR(20),
    course_number VARCHAR(50) REFERENCES course(course_number) ON DELETE CASCADE,
    date DATE,
    day_of_week day_enum,
    start_time TIME,
    end_time TIME,
    location VARCHAR(100),
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE,
    PRIMARY KEY (section_id, course_number)
);