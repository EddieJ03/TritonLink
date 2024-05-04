CREATE TYPE grad_enum AS ENUM ('MS', 'PhD');

CREATE TABLE graduate (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    department VARCHAR(50),
    grad_type grad_enum,
    PRIMARY KEY (PID, department)
);