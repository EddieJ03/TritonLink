INSERT INTO course (course_number, department, min_unit, max_unit, letter_grade, S_or_U, lab_work, instructor_consent) VALUES
('CSE100', 'CSE', 4, 4, TRUE, FALSE, FALSE, FALSE),
('CSE110', 'CSE', 4, 4, TRUE, FALSE, TRUE, FALSE),
('CSE120', 'CSE', 4, 4, TRUE, FALSE, FALSE, TRUE);

INSERT INTO classes (section_id, course_number, title, quarter, year, enrollment_limit) VALUES
('001', 'CSE100', 'Advanced Data Structures', 'Spring', 2024, 100),
('002', 'CSE110', 'Software Engineering', 'Spring', 2024, 80),
('003', 'CSE120', 'Operating Systems', 'Spring', 2024, 60);

INSERT INTO student (PID, first_name, middle_name, last_name, ssn, enrolled, residency) VALUES
-- ('A123456789', 'John', 'M', 'Doe', '123-45-6789', TRUE, 'California'),
('A987654321', 'Jane', 'A', 'Smith', '987-65-4321', TRUE, 'International'),
('A112233445', 'Alice', 'B', 'Johnson', '112-23-3445', TRUE, 'Non-CA US'),
('A223344556', 'Bob', 'C', 'Brown', '223-34-4556', TRUE, 'California'),
('A334455667', 'Charlie', 'D', 'Green', '334-45-5667', TRUE, 'International'),
('A445566778', 'Daisy', 'E', 'White', '445-56-6778', TRUE, 'Non-CA US'),
('A556677889', 'Eve', 'F', 'Black', '556-67-7889', TRUE, 'California'),
('A667788990', 'Frank', 'G', 'Grey', '667-78-8990', TRUE, 'International');

INSERT INTO weekly_meeting (section_id, course_number, meeting_type, start_time, start_date, end_time, end_date, day_of_week, location) VALUES
('001', 'CSE100', 'LE', '09:00:00', '2024-04-01', '10:00:00', '2024-06-07', 'Mon', 'Room 101'),
('001', 'CSE100', 'DI', '13:00:00', '2024-04-01', '14:00:00', '2024-06-07', 'Wed', 'Room 102'),
('002', 'CSE110', 'LE', '11:00:00', '2024-04-01', '12:30:00', '2024-06-07', 'Tue', 'Room 201'),
('002', 'CSE110', 'Lab Sessions', '14:00:00', '2024-04-01', '16:00:00', '2024-06-07', 'Thu', 'Room 202'),
('003', 'CSE120', 'LE', '10:00:00', '2024-04-01', '11:30:00', '2024-06-07', 'Mon', 'Room 301'),
('003', 'CSE120', 'DI', '15:00:00', '2024-04-01', '16:30:00', '2024-06-07', 'Wed', 'Room 302');

INSERT INTO review_meeting (section_id, course_number, start_time, end_time, location) VALUES
('001', 'CSE100', '2024-05-01 10:00:00', '2024-05-01 12:00:00', 'Room 101'),
('002', 'CSE110', '2024-05-02 14:00:00', '2024-05-02 16:00:00', 'Room 201'),
('003', 'CSE120', '2024-05-03 10:00:00', '2024-05-03 12:00:00', 'Room 301');

INSERT INTO enrolled (PID, section_id, course_number, grade, num_units) VALUES
('A123456789', '001', 'CSE100', 'Incomplete', 4),
('A223344556', '001', 'CSE100', 'Incomplete', 4),
('A223344556', '003', 'CSE120', 'Incomplete', 4),
('A334455667', '001', 'CSE100', 'Incomplete', 4),
('A445566778', '002', 'CSE110', 'Incomplete', 4),
('A556677889', '002', 'CSE110', 'Incomplete', 4),
('A667788990', '003', 'CSE120', 'Incomplete', 4),
('A987654321', '002', 'CSE110', 'Incomplete', 4),
('A112233445', '003', 'CSE120', 'Incomplete', 4);