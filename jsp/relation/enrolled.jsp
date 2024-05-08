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
                                PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO enrolled VALUES (?, ?, ?::grade_enum, ?)"));
                                
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("section_id"));
                                pstmt.setString(3, request.getParameter("grade"));
                                pstmt.setInt(4, Integer.parseInt(request.getParameter("num_units")));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("update")) {
                                conn.setAutoCommit(false);
                                // Create the prepared statement and use it to
                                // INSERT the student attrs INTO the Student table.
                                PreparedStatement pstmt = conn.prepareStatement(("UPDATE enrolled SET grade = ?::grade_enum, num_units = ? WHERE PID = ? AND section_id = ?"));
                                
                                pstmt.setString(1, request.getParameter("grade"));
                                pstmt.setString(3, request.getParameter("PID"));
                                pstmt.setString(4, request.getParameter("section_id"));
                                pstmt.setInt(2, Integer.parseInt(request.getParameter("num_units")));
                                
                                pstmt.executeUpdate();
                                conn.commit();
                                conn.setAutoCommit(true);
                            }

                            if (action != null && action.equals("delete")) {
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // DELETE the student FROM the Student table.
                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM enrolled WHERE PID = ? AND section_id = ?");
                                pstmt.setString(1, request.getParameter("PID"));
                                pstmt.setString(2, request.getParameter("section_id"));

                                int rowCount = pstmt.executeUpdate();

                                conn.setAutoCommit(false);
                                conn.setAutoCommit(true);
                            }

                            // Create the statement
                            statement = conn.createStatement();

                            // Use the statement to SELECT the student attributes
                            // FROM the Student table.
                            rs = statement.executeQuery("SELECT * FROM enrolled");
                    %>
                    <table>
                        <tr>
                            <th>PID</th>
                            <th>Section ID</th>
                            <th>Grade</th>
                            <th>Num Units</th>
                        </tr>
                        <tr>
                            <form action="enrolled.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="PID" size="10" maxlength="10" required></th>
                                <th><input value="" name="section_id" size="15" maxlength="50" required></th>
                                <th>
                                    <select name="grade" id="grade">
                                        <option value="A+">A+</option>
                                        <option value="A">A</option>
                                        <option value="A-">A-</option>
                                        <option value="B+">B+</option>
                                        <option value="B">B</option>
                                        <option value="B-">B-</option>
                                        <option value="C+">C+</option>
                                        <option value="C">C</option>
                                        <option value="C-">C-</option>
                                        <option value="D+">D+</option>
                                        <option value="D">D</option>
                                        <option value="D-">D-</option>
                                        <option value="F">F</option>
                                        <option value="S">S</option>
                                        <option value="U">U</option>
                                        <option value="Incomplete">Incomplete</option>
                                    </select>
                                </th>
                                <th><input value="" name="num_units" size="15" type="number" required></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>
                        <%
                            // Iterate over the ResultSet
                            while ( rs.next() ) {
                        %>
                            <tr>
                                <form action="enrolled.jsp" method="get">
                                    <input type="hidden" value="update" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
                                    <td><input value="<%= rs.getString("PID") %>" name="PID" size="10" disabled></td>
                                    <td><input value="<%= rs.getString("section_id") %>" name="section_id" size="15" disabled></td>
                                    <td>
                                        <select name="grade" id="grade">
                                            <option value="A+" <%=rs.getString("grade").equals("A+") ? "selected" : "" %>>A+</option>
                                            <option value="A" <%=rs.getString("grade").equals("A") ? "selected" : "" %>>A</option>
                                            <option value="A-" <%=rs.getString("grade").equals("A-") ? "selected" : "" %>>A-</option>
                                            <option value="B+" <%=rs.getString("grade").equals("B+") ? "selected" : "" %>>B+</option>
                                            <option value="B" <%=rs.getString("grade").equals("B") ? "selected" : "" %>>B</option>
                                            <option value="B-" <%=rs.getString("grade").equals("B-") ? "selected" : "" %>>B-</option>
                                            <option value="C+" <%=rs.getString("grade").equals("C+") ? "selected" : "" %>>C+</option>
                                            <option value="C" <%=rs.getString("grade").equals("C") ? "selected" : "" %>>C</option>
                                            <option value="C-" <%=rs.getString("grade").equals("C-") ? "selected" : "" %>>C-</option>
                                            <option value="D+" <%=rs.getString("grade").equals("D+") ? "selected" : "" %>>D+</option>
                                            <option value="D" <%=rs.getString("grade").equals("D") ? "selected" : "" %>>D</option>
                                            <option value="D-" <%=rs.getString("grade").equals("D-") ? "selected" : "" %>>D-</option>
                                            <option value="F" <%=rs.getString("grade").equals("F") ? "selected" : "" %>>F</option>
                                            <option value="S" <%=rs.getString("grade").equals("S") ? "selected" : "" %>>S</option>
                                            <option value="U" <%=rs.getString("grade").equals("U") ? "selected" : "" %>>U</option>
                                            <option value="Incomplete" <%=rs.getString("grade").equals("Incomplete") ? "selected" : "" %>>Incomplete</option>
                                        </select>
                                    </td>
                                    <td><input value="<%= rs.getString("num_units") %>" name="num_units" size="15"></td>
                                    <td><input type="submit" value="Update"></td>
                                </form>
                                <form action="enrolled.jsp" method="get">
                                    <input type="hidden" value="delete" name="action">
                                    <input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
                                    <input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
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