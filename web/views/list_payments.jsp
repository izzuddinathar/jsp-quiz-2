<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = 
            "SELECT p.payment_id, t.nomor_meja, m.nama_menu, p.jumlah, " +
            "p.metode_pembayaran, p.status, p.created_at, p.updated_at " +
            "FROM payments p " +
            "JOIN tables t ON p.nomor_meja = t.nomor_meja " +
            "JOIN menus m ON p.menu_id = m.menu_id";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Payment Management</h1>
    <a href="create_payment.jsp" class="btn btn-primary mb-3">Add New Payment</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Table Number</th>
                <th>Menu</th>
                <th>Quantity</th>
                <th>Payment Method</th>
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
                <td><%= rs.getString("nama_menu") %></td>
                <td><%= rs.getInt("jumlah") %></td>
                <td><%= rs.getString("metode_pembayaran") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_payment.jsp?id=<%= rs.getInt("payment_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_payment?id=<%= rs.getInt("payment_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
