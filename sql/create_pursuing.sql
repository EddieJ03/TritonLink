CREATE TABLE pursuing (
    degree_id VARCHAR(20),
    PID VARCHAR(10),
    earned BOOLEAN,
    FOREIGN KEY (degree_id) REFERENCES degree(degree_id),
    FOREIGN KEY (PID) REFERENCES student(PID)
);