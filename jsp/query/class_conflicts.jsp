<%@ page language="java" import="java.sql.*" %>

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
                        ResultSet rs = null;
                        PreparedStatement statement = null;

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
                                statement = conn.prepareStatement(("WITH EnrolledMeetings AS (SELECT C.SECTION_ID as section_id, C.COURSE_NUMBER as course_number, day_of_week, start_time, end_time, C.title as title FROM enrolled E JOIN student s ON s.PID = e.PID JOIN Classes C ON E.SECTION_ID = C.SECTION_ID AND E.COURSE_NUMBER = C.COURSE_NUMBER JOIN weekly_meeting wm ON c.SECTION_ID = wm.SECTION_ID AND c.COURSE_NUMBER = wm.COURSE_NUMBER WHERE S.ssn = ? AND C.year = 2024 AND C.quarter = 'Spring'), NonenrolledMeetings AS (SELECT C.title as title, wm.course_number as course_number, day_of_week, start_time, end_time FROM weekly_meeting wm JOIN Classes C ON wm.SECTION_ID = C.SECTION_ID AND wm.COURSE_NUMBER = C.COURSE_NUMBER WHERE (C.SECTION_ID, C.COURSE_NUMBER) NOT IN ( SELECT section_id, course_number FROM EnrolledMeetings) AND C.year = 2024 AND C.quarter = 'Spring') SELECT em.title as enrolled_title, em.course_number as enrolled_course, nem.title as not_enrolled_title, nem.course_number as not_enrolled_course FROM EnrolledMeetings em JOIN NonenrolledMeetings nem ON em.day_of_week = nem.day_of_week WHERE em.start_time < nem.end_time AND em.end_time > nem.start_time;"));

                                statement.setString(1, request.getParameter("ssn"));

                                rs = statement.executeQuery();
                            }

                            // for selecting PIDs
                            Statement pidStatement = conn.createStatement();

                            ResultSet pidRS = pidStatement.executeQuery("SELECT * FROM student JOIN enrolled ON student.PID = enrolled.PID JOIN classes on classes.section_id = enrolled.section_id AND classes.course_number = enrolled.course_number WHERE classes.year = 2024 AND classes.quarter = 'Spring'");
                            //
                    %>
                    <table>
                        <tr>
                            <form action="class_conflicts.jsp" method="get">
                                <input type="hidden" value="find" name="action">
                                <th>
                                    <select name="ssn" id="ssn">
                                        <%
                                            while(pidRS.next()) {
                                        %>
                                                <option value=<%= pidRS.getString("ssn") %> <%=pidRS.getString("ssn").equals(request.getParameter("ssn")) ? "selected" : "" %>><%= pidRS.getString("ssn") + " / " + pidRS.getString("first_name") + " " + pidRS.getString("middle_name") + " " + pidRS.getString("last_name")%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Not Enrolled Title</th>
                            <th>Not Enrolled Course Number</th>
                            <th>Conflicting Enrolled Title</th>
                            <th>Conflicting Enrolled Course Number</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs != null && rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("not_enrolled_title") %></td> 
                                <td><%= rs.getString("not_enrolled_course") %></td>   
                                <td><%= rs.getString("enrolled_title") %></td> 
                                <td><%= rs.getString("enrolled_course") %></td>   
                            </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                            // Close the ResultSet
                            if(rs != null)
                                rs.close();
                            // Close the Statement
                            if(statement != null)
                                statement.close();
                            // Close the Connection
                            conn.close();
                        } catch (SQLException sqle) {
                            // Close the ResultSet
                            if(rs != null)
                                rs.close();
                            // Close the Statement

                            if(statement != null)
                                statement.close();
                            // Close the Connection

                            if(conn != null)
                                conn.close();

                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            // Close the ResultSet
                            if(rs != null)
                                rs.close();
                            // Close the Statement
                            if(statement != null)
                                statement.close();
                            // Close the Connection
                            
                            if(conn != null)
                                conn.close();
                            
                            out.println(e.getMessage());
                        }
                    %>
                </td>
            </tr>
        </table>
    </body>
</html>