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

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");

                            if (action != null && action.equals("course")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT cl.course_number, SUM(CASE WHEN e.grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END) AS A, SUM(CASE WHEN e.grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END) AS B, SUM(CASE WHEN e.grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END) AS C, SUM(CASE WHEN e.grade IN ('D') THEN 1 ELSE 0 END) AS D, SUM(CASE WHEN e.grade IN ('F','S','U') THEN 1 ELSE 0 END) AS other FROM classes cl JOIN enrolled e ON cl.section_id = e.section_id WHERE cl.course_number = ? GROUP BY cl.course_number;"));


                                statement.setString(1, request.getParameter("course_number"));

                                courseDistRS = statement.executeQuery();
                            }

                            if (action != null && action.equals("course and professor")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT f.name, te.course_number, SUM(CASE WHEN e.grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END) AS A,SUM(CASE WHEN e.grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END) AS B, SUM(CASE WHEN e.grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END) AS C, SUM(CASE WHEN e.grade IN ('D') THEN 1 ELSE 0 END) AS D, SUM(CASE WHEN e.grade IN ('F','S','U') THEN 1 ELSE 0 END) AS other, AVG(g.NUMBER_GRADE) as gpa FROM faculty f JOIN teaches te ON f.name = te.faculty_name JOIN classes cl ON te.section_id = cl.section_id JOIN enrolled e ON te.section_id = e.section_id LEFT JOIN grade_conversion g ON CAST(e.grade AS CHAR(2)) = g.LETTER_GRADE WHERE f.name = ? AND cl.course_number = ? GROUP BY f.name, te.course_number;"));

                                statement.setString(1, request.getParameter("professor"));
                                statement.setString(2, request.getParameter("course_number"));

                                courseProfDistRS = statement.executeQuery();
                            }

                            if (action != null && action.equals("cpq")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("SELECT f.name, te.course_number, SUM(CASE WHEN e.grade IN ('A+', 'A', 'A-') THEN 1 ELSE 0 END) AS A, SUM(CASE WHEN e.grade IN ('B+', 'B', 'B-') THEN 1 ELSE 0 END) AS B, SUM(CASE WHEN e.grade IN ('C+', 'C', 'C-') THEN 1 ELSE 0 END) AS C, SUM(CASE WHEN e.grade IN ('D') THEN 1 ELSE 0 END) AS D, SUM(CASE WHEN e.grade IN ('F','S','U') THEN 1 ELSE 0 END) AS other FROM faculty f JOIN teaches te ON f.name = te.faculty_name JOIN classes cl ON te.section_id = cl.section_id AND cl.quarter = ?::quarter_enum AND cl.year = ? JOIN enrolled e ON te.section_id = e.section_id WHERE f.name = ? AND te.course_number = ? GROUP BY f.name, te.course_number;"));

                                statement.setString(1, request.getParameter("quarter"));
                                statement.setInt(2, Integer.parseInt(request.getParameter("year")));
                                statement.setString(3, request.getParameter("professor"));
                                statement.setString(4, request.getParameter("course_number"));
                                
                                courseProfQuarterDistRS = statement.executeQuery();
                            }
                    %>
                    <table>
                        <tr>
                            <th>Quarter</th>
                            <th>Year</th>
                            <th>Professor</th>
                            <th>Course Number</th>
                        </tr>
                        <tr>
                            <form id="cpq" action="decision_support.jsp" method="get">
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
                                <th><input value="<%= (request.getParameter("professor") == null || request.getParameter("action") == null || !request.getParameter("action").equals("cpq")) ? "" : request.getParameter("professor") %>" name="professor" size="15" required></th>
                                <th><input value="<%= (request.getParameter("course_number") == null || request.getParameter("action") == null || !request.getParameter("action").equals("cpq")) ? "" : request.getParameter("course_number") %>" name="course_number" size="15" required></th>
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
                            while ( courseProfQuarterDistRS != null && courseProfQuarterDistRS.next() ) {
                        %>
                            <tr>
                                <td><%= courseProfQuarterDistRS.getString("name") %></td> 
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
                            <form action="decision_support.jsp" method="get">
                                <input type="hidden" value="course and professor" name="action">
                                <th><input value="<%= (request.getParameter("professor") == null || request.getParameter("action") == null || !request.getParameter("action").equals("course and professor")) ? "" : request.getParameter("professor") %>" name="professor" size="15" required></th>
                                <th><input value="<%= (request.getParameter("course_number") == null || request.getParameter("action") == null || !request.getParameter("action").equals("course and professor")) ? "" : request.getParameter("course_number") %>" name="course_number" size="15" required></th>
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
                            <th>GPA</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( courseProfDistRS != null && courseProfDistRS.next() ) {
                        %>
                            <tr>
                                <td><%= courseProfDistRS.getString("name") %></td> 
                                <td><%= courseProfDistRS.getString("course_number") %></td>   
                                <td><%= courseProfDistRS.getString("A") %></td> 
                                <td><%= courseProfDistRS.getString("B") %></td>     
                                <td><%= courseProfDistRS.getString("C") %></td>         
                                <td><%= courseProfDistRS.getString("D") %></td>   
                                <td><%= courseProfDistRS.getString("other") %></td>   
                                <td><%= courseProfDistRS.getString("gpa") %></td>   
                            </tr>
                        <%
                            }
                        %>
                    </table>
                    <br/>
                    <br/>
                    <table>
                        <tr>
                            <th>Course Number</th>
                        </tr>
                        <tr>
                            <form action="decision_support.jsp" method="get">
                                <input type="hidden" value="course" name="action">
                                <th><input value="<%= (request.getParameter("course_number") == null || request.getParameter("action") == null || !request.getParameter("action").equals("course")) ? "" : request.getParameter("course_number") %>" name="course_number" size="15" required></th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Course Number</th>
                            <th>A</th>
                            <th>B</th>
                            <th>C</th>
                            <th>D</th>
                            <th>Other</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( courseDistRS != null && courseDistRS.next() ) {
                        %>
                            <tr>
                                <td><%= courseDistRS.getString("course_number") %></td>   
                                <td><%= courseDistRS.getString("A") %></td> 
                                <td><%= courseDistRS.getString("B") %></td>     
                                <td><%= courseDistRS.getString("C") %></td>         
                                <td><%= courseDistRS.getString("D") %></td>   
                                <td><%= courseDistRS.getString("other") %></td>   
                            </tr>
                        <%
                            }
                        %>
                    </table>
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