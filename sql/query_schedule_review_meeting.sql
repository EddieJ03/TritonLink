WITH day_mappings AS (
    SELECT unnest(ARRAY['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) AS day_name,
           generate_series(1, 7) AS day_number
),
student_in_this_section AS (
	SELECT PID 
	FROM enrolled e
	JOIN classes cl on e.section_id = cl.section_id
	WHERE cl.year=2024 AND cl.quarter = 'Spring' AND e.section_id = ?
), 
weekly_meeting_of_students_in_this_section AS (SELECT DISTINCT wm.start_date, wm.start_time, wm.end_date, wm.end_time, wm.day_of_week 
	FROM weekly_meeting wm 
	WHERE exists(
		select * from enrolled e
		WHERE wm.course_number = e.course_number and wm.section_id = e.section_id
		and e.PID in (select * from student_in_this_section))
),
weekly_meeting_times as (SELECT DISTINCT t.day::date, wm.start_time, wm.end_time 
	FROM weekly_meeting_of_students_in_this_section wm 
	CROSS JOIN generate_series(
		wm.start_date + ((((SELECT day_number FROM day_mappings WHERE day_name::day_enum = wm.day_of_week) - EXTRACT(DOW FROM wm.start_date) + 7) % 7) || ' days')::interval,
		wm.end_date, interval  '1 week') AS t(day)
	order by t.day::date
),
review_meeting_of_students_in_this_section AS (SELECT DISTINCT rm.start_time, rm.end_time 
	FROM review_meeting rm 
	WHERE exists(
		select * from enrolled e
		WHERE rm.course_number = e.course_number and rm.section_id = e.section_id
		and e.PID in (select * from student_in_this_section))
),
date_choice as (SELECT t.day::date 
	FROM generate_series(?, ?, interval '1 day') AS t(day) 
	order by t.day::date
),
time_choice as (SELECT distinct t.time::time 
	FROM generate_series('2000-01-01', '2000-01-02', interval '1 hour') AS t(time) 
	order by t.time::time
),
date_time_choice as ( select distinct date_choice.day, time_choice.time as start_time, time_choice.time+interval '1 hour' as end_time 
	from date_choice, time_choice
	order by date_choice.day, time_choice.time
)

SELECT d.day, d.start_time, d.end_time
FROM date_time_choice d
WHERE d.start_time >= '08:00:00' and d.end_time <= '20:00:00'
AND d.end_time >= '08:00:00' and d.start_time <= '20:00:00'
AND NOT EXISTS(
	select 1
	from weekly_meeting_times times
	where times.day = d.day
	and (times.start_time, times.end_time) overlaps (d.start_time, d.end_time)
) AND NOT EXISTS(
	select 1
	from review_meeting_of_students_in_this_section times
	where (times.start_time::date, times.end_time::date) overlaps (d.day, d.day)
	and (times.start_time::time, times.end_time::time) overlaps (d.start_time, d.end_time)
);