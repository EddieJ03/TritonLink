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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO PhD VALUES (?, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("PID"));
                                if(request.getParameter("pre_candidacy") != null)
                                    pstmt.setBoolean(2, true);
                                else
                                    pstmt.setBoolean(2, false);
                                
                                pstmt.setString(3, request.getParameter("advisor"));

                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }
                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE PhD SET pre_candidacy = ?, advisor = ? WHERE PID = ?"));
                                
                                pstmt.setString(3, request.getParameter("PID"));
                                if(request.getParameter("pre_candidacy") != null)
                                    pstmt.setBoolean(1, true);
                                else
                                    pstmt.setBoolean(1, false);

                                pstmt.setString(2, request.getParameter("advisor"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM PhD WHERE PID = ?");
                                pstmt.setString(1, request.getParameter("PID"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM PhD");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>Pre Candidacy</th>
                            <th>Advisor</th>
                        </tr>
                        <tr>
                            <form action="phd.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" required></th>
                                <th><input type="checkbox" value="true" name="pre_candidacy" size="10"></th>
                                <th><input value="" name="advisor" size="10" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="phd.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td><input type="checkbox" <%=rs.getString("pre_candidacy").equals("t") ? "checked" : "" %> name="pre_candidacy"></td>
                                    <td><input value="<%= rs.getString("advisor") %>" name="advisor"></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="phd.jsp" method="get">
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