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

                        ResultSet courseRS = null;
                        PreparedStatement courseStatement = null;

                        ResultSet sectionRS = null;
                        PreparedStatement sectionStatement = null;

                        Statement classTitleStatement = null;
                        ResultSet classTitleRS = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");
                            if (action != null && action.equals("roster")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT * FROM student JOIN enrolled ON student.PID = enrolled.PID JOIN course ON course.course_number = enrolled.course_number WHERE section_id = ? AND enrolled.course_number = ?"));

                                statement.setString(1, request.getParameter("section_id"));
                                statement.setString(2, request.getParameter("course_number"));

                                rs = statement.executeQuery();
                            }

                            if(action != null && (action.equals("find") || action.equals("roster"))) {
                                courseStatement = conn.prepareStatement("SELECT course_number FROM classes WHERE title = ? AND quarter = ?::quarter_enum AND year = ?");
                                courseStatement.setString(1, request.getParameter("title"));
                                courseStatement.setString(2, request.getParameter("quarter"));
                                courseStatement.setInt(3, Integer.parseInt(request.getParameter("year")));

                                courseRS = courseStatement.executeQuery();

                                sectionStatement = conn.prepareStatement("SELECT section_id FROM classes WHERE title = ? AND quarter = ?::quarter_enum AND year = ?");
                                sectionStatement.setString(1, request.getParameter("title"));
                                sectionStatement.setString(2, request.getParameter("quarter"));
                                sectionStatement.setInt(3, Integer.parseInt(request.getParameter("year")));

                                sectionRS = sectionStatement.executeQuery();
                            }
                            classTitleStatement = conn.createStatement();
                            classTitleRS = classTitleStatement.executeQuery("SELECT DISTINCT title FROM classes;");
                    %>
                    <table>
                        <tr>
                            <form action="class_roster.jsp" method="get">
                                <input type="hidden" value="find" name="action">
                                <th>
                                    <select name="title" id="title">
                                        <%
                                            while(classTitleRS != null && classTitleRS.next()) {
                                        %>
                                                <option value="<%= String.format("%s", classTitleRS.getString("title")) %>" <%=classTitleRS.getString("title").equals(request.getParameter("title")) ? "selected" : "" %>><%= classTitleRS.getString("title") %></option>
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
                        <% if (courseRS != null) { %>
                        <tr>
                            <th>Course Number</th>
                            <th>Section ID</th>
                        </tr>
                        <% } %>
                        <tr>

                            <form action="class_roster.jsp" method="get">
                                <input type="hidden" value="roster" name="action">
                                <input type="hidden" value="<%= String.format("%s", request.getParameter("title")) %>" name="title">
                                <input type="hidden" value="<%= String.format("%s", request.getParameter("quarter")) %>" name="quarter">
                                <input type="hidden" value="<%= String.format("%s", request.getParameter("year")) %>" name="year">
                                <th>
                                <% if (courseRS != null) { %>
                                    <select name="course_number" id="course_number">
                                        <%
                                            while(courseRS != null && courseRS.next()) {
                                        %>
                                                <option value=<%= courseRS.getString("course_number") %> <%=courseRS.getString("course_number").equals(request.getParameter("course_number")) ? "selected" : "" %>><%= courseRS.getString("course_number") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                <% } else { %>
                                No course sections found.
                                <% } %>
                                </th>
                                <th>
                                <% if (courseRS != null || sectionRS != null) { %>
                                    <select name="section_id" id="section_id">
                                        <%
                                            while(sectionRS != null && sectionRS.next()) {
                                        %>
                                                <option value=<%= sectionRS.getString("section_id") %> <%=sectionRS.getString("section_id").equals(request.getParameter("section_id")) ? "selected" : "" %>><%= sectionRS.getString("section_id") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <% }  %>
                                </th>
                                <% if (courseRS != null || sectionRS != null) { %>
                                <th><input type="submit" value="Get Roster"></th>
                                <% }  %>
                            </form>
                            
                        </tr>
                        <% if (rs != null) { %>
                        <tr>
                            <th>PID</th>
                            <th>SSN</th>
                            <th>First</th>
                            <th>Middle</th>
                            <th>Last</th>
                            <th>Units</th>
                            <th>Enrolled</th>
                            <th>Residency</th>
                            <th>Letter Grade</th>
                            <th>S / U</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs != null && rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("PID") %></td> 
                                <td><%= rs.getString("ssn") %></td> 
                                <td><%= rs.getString("first_name") %></td>   
                                <td><%= rs.getString("middle_name") %></td> 
                                <td><%= rs.getString("last_name") %></td>     
                                <td><%= rs.getString("num_units") %></td>   
                                <td><input type="checkbox" <%=rs.getString("enrolled").equals("t") ? "checked" : "" %> name="enrolled" disabled></td>
                                <td><%= rs.getString("residency") %></td> 
                                <td><input type="checkbox" <%=rs.getString("letter_grade").equals("t") ? "checked" : "" %> name="letter_grade" disabled></td>
                                <td><input type="checkbox" <%=rs.getString("S_or_U").equals("t") ? "checked" : "" %> name="S_or_U" disabled></td>
                            </tr>
                        <%
                            }
                        %>
                        <% } %>
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