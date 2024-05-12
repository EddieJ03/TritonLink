CREATE TYPE meeting_enum AS ENUM ('LE', 'DI', 'Lab Sessions');

CREATE TABLE weekly_meeting (
    section_id VARCHAR(20),
    course_number VARCHAR(50) REFERENCES course(course_number) ON DELETE CASCADE,
    meeting_type meeting_enum,
    start_time time,
    start_date date,
    end_time time,
    end_date date,
    day_of_week day_enum,
    location VARCHAR(100),
    FOREIGN KEY (section_id, course_number) REFERENCES classes(section_id, course_number) ON DELETE CASCADE,
    PRIMARY KEY (section_id, course_number, meeting_type, day_of_week)
);