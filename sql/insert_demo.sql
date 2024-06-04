-- insert students
INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES
('1', 'John', 'A', 'Doe', '123-45-6789', TRUE, NULL),
('2', 'Jane', 'B', 'Smith', '987-65-4321', TRUE, NULL),
('3', 'Alice', 'C', 'Johnson', '567-89-1234', TRUE, NULL),
('4', 'Bob', 'D', 'Brown', '234-56-7890', TRUE, NULL),
('5', 'Carol', 'E', 'Davis', '345-67-8901', TRUE, NULL),
('6', 'David', 'Fri', 'Miller', '456-78-9012', TRUE, NULL),
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
('2', 'CSE', 'MS');

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

-- insert degree
INSERT INTO degree (degree_id, degree_type, university, total_units) VALUES
('BSC in Computer Science', 'Bachelor', 'UCSD', 134),
('MS in Computer Science', 'MS', 'UCSD', 45),
('BSC in Mathematics', 'Bachelor', 'UCSD', 120),
('BSC in Physics', 'Bachelor', 'UCSD', 120),
('BSC in Biology', 'Bachelor', 'UCSD', 120),
('BSC in Chemistry', 'Bachelor', 'UCSD', 120),
('BSC in Statistics', 'Bachelor', 'UCSD', 120);

-- insert concentration
INSERT INTO category (category_id, degree_id, category_name, min_gpa, required_units, is_concentration) VALUES 
('Machine Learning', 'MS in Computer Science', 'Machine Learning', 3, 12, TRUE),
('1', 'BSC in Computer Science', 'Lower Division', 0, 70, FALSE),
('2', 'BSC in Computer Science', 'Upper Division', 0, 40, FALSE),
('3', 'BSC in Computer Science', 'Technical Elective', 0, 70, FALSE),
('4', 'BSC in Mathematics', 'Lower Division', 0, 60, FALSE),
('5', 'BSC in Mathematics', 'Upper Division', 0, 40, FALSE),
('6', 'BSC in Mathematics', 'Technical Elective', 0, 20, FALSE),
('7', 'BSC in Physics', 'Lower Division', 0, 60, FALSE),
('8', 'BSC in Physics', 'Upper Division', 0, 40, FALSE),
('9', 'BSC in Physics', 'Technical Elective', 0, 20, FALSE),
('10', 'BSC in Biology', 'Lower Division', 0, 60, FALSE),
('11', 'BSC in Biology', 'Upper Division', 0, 40, FALSE),
('12', 'BSC in Biology', 'Technical Elective', 0, 20, FALSE),
('13', 'BSC in Chemistry', 'Lower Division', 0, 60, FALSE),
('14', 'BSC in Chemistry', 'Upper Division', 0, 40, FALSE),
('15', 'BSC in Chemistry', 'Technical Elective', 0, 20, FALSE),
('16', 'BSC in Statistics', 'Lower Division', 0, 60, FALSE),
('17', 'BSC in Statistics', 'Upper Division', 0, 40, FALSE),
('18', 'BSC in Statistics', 'Technical Elective', 0, 20, FALSE);

