CREATE TYPE college_enum AS ENUM ('Warren', 'Muir', 'Sixth', 'ERC', 'Marshall', 'Revelle', 'Seventh');

CREATE TABLE undergraduate (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    college college_enum,
    major VARCHAR(100),
    minor VARCHAR(100),
    PRIMARY KEY (PID)
);