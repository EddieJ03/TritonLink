CREATE TYPE quarter_enum AS ENUM('Fall', 'Winter', 'Spring', 'Summer');

CREATE TABLE classes (
    section_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(100),
    quarter quarter_enum,
    year INT,
    enrollment_limit INT
);
