CREATE TABLE waitlisted (
    PID VARCHAR(10),
    section_id VARCHAR(50),
    PRIMARY KEY (PID, section_id),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES classes(section_id) ON DELETE CASCADE
);