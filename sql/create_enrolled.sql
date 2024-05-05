CREATE TYPE grade_enum AS ENUM('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'S', 'U', 'Incomplete');

CREATE TABLE enrolled (
    PID VARCHAR(10),
    section_id VARCHAR(20),
    grade grade_enum,
    PRIMARY KEY (PID, section_id),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES classes(section_id) ON DELETE CASCADE
);
