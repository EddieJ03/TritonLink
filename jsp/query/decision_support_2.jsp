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
                        ResultSet courseDistRS = null;
                        ResultSet courseProfDistRS = null;
                        ResultSet courseProfQuarterDistRS = null;
                        PreparedStatement statement = null;

                        Statement courseNumberStatement = null;
                        ResultSet courseNumberRS = null;

                        
                        Statement courseNumberStatement2 = null;
                        ResultSet courseNumberRS2 = null;

                        Statement professorStatement = null;
                        ResultSet professorRS = null;

                        Statement professorStatement2 = null;
                        ResultSet professorRS2 = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");

                            if (action != null && action.equals("course and professor")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT faculty_name, course_number, SUM(A) as A, SUM(B) as B, SUM(C) as C, SUM(D) as D, SUM(other) as other FROM cpg WHERE faculty_name = ? AND course_number = ? GROUP BY faculty_name, course_number;"));

                                statement.setString(1, request.getParameter("professor"));
                                statement.setString(2, request.getParameter("course_number"));

                                courseProfDistRS = statement.executeQuery();
                            }

                            if (action != null && action.equals("cpq")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT faculty_name, course_number, quarter, year, SUM(A) as A, SUM(B) as B, SUM(C) as C, SUM(D) as D, SUM(other) as other FROM cpqg WHERE quarter = ?::quarter_enum AND course_number = ? AND faculty_name = ? AND year = ? GROUP BY faculty_name, course_number, quarter, year;"));

                                statement.setString(1, request.getParameter("quarter"));
                                statement.setString(2, request.getParameter("course_number"));
                                statement.setString(3, request.getParameter("professor"));
                                statement.setInt(4, Integer.parseInt(request.getParameter("year")));

                                courseProfQuarterDistRS = statement.executeQuery();
                            }

                            courseNumberStatement = conn.createStatement();
                            courseNumberRS = courseNumberStatement.executeQuery("SELECT DISTINCT course_number FROM course;");
                            
                            courseNumberStatement2 = conn.createStatement();
                            courseNumberRS2 = courseNumberStatement2.executeQuery("SELECT DISTINCT course_number FROM course;");

                            professorStatement = conn.createStatement();
                            professorRS = professorStatement.executeQuery("SELECT name AS professor FROM faculty;");

                            professorStatement2 = conn.createStatement();
                            professorRS2 = professorStatement2.executeQuery("SELECT name AS professor FROM faculty;");
                    %>
                    <table>
                        <tr>
                            <th>Quarter</th>
                            <th>Year</th>
                            <th>Professor</th>
                            <th>Course Number</th>
                        </tr>
                        <tr>
                            <form id="cpq" action="decision_support_2.jsp" method="get">
                                <input type="hidden" value="cpq" name="action">
                                <th>
                                    <select name="quarter" id="quarter" required>
                                        <option value="Fall" <%=(request.getParameter("quarter") == null || request.getParameter("quarter").equals("Fall")) ? "selected" : "" %>>Fall</option>
                                        <option value="Winter" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Winter")) ? "selected" : "" %>>Winter</option>
                                        <option value="Spring" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Spring")) ? "selected" : "" %>>Spring</option>
                                        <option value="Summer" <%=(request.getParameter("quarter") != null && request.getParameter("quarter").equals("Summer")) ? "selected" : "" %>>Summer</option>
                                    </select>
                                </th>
                                <th><input type="number"  value="<%= request.getParameter("year") == null ? 2024 : request.getParameter("year") %>" name="year" size="15" required></th>
                                <th>
                                    <select name="professor" id="professor">
                                        <%
                                            while (professorRS != null && professorRS.next()) {
                                        %>
                                            <option value="<%= String.format("%s", professorRS.getString("professor")) %>"
                                                <%= professorRS.getString("professor").equals(request.getParameter("professor")) && "cpq".equals(request.getParameter("action")) ? "selected" : "" %>>
                                                <%= professorRS.getString("professor") %>
                                            </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th>
                                    <select name="course_number" id="course_number">
                                        <%
                                            while(courseNumberRS != null && courseNumberRS.next()) {
                                        %>
                                                <option value="<%= String.format("%s", courseNumberRS.getString("course_number")) %>" <%=courseNumberRS.getString("course_number").equals(request.getParameter("course_number")) && request.getParameter("action").equals("cpq") ? "selected" : "" %>><%= courseNumberRS.getString("course_number") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Professor</th>
                            <th>Quarter</th>
                            <th>Year</th>
                            <th>Course Number</th>
                            <th>A</th>
                            <th>B</th>
                            <th>C</th>
                            <th>D</th>
                            <th>Other</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( courseProfQuarterDistRS != null && courseProfQuarterDistRS.next() ) {
                        %>
                            <tr>
                                <td><%= courseProfQuarterDistRS.getString("faculty_name") %></td> 
                                <td><%= courseProfQuarterDistRS.getString("quarter") %></td> 
                                <td><%= courseProfQuarterDistRS.getString("year") %></td> 
                                <td><%= courseProfQuarterDistRS.getString("course_number") %></td>   
                                <td><%= courseProfQuarterDistRS.getString("A") %></td> 
                                <td><%= courseProfQuarterDistRS.getString("B") %></td>     
                                <td><%= courseProfQuarterDistRS.getString("C") %></td>         
                                <td><%= courseProfQuarterDistRS.getString("D") %></td>   
                                <td><%= courseProfQuarterDistRS.getString("other") %></td>   
                            </tr>
                        <%
                            }
                        %>
                    </table>
                    <br/>
                    <br/>
                    <table>
                        <tr>
                            <th>Professor</th>
                            <th>Course Number</th>
                        </tr>
                        <tr>
                            <form action="decision_support_2.jsp" method="get">
                                <input type="hidden" value="course and professor" name="action">
                                <th>
                                    <select name="professor" id="professor">
                                        <%
                                            while (professorRS2 != null && professorRS2.next()) {
                                        %>
                                            <option value="<%= String.format("%s", professorRS2.getString("professor")) %>"
                                                <%= professorRS2.getString("professor").equals(request.getParameter("professor")) && "course and professor".equals(request.getParameter("action")) ? "selected" : "" %>>
                                                <%= professorRS2.getString("professor") %>
                                            </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th>
                                    <select name="course_number" id="course_number">
                                        <%
                                            while(courseNumberRS2 != null && courseNumberRS2.next()) {
                                        %>
                                                <option value="<%= String.format("%s", courseNumberRS2.getString("course_number")) %>" <%=courseNumberRS2.getString("course_number").equals(request.getParameter("course_number")) && request.getParameter("action").equals("course and professor") ? "selected" : "" %>><%= courseNumberRS2.getString("course_number") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Professor</th>
                            <th>Course Number</th>
                            <th>A</th>
                            <th>B</th>
                            <th>C</th>
                            <th>D</th>
                            <th>Other</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( courseProfDistRS != null && courseProfDistRS.next() ) {
                        %>
                            <tr>
                                <td><%= courseProfDistRS.getString("faculty_name") %></td> 
                                <td><%= courseProfDistRS.getString("course_number") %></td>   
                                <td><%= courseProfDistRS.getString("A") %></td> 
                                <td><%= courseProfDistRS.getString("B") %></td>     
                                <td><%= courseProfDistRS.getString("C") %></td>         
                                <td><%= courseProfDistRS.getString("D") %></td>   
                                <td><%= courseProfDistRS.getString("other") %></td>   
                            </tr>
                        <%
                            }
                        %>
                         
                    <%
                            // Close the ResultSet
                            if(courseProfQuarterDistRS != null)
                                courseProfQuarterDistRS.close();
                            if(courseProfDistRS != null)
                                courseProfDistRS.close();
                            if(courseDistRS != null)
                                courseDistRS.close();
                            // Close the Statement
                            if(statement != null)
                                statement.close();

                            if (courseNumberRS != null) {
                                courseNumberRS.close();
                            }
                            if (courseNumberStatement != null) {
                                courseNumberStatement.close();
                            }
                            if (courseNumberRS2 != null) {
                                courseNumberRS2.close();
                            }
                            if (courseNumberStatement2 != null) {
                                courseNumberStatement2.close();
                            }

                            if (professorRS != null) {
                                professorRS.close();
                            }
                            if (professorStatement != null) {
                                professorStatement.close();
                            }
                            if (professorRS2 != null) {
                                professorRS2.close();
                            }
                            if (professorStatement2 != null) {
                                professorStatement2.close();
                            }


                            // Close the Connection
                            conn.close();
                        } catch (SQLException sqle) {
                            // Close the ResultSet
                            if(courseProfQuarterDistRS != null)
                                courseProfQuarterDistRS.close();
                            if(courseProfDistRS != null)
                                courseProfDistRS.close();
                            // Close the Statement
                            if(courseDistRS != null)
                                courseDistRS.close();
                            if(statement != null)
                                statement.close();
                            // Close the Connection
                            if (courseNumberRS != null) {
                                courseNumberRS.close();
                            }
                            if (courseNumberStatement != null) {
                                courseNumberStatement.close();
                            }
                            if (courseNumberRS2 != null) {
                                courseNumberRS2.close();
                            }
                            if (courseNumberStatement2 != null) {
                                courseNumberStatement2.close();
                            }

                            if (professorRS != null) {
                                professorRS.close();
                            }
                            if (professorStatement != null) {
                                professorStatement.close();
                            }
                            if (professorRS2 != null) {
                                professorRS2.close();
                            }
                            if (professorStatement2 != null) {
                                professorStatement2.close();
                            }

                            if(conn != null)
                                conn.close();

                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            // Close the ResultSet
                            if(courseProfQuarterDistRS != null)
                                courseProfQuarterDistRS.close();
                            if(courseProfDistRS != null)
                                courseProfDistRS.close();
                            if(courseDistRS != null)
                                courseDistRS.close();
                            // Close the Statement
                            if(statement != null)
                                statement.close();
                            // Close the Connection

                            if (courseNumberRS != null) {
                                courseNumberRS.close();
                            }
                            if (courseNumberStatement != null) {
                                courseNumberStatement.close();
                            }
                            if (courseNumberRS2 != null) {
                                courseNumberRS2.close();
                            }
                            if (courseNumberStatement2 != null) {
                                courseNumberStatement2.close();
                            }

                            if (professorRS != null) {
                                professorRS.close();
                            }
                            if (professorStatement != null) {
                                professorStatement.close();
                            }
                            if (professorRS2 != null) {
                                professorRS2.close();
                            }
                            if (professorStatement2 != null) {
                                professorStatement2.close();
                            }
                            
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