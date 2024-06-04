-- insert students
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES
('1', 'John', 'A', 'Doe', '123-45-6789', TRUE, NULL),
('2', 'Jane', 'B', 'Smith', '987-65-4321', TRUE, NULL),
('3', 'Alice', 'C', 'Johnson', '567-89-1234', TRUE, NULL),
('4', 'Bob', 'D', 'Brown', '234-56-7890', TRUE, NULL),
('5', 'Carol', 'E', 'Davis', '345-67-8901', TRUE, NULL),
('6', 'David', 'F', 'Miller', '456-78-9012', TRUE, NULL),
('7', 'Eve', 'G', 'Wilson', '567-89-0123', TRUE, NULL);

-- insert undergrad
INSERT INTO undergraduate (PID, college, major, minor) VALUES
('1', 'Warren', 'Computer Science', 'Statistics'),
('3', 'Muir', 'Computer Science', 'Statistics'),
('4', 'Sixth', 'Computer Science', 'Statistics'),
('5', 'ERC', 'Computer Science', 'Statistics'),
('6', 'Marshall', 'Computer Science', 'Statistics'),
('7', 'Revelle', 'Computer Science', 'Statistics');

-- insert graduate
INSERT INTO graduate (PID, department, grad_type) VALUES
('2', 'CSE', 'PhD');

-- insert faculty
INSERT INTO faculty (name, title, department) VALUES
('Dr. Alan Turing', 'Professor', 'Computer Science'),
('Dr. Ada Lovelace', 'Professor', 'Computer Science'),
('Dr. Andrew Ng', 'Professor', 'Computer Science'),
('Dr. Geoffrey Hinton', 'Professor', 'Computer Science'),
('Dr. Carl Gauss', 'Professor', 'Mathematics'),
('Dr. Albert Einstein', 'Professor', 'Physics'),
('Dr. James Watson', 'Professor', 'Biology'),
('Dr. Marie Curie', 'Professor', 'Chemistry'),
('Dr. John Tukey', 'Professor', 'Statistics'),
('Dr. Ian Goodfellow', 'Professor', 'Computer Science'),
('Dr. Alin D', 'Professor', 'Computer Science');


