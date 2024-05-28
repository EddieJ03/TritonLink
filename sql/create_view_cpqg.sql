CREATE TABLE CPQG (
    faculty_name VARCHAR(100),
    course_number VARCHAR(50),
    quarter quarter_enum,
    year INT,
    A INTEGER DEFAULT 0,
    B INTEGER DEFAULT 0,
    C INTEGER DEFAULT 0,
    D INTEGER DEFAULT 0,
    other INTEGER DEFAULT 0,
    FOREIGN KEY (faculty_name) REFERENCES faculty(name) ON DELETE CASCADE,
    FOREIGN KEY (course_number) REFERENCES course(course_number) ON DELETE CASCADE,
    PRIMARY KEY (faculty_name, course_number, quarter, year)
);

INSERT INTO CPQG (faculty_name, course_number, quarter, year, A, B, C, D, other)
SELECT 
    f.name AS faculty_name, 
    te.course_number AS course_number,
    cl.quarter AS quarter,
    cl.year AS year, 
    SUM(CASE WHEN e.grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END) AS A,
    SUM(CASE WHEN e.grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END) AS B,
    SUM(CASE WHEN e.grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END) AS C,
    SUM(CASE WHEN e.grade = 'D' THEN 1 ELSE 0 END) AS D,
    SUM(CASE WHEN e.grade IN ('F', 'Incomplete', 'S', 'U') THEN 1 ELSE 0 END) AS other
FROM 
    faculty f 
    JOIN teaches te ON f.name = te.faculty_name
    JOIN classes cl ON te.section_id = cl.section_id
    JOIN enrolled e ON te.section_id = e.section_id
GROUP BY 
    f.name, te.course_number, cl.quarter, cl.year;

-- CREATE TABLE CPQG AS (
--     SELECT f.name as faculty_name, te.course_number as course_number, 
--         SUM(CASE WHEN e.grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END) AS A,
--         SUM(CASE WHEN e.grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END) AS B,
--         SUM(CASE WHEN e.grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END) AS C,
--         SUM(CASE WHEN e.grade IN ('D') THEN 1 ELSE 0 END) AS D,
--         SUM(CASE WHEN e.grade IN ('F', 'Incomplete', 'S','U') THEN 1 ELSE 0 END) AS other
--     FROM faculty f 
--         JOIN teaches te ON f.name = te.faculty_name
--         JOIN classes cl ON te.section_id = cl.section_id
--         JOIN enrolled e ON te.section_id = e.section_id
--     GROUP BY f.name, te.course_number
-- );

CREATE OR REPLACE FUNCTION cpqg_update()
    RETURNS trigger 
    LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT FROM CPQG c 
            JOIN teaches t ON t.course_number = c.course_number
            JOIN classes cl ON c.course_number = cl.course_number AND c.quarter = cl.quarter AND c.year = cl.year 
        WHERE NEW.course_number = t.course_number 
            AND t.faculty_name = (SELECT faculty_name FROM teaches t WHERE t.course_number = NEW.course_number AND t.section_id = NEW.section_id) 
            AND cl.quarter = (SELECT quarter FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id)
            AND cl.year = (SELECT year FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id)
        ) THEN
        UPDATE CPQG SET 
        A = (
            CASE WHEN NEW.grade IN ('A+', 'A', 'A-') THEN A + 1 ELSE A END
        ),
        B = (
            CASE WHEN NEW.grade IN ('B+', 'B', 'B-') THEN B + 1 ELSE B END
        ),
        C = (
            CASE WHEN NEW.grade IN ('C+', 'C', 'C-') THEN C + 1 ELSE C END
        ),
        D = (
            CASE WHEN NEW.grade IN ('D') THEN D + 1 ELSE D END
        ),
        other = (
            CASE WHEN NEW.grade IN ('F', 'Incomplete', 'S','U') THEN other + 1 ELSE other END
        )
        WHERE course_number = NEW.course_number 
            AND faculty_name = (SELECT faculty_name FROM teaches t WHERE t.course_number = NEW.course_number AND t.section_id = NEW.section_id) 
            AND quarter = (SELECT quarter FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id)
            AND year = (SELECT year FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id);

        -- SUBTRACT FROM OLD
        UPDATE CPQG SET 
        A = (
            CASE WHEN OLD.grade IN ('A+', 'A', 'A-') THEN A - 1 ELSE A END
        ),
        B = (
            CASE WHEN OLD.grade IN ('B+', 'B', 'B-') THEN B - 1 ELSE B END
        ),
        C = (
            CASE WHEN OLD.grade IN ('C+', 'C', 'C-') THEN C - 1 ELSE C END
        ),
        D = (
            CASE WHEN OLD.grade IN ('D') THEN D - 1 ELSE D END
        ),
        other = (
            CASE WHEN OLD.grade IN ('F', 'Incomplete', 'S','U') THEN other - 1 ELSE other END
        )
        WHERE course_number = OLD.course_number 
            AND faculty_name = (SELECT faculty_name FROM teaches t WHERE t.course_number = OLD.course_number AND t.section_id = OLD.section_id)
            AND quarter = (SELECT quarter FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id)
            AND year = (SELECT year FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id);

        RETURN NEW;
    ELSE
        INSERT INTO CPQG VALUES((SELECT faculty_name FROM teaches t WHERE t.course_number = NEW.course_number AND t.section_id = NEW.section_id), NEW.course_number, (SELECT quarter FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id), (SELECT year FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id), 0, 0, 0, 0, 0);

        UPDATE CPQG SET 
        A = (
            CASE WHEN NEW.grade IN ('A+', 'A', 'A-') THEN A + 1 ELSE A END
        ),
        B = (
            CASE WHEN NEW.grade IN ('B+', 'B', 'B-') THEN B + 1 ELSE B END
        ),
        C = (
            CASE WHEN NEW.grade IN ('C+', 'C', 'C-') THEN C + 1 ELSE C END
        ),
        D = (
            CASE WHEN NEW.grade IN ('D') THEN D + 1 ELSE D END
        ),
        other = (
            CASE WHEN NEW.grade IN ('F', 'Incomplete', 'S','U') THEN other + 1 ELSE other END
        )
        WHERE course_number = NEW.course_number AND faculty_name = (SELECT faculty_name FROM teaches t WHERE t.course_number = NEW.course_number AND t.section_id = NEW.section_id) AND quarter = (SELECT quarter FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id)
            AND year = (SELECT year FROM classes cl WHERE cl.course_number = NEW.course_number AND cl.section_id = NEW.section_id);

        RETURN NEW;
    END IF;
END;
$$;

CREATE or replace TRIGGER cpqg_view_maintenance
AFTER INSERT OR UPDATE on enrolled
FOR EACH ROW
EXECUTE procedure cpqg_update();

