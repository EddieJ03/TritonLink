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
                        ResultSet rsStudent = null;
                        ResultSet rsDegree = null;
                        ResultSet rsCategoryRemaining = null;
                        PreparedStatement statementStudent = null;
                        PreparedStatement statementDegree = null;
                        PreparedStatement statementCategoryRemaining = null;
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

                                statementDegree = conn.prepareStatement(("SELECT degree_id, degree_type, total_units FROM degree WHERE degree_id = ?"));
                                statementDegree.setString(1, request.getParameter("degree_id"));

                                statementCategoryRemaining = conn.prepareStatement(("SELECT c.degree_id, c.category_name, c.required_units - COALESCE(SUM(e.num_units), 0) AS remaining_units, c.required_units FROM category c JOIN category_course cc ON c.category_id = cc.category_id JOIN course co ON cc.course_number = co.course_number LEFT JOIN enrolled e ON co.course_number = e.course_number AND e.PID = ? AND e.grade NOT IN ('F', 'U', 'Incomplete') WHERE c.degree_id = ? AND c.is_concentration = FALSE GROUP BY c.degree_id, c.category_id;"));
                                statementCategoryRemaining.setString(2, request.getParameter("degree_id"));
                                statementCategoryRemaining.setString(1, request.getParameter("PID"));

                                rsStudent = statementStudent.executeQuery();
                                rsDegree = statementDegree.executeQuery();
                                rsCategoryRemaining = statementCategoryRemaining.executeQuery();
                            }

                            // for selecting PIDs
                            pidStatement = conn.createStatement();
                            degreeStatement = conn.createStatement();

                            pidRS = pidStatement.executeQuery("SELECT PID FROM undergraduate");
                            degreeRS = degreeStatement.executeQuery("SELECT degree_id FROM degree WHERE degree_type = 'Bachelor'");
                            //
                    %>
                    <table>
                        <tr>
                            <th>Student ID</th>
                            <th>Degree ID</th>
                        <tr>
                            <form action="degree_reqs.jsp" method="get">
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
                            <th>Remaining Units</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rsStudent.next() && rsDegree.next()) {
                        %>
                        <tr>
                            <td><%= rsStudent.getString("ssn") %></td> 
                            <td><%= rsStudent.getString("first_name") %></td>   
                            <td><%= rsStudent.getString("middle_name") %></td> 
                            <td><%= rsStudent.getString("last_name") %></td>     
                            <td><%= rsDegree.getString("degree_id") %></td>         
                            <td><%= rsDegree.getString("degree_type") %></td>   
                            <td><%= rsDegree.getString("total_units") %></td> 
                        </tr>
                        <%
                            }
                        %>
                        <tr></tr>
                        <tr>
                            <th>Category_Name</th>
                            <th>Remaining Units</th>
                            <th>Total Units</th>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rsCategoryRemaining.next()) {
                        %>
                        <tr>
                            <td><%= rsCategoryRemaining.getString("category_name") %></td>
                            <td><%= rsCategoryRemaining.getString("remaining_units") %></td> 
                            <td><%= rsCategoryRemaining.getString("required_units") %></td>   
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
                            if(statementDegree != null)
                                statementDegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsCategoryRemaining != null)
                                rsCategoryRemaining.close();
                            if(statementCategoryRemaining != null)
                                statementCategoryRemaining.close();
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
                            if(statementDegree != null)
                                statementDegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsCategoryRemaining != null)
                                rsCategoryRemaining.close();
                            if(statementCategoryRemaining != null)
                                statementCategoryRemaining.close();
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
                            if(statementDegree != null)
                                statementDegree.close();
                            if(degreeRS != null)
                                degreeRS.close();
                            if(degreeStatement != null)
                                degreeStatement.close();
                            if(pidRS != null)
                                pidRS.close();
                            if(pidStatement != null)
                                pidStatement.close();
                            if(rsCategoryRemaining != null)
                                rsCategoryRemaining.close();
                            if(statementCategoryRemaining != null)
                                statementCategoryRemaining.close();
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