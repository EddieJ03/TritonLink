-- Define the PhD table
CREATE TABLE PhD (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    pre_candidacy BOOLEAN,
    PRIMARY KEY (PID)
);