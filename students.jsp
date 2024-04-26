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

                        // Make a connection to the PostgreSQL datasource
                        try {
                            Connection conn = DriverManager.getConnection(
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

                            // Create the statement
                            Statement statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            ResultSet rs = statement.executeQuery("SELECT * FROM student");
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
                            <form action="students.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10"></th>
                                <th><input value="" name="first_name" size="15"></th>
                                <th><input value="" name="middle_name" size="15"></th>
                                <th><input value="" name="last_name" size="15"></th>
                                <th><input value="" name="ssn" size="10"></th>
                                <th><input type="checkbox" value="true" name="enrolled" size="10"></th>
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
                                <td><%= rs.getString("PID") %></td>
                                <td><%= rs.getString("first_name") %></td>
                                <td><%= rs.getString("middle_name") %></td>
                                <td><%= rs.getString("last_name") %></td>
                                <td><%= rs.getInt("ssn") %></td>
                                <td><%= rs.getString("enrolled") %></td>
                                <td><%= rs.getString("residency") %></td>
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
                            rs.close();
                            // Close the Statement
                            statement.close();
                            // Close the Connection
                            conn.close();

                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            // Close the ResultSet
                            rs.close();
                            // Close the Statement
                            statement.close();
                            // Close the Connection
                            conn.close();
                            
                            out.println(e.getMessage());
                        }
                    %>
                </td>
            </tr>
        </table>
    </body>
</html>