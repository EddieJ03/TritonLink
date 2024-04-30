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
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO classes VALUES (?, ?, ?::quarter_enum, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("section_id"));
                                pstmt.setString(2, request.getParameter("title"));
                                pstmt.setString(3, request.getParameter("quarter"));
                                pstmt.setInt(4, request.getParameter("year"));
                                pstmt.setInt(5, request.getParameter("enrollment_limit"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM classes");
                    %>
                    <table>
                        <tr>
                            <th>Section ID</th>
                            <th>Title</th>
                            <th>Quarter</th>
                            <th>Year</th>
                            <th>Enrollment Limit</th>
                        </tr>
                        <tr>
                            <form action="classes.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="section_id" size="10"></th>
                                <th><input value="" name="title" size="15"></th>
                                <th>
                                    <select name="quarter" id="quarter">
                                        <option value="Fall">Fall</option>
                                        <option value="Winter">Winter</option>
                                        <option value="Spring">Spring</option>
                                        <option value="Summer">Summer</option>
                                    </select>
                                </th>
                                <th><input value="" name="year" size="10"></th>
                                <th><input value="" name="enrollment_limit" size="15"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("section_id") %></td>
                                <td><%= rs.getString("title") %></td>
                                <td><%= rs.getString("quarter") %></td>
                                <td><%= rs.getString("year") %></td>
                                <td><%= rs.getString("enrollment_limit") %></td>
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