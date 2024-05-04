CREATE TABLE pursuing (
    PID VARCHAR(10),
    degree_id VARCHAR(20),
    earned BOOLEAN,
    PRIMARY KEY (PID, degree_id),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (degree_id) REFERENCES degree(degree_id) ON DELETE CASCADE
);