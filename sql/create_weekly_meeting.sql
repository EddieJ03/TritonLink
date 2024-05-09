CREATE TYPE meeting_enum AS ENUM ('LE', 'DI', 'Lab Sessions');
CREATE TYPE day_enum AS ENUM ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

CREATE TABLE weekly_meeting (
    section_id VARCHAR(20) REFERENCES classes(section_id) ON DELETE CASCADE,
    meeting_type meeting_enum,
    start_time time,
    start_date date,
    end_time time,
    end_date date,
    day_of_week day_enum,
    location VARCHAR(100),
    PRIMARY KEY (section_id, meeting_type, start_time, start_date, day_of_week)
);