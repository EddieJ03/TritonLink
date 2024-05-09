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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?::residency_enum)"));
                                
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("first_name"));
                                pstmt.setString(3, request.getParameter("middle_name"));
                                pstmt.setString(4, request.getParameter("last_name"));
                                pstmt.setString(5, request.getParameter("ssn"));
                            
                                if(request.getParameter("enrolled") != null)
                                    pstmt.setBoolean(6, true);
                                else
                                    pstmt.setBoolean(6, false);

                                pstmt.setString(7, request.getParameter("residency"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE Student SET first_name = ?, middle_name = ?, last_name = ?, ssn = ?, enrolled = ?, residency = ?::residency_enum WHERE PID = ?"));
                                
                                pstmt.setString(1, request.getParameter("first_name"));
                                pstmt.setString(2, request.getParameter("middle_name"));
                                pstmt.setString(3, request.getParameter("last_name"));
                                pstmt.setString(4, request.getParameter("ssn"));
                            
                                if(request.getParameter("enrolled") != null)
                                    pstmt.setBoolean(5, true);
                                else
                                    pstmt.setBoolean(5, false);

                                pstmt.setString(6, request.getParameter("residency"));
                                pstmt.setString(7, request.getParameter("PID"));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM student WHERE PID = ?");
                                pstmt.setString(1, request.getParameter("PID"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM student");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>First</th>
                            <th>Middle</th>
                            <th>Last</th>
                            <th>SSN</th>
                            <th>Enrolled</th>
                            <th>Residency</th>
                        </tr>
                        <tr>
                            <form action="student.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" required></th>
                                <th><input value="" name="first_name" size="15" required></th>
                                <th><input value="" name="middle_name" size="15"></th>
                                <th><input value="" name="last_name" size="15"></th>
                                <th><input value="" name="ssn" size="10" required></th>
                                <th><input type="checkbox" value="true" name="enrolled"></th>
                                <th>
                                    <select name="residency" id="residency">
                                        <option value="California">California</option>
                                        <option value="International">International</option>
                                        <option value="Non-CA US">Non-CA US</option>
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
                                <form action="student.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("first_name") %>" name="first_name" size="15" required></td>
                                    <td><input value="<%= rs.getString("middle_name") %>" name="middle_name" size="15"></td>
                                    <td><input value="<%= rs.getString("last_name") %>" name="last_name" size="15"></td>
                                    <td><input value="<%= rs.getString("ssn") %>" name="ssn" size="10" required></td>

                                    <td><input type="checkbox" <%=rs.getString("enrolled").equals("t") ? "checked" : "" %> name="enrolled"></td>
                                    <td>
                                        <select name="residency" id="residency">
                                            <option value="California" <%=rs.getString("residency").equals("California") ? "selected" : "" %>>California</option>
                                            <option value="International" <%=rs.getString("residency").equals("International") ? "selected" : "" %>>International</option>
                                            <option value="Non-CA US" <%=rs.getString("residency").equals("Non-CA US") ? "selected" : "" %>>Non-CA US</option>
                                        </select>
                                    </td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="student.jsp" method="get">
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