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

                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO category_course VALUES (?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("course_number"));
                                pstmt.setString(2, request.getParameter("category_id"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM category_course WHERE course_number = ? AND category_id = ?");
                                pstmt.setString(1, request.getParameter("course_number"));
                                pstmt.setString(2, request.getParameter("category_id"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            rs = statement.executeQuery("SELECT * FROM category_course");
                    %>
                    <table>
                        <tr>
                            <th>Course Number</th>
                            <th>Category ID</th>
                        </tr>
                        <tr>
                            <form action="category_course.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="course_number" size="10" maxlength="10" required></th>
                                <th><input value="" name="category_id" size="15" maxlength="50" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="category_course.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <td><input value="<%= rs.getString("course_number") %>" name="course_number" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("category_id") %>" name="category_id" size="10" disabled></td>
                                    <input type="hidden" value="<%= rs.getString("course_number") %>" name="course_number">
                                    <input type="hidden" value="<%= rs.getString("category_id") %>" name="category_id">
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