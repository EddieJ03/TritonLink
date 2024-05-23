CREATE TABLE thesis_committee (
    PID VARCHAR(10),
    faculty_name VARCHAR(100),
    PRIMARY KEY (PID, faculty_name),
    FOREIGN KEY (PID) REFERENCES PhD(PID) ON DELETE CASCADE,
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_thesis_committee_count() 
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM thesis_committee WHERE PID = NEW.PID) >= 3 THEN
        RAISE EXCEPTION 'A student can have at most 3 faculty members on their thesis committee';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER thesis_committee_limit
BEFORE INSERT ON thesis_committee
FOR EACH ROW
EXECUTE FUNCTION check_thesis_committee_count();
