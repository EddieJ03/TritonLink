-- Define the BsMs table
CREATE TABLE BsMs (
    PID VARCHAR(10) REFERENCES student(PID),
    PRIMARY KEY (PID)
);