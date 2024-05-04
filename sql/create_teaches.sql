CREATE TABLE teaches (
    faculty_name VARCHAR(100),
    section_id VARCHAR(20),
    PRIMARY KEY (faculty_name, section_id),
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES classes(section_id) ON DELETE CASCADE
);
