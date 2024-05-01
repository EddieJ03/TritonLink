CREATE TABLE course (
    course_number VARCHAR(50) PRIMARY KEY,
    department VARCHAR(50),
    min_unit INT,
    max_unit INT,
    letter_grade BOOLEAN,
    S_or_U BOOLEAN,
    lab_work BOOLEAN,
    instructor_consent BOOLEAN
);
