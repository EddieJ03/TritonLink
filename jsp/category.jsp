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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO category VALUES (?, ?, ?, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("category_id"));
                                pstmt.setString(2, request.getParameter("category_name"));
                                pstmt.setFloat(3, Float.parseFloat(request.getParameter("min_gpa")));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("required_units")));
                            
                                if(request.getParameter("is_concentration") != null)
                                    pstmt.setBoolean(5, true);
                                else
                                    pstmt.setBoolean(5, false);
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM category");
                    %>
                    <table>
                        <tr>
                            <th>Category ID</th>
                            <th>Category Name</th>
                            <th>Min GPA</th>
                            <th>Required Units</th>
                            <th>Is Concentration</th>
                        </tr>
                        <tr>
                            <form action="category.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="category_id" size="10"></th>
                                <th><input value="" name="category_name" size="15"></th>
                                <th><input type="number" step="0.01" value="" name="min_gpa" size="15"></th>
                                <th><input required type="number" value="" name="required_units" size="15"></th>
                                <th><input type="checkbox" value="true" name="is_concentration" size="10"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("category_id") %></td>
                                <td><%= rs.getString("category_name") %></td>
                                <td><%= rs.getString("min_gpa") %></td>
                                <td><%= rs.getString("required_units") %></td>
                                <td><%= rs.getString("is_concentration") %></td>
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