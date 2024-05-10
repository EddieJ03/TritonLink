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
                        ResultSet rs = null;
                        Statement statement = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");
                            if (action != null && action.equals("insert")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Attendance table.
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO weekly_meeting VALUES (?, ?, ?::meeting_enum, ?::time, ?, ?::time, ?, ?::day_enum, ?)"));

                                pstmt.setString(1, request.getParameter("section_id"));
                                
                                pstmt.setString(2, request.getParameter("course_number"));

                                pstmt.setString(3, request.getParameter("meeting_type"));

                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                pstmt.setString(4, request.getParameter("start_time"));
                                pstmt.setDate(5, new java.sql.Date(dateFormat.parse(request.getParameter("start_date")).getTime()));
                                pstmt.setString(6, request.getParameter("end_time"));
                                pstmt.setDate(7, new java.sql.Date(dateFormat.parse(request.getParameter("end_date")).getTime()));
                                pstmt.setString(8, request.getParameter("day_of_week"));

                                pstmt.setString(9, request.getParameter("location"));

                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE weekly_meeting SET end_time = ?::time, end_date = ?, location = ? WHERE section_id = ? AND meeting_type = ?::meeting_enum AND course_number = ? AND day_of_week = ?::day_enum"));

                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                
                                pstmt.setString(4, request.getParameter("section_id"));
                                pstmt.setString(5, request.getParameter("meeting_type"));
                                pstmt.setString(6, request.getParameter("course_number"));
                                pstmt.setString(7, request.getParameter("day_of_week"));
                                pstmt.setString(1, request.getParameter("end_time"));
                                pstmt.setDate(2, new java.sql.Date(dateFormat.parse(request.getParameter("end_date")).getTime()));
                                pstmt.setString(3, request.getParameter("location"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM weekly_meeting WHERE section_id = ? AND meeting_type = ?::meeting_enum AND course_number = ? AND day_of_week = ?::day_enum");
                                pstmt.setString(1, request.getParameter("section_id"));
                                pstmt.setString(2, request.getParameter("meeting_type"));
                                pstmt.setString(3, request.getParameter("course_number"));
                                pstmt.setString(4, request.getParameter("day_of_week"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM weekly_meeting");
                    %>
                    <table>
                        <tr>
                            <th>Section ID</th>
                            <th>Course Number</th>
                            <th>Meeting Type</th>
                            <th>Day of Week</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Location</th>
                        </tr>
                        <tr>
                            <form action="weekly_meeting.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="section_id" size="10" required></th>
                                <th><input value="" name="course_number" size="10" required></th>
                                <th>
                                    <select name="meeting_type" id="meeting_type">
                                        <option value="LE">Lecture</option>
                                        <option value="DI">Discussion</option>
                                        <option value="Lab Sessions">Lab Session</option>
                                    </select>
                                </th>
                                <th>
                                    <select name="day_of_week" id="day_of_week">
                                        <option value="Monday">Monday</option>
                                        <option value="Tuesday">Tuesday</option>
                                        <option value="Wednesday">Wednesday</option>
                                        <option value="Thursday">Thursday</option>
                                        <option value="Friday">Friday</option>
                                        <option value="Saturday">Saturday</option>
                                        <option value="Sunday">Sunday</option>
                                    </select>
                                </th>
                                <th><input type="date" name="start_date" required></th>
                                <th><input type="date" name="end_date" required></th>
                                <th><input type="time" name="start_time" required></th>
                                <th><input type="time" name="end_time" required></th>
                                <th><input value="" name="location" size="15" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="weekly_meeting.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= rs.getString("course_number") %>" name="course_number">
                                    <input type="hidden" value="<%= rs.getString("meeting_type") %>" name="meeting_type">
                                    <input type="hidden" value="<%= rs.getString("day_of_week") %>" name="day_of_week">
                                    <td><input value="<%= rs.getString("section_id") %>" name="section_id" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("course_number") %>" name="course_number" size="10" disabled></td>
                                    <td>
                                        <select name="meeting_type" id="meeting_type" disabled>
                                            <option value="LE" <%=rs.getString("meeting_type").equals("LE") ? "selected" : "" %>>Lecture</option>
                                            <option value="DI" <%=rs.getString("meeting_type").equals("DI") ? "selected" : "" %>>Discussion</option>
                                            <option value="Lab Sessions" <%=rs.getString("meeting_type").equals("Lab Sessions") ? "selected" : "" %>>Lab Session</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select name="day_of_week" id="day_of_week" disabled>
                                            <option value="Monday" <%=rs.getString("day_of_week").equals("Monday") ? "selected" : "" %>>Monday</option>
                                            <option value="Tuesday" <%=rs.getString("day_of_week").equals("Tuesday") ? "selected" : "" %>>Tuesday</option>
                                            <option value="Wednesday" <%=rs.getString("day_of_week").equals("Wednesday") ? "selected" : "" %>>Wednesday</option>
                                            <option value="Thursday" <%=rs.getString("day_of_week").equals("Thursday") ? "selected" : "" %>>Thursday</option>
                                            <option value="Friday" <%=rs.getString("day_of_week").equals("Friday") ? "selected" : "" %>>Friday</option>
                                            <option value="Saturday" <%=rs.getString("day_of_week").equals("Saturday") ? "selected" : "" %>>Saturday</option>
                                            <option value="Sunday" <%=rs.getString("day_of_week").equals("Sunday") ? "selected" : "" %>>Sunday</option>
                                        </select>
                                    </td>
                                    <th><input type="date" value="<%= rs.getString("start_date") %>" name="start_date" required></th>
                                    <th><input type="date" value="<%= rs.getString("end_date") %>" name="end_date" required></th>
                                    <th><input type="time" value="<%= rs.getString("start_time") %>" name="start_time" required></th>
                                    <th><input type="time" value="<%= rs.getString("end_time") %>" name="end_time" required></th>
                                    <td><input value="<%= rs.getString("location") %>" name="location" size="15" required></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="weekly_meeting.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= rs.getString("meeting_type") %>" name="meeting_type">
                                    <input type="hidden" value="<%= rs.getString("course_number") %>" name="course_number">
                                    <input type="hidden" value="<%= rs.getString("day_of_week") %>" name="day_of_week">
                                    <td><input type="submit" value="Delete"></td>
                                </form>
                            </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                            // Close the ResultSet
                            rs.close();
                            // Close the Statement
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