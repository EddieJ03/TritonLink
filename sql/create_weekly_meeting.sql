CREATE TYPE meeting_enum AS ENUM ('LE', 'DI', 'Lab Sessions')

CREATE TABLE weekly_meeting (
    section_id VARCHAR(20) REFERENCES classes(section_id),
    meeting_type meeting_enum,
    start_time TIME,
    end_time TIME,
    location VARCHAR(100),
    PRIMARY KEY (section_id)
);