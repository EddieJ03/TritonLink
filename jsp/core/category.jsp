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

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE category SET category_name = ?, min_gpa = ?, required_units = ?, is_concentration = ? WHERE category_id = ?"));
                                
                                pstmt.setString(5, request.getParameter("category_id"));
                                pstmt.setString(1, request.getParameter("category_name"));
                                pstmt.setFloat(2, Float.parseFloat(request.getParameter("min_gpa")));
                                pstmt.setInt(3 Integer.parseInt(request.getParameter("required_units")));
                            
                                if(request.getParameter("is_concentration") != null)
                                    pstmt.setBoolean(4, true);
                                else
                                    pstmt.setBoolean(4, false);
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM category WHERE category_id = ?"));
                                
                                pstmt.setString(1, request.getParameter("category_id"));
                                
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
                                <form action="category.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("category_id") %>" name="PID">
                                    <td><input value="<%= rs.getString("category_id") %>" name="category_id" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("category_name") %>" name="category_name" size="15" required></td>
                                    <td><input value="<%= rs.getString("min_gpa") %>" name="min_gpa" size="15" required></td>
                                    <td><input value="<%= rs.getString("required_units") %>" name="required_units" size="15" required></td>
                                    <td><input type="checkbox" <%=rs.getString("is_concentration").equals("t") ? "checked" : "" %> name="is_concentration"></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="category.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
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