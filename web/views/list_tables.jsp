<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = "SELECT table_id, nomor_meja, kapasitas, status, created_at, updated_at FROM tables";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Table Management</h1>
    <a href="create_table.jsp" class="btn btn-primary mb-3">Add New Table</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Table Number</th>
                <th>Capacity</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                int index = 1;
                while (rs.next()) {
            %>
            <tr>
                <td><%= index++ %></td>
                <td><%= rs.getInt("nomor_meja") %></td>
                <td><%= rs.getInt("kapasitas") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_table.jsp?id=<%= rs.getInt("table_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_table?id=<%= rs.getInt("table_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>

</html>
