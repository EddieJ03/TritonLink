-- Define the attendance table
CREATE TABLE attendance (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (PID, start_date)
);