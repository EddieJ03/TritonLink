<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.text.*" %>

<html>
    <body>	
        <table>
            <tr>
                <th>
                    <%
                        try {
                            Class.forName("org.postgresql.Driver");
                        } catch (ClassNotFoundException e) {
                            System.out.println("PostgreSQL JDBC Driver not found.");
                            e.printStackTrace();
                            return;
                        }

                        Connection conn = null;
                        ResultSet rsStudent = null;
                        ResultSet rsDegree = null;
                        ResultSet rsMissingClasses = null;
                        ResultSet rsCompleted = null;
                        PreparedStatement statementStudent = null;
                        PreparedStatement statementhegree = null;
                        PreparedStatement statementMissingClasses = null;
                        PreparedStatement statementCompleted = null;
                        Statement pidStatement = null;
                        Statement degreeStatement = null;
                        ResultSet pidRS = null;
                        ResultSet degreeRS = null;

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
                                statementStudent = conn.prepareStatement(("SELECT ssn, first_name, middle_name, last_name FROM student WHERE PID = ?"));
                                statementStudent.setString(1, request.getParameter("PID"));

                                statementhegree = conn.prepareStatement(("SELECT degree_id, degree_type, total_units FROM degree WHERE degree_id = ?"));
                                statementhegree.setString(1, request.getParameter("degree_id"));

                                statementMissingClasses = conn.prepareStatement(("SELECT c.degree_id, c.category_name, co.course_number AS courses, MIN(TO_DATE(CONCAT(CASE WHEN cl.quarter = 'Fall' THEN 'September' WHEN cl.quarter = 'Winter' THEN 'December' WHEN cl.quarter = 'Spring' THEN 'March' WHEN cl.quarter = 'Summer' THEN 'June' ELSE 'January' END , ' ', cl.year), 'FMMonth YYYY')) AS next_offered_date FROM category c JOIN category_course cc ON c.category_id = cc.category_id JOIN course co ON cc.course_number = co.course_number LEFT JOIN classes cl ON co.course_number = cl.course_number AND (cl.year > 2024 OR (cl.year = 2024 AND cl.quarter IN ('Summer', 'Fall'))) WHERE c.degree_id = ? AND c.is_concentration = TRUE AND NOT EXISTS (SELECT 1 FROM enrolled e WHERE e.course_number = co.course_number AND e.PID = ?) GROUP BY c.degree_id, c.category_name, courses, cl.section_id;"));
                                statementMissingClasses.setString(1, request.getParameter("degree_id"));
                                statementMissingClasses.setString(2, request.getParameter("PID"));

                                statementCompleted = conn.prepareStatement(("SELECT c.degree_id, c.category_name, c.min_gpa, c.required_units, SUM(e.num_units) AS student_units, AVG(gr.NUMBER_GRADE) as student_gpa, SUM(e.num_units) >= c.required_units AND AVG(gr.NUMBER_GRADE) >= c.min_gpa as completed FROM category c JOIN category_course cc ON c.category_id = cc.category_id JOIN course co ON cc.course_number = co.course_number JOIN classes cl ON co.course_number = cl.course_number JOIN enrolled e ON e.course_number = cl.course_number AND e.section_id = cl.section_id AND e.PID = ? AND e.grade NOT IN ('F', 'S', 'U', 'Incomplete') JOIN grade_conversion gr ON CAST(e.grade AS CHAR(2)) = gr.LETTER_GRADE WHERE c.degree_id = ? AND c.is_concentration = TRUE GROUP BY c.degree_id, c.category_name, c.required_units, c.min_gpa;"));
                                statementCompleted.setString(2, request.getParameter("degree_id"));
                                statementCompleted.setString(1, request.getParameter("PID"));

                                rsStudent = statementStudent.executeQuery();
                                rsDegree = statementhegree.executeQuery();
                                rsMissingClasses = statementMissingClasses.executeQuery();
                                rsCompleted = statementCompleted.executeQuery();
                            }

                            // for selecting PIDs
                            pidStatement = conn.createStatement();
                            degreeStatement = conn.createStatement();

                            pidRS = pidStatement.executeQuery("SELECT PID FROM graduate where grad_type = 'MS'");
                            degreeRS = degreeStatement.executeQuery("SELECT degree_id FROM degree WHERE degree_type = 'MS'");
                            //
                    %>
                    <table>
                        <tr>
                            <th>Student ID</th>
                            <th>Degree ID</th>
                        <tr>
                            <form action="ms_degree_reqs.jsp" method="get">
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
                                    <select name="degree_id" id="degree_id">
                                        <%
                                            while(degreeRS.next()) {
                                        %>
                                                <option value=<%= degreeRS.getString("degree_id") %> <%=degreeRS.getString("degree_id").equals(request.getParameter("degree_id")) ? "selected" : "" %>><%= degreeRS.getString("degree_id") %></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </th>
                                <th><input type="submit" value="Find"></th>
                            </form>
                        </tr>
                        <tr>
                            <th>SSN</th>
                            <th>First</th>
                            <th>Middle</th>
                            <th>Last</th>
                            <th>Degree_Name</th>
                            <th>Degree_Type</th>
                            <th>Required_Units</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rsStudent != null && rsStudent.next() && rsDegree.next()) {
                        %>
                        <tr>
                            <th><%= rsStudent.getString("ssn") %></th> 
                            <th><%= rsStudent.getString("first_name") %></th>   
                            <th><%= rsStudent.getString("middle_name") %></th> 
                            <th><%= rsStudent.getString("last_name") %></th>     
                            <th><%= rsDegree.getString("degree_id") %></th>         
                            <th><%= rsDegree.getString("degree_type") %></th>   
                            <th><%= rsDegree.getString("total_units") %></th> 
                        </tr>
                        <%
                            }
                        %>
                        <tr></tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rsCompleted != null && rsCompleted.next()) {
                                String category = rsCompleted.getString("category_name");
                        %>
                        <tr>
                            <th>Concentration_Name</th>
                            <th>Completed</th>
                            <th>Required_GPA</th>
                            <th>Student_GPA</th>
                            <th>Required_Units</th>
                            <th>Student_Units</th>
                            <th>Missing Classes + Next Offering</th>
                        </tr>
                        <tr>
                            <th><%= rsCompleted.getString("category_name") %></th>
                            <th><%= rsCompleted.getString("completed") %></th> 
                            <th><%= rsCompleted.getString("min_gpa") %></th>   
                            <th><%= rsCompleted.getString("student_gpa") %></th> 
                            <th><%= rsCompleted.getString("required_units") %></th>   
                            <th><%= rsCompleted.getString("student_units") %></th> 
                            <%
                            // Iterate over the ResultSet
                            String classOfferings = "";
                            SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
                            while ( rsMissingClasses.next() && rsMissingClasses.getString("category_name").equals(category)) {
                                java.util.Date date = sdfInput.parse(rsMissingClasses.getString("next_offered_date"));
                                if (date.getYear() < 0) {
                                    classOfferings += rsMissingClasses.getString("courses") + " has no offerings.";
                                    continue;
                                } else {
                                    classOfferings += rsMissingClasses.getString("courses") + " offered ";
                                }

                                switch (date.getMonth()) {
                                    case 0:
                                        classOfferings += "Winter " + (date.getYear() + 1900);
                                        break;
                                    case 3:
                                        classOfferings += "Spring " + (date.getYear() + 1900);
                                        break;
                                    case 6:
                                        classOfferings += "Summer " + (date.getYear() + 1900);
                                        break;
                                    default:
                                        classOfferings += "Fall " + (date.getYear() + 1900);
                                        break;
                                }
                                classOfferings += ", ";
                            }
                            if (classOfferings == "") {
                                classOfferings = "None";
                            }
                            %>
                            <th><%= classOfferings %></th> 
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                            // Close the ResultSet
                            if(rsStudent != null)
                                rsStudent.close();
                            // Close the Statement
                            if(statementStudent != null)
                                statementStudent.close();
                            if(rsDegree != null)
                                rsDegree.close();
                            if(statementhegree != null)
                                statementhegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsMissingClasses != null)
                                rsMissingClasses.close();
                            if(statementMissingClasses != null)
                                statementMissingClasses.close();
                            // Close the Connection
                            conn.close();
                        } catch (SQLException sqle) {
                            // Close the ResultSet
                            if(rsStudent != null)
                                rsStudent.close();
                            // Close the Statement
                            if(statementStudent != null)
                                statementStudent.close();
                            if(rsDegree != null)
                                rsDegree.close();
                            if(statementhegree != null)
                                statementhegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsMissingClasses != null)
                                rsMissingClasses.close();
                            if(statementMissingClasses != null)
                                statementMissingClasses.close();
                            // Close the Connection
                            conn.close();

                            out.println(sqle.getMessage());
                        } catch (Exception e) {
                            // Close the ResultSet
                            if(rsStudent != null)
                                rsStudent.close();
                            // Close the Statement
                            if(statementStudent != null)
                                statementStudent.close();
                            if(rsDegree != null)
                                rsDegree.close();
                            if(statementhegree != null)
                                statementhegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsMissingClasses != null)
                                rsMissingClasses.close();
                            if(statementMissingClasses != null)
                                statementMissingClasses.close();
                            // Close the Connection
                            conn.close();
                            out.println(e.getMessage());
                        }
                    %>
                </th>
            </tr>
        </table>
    </body>
</html>