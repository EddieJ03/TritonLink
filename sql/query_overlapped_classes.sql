/* 
Step 1: Identify All Meetings Of Classes Student is Currently Enrolled In
*/
WITH EnrolledMeetings AS (
    SELECT C.SECTION_ID as section_id, C.COURSE_NUMBER as course_number, day_of_week, start_time, end_time
    FROM enrolled E
    JOIN student s ON s.PID = e.PID
    JOIN Classes C ON E.SECTION_ID = C.SECTION_ID AND E.COURSE_NUMBER = C.COURSE_NUMBER
    JOIN weekly_meeting wm ON c.SECTION_ID = wm.SECTION_ID AND c.COURSE_NUMBER = wm.COURSE_NUMBER
    WHERE S.ssn = '223-34-4556'  -- Replace 'X' with the student's SSN
)

/* 
Step 2: Identify All Meetings Of All Clases Student is NOT Enrolled In
*/

, NonenrolledMeetings AS (
    SELECT *
    FROM weekly_meeting wm
    JOIN Classes C ON wm.SECTION_ID = C.SECTION_ID AND wm.COURSE_NUMBER = C.COURSE_NUMBER
    WHERE (C.SECTION_ID, C.COURSE_NUMBER) NOT IN (
        SELECT section_id, course_number FROM EnrolledMeetings
    )
)

/*
Step 3: Find Overlapping Sections
Find sections that have overlapping meeting times with the students current sections.
*/
SELECT em.*, nem.*
FROM EnrolledMeetings em
JOIN NonenrolledMeetings nem ON em.day_of_week = nem.day_of_week
WHERE em.start_time < nem.end_time AND em.end_time > nem.start_time;