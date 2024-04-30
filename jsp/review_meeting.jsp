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
                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

                                java.util.Date startDateTime = dateTimeFormat.parse(request.getParameter("start_date") + " " + request.getParameter("start_time"));
                                java.util.Date endDateTime = dateTimeFormat.parse(request.getParameter("end_date") + " " + request.getParameter("end_time"));

                                pstmt.setTimestamp(2, new java.sql.Timestamp(startDateTime.getTime()));
                                pstmt.setTimestamp(3, new java.sql.Timestamp(endDateTime.getTime()));
                                pstmt.setString(4, request.getParameter("location"));

                                pstmt.executeUpdate();
                                conn.commit();
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
                        %>
                            <tr>
                                <td><%= rs.getString("section_id") %></td>
                                <td><%= rs.getString("start_time") %></td>
                                <td></td>
                                <td><%= rs.getString("end_time") %></td>
                                <td></td>
                                <td><%= rs.getString("location") %></td>
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