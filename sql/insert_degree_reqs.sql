-- Insert into student
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency)
VALUES 
('A123456789', 'John', 'M.', 'Doe', '123-45-6789', TRUE, 'California'),
('B987654321', 'Jane', 'A.', 'Smith', '987-65-4321', FALSE, 'Non-CA US'),
('C112233445', 'Alice', 'B.', 'Johnson', '111-22-3333', TRUE, 'California'),
('D556677889', 'Bob', 'C.', 'Brown', '555-66-7788', TRUE, 'International');

-- Insert into undergraduate
INSERT INTO undergraduate (PID, college, major, minor)
VALUES 
('A123456789', 'Revelle', 'Computer Science', 'Mathematics'),
('B987654321', 'Muir', 'Biology', 'Chemistry'),
('C112233445', 'Marshall', 'Physics', 'Computer Science'),
('D556677889', 'Warren', 'History', 'Political Science');

-- Insert into degree
INSERT INTO degree (degree_id, degree_type, university, total_units)
VALUES 
('D001', 'Bachelor', 'UCSD', 180),
('D002', 'MS', 'UCSD', 45),
('D003', 'PhD', 'UCSD', 90),
('D004', 'Bachelor', 'UCLA', 180);

-- Insert into category
INSERT INTO category (category_id, degree_id, category_name, min_gpa, required_units, is_concentration)
VALUES 
('C001', 'D001', 'Core Requirements', 2.0, 60, FALSE),
('C002', 'D001', 'Electives', 2.0, 120, FALSE),
('C003', 'D002', 'Thesis', 3.0, 15, TRUE),
('C004', 'D003', 'Research', 3.5, 30, TRUE),
('C005', 'D004', 'General Education', 2.0, 50, FALSE);

-- Insert into course
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent)
VALUES 
('CSE101', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE),
('BIOL202', 'Biology', 4, 4, TRUE, FALSE, TRUE, FALSE),
('MATH303', 'Mathematics', 3, 3, TRUE, FALSE, FALSE, FALSE),
('CHEM404', 'Chemistry', 3, 3, TRUE, FALSE, TRUE, TRUE),
('PHYS505', 'Physics', 4, 4, TRUE, FALSE, FALSE, FALSE),
('HIST606', 'History', 3, 3, TRUE, FALSE, FALSE, FALSE),
('CSE201', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('BIOL301', 'Biology', 4, 4, TRUE, FALSE, FALSE, FALSE),
('MATH401', 'Mathematics', 3, 3, TRUE, FALSE, FALSE, FALSE),
('PHYS601', 'Physics', 4, 4, TRUE, FALSE, TRUE, TRUE);

-- Insert into category_course
INSERT INTO category_course (course_number, category_id)
VALUES 
('CSE101', 'C001'),
('CSE101', 'C002'),
('MATH303', 'C001'),
('BIOL202', 'C002'),
('CHEM404', 'C002'),
('PHYS505', 'C003'),
('CHEM404', 'C003'),
('PHYS601', 'C004'),
('CSE201', 'C004'),
('HIST606', 'C005'),
('MATH401', 'C005');

-- Insert into classes
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit)
VALUES 
('SEC001', 'CSE101', 'Introduction to Computer Science', 'Fall', 2023, 150),
('SEC002', 'BIOL202', 'General Biology', 'Fall', 2023, 200),
('SEC003', 'MATH303', 'Calculus III', 'Spring', 2024, 100),
('SEC004', 'CHEM404', 'Organic Chemistry', 'Spring', 2024, 80),
('SEC005', 'PHYS505', 'Classical Mechanics', 'Winter', 2024, 120),
('SEC006', 'HIST606', 'World History', 'Winter', 2024, 50),
('SEC007', 'PHYS601', 'Quantum Physics', 'Spring', 2024, 70),
('SEC008', 'CSE201', 'Data Structures', 'Winter', 2024, 150);

-- Insert into enrolled
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units)
VALUES 
('A123456789', 'SEC003', 'MATH303', 'B+', 3),
('A123456789', 'SEC001', 'CSE101', 'D', 4),
('B987654321', 'SEC002', 'BIOL202', 'A-', 4),
('B987654321', 'SEC004', 'CHEM404', 'B', 3),
('C112233445', 'SEC005', 'PHYS505', 'A+', 4),
('C112233445', 'SEC001', 'CSE101', 'A-', 4),
('D556677889', 'SEC006', 'HIST606', 'B+', 3),
('D556677889', 'SEC004', 'CHEM404', 'C+', 3),
('C112233445', 'SEC007', 'PHYS601', 'A', 4),
('A123456789', 'SEC008', 'CSE201', 'B', 4);