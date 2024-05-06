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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO review_meeting VALUES (?, ?, ?, ?)"));

                                pstmt.setString(1, request.getParameter("section_id"));

                                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                                java.util.Date startDateTime = dateTimeFormat.parse(request.getParameter("start_date") + " " + request.getParameter("start_time"));
                                java.util.Date endDateTime = dateTimeFormat.parse(request.getParameter("end_date") + " " + request.getParameter("end_time"));

                                pstmt.setTimestamp(2, new java.sql.Timestamp(startDateTime.getTime()));
                                pstmt.setTimestamp(3, new java.sql.Timestamp(endDateTime.getTime()));
                                pstmt.setString(4, request.getParameter("location"));

                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }
                            
                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE review_meeting SET end_time = ?, location = ? WHERE section_id = ? AND start_time = ?"));
                                
                                pstmt.setString(3, request.getParameter("section_id"));

                                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                                java.util.Date startDateTime = dateTimeFormat.parse(request.getParameter("start_date") + " " + request.getParameter("start_time"));
                                java.util.Date endDateTime = dateTimeFormat.parse(request.getParameter("end_date") + " " + request.getParameter("end_time"));

                                pstmt.setTimestamp(4, new java.sql.Timestamp(startDateTime.getTime()));
                                pstmt.setTimestamp(1, new java.sql.Timestamp(endDateTime.getTime()));
                                pstmt.setString(2, request.getParameter("location"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM review_meeting WHERE section_id = ? AND start_time = ?");
                                pstmt.setString(1, request.getParameter("section_id"));
                                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                java.util.Date startDateTime = dateTimeFormat.parse(request.getParameter("start_date") + " " + request.getParameter("start_time"));
                                pstmt.setTimestamp(2, new java.sql.Timestamp(startDateTime.getTime()));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM review_meeting");
                    %>
                    <table>
                        <tr>
                            <th>Section ID</th>
                            <th>Start Date</th>
                            <th>Start Time</th>
                            <th>End Date</th>
                            <th>End Time</th>
                            <th>Location</th>
                        </tr>
                        <tr>
                            <form action="review_meeting.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="section_id" size="10" required></th>
                                <th><input type="date" name="start_date" required></th>
                                <th><input type="time" name="start_time" required></th>
                                <th><input type="date" name="end_date" required></th>
                                <th><input type="time" name="end_time" required></th>
                                <th><input value="" name="location" size="10" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                                SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                SimpleDateFormat sdfOutputTime = new SimpleDateFormat("HH:mm");
                                SimpleDateFormat sdfOutputDate = new SimpleDateFormat("yyyy-MM-dd");
                                java.util.Date date = sdfInput.parse(rs.getString("start_time"));
                                String startDate = sdfOutputDate.format(date);
                                String startTime = sdfOutputTime.format(date);
                                date = sdfInput.parse(rs.getString("end_time"));
                                String endDate = sdfOutputDate.format(date);
                                String endTime = sdfOutputTime.format(date);
                        %>
                            <tr>
                                <form action="review_meeting.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= startDate %>" name="start_date">
                                    <input type="hidden" value="<%= startTime %>" name="start_time">
                                    <td><input value="<%= rs.getString("section_id") %>" name="section_id" size="10" disabled></td>
                                    <th><input type="date" value="<%= startDate %>" name="start_date" disabled></th>
                                    <th><input type="time" value="<%= startTime %>" name="start_time" disabled></th>
                                    <th><input type="date" value="<%= endDate %>" name="end_date" required></th>
                                    <th><input type="time" value="<%= endTime %>" name="end_time" required></th>
                                    <td><input value="<%= rs.getString("location") %>" name="location" size="15" required></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="review_meeting.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= startDate %>" name="start_date">
                                    <input type="hidden" value="<%= startTime %>" name="start_time">
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