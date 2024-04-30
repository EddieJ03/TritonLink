CREATE TYPE meeting_enum AS ENUM ('LE', 'DI', 'Lab Sessions');

CREATE TABLE weekly_meeting (
    section_id VARCHAR(20) REFERENCES classes(section_id),
    meeting_type meeting_enum,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    location VARCHAR(100),
    PRIMARY KEY (section_id, meeting_type, start_time)
);