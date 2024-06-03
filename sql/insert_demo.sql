-- insert students
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES
('1', 'John', 'A', 'Doe', '123-45-6789', TRUE, NULL),
('2', 'Jane', 'B', 'Smith', '987-65-4321', TRUE, NULL),
('3', 'Alice', 'C', 'Johnson', '567-89-1234', TRUE, NULL),
('4', 'Bob', 'D', 'Brown', '234-56-7890', TRUE, NULL),
('5', 'Carol', 'E', 'Davis', '345-67-8901', TRUE, NULL),
('6', 'David', 'F', 'Miller', '456-78-9012', TRUE, NULL),
('7', 'Eve', 'G', 'Wilson', '567-89-0123', TRUE, NULL);

-- insert classes
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES
('1', '1', 'DB System Principles', 'Spring', 2018, 30),
('2', '2', 'Advanced Topics in CS', 'Fall', 2017, 30),
('3', '3', 'Introduction to Programming', 'Winter', 2017, 30),
('4', '4', 'Advanced Databases', 'Winter', 2018, 30),
('5', '5', 'Machine Learning Algorithms', 'Spring', 2018, 30),
('6', '6', 'Calculus I', 'Spring', 2017, 30),
('7', '7', 'Physics I', 'Fall', 2017, 30),
('8', '8', 'Introduction to Biology', 'Spring', 2017, 30),
('9', '9', 'General Chemistry', 'Fall', 2017, 30),
('10', '10', 'Introduction to Statistics', 'Winter', 2018, 30),
('11', '1', 'DB System Principles 2', 'Fall', 2017, 30),
('12', '12', 'Advanced Topics in Machine Learning 2', 'Winter', 2019, 30),
('13', '11', 'Database System Applications', 'Spring', 2018, 30);

-- insert enrolled
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES
('1', '2', '2', 'A', 4),
('1', '3', '3', 'B+', 4),
('2', '3', '3', 'B', 4),
('1', '10', '10', 'A-', 4),
('1', '11', '11', 'A', 4),
('2', '2', '2', 'A-', 4),
('1', '1', '1', NULL, 4),
('2', '1', '1', NULL, 4),
('2', '5', '5', NULL, 4);
