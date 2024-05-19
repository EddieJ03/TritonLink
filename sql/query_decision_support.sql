-- I added ? for you, you can replace them with actual stuff if u wanna test

-- #2 - takes quarter, year, faculty name in that order
SELECT f.name, te.course_number, 
	SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) AS A,
	SUM(CASE WHEN e.grade = 'B' THEN 1 ELSE 0 END) AS B,
	SUM(CASE WHEN e.grade = 'C' THEN 1 ELSE 0 END) AS C,
	SUM(CASE WHEN e.grade = 'D' THEN 1 ELSE 0 END) AS D,
	SUM(CASE WHEN e.grade NOT IN ('A', 'B', 'C','D') THEN 1 ELSE 0 END) AS other

FROM faculty f
	JOIN teaches te ON f.name = te.faculty_name
	JOIN classes cl ON te.section_id = cl.section_id AND cl.quarter = ? AND cl.year = ?
	JOIN enrolled e ON te.section_id = e.section_id
WHERE f.name = ?
GROUP BY f.name, te.course_number;

-- #3 and #6 - takes faculty name and course number in that order
SELECT f.name, te.course_number, 
	SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) AS A,
	SUM(CASE WHEN e.grade = 'B' THEN 1 ELSE 0 END) AS B,
	SUM(CASE WHEN e.grade = 'C' THEN 1 ELSE 0 END) AS C,
	SUM(CASE WHEN e.grade = 'D' THEN 1 ELSE 0 END) AS D,
	SUM(CASE WHEN e.grade NOT IN ('A', 'B', 'C','D') THEN 1 ELSE 0 END) AS other,
	AVG(g.NUMBER_GRADE) as gpa
FROM faculty f 
	JOIN teaches te ON f.name = te.faculty_name
	JOIN classes cl ON te.section_id = cl.section_id
	JOIN enrolled e ON te.section_id = e.section_id
	LEFT JOIN grade_conversion g ON CAST(e.grade AS CHAR(2)) = g.LETTER_GRADE
WHERE f.name = ? AND cl.course_number = ?
GROUP BY f.name, te.course_number;


-- #4 - takes course number
SELECT cl.course_number, 
	SUM(CASE WHEN e.grade = 'A' THEN 1 ELSE 0 END) AS A,
	SUM(CASE WHEN e.grade = 'B' THEN 1 ELSE 0 END) AS B,
	SUM(CASE WHEN e.grade = 'C' THEN 1 ELSE 0 END) AS C,
	SUM(CASE WHEN e.grade = 'D' THEN 1 ELSE 0 END) AS D,
	SUM(CASE WHEN e.grade NOT IN ('A', 'B', 'C','D') THEN 1 ELSE 0 END) AS other

FROM classes cl
	JOIN enrolled e ON cl.section_id = e.section_id

WHERE cl.course_number = ?

GROUP BY cl.course_number;

