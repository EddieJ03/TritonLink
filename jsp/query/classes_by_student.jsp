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
                        PreparedStatement statement = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");
                            if (action != null && action.equals("find")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT student.ssn, student.first_name, student.middle_name, student.last_name, enrolled.course_number, enrolled.section_id, enrolled.num_units FROM student JOIN enrolled ON student.PID = enrolled.PID JOIN classes ON enrolled.section_id = classes.section_id AND enrolled.course_number = classes.course_number WHERE student.PID = ? AND classes.quarter = ?::quarter_enum AND classes.year = ?"));

                                statement.setString(1, request.getParameter("PID"));
                                statement.setString(2, request.getParameter("quarter"));
                                statement.setInt(3, Integer.parseInt(request.getParameter("year")));

                                rs = statement.executeQuery();
                            }

                            // for selecting PIDs
                            Statement pidStatement = conn.createStatement();

                            ResultSet pidRS = pidStatement.executeQuery("SELECT PID FROM student");
                            //
                    %>
                    <table>
                        <tr>
                            <form action="classes_by_student.jsp" method="get">
                                <input type="hidden" value="find" name="action">
                                <th>
                                    <select name="PID" id="PID">
                                        <%
                                            while(pidRS.next()) {
                                        %>
                                                <option value=<%= pidRS.getString("PID") %> <%=pidRS.getString("PID").equals(request.getParameter("PID")) ? "selected" : "" %>><%= pidRS.getString("PID") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th>
                                    <select name="quarter" id="quarter" required>
                                        <option value="Fall" <%=(request.getParameter("quarter") == null || request.getParameter("quarter").equals("Fall")) ? "selected" : "" %>>Fall</option>
                                        <option value="Winter" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Winter")) ? "selected" : "" %>>Winter</option>
                                        <option value="Spring" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Spring")) ? "selected" : "" %>>Spring</option>
                                        <option value="Summer" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Summer")) ? "selected" : "" %>>Summer</option>
                                    </select>
                                </th>
                                <th><input type="number"  value="<%= request.getParameter("year") == null ? 2024 : request.getParameter("year") %>" name="year" size="15" required></th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>SSN</th>
                            <th>First</th>
                            <th>Middle</th>
                            <th>Last</th>
                            <th>Course</th>
                            <th>Section</th>
                            <th>Units</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs != null && rs.next() ) {

                                System.out.println(rs.getString("course_number"));
                        %>
                            <tr>
                                <td><%= rs.getString("ssn") %></td> 
                                <td><%= rs.getString("first_name") %></td>   
                                <td><%= rs.getString("middle_name") %></td> 
                                <td><%= rs.getString("last_name") %></td>     
                                <td><%= rs.getString("course_number") %></td>         
                                <td><%= rs.getString("section_id") %></td>   
                                <td><%= rs.getString("num_units") %></td>   
                            </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                            // Close the ResultSet
                            if(rs != null)
                                rs.close();
                            // Close the Statement
                            if(statement != null)
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