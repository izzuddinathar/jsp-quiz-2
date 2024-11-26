<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = "SELECT inventory_id, nama_bahan_pokok, jumlah, satuan, supplier, created_at, updated_at FROM inventories";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Inventory Management</h1>
    <a href="create_inventory.jsp" class="btn btn-primary mb-3">Add New Item</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Unit</th>
                <th>Supplier</th>
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
                <td><%= rs.getString("nama_bahan_pokok") %></td>
                <td><%= rs.getInt("jumlah") %></td>
                <td><%= rs.getString("satuan") %></td>
                <td><%= rs.getString("supplier") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_inventory.jsp?id=<%= rs.getInt("inventory_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_inventory?id=<%= rs.getInt("inventory_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
