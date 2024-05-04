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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO probation VALUES (?, ?, ?, ?)"));

                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

                                pstmt.setString(1, request.getParameter("PID"));

                                pstmt.setDate(2, new java.sql.Date(dateFormat.parse(request.getParameter("start_date")).getTime()));

                                pstmt.setDate(3, new java.sql.Date(dateFormat.parse(request.getParameter("end_date")).getTime()));
                                pstmt.setString(4, request.getParameter("reason"));

                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }
                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE probation SET start_date = ?, end_date = ?, reason = ? WHERE PID = ?"));
                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                pstmt.setString(4, request.getParameter("PID"));

                                pstmt.setDate(1, new java.sql.Date(dateFormat.parse(request.getParameter("start_date")).getTime()));

                                pstmt.setDate(2, new java.sql.Date(dateFormat.parse(request.getParameter("end_date")).getTime()));
                                pstmt.setString(3, request.getParameter("reason"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM probation WHERE PID = ?");
                                pstmt.setString(1, request.getParameter("PID"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM probation");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>Start</th>
                            <th>End</th>
                            <th>Reason</th>
                        </tr>
                        <tr>
                            <form action="probation.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" required></th>
                                <th><input type="date" name="start_date" required></th>
                                <th><input type="date" name="end_date" required></th>
                                <th><input value="" name="reason" size="15" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="probation.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td><input type="date" value="<%= rs.getString("start_date") %>" name="start_date" size="15" required></td>
                                    <td><input type="date" value="<%= rs.getString("end_date") %>" name="end_date" size="15" required></td>
                                    <td><input value="<%= rs.getString("reason") %>" name="reason" size="15" required></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="probation.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
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