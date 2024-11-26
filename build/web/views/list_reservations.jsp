<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = 
            "SELECT r.reservasi_id, r.nama_pelanggan, r.nomor_kontak, r.waktu_reservasi, " +
            "t.nomor_meja, r.status, r.created_at, r.updated_at " +
            "FROM reservations r " +
            "JOIN tables t ON r.nomor_meja = t.nomor_meja";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Reservation Management</h1>
    <a href="create_reservation.jsp" class="btn btn-primary mb-3">Add New Reservation</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Customer Name</th>
                <th>Contact Number</th>
                <th>Reservation Time</th>
                <th>Table Number</th>
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
                <td><%= rs.getString("nama_pelanggan") %></td>
                <td><%= rs.getString("nomor_kontak") %></td>
                <td><%= rs.getTimestamp("waktu_reservasi") %></td>
                <td><%= rs.getInt("nomor_meja") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_reservation.jsp?id=<%= rs.getInt("reservasi_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_reservation?id=<%= rs.getInt("reservasi_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
