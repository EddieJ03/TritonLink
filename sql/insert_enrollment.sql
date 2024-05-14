-- Inserting into the 'course' table
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent)
VALUES ('CSCI101', 'Computer Science', 3, 5, TRUE, FALSE, FALSE, FALSE),
       ('MATH202', 'Mathematics', 4, 4, TRUE, FALSE, FALSE, FALSE);

-- Inserting into the 'classes' table
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit)
VALUES ('CSCI101-01', 'CSCI101', 'Introduction to Computer Science', 'Fall', 2024, 50),
       ('MATH202-01', 'MATH202', 'Calculus II', 'Spring', 2025, 40);

-- Inserting into the 'student' table
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency)
VALUES ('1001', 'John', 'David', 'Smith', '123-45-6789', TRUE, 'California'),
       ('1002', 'Alice', 'Maria', 'Johnson', '987-65-4321', TRUE, 'International'),
       ('1003', 'Michael', 'Robert', 'Williams', '456-78-9123', TRUE, 'Non-CA US');
       
-- Inserting into the 'enrolled' table
-- Note: Ensure that the PID and course_number exist in the 'student' and 'course' tables respectively
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units)
VALUES ('1001', 'CSCI101-01', 'CSCI101', 'A', 4),
       ('1002', 'CSCI101-01', 'CSCI101', 'B+', 4),
       ('1003', 'MATH202-01', 'MATH202', 'A-', 4);