-- Insert courses
INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent) VALUES 
('CSE132A', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE291', 'Computer Science', 4, 4, TRUE, TRUE, FALSE, FALSE),
('CSE101', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE132B', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE232A', 'Computer Science', 4, 4, TRUE, FALSE, TRUE, FALSE),
('MATH101', 'Mathematics', 4, 4, TRUE, FALSE, FALSE, FALSE),
('PHYS101', 'Physics', 4, 4, TRUE, FALSE, TRUE, TRUE),
('BIO101', 'Biology', 4, 4, TRUE, FALSE, TRUE, TRUE),
('CHEM101', 'Chemistry', 4, 4, TRUE, FALSE, TRUE, TRUE),
('STAT101', 'Statistics', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE132C', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE291B', 'Computer Science', 4, 4, TRUE, FALSE, FALSE, FALSE);

-- insert into category course
INSERT INTO category_course (course_number, category_id) VALUES 
('CSE291', 'Machine Learning'), 
('CSE232A', 'Machine Learning'), 
('CSE291B', 'Machine Learning');

-- Insert Prerequisites
INSERT INTO prerequisite (course_number, prereq_course) VALUES 
('CSE132A', 'CSE101'),
('CSE132B', 'CSE132A'),
('CSE232A', 'CSE132A');

-- insert classes
INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES
('S1', 'CSE132A', 'DB System Principles', 'Spring', 2018, 30),
('S2', 'CSE291', 'Advanced Topics in CS', 'Fall', 2017, 30),
('S3', 'CSE101', 'Introduction to Programming', 'Winter', 2017, 30),
('S4', 'CSE132B', 'Advanced Databases', 'Winter', 2018, 30),
('S5', 'CSE232A', 'Machine Learning Algorithms', 'Spring', 2018, 30),
('S6', 'MATH101', 'Calculus I', 'Spring', 2017, 30),
('S7', 'PHYS101', 'Physics I', 'Fall', 2017, 30),
('S8', 'BIO101', 'Introduction to Biology', 'Spring', 2017, 30),
('S9', 'CHEM101', 'General Chemistry', 'Fall', 2017, 30),
('S10', 'STAT101', 'Introduction to Statistics', 'Winter', 2018, 30),
('S11', 'CSE132A', 'DB System Principles 2', 'Fall', 2017, 30),
('S12', 'CSE291B', 'Advanced Topics in Machine Learning 2', 'Winter', 2019, 30),
('S13', 'CSE132C', 'Database System Applications', 'Spring', 2018, 30);

-- insert teaches
INSERT INTO teaches (faculty_name, section_id, course_number) VALUES
('Dr. Alan Turing', 'S1', 'CSE132A'),
('Dr. Ada Lovelace', 'S2', 'CSE291'),
('Dr. Andrew Ng', 'S3', 'CSE101'),
('Dr. Alan Turing', 'S4', 'CSE132B'),
('Dr. Geoffrey Hinton', 'S5', 'CSE232A'),
('Dr. Carl Gauss', 'S6', 'MATH101'),
('Dr. Albert Einstein', 'S7', 'PHYS101'),
('Dr. James Watson', 'S8', 'BIO101'),
('Dr. Marie Curie', 'S9', 'CHEM101'),
('Dr. John Tukey', 'S10', 'STAT101'),
('Dr. Alan Turing', 'S11', 'CSE132A'),
('Dr. Ian Goodfellow', 'S12', 'CSE291B'),
('Dr. Alin D', 'S13', 'CSE132C');

-- Insert weekly meeting
INSERT INTO weekly_meeting (section_id, course_number, meeting_type, start_time, start_date, end_time, end_date, day_of_week, location) VALUES 
('S1', 'CSE132A', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'Mon', 'Room 101'),
('S1', 'CSE132A', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'Wed', 'Room 101'),
('S1', 'CSE132A', 'LE', '10:00:00', '2018-03-01', '11:00:00', '2018-06-01', 'Fri', 'Room 101'),
('S2', 'CSE291', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Mon', 'Room 102'),
('S2', 'CSE291', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Wed', 'Room 102'),
('S2', 'CSE291', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Fri', 'Room 102'),
('S3', 'CSE101', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'Mon', 'Room 103'),
('S3', 'CSE101', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'Wed', 'Room 103'),
('S3', 'CSE101', 'LE', '13:00:00', '2017-01-01', '14:00:00', '2017-03-01', 'Fri', 'Room 103'),
('S4', 'CSE132B', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'Mon', 'Room 104'),
('S4', 'CSE132B', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'Wed', 'Room 104'),
('S4', 'CSE132B', 'LE', '14:00:00', '2018-01-01', '15:00:00', '2018-03-01', 'Fri', 'Room 104'),
('S5', 'CSE232A', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Mon', 'Room 105'),
('S5', 'CSE232A', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Wed', 'Room 105'),
('S5', 'CSE232A', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Fri', 'Room 105'),
('S6', 'MATH101', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'Mon', 'Room 106'),
('S6', 'MATH101', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'Wed', 'Room 106'),
('S6', 'MATH101', 'LE', '09:00:00', '2017-03-01', '10:00:00', '2017-06-01', 'Fri', 'Room 106'),
('S7', 'PHYS101', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'Mon', 'Room 107'),
('S7', 'PHYS101', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'Wed', 'Room 107'),
('S7', 'PHYS101', 'LE', '08:00:00', '2017-09-01', '09:00:00', '2017-12-01', 'Fri', 'Room 107'),
('S8', 'BIO101', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'Mon', 'Room 108'),
('S8', 'BIO101', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'Wed', 'Room 108'),
('S8', 'BIO101', 'LE', '10:00:00', '2017-03-01', '11:00:00', '2017-06-01', 'Fri', 'Room 108'),
('S9', 'CHEM101', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Mon', 'Room 109'),
('S9', 'CHEM101', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Wed', 'Room 109'),
('S9', 'CHEM101', 'LE', '11:00:00', '2017-09-01', '12:00:00', '2017-12-01', 'Fri', 'Room 109'),
('S10', 'STAT101', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'Mon', 'Room 110'),
('S10', 'STAT101', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'Wed', 'Room 110'),
('S10', 'STAT101', 'LE', '12:00:00', '2018-01-01', '13:00:00', '2018-03-01', 'Fri', 'Room 110'),
('S11', 'CSE132A', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'Mon', 'Room 201'),
('S11', 'CSE132A', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'Wed', 'Room 201'),
('S11', 'CSE132A', 'LE', '10:00:00', '2017-09-01', '11:00:00', '2017-12-01', 'Fri', 'Room 201'),
('S12', 'CSE291B', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'Mon', 'Room 112'),
('S12', 'CSE291B', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'Wed', 'Room 112'),
('S12', 'CSE291B', 'LE', '13:00:00', '2019-01-01', '14:00:00', '2019-03-01', 'Fri', 'Room 112'),
('S13', 'CSE132C', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Mon', 'Room 113'),
('S13', 'CSE132C', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Wed', 'Room 113'),
('S13', 'CSE132C', 'LE', '11:00:00', '2018-03-01', '12:00:00', '2018-06-01', 'Fri', 'Room 113');

-- insert enrolled
INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES
('1', 'S2', 'CSE291', 'A', 4),
('1', 'S3', 'CSE101', 'B+', 4),
('2', 'S3', 'CSE101', 'B', 4),
('3', 'S4', 'CSE132B', 'A-', 4),
('4', 'S6', 'MATH101', 'B+', 4),
('5', 'S7', 'PHYS101', 'A', 4),
('6', 'S8', 'BIO101', 'A', 4),
('7', 'S9', 'CHEM101', 'B+', 4),
('1', 'S10', 'STAT101', 'A-', 4),
('1', 'S11', 'CSE132A', 'A', 4),
('2', 'S2', 'CSE291', 'A-', 4),
-- ('1', 'S1', 'CSE132A', 'Incomplete', 4),
('2', 'S1', 'CSE132A', 'Incomplete', 4),
('2', 'S5', 'CSE232A', 'Incomplete', 4),
('3', 'S1', 'CSE132A', 'Incomplete', 4),
('4', 'S1', 'CSE132A', 'Incomplete', 4),
('5', 'S1', 'CSE132A', 'Incomplete', 4),
('6', 'S1', 'CSE132A', 'Incomplete', 4),
('7', 'S1', 'CSE132A', 'Incomplete', 4),
('7', 'S3', 'CSE101', 'A', 4),
('6', 'S3', 'CSE101', 'A', 4);

