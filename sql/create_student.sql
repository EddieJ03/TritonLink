CREATE TYPE residency_enum AS ENUM('California', 'International', 'Non-CA US');

CREATE TABLE student (
    PID VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    ssn VARCHAR(11),
    enrolled BOOLEAN,
    residency residency_enum
);
