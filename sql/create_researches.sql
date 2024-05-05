CREATE TABLE researches (
    PID VARCHAR(10),
    project_id VARCHAR(20),
    PRIMARY KEY (PID, project_id),
    FOREIGN KEY (PID) REFERENCES student(PID) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES research(project_id) ON DELETE CASCADE
);
