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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO course VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("course_number"));
                                pstmt.setString(2, request.getParameter("department"));
                                pstmt.setInt(3, Integer.parseInt(request.getParameter("min_unit")));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("max_unit")));
                            
                                if(request.getParameter("letter_grade") != null)
                                    pstmt.setBoolean(5, true);
                                else
                                    pstmt.setBoolean(5, false);

                                if(request.getParameter("S_or_U") != null)
                                    pstmt.setBoolean(6, true);
                                else
                                    pstmt.setBoolean(6, false);

                                if(request.getParameter("lab_work") != null)
                                    pstmt.setBoolean(7, true);
                                else
                                    pstmt.setBoolean(7, false);

                                if(request.getParameter("instructor_consent") != null)
                                    pstmt.setBoolean(8, true);
                                else
                                    pstmt.setBoolean(8, false);

                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM course");
                    %>
                    <table>
                        <tr>
                            <th>Course Number</th>
                            <th>Department</th>
                            <th>Min Unit</th>
                            <th>Max Unit</th>
                            <th>Letter Grade</th>
                            <th>Satisfactory / Unsatisfactory</th>
                            <th>Lab Work</th>
                            <th>Instructor Consent</th>
                        </tr>
                        <tr>
                            <form action="course.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="course_number" size="10" required></th>
                                <th><input value="" name="department" size="15" required></th>
                                <th><input type="number" value="" name="min_unit" size="15" required></th>
                                <th><input type="number" value="" name="max_unit" size="15" required></th>
                                <th><input type="checkbox" value="true" name="letter_grade" size="10"></th>
                                <th><input type="checkbox" value="true" name="S_or_U" size="10"></th>
                                <th><input type="checkbox" value="true" name="lab_work" size="10"></th>
                                <th><input type="checkbox" value="true" name="instructor_consent" size="10"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("course_number") %></td>
                                <td><%= rs.getString("department") %></td>
                                <td><%= rs.getString("min_unit") %></td>
                                <td><%= rs.getString("max_unit") %></td>
                                <td><%= rs.getString("letter_grade") %></td>
                                <td><%= rs.getString("S_or_U") %></td>
                                <td><%= rs.getString("lab_work") %></td>
                                <td><%= rs.getString("instructor_consent") %></td>
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