CREATE TABLE oversees_research (
    faculty_name VARCHAR(100),
    project_id VARCHAR(20),
    PRIMARY KEY (faculty_name, project_id),
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES research(project_id) ON DELETE CASCADE
);