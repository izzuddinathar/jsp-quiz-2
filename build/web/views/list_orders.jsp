<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        if (connection == null) {
            throw new SQLException("Database connection is null.");
        }

        // Corrected SQL query
        String sql = 
            "SELECT o.order_id, t.nomor_meja, m.nama_menu AS menu_name, " +
            "o.jumlah, o.status_pesanan, o.created_at, o.updated_at " +
            "FROM orders o " +
            "JOIN tables t ON o.nomor_meja = t.nomor_meja " +
            "JOIN menus m ON o.menu_id = m.menu_id";

        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();

        System.out.println("SQL Query executed successfully.");
%>
<div>
    <h1 class="mb-4">Order Management</h1>
    <a href="create_order.jsp" class="btn btn-primary mb-3">Add New Order</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Table Number</th>
                <th>Menu</th>
                <th>Quantity</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                boolean hasData = false;
                int index = 1;
                while (rs.next()) {
                    hasData = true;
            %>
            <tr>
                <td><%= index++ %></td>
                <td><%= rs.getInt("nomor_meja") %></td>
                <td><%= rs.getString("menu_name") %></td>
                <td><%= rs.getInt("jumlah") %></td>
                <td><%= rs.getString("status_pesanan") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_order.jsp?id=<%= rs.getInt("order_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_order?id=<%= rs.getInt("order_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
            <%
                }
                if (!hasData) {
            %>
            <tr>
                <td colspan="8" class="text-center">No orders found.</td>
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
        out.println("<p>Error fetching orders: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>
