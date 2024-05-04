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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO undergraduate VALUES (?, ?::college_enum, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("college"));
                                pstmt.setString(3, request.getParameter("major"));
                                pstmt.setString(4, request.getParameter("minor"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }
                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE undergraduate SET college = ?::college_enum, major = ?, minor = ? WHERE PID = ?"));
                                
                                pstmt.setString(4, request.getParameter("PID"));
                                pstmt.setString(1, request.getParameter("college"));
                                pstmt.setString(2, request.getParameter("major"));
                                pstmt.setString(3, request.getParameter("minor"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM undergraduate WHERE PID = ?");
                                pstmt.setString(1, request.getParameter("PID"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM undergraduate");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>College</th>
                            <th>Major</th>
                            <th>Minor</th>
                        </tr>
                        <tr>
                            <form action="undergrad.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" required></th>
                                <th>
                                    <select name="college" id="college">
                                        <option value="Warren">Warren</option>
                                        <option value="Muir">Muir</option>
                                        <option value="Sixth">Sixth</option>
                                        <option value="ERC">ERC</option>
                                        <option value="Marshall">Marshall</option>
                                        <option value="Revelle">Revelle</option>
                                        <option value="Seventh">Seventh</option>
                                    </select>
                                </th>
                                <th><input value="" name="major" size="10" required></th>
                                <th><input value="" name="minor" size="10" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="undergrad.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td>
                                        <select name="college" id="college">
                                            <option value="Warren" <%=rs.getString("college").equals("Warren") ? "selected" : "" %>>Warren</option>
                                            <option value="Muir" <%=rs.getString("college").equals("Muir") ? "selected" : "" %>>Muir</option>
                                            <option value="Sixth" <%=rs.getString("college").equals("Sixth") ? "selected" : "" %>>Sixth</option>
                                            <option value="ERC" <%=rs.getString("college").equals("ERC") ? "selected" : "" %>>ERC</option>
                                            <option value="Marshall" <%=rs.getString("college").equals("Marshall") ? "selected" : "" %>>Marshall</option>
                                            <option value="Revelle" <%=rs.getString("college").equals("Revelle") ? "selected" : "" %>>Revelle</option>
                                            <option value="Seventh" <%=rs.getString("college").equals("Seventh") ? "selected" : "" %>>Seventh</option>
                                        </select>
                                    </td>
                                    <td><input value="<%= rs.getString("major") %>" name="major" size="10" required></td>                                    
                                    <td><input value="<%= rs.getString("minor") %>" name="minor" size="10" required></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="undergrad.jsp" method="get">
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