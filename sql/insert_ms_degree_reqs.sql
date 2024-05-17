-- Insert data into student table
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES
('S123456789', 'John', 'A.', 'Doe', '123-45-6789', TRUE, 'California'),
('S987654321', 'Jane', 'B.', 'Smith', '987-65-4321', FALSE, 'International'),
('S111213141', 'Alice', 'C.', 'Johnson', '111-21-3141', TRUE, 'Non-CA US'),
('S141312111', 'Bob', 'D.', 'Brown', '141-31-2111', FALSE, 'California');

-- Insert data into graduate table
INSERT INTO graduate (PID, department, grad_type) VALUES
('S123456789', 'Computer Science', 'MS'),
('S987654321', 'Electrical Engineering', 'MS'),
('S111213141', 'Computer Science', 'MS'),
('S141312111', 'Data Science', 'MS');

-- Insert data into degree table
INSERT INTO degree (degree_id, degree_type, university, total_units) VALUES
('D1', 'MS', 'UCSD', 45),
('D2', 'MS', 'UCSD', 50);

-- Insert data into category table
INSERT INTO category (category_id, degree_id, category_name, min_gpa, required_units, is_concentration) VALUES
('C1', 'D1', 'Artificial Intelligence', 3.0, 12, TRUE),
('C2', 'D2', 'Machine Learning', 3.5, 15, TRUE);

-- Insert additional data into course table
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent) VALUES
('CSE103', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE104', 'Computer Science', 3, 3, TRUE, TRUE, TRUE, FALSE),
('ECE202', 'Electrical Engineering', 3, 4, TRUE, FALSE, TRUE, TRUE),
('ECE203', 'Electrical Engineering', 3, 3, TRUE, TRUE, FALSE, FALSE),
('DS101', 'Data Science', 4, 4, TRUE, FALSE, FALSE, FALSE);

-- Insert additional data into category_course table
INSERT INTO category_course (course_number, category_id) VALUES
('CSE103', 'C1'),
('CSE104', 'C2'),
('ECE202', 'C1'),
('ECE203', 'C2'),
('DS101', 'C1');

-- Insert additional data into classes table
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES
('S4', 'CSE103', 'Data Structures', 'Fall', 2023, 60),
('S5', 'CSE104', 'Computer Networks', 'Winter', 2024, 50),
('S6', 'ECE202', 'Digital Signal Processing', 'Spring', 2024, 40),
('S20', 'ECE202', 'Digital Signal Processing', 'Fall', 2025, 40),
('S22', 'ECE202', 'Digital Signal Processing', 'Winter', 2026, 40),
('S7', 'ECE203', 'Microelectronics', 'Summer', 2023, 30),
('S8', 'DS101', 'Intro to Data Science', 'Fall', 2023, 50);

-- Insert additional data into enrolled table
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES
('S123456789', 'S4', 'CSE103', 'B', 4),
('S123456789', 'S5', 'CSE104', 'Incomplete', 3),
('S987654321', 'S6', 'ECE202', 'A-', 4),
('S987654321', 'S7', 'ECE203', 'B+', 3),
('S111213141', 'S8', 'DS101', 'A', 4),
('S111213141', 'S4', 'CSE103', 'Incomplete', 4),
('S141312111', 'S5', 'CSE104', 'B-', 3),
('S141312111', 'S6', 'ECE202', 'C+', 3),
('S141312111', 'S7', 'ECE203', 'D', 3);