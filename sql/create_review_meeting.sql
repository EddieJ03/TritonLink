-- Define the review_meeting table
CREATE TABLE review_meeting (
    section_id VARCHAR(20) REFERENCES classes(section_id) ON DELETE CASCADE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    location VARCHAR(100),
    PRIMARY KEY (section_id, start_time)
);