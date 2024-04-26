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

                            // Use the connection...
                            System.out.println("Connected to PostgreSQL database!");
                            // Remember to close the connection when done.
                            conn.close();
                        } catch (SQLException e) {
                            System.out.println("Connection failed. Check output console.");
                            e.printStackTrace();
                            return;
                        }
                    %>
                    <%
                        try {
                            String action = request.getParameter("action");
                            if (action != null && action.equals("insert")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(
                                ("INSERT INTO Student VALUES (?, ?, ?, ?, ?)"));
                                pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                                pstmt.setString(2, request.getParameter("ID"));
                                
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
                            <th>SSN</th>
                            <th>First</th>
                            <th>Last</th>
                            <th>College</th>
                        </tr>
                        <tr>
                            <form action="students.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="SSN" size="10"></th>
                                <th><input value="" name="ID" size="10"></th>
                                <th><input value="" name="FIRSTNAME" size="15"></th>
                                <th><input value="" name="LASTNAME" size="15"></th>
                                <th><input value="" name="COLLEGE" size="15"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <%-- Get the SSN, which is a number --%>
                                <td><%= rs.getInt("SSN") %></td>
                                <%-- Get the ID --%>
                                <td><%= rs.getString("ID") %></td>
                                <%-- Get the FIRSTNAME --%>
                                <td><%= rs.getString("FIRSTNAME") %></td>
                                <%-- Get the LASTNAME --%>
                                <td><%= rs.getString("LASTNAME") %></td>
                                <%-- Get the COLLEGE --%>
                                <td><%= rs.getString("COLLEGE") %></td>
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
                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
                </td>
            </tr>
        </table>
    </body>
</html>