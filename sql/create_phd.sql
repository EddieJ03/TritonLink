-- Define the PhD table
CREATE TABLE PhD (
    PID VARCHAR(10) REFERENCES student(PID),
    pre_candidacy BOOLEAN,
    PRIMARY KEY (PID)
);