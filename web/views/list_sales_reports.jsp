<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = 
            "SELECT sr.report_id, sr.tanggal, m.nama_menu, sr.harga, sr.total, sr.created_at, sr.updated_at " +
            "FROM sales_reports sr " +
            "JOIN menus m ON sr.menu_id = m.menu_id";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Sales Reports Management</h1>
    <a href="create_sales_report.jsp" class="btn btn-primary mb-3">Add New Report</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Date</th>
                <th>Menu</th>
                <th>Price</th>
                <th>Total</th>
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
                <td><%= rs.getDate("tanggal") %></td>
                <td><%= rs.getString("nama_menu") %></td>
                <td><%= rs.getBigDecimal("harga") %></td>
                <td><%= rs.getBigDecimal("total") %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_sales_report.jsp?id=<%= rs.getInt("report_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_sales_report?id=<%= rs.getInt("report_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
