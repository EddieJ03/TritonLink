CREATE TABLE course (
    course_number VARCHAR(50) PRIMARY KEY,
    department VARCHAR(50),
    min_unit INT NOT NULL CHECK (min_unit > 0),
    max_unit INT NOT NULL CHECK (max_unit > 0),
    letter_grade BOOLEAN,
    S_or_U BOOLEAN,
    lab_work BOOLEAN,
    instructor_consent BOOLEAN,
    CHECK (max_unit >= min_unit)
);