-- Insert courses
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent) VALUES 
('CSE132A', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE291', 'Computer Science', 4, 4, TRUE, TRUE, FALSE, FALSE),
('CSE101', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE132B', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE232A', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('MATH101', 'Mathematics', 4, 4, TRUE, FALSE, FALSE, FALSE),
('PHYS101', 'Physics', 4, 4, TRUE, FALSE, FALSE, TRUE),
('BIO101', 'Biology', 4, 4, TRUE, FALSE, FALSE, TRUE),
('CHEM101', 'Chemistry', 4, 4, TRUE, FALSE, FALSE, TRUE),
('STAT101', 'Statistics', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE132C', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE291B', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE);

-- Insert Prerequisites
INSERT INTO prerequisite (course_number, prereq_course) VALUES 
('CSE132A', 'CSE101'),
('CSE132B', 'CSE132A'),
('CSE232A', 'CSE132A');

-- insert classes
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES
('S1', '1', 'DB System Principles', 'Spring', 2018, 30),
('S2', '2', 'Advanced Topics in CS', 'Fall', 2017, 30),
('S3', '3', 'Introduction to Programming', 'Winter', 2017, 30),
('S4', '4', 'Advanced Databases', 'Winter', 2018, 30),
('S5', '5', 'Machine Learning Algorithms', 'Spring', 2018, 30),
('S6', '6', 'Calculus I', 'Spring', 2017, 30),
('S7', '7', 'Physics I', 'Fall', 2017, 30),
('S8', '8', 'Introduction to Biology', 'Spring', 2017, 30),
('S9', '9', 'General Chemistry', 'Fall', 2017, 30),
('S10', '10', 'Introduction to Statistics', 'Winter', 2018, 30),
('S11', '1', 'DB System Principles 2', 'Fall', 2017, 30),
('S2', '12', 'Advanced Topics in Machine Learning 2', 'Winter', 2019, 30),
('S13', '11', 'Database System Applications', 'Spring', 2018, 30);

-- insert degrees
INSERT INTO degrees (degree_id, degree_type, university, total_units) VALUES
('BSC in Computer Science', 'Bachelor', 'UCSD', 134),
('MS in Computer Science', 'MS', 'UCSD', 45),
('BSC in Mathematics', 'Bachelor', 'UCSD', 120),
('BSC in Physics', 'Bachelor', 'UCSD', 120),
('BSC in Biology', 'Bachelor', 'UCSD', 120),
('BSC in Chemistry', 'Bachelor', 'UCSD', 120),
('BSC in Statistics', 'Bachelor', 'UCSD', 120);

-- Insert weekly meeting
INSERT INTO weekly_meeting (section_id, course_number, meeting_type, start_time, start_date, end_time, end_date, day_of_week, location) VALUES 
('S1', '1', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'M', 'Room 101'),
('S1', '1', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'W', 'Room 101'),
('S1', '1', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'F', 'Room 101'),
('S2', '2', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'M', 'Room 102'),
('S2', '2', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'W', 'Room 102'),
('S2', '2', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'F', 'Room 102'),
('S3', '3', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'M', 'Room 103'),
('S3', '3', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'W', 'Room 103'),
('S3', '3', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'F', 'Room 103'),
('S4', '4', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'M', 'Room 104'),
('S4', '4', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'W', 'Room 104'),
('S4', '4', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'F', 'Room 104'),
('S5', '5', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'M', 'Room 105'),
('S5', '5', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'W', 'Room 105'),
('S5', '5', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'F', 'Room 105'),
('S6', '6', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'M', 'Room 106'),
('S6', '6', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'W', 'Room 106'),
('S6', '6', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'F', 'Room 106'),
('S7', '7', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'M', 'Room 107'),
('S7', '7', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'W', 'Room 107'),
('S7', '7', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'F', 'Room 107'),
('S8', '8', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'M', 'Room 108'),
('S8', '8', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'W', 'Room 108'),
('S8', '8', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'F', 'Room 108'),
('S9', '9', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'M', 'Room 109'),
('S9', '9', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'W', 'Room 109'),
('S9', '9', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'F', 'Room 109'),
('S10', '10', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'M', 'Room 110'),
('S10', '10', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'W', 'Room 110'),
('S10', '10', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'F', 'Room 110'),
('S11', '1', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'M', 'Room 101'),
('S11', '1', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'W', 'Room 101'),
('S11', '1', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'F', 'Room 101'),
('S12', '12', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'M', 'Room 112'),
('S12', '12', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'W', 'Room 112'),
('S12', '12', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'F', 'Room 112'),
('S13', '13', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'M', 'Room 113'),
('S13', '13', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'W', 'Room 113'),
('S13', '13', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'F', 'Room 113');


-- insert enrolled
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES
('1', 'S2', '2', 'A', 4),
('1', 'S3', '3', 'B+', 4),
('2', 'S3', '3', 'B', 4),
('3', 'S4', '4', 'A-', 4),
('4', 'S6', '6', 'B+', 4),
('5', 'S7', '7', 'A', 4),
('6', 'S8', '8', 'A', 4),
('7', 'S9', '9', 'B+', 4),
('1', 'S10', '10', 'A-', 4),
('1', 'S11', '11', 'A', 4),
('2', 'S2', '2', 'A-', 4),
('1', 'S1', '1', NULL, 4),
('2', 'S1', '1', NULL, 4),
('2', 'S5', '5', NULL, 4),
('3', 'S1', '1', NULL, 4),
('4', 'S1', '1', NULL, 4),
('5', 'S1', '1', NULL, 4),
('6', 'S1', '1', NULL, 4),
('7', 'S1', '1', NULL, 4),
('7', 'S3', '3', 'A', 4),
('6', 'S3', '3', 'A', 4);

