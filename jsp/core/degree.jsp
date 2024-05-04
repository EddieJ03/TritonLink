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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO degree VALUES (?, ?::degree_enum, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("degree_id"));
                                pstmt.setString(2, request.getParameter("degree_type"));
                                pstmt.setString(3, request.getParameter("university"));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("total_units")));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM degree");
                    %>
                    <table>
                        <tr>
                            <th>Degree ID</th>
                            <th>University</th>
                            <th>Total Units</th>
                            <th>Degree Type</th>
                        </tr>
                        <tr>
                            <form action="degree.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="degree_id" size="10" required></th>
                                <th><input value="" name="university" size="15" required></th>
                                <th><input type="number" value="" name="total_units" size="15" required></th>
                                <th>
                                    <select name="degree_type" id="degree_type">
                                        <option value="Bachelor">Bachelor</option>
                                        <option value="BS/MS">BS/MS</option>
                                        <option value="MS">MS</option>
                                        <option value="PhD">PhD</option>
                                    </select>
                                </th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("degree_id") %></td>
                                <td><%= rs.getString("university") %></td>
                                <td><%= rs.getString("total_units") %></td>
                                <td><%= rs.getString("degree_type") %></td>
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