-- Define the review_meeting table
CREATE TABLE review_meeting (
    section_id VARCHAR(20) REFERENCES classes(section_id),
    start_time TIME,
    end_time TIME,
    location VARCHAR(100),
    PRIMARY KEY (section_id)
);