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

                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO pursuing VALUES (?, ?, ?)"));
                                
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("degree_id"));

                                if(request.getParameter("earned") != null)
                                    pstmt.setBoolean(3, true);
                                else
                                    pstmt.setBoolean(3, false);
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE pursuing SET earned = ? WHERE PID = ? AND degree_id = ?"));
                                
                                System.out.println(request.getParameter("PID"));

                                if(request.getParameter("earned") != null)
                                    pstmt.setBoolean(1, true);
                                else
                                    pstmt.setBoolean(1, false);

                                pstmt.setString(2, request.getParameter("PID"));
                                pstmt.setString(3, request.getParameter("degree_id"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM pursuing WHERE PID = ? AND degree_id = ?");
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("degree_id"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            rs = statement.executeQuery("SELECT * FROM pursuing");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>Degree ID</th>
                            <th>Earned</th>
                        </tr>
                        <tr>
                            <form action="pursuing.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" maxlength="10" required></th>
                                <th><input value="" name="degree_id" size="15" maxlength="50" required></th>
                                <th><input type="checkbox" value="true" name="earned"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="pursuing.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input value="<%= rs.getString("PID") %>" name="PID" size="10" type="hidden" >
                                    <input value="<%= rs.getString("degree_id") %>" name="degree_id" size="10" type="hidden" >
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("degree_id") %>" name="degree_id" size="10" disabled></td>
                                    <td><input type="checkbox" <%=rs.getString("earned").equals("t") ? "checked" : "" %> name="earned"></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="pursuing.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <input type="hidden" value="<%= rs.getString("degree_id") %>" name="degree_id">
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