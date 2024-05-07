CREATE TABLE thesis_committee (
    PID VARCHAR(10),
    faculty_name VARCHAR(100),
    PRIMARY KEY (PID, faculty_name),
    FOREIGN KEY (PID) REFERENCES PhD(PID) ON DELETE CASCADE,
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE
);
