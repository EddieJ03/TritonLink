-- Define the attendance table
CREATE TABLE attendance (
    PID VARCHAR(10) REFERENCES student(PID) ON DELETE CASCADE,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (PID, start_date)
);

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE OR REPLACE FUNCTION check_date_overlap() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM attendance
        WHERE PID = NEW.PID
          AND daterange(start_date, end_date, '[]') && daterange(NEW.start_date, NEW.end_date, '[]')
    ) THEN
        RAISE EXCEPTION 'Attendance period for PID % overlaps with an existing record', NEW.PID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Create the trigger
CREATE TRIGGER trigger_check_date_overlap
BEFORE INSERT OR UPDATE ON attendance
FOR EACH ROW
EXECUTE FUNCTION check_date_overlap();