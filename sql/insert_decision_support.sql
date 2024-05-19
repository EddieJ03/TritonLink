-- Insert faculty members
INSERT INTO faculty (name, title, department) VALUES 
('John Smith', 'Professor', 'Computer Science'),
('Jane Doe', 'Associate Professor', 'Mathematics'),
('Sarah Johnson', 'Assistant Professor', 'Computer Science'),
('Michael Brown', 'Professor', 'Computer Science');

-- Insert courses
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent) VALUES 
('CSE1010', 'Computer Science', 4, 5, TRUE, FALSE, FALSE, FALSE),
('MAT200', 'Mathematics', 3, 4, TRUE, FALSE, FALSE, FALSE);

-- Insert classes
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES 
('CSE101-01', 'CSE1010', 'Introduction to Computer Science', 'Fall', 2024, 50),
('CSE101-02', 'CSE1010', 'Introduction to Computer Science', 'Fall', 2024, 50),
('CSE101-03', 'CSE1010', 'Introduction to Computer Science', 'Fall', 2024, 50),
('CSE101-04', 'CSE1010', 'Introduction to Computer Science', 'Summer', 2024, 50),
('MAT200-01', 'MAT200', 'Calculus II', 'Fall', 2024, 40),
('MAT200-02', 'MAT200', 'Calculus II', 'Fall', 2024, 40);

-- Insert teaches
INSERT INTO teaches (faculty_name, section_id, course_number) VALUES 
('John Smith', 'CSE101-01', 'CSE1010'),
('John Smith', 'CSE101-02', 'CSE1010'),
('Jane Doe', 'MAT200-01', 'MAT200'),
('Jane Doe', 'MAT200-02', 'MAT200'),
('Sarah Johnson', 'CSE101-03', 'CSE1010'),
('Michael Brown', 'CSE101-04', 'CSE1010');

-- Insert students
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES 
('1234567890', 'Alice', '', 'Smith', '123-45-6789', TRUE, 'California'),
('2345678901', 'Bob', '', 'Johnson', '234-56-7890', TRUE, 'International'),
('3456789012', 'Charlie', '', 'Brown', '345-67-8901', TRUE, 'Non-CA US'),
('4567890123', 'David', '', 'Lee', '456-78-9012', TRUE, 'California'),
('5678901234', 'Emily', '', 'Davis', '567-89-0123', TRUE, 'California'),
('6789012345', 'Fiona', '', 'Garcia', '678-90-1234', TRUE, 'California'),
('7890123456', 'George', '', 'Martinez', '789-01-2345', TRUE, 'International'),
('8901234567', 'Hannah', '', 'Lopez', '890-12-3456', TRUE, 'Non-CA US'),
('9012345678', 'Isaac', '', 'Gonzalez', '901-23-4567', TRUE, 'California'),
('0123456789', 'Julia', '', 'Hernandez', '012-34-5678', TRUE, 'California');

-- Insert enrolled
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES 
('1234567890', 'CSE101-01', 'CSE1010', 'A+', 4),
('2345678901', 'CSE101-01', 'CSE1010', 'D', 4),
('3456789012', 'CSE101-01', 'CSE1010', 'C-', 4),
('4567890123', 'CSE101-02', 'CSE1010', 'A', 4),
('5678901234', 'CSE101-02', 'CSE1010', 'B', 4),
('1234567890', 'MAT200-01', 'MAT200', 'A', 3),
('2345678901', 'MAT200-01', 'MAT200', 'B', 3),
('3456789012', 'MAT200-01', 'MAT200', 'C', 3),
('4567890123', 'MAT200-02', 'MAT200', 'A', 3),
('5678901234', 'MAT200-02', 'MAT200', 'B', 3),
('6789012345', 'CSE101-03', 'CSE1010', 'B+', 4),
('7890123456', 'CSE101-03', 'CSE1010', 'F', 4),
('8901234567', 'CSE101-03', 'CSE1010', 'A', 4),
('9012345678', 'CSE101-04', 'CSE1010', 'B', 4),
('0123456789', 'CSE101-04', 'CSE1010', 'A', 4);