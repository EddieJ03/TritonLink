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

                        ResultSet allClasses = null;
                        ResultSet cumulativeGrade = null;
                        ResultSet perQuarterYearGrade = null;

                        // Make a connection to the PostgreSQL datasource
                        try {
                            conn = DriverManager.getConnection(
                                    "jdbc:postgresql://localhost:5432/cse132b", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
                                    "postgres", // Database username
                                    "edward" // CHANGE THIS TO YOUR PASSWORD
                            );

                            String action = request.getParameter("action");
                            if (action != null && action.equals("generate")) {
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                statement = conn.prepareStatement(("select * from student JOIN enrolled ON enrolled.PID = student.PID JOIN classes ON classes.course_number = enrolled.course_number AND classes.section_id = enrolled.section_id WHERE ssn = ? ORDER BY classes.year, classes.quarter;"));

                                statement.setString(1, request.getParameter("ssn"));

                                allClasses = statement.executeQuery();

                                rs = statement.executeQuery();

                                // cumulative 

                                // COALESCE NULL TO 0
                                statement = conn.prepareStatement(
                                    "SELECT COALESCE(SUM(e.num_units * co.NUMBER_GRADE) / SUM(e.num_units), 0) AS cumulative_grade FROM student st JOIN enrolled e ON st.PID = e.PID JOIN classes cl ON e.course_number = cl.course_number AND e.section_id = cl.section_id JOIN course c ON c.course_number = cl.course_number JOIN grade_conversion co ON CAST(e.grade AS CHAR(2)) = co.LETTER_GRADE WHERE st.ssn = ? AND c.letter_grade = TRUE AND e.grade != 'Incomplete';"
                                );

                                statement.setString(1, request.getParameter("ssn"));

                                cumulativeGrade = statement.executeQuery();

                                // grade per year + quarter
                                statement = conn.prepareStatement("SELECT cl.year, cl.quarter, COALESCE(SUM(e.num_units * co.NUMBER_GRADE) / SUM(e.num_units), 0) AS grade FROM student st JOIN enrolled e ON st.PID = e.PID JOIN classes cl ON e.course_number = cl.course_number AND e.section_id = cl.section_id JOIN course c ON c.course_number = cl.course_number JOIN grade_conversion co ON CAST(e.grade AS CHAR(2)) = co.LETTER_GRADE WHERE st.ssn = ? AND c.letter_grade = TRUE AND e.grade <> 'Incomplete' GROUP BY cl.year, cl.quarter;");

                                statement.setString(1, request.getParameter("ssn"));

                                perQuarterYearGrade = statement.executeQuery();
                            }

                            // for selecting PIDs
                            Statement ssnStatement = conn.createStatement();

                            ResultSet ssnrs = ssnStatement.executeQuery("SELECT * FROM student WHERE student.enrolled = TRUE");
                            //
                    %>
                    <table>
                        <tr>
                            <form action="grade_report.jsp" method="get">
                                <input type="hidden" value="generate" name="action">
                                <th>
                                    <select name="ssn" id="ssn">
                                        <%
                                            while(ssnrs.next()) {
                                        %>
                                                <option value=<%= ssnrs.getString("ssn") %> <%=ssnrs.getString("ssn").equals(request.getParameter("ssn")) ? "selected" : "" %>><%= ssnrs.getString("ssn") + "/" + ssnrs.getString("first_name") + " " + ssnrs.getString("middle_name") + " " + ssnrs.getString("last_name") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                            
                                <th><input type="submit" value="Generate Report"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>Course Number</th>
                            <th>Section ID</th>
                            <th>Quarter</th>
                            <th>Title</th>
                            <th>Year</th>
                            <th>Enrollment Limit</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs != null && rs.next() ) {
                        %>
                            <tr>
                                <td><%= rs.getString("course_number") %></td> 
                                <td><%=rs.getString("section_id")%></td>
                                <td><%= rs.getString("quarter") %></td> 
                                <td><%= rs.getString("title") %></td>   
                                <td><%= rs.getInt("year") %></td> 
                                <td><%= rs.getString("enrollment_limit") %></td>     
                            </tr>
                        <%
                            }
                        %>
                        <tr>
                            <th>Per Quarter Grade</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( perQuarterYearGrade != null && perQuarterYearGrade.next() ) {
                        %>
                            <tr>
                                <td><%= perQuarterYearGrade.getString("year") %></td>   
                                <td><%= perQuarterYearGrade.getString("quarter") %></td>  
                                <td><%= perQuarterYearGrade.getString("grade") %></td> 
                            </tr>
                        <%
                            }
                        %>
                        <tr>
                            <th>Cumulative Grade</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( cumulativeGrade != null && cumulativeGrade.next() ) {
                        %>
                            <tr>   
                                <td><%= cumulativeGrade.getString("cumulative_grade") %></td> 
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