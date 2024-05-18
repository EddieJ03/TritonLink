<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>

<html>
    <body>	
        <table>
            <tr>
                <td>
                    <%
                        try {
                            Class.forName("org.postgresql.Driver");
                        } catch (ClassNotFoundException e) {
                            System.out.println("PostgreSQL JDBC Driver not found.");
                            e.printStackTrace();
                            return;
                        }

                        Connection conn = null;
                        ResultSet rsTimes = null;
                        PreparedStatement statementTimes = null;
                        Statement classStatement = null;
                        ResultSet classRS = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");
                            if (action != null && action.equals("find")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statementTimes = conn.prepareStatement("WITH day_mappings AS (     SELECT unnest(ARRAY['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']) AS day_name,            generate_series(1, 7) AS day_number ), student_in_this_section AS ( SELECT PID  FROM enrolled e JOIN classes cl on e.section_id = cl.section_id WHERE cl.year=2024 AND cl.quarter = 'Spring' AND e.section_id = ? ),  weekly_meeting_of_students_in_this_section AS (SELECT DISTINCT wm.start_date, wm.start_time, wm.end_date, wm.end_time, wm.day_of_week  FROM weekly_meeting wm  WHERE exists( select * from enrolled e WHERE wm.course_number = e.course_number and wm.section_id = e.section_id and e.PID in (select * from student_in_this_section)) ), weekly_meeting_times as (SELECT DISTINCT t.day::date, wm.start_time, wm.end_time  FROM weekly_meeting_of_students_in_this_section wm  CROSS JOIN generate_series( wm.start_date + ((((SELECT day_number FROM day_mappings WHERE day_name::day_enum = wm.day_of_week) - EXTRACT(DOW FROM wm.start_date) + 7) % 7) || ' days')::interval, wm.end_date, interval  '1 week') AS t(day) order by t.day::date ), review_meeting_of_students_in_this_section AS (SELECT DISTINCT rm.start_time, rm.end_time  FROM review_meeting rm  WHERE exists( select * from enrolled e WHERE rm.course_number = e.course_number and rm.section_id = e.section_id and e.PID in (select * from student_in_this_section)) ), date_choice as (SELECT t.day::date  FROM generate_series(?::date, ?::date, interval '1 day') AS t(day)  order by t.day::date ), time_choice as (SELECT distinct t.time::time  FROM generate_series('2000-01-01', '2000-01-02', interval '1 hour') AS t(time)  order by t.time::time ), date_time_choice as ( select distinct date_choice.day, time_choice.time as start_time, time_choice.time+interval '1 hour' as end_time  from date_choice, time_choice order by date_choice.day, time_choice.time )  SELECT d.day, d.start_time, d.end_time FROM date_time_choice d WHERE d.start_time >= '08:00:00' and d.end_time <= '20:00:00' AND d.end_time >= '08:00:00' and d.start_time <= '20:00:00' AND NOT EXISTS( select 1 from weekly_meeting_times times where times.day = d.day and (times.start_time, times.end_time) overlaps (d.start_time, d.end_time) ) AND NOT EXISTS( select 1 from review_meeting_of_students_in_this_section times where (times.start_time::date, times.end_time::date) overlaps (d.day, d.day) and (times.start_time::time, times.end_time::time) overlaps (d.start_time, d.end_time) );");
                                statementTimes.setString(1, request.getParameter("section_id"));
                                statementTimes.setString(2, request.getParameter("start_date"));
                                statementTimes.setString(3, request.getParameter("end_date"));
                                rsTimes = statementTimes.executeQuery();
                            }

                            // for selecting PIDs
                            classStatement = conn.createStatement();

                            classRS = classStatement.executeQuery("SELECT section_id, course_number FROM classes");
                            //
                    %>
                    <table>
                        <tr>
                            <th>Class Section</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        <tr>
                            <form action="schedule_review_meeting.jsp" method="get">
                                <input type="hidden" value="find" name="action">
                                <th>
                                    <select name="section_id" id="section_id">
                                        <%
                                            while(classRS.next()) {
                                        %>
                                                <option value=<%= classRS.getString("section_id") %> <%=classRS.getString("section_id").equals(request.getParameter("section_id")) ? "selected" : "" %>><%= classRS.getString("course_number") %>, <%= classRS.getString("section_id") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th>
                                    <input type="date" value="<%= request.getParameter("start_date") %>" name="start_date" id="start_date">
                                </th>
                                <th>
                                    <input type="date" value="<%= request.getParameter("end_date") %>" name="end_date" id="end_date">
                                </th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Available Times</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
                            SimpleDateFormat formatter = new SimpleDateFormat("MMMM d EEEE");
                            SimpleDateFormat sdfInputTime = new SimpleDateFormat("HH:mm:ss");
                            SimpleDateFormat formatterTime = new SimpleDateFormat("h:mm a");
                            while ( rsTimes != null && rsTimes.next()) {
                                java.util.Date date = sdfInput.parse(rsTimes.getString("day"));
                                java.util.Date start_time = sdfInputTime.parse(rsTimes.getString("start_time"));
                                java.util.Date end_time = sdfInputTime.parse(rsTimes.getString("end_time"));
                        %>
                            <tr>
                            <td><%= formatter.format(date) %></td> 
                            <td><%= formatterTime.format(start_time) %> - <%= formatterTime.format(end_time) %></td>   
                            </tr>
                        <%
                            }
                        %>

                    </table>
                    <%
                            // Close the ResultSet
                            if(rsTimes != null)
                                rsTimes.close();
                            // Close the Statement
                            if(statementTimes != null)
                                statementTimes.close();
                            if(classRS != null)
                                classRS.close();
                            if(classStatement != null)
                                classStatement.close();
                            // Close the Connection
                            conn.close();
                        } catch (SQLException sqle) {
                            // Close the ResultSet
                            if(rsTimes != null)
                                rsTimes.close();
                            // Close the Statement
                            if(statementTimes != null)
                                statementTimes.close();
                            if(classRS != null)
                                classRS.close();
                            if(classStatement != null)
                                classStatement.close();
                            // Close the Connection
                            conn.close();

                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            // Close the ResultSet
                            if(rsTimes != null)
                                rsTimes.close();
                            // Close the Statement
                            if(statementTimes != null)
                                statementTimes.close();
                            if(classRS != null)
                                classRS.close();
                            if(classStatement != null)
                                classStatement.close();
                            conn.close();
                            out.println(e.getMessage());
                        }
                    %>
                </td>
            </tr>
        </table>
    </body>
</html>