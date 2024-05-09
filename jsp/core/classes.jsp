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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO classes VALUES (?, ?, ?, ?::quarter_enum, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("section_id"));
                                pstmt.setString(2, request.getParameter("course_number"));
                                pstmt.setString(3, request.getParameter("title"));
                                pstmt.setString(4, request.getParameter("quarter"));
                                pstmt.setInt(5, Integer.parseInt(request.getParameter("year")));
                                pstmt.setInt(6, Integer.parseInt(request.getParameter("enrollment_limit")));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE classes SET title = ?, quarter = ?::quarter_enum, year = ?, enrollment_limit = ? WHERE course_number = ? AND section_id = ?"));
                                
                                pstmt.setString(5, request.getParameter("course_number"));
                                pstmt.setString(6, request.getParameter("section_id"));
                                pstmt.setString(1, request.getParameter("title"));
                                pstmt.setString(2, request.getParameter("quarter"));
                                pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("enrollment_limit")));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM classes WHERE course_number = ? AND section_id = ?"));
                                
                                pstmt.setString(1, request.getParameter("course_number"));
                                pstmt.setString(2, request.getParameter("section_id"));
                                
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
                            <th>Course Number</th>
                            <th>Title</th>
                            <th>Quarter</th>
                            <th>Year</th>
                            <th>Enrollment Limit</th>
                        </tr>
                        <tr>
                            <form action="classes.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="section_id" size="10" required></th>
                                <th><input value="" name="course_number" size="10" required></th>
                                <th><input value="" name="title" size="15" required></th>
                                <th>
                                    <select name="quarter" id="quarter">
                                        <option value="Fall">Fall</option>
                                        <option value="Winter">Winter</option>
                                        <option value="Spring">Spring</option>
                                        <option value="Summer">Summer</option>
                                    </select>
                                </th>
                                <th><input value="" type="number" name="year" size="10" required></th>
                                <th><input value="" type="number" name="enrollment_limit" size="15" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="classes.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= rs.getString("course_number") %>" name="course_number">
                                    <td><input value="<%= rs.getString("section_id") %>" name="section_id" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("course_number") %>" name="course_number" size="15" disabled></td>
                                    <td><input value="<%= rs.getString("title") %>" name="title" size="15" required></td>

                                    <td>
                                        <select name="quarter" id="quarter">
                                            <option value="Fall" <%=rs.getString("quarter").equals("Fall") ? "selected" : "" %>>Fall</option>
                                            <option value="Winter" <%=rs.getString("quarter").equals("Winter") ? "selected" : "" %>>Winter</option>
                                            <option value="Spring" <%=rs.getString("quarter").equals("Spring") ? "selected" : "" %>>Spring</option>
                                            <option value="Summer" <%=rs.getString("quarter").equals("Summer") ? "selected" : "" %>>Summer</option>
                                        </select>
                                    </td>
                                    <td><input type="number" value="<%= rs.getString("year") %>" name="year" size="15" required></td>
                                    <td><input type="number" value="<%= rs.getString("enrollment_limit") %>" name="enrollment_limit" size="15" required></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="classes.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <input type="hidden" value="<%= rs.getString("course_number") %>" name="course_number">
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