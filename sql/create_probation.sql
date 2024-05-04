-- Define the probation table
CREATE TABLE probation (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    start_date DATE,
    end_date DATE,
    reason TEXT,
    PRIMARY KEY (PID, start_date)
);