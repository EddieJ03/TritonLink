<%@ page import="java.sql.*" %>

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
                                    "jdbc:postgresql://localhost:5432/postgres", // JDBC URL for PostgreSQL (/postgres is the database so may need to change on your end)
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
                    Statement code
                    Presentation code
                    Close connection code
                </td>
            </tr>
        </table>
    </body>
</html>