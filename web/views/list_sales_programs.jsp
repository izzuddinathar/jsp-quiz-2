<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = 
            "SELECT sp.program_id, sp.nama_program, sp.diskon, sp.tanggal_berlaku, sp.jam_berlaku, " +
            "m.nama_menu, sp.kategori_produk, sp.created_at, sp.updated_at " +
            "FROM sales_programs sp " +
            "LEFT JOIN menus m ON sp.menu_id = m.menu_id";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Sales Programs Management</h1>
    <a href="create_sales_program.jsp" class="btn btn-primary mb-3">Add New Program</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Program Name</th>
                <th>Discount</th>
                <th>Valid Date</th>
                <th>Valid Time</th>
                <th>Menu</th>
                <th>Category</th>
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
                <td><%= rs.getString("nama_program") %></td>
                <td><%= rs.getBigDecimal("diskon") %>%</td>
                <td><%= rs.getTimestamp("tanggal_berlaku") %></td>
                <td><%= rs.getTime("jam_berlaku") %></td>
                <td><%= rs.getString("nama_menu") != null ? rs.getString("nama_menu") : "All Menus" %></td>
                <td><%= rs.getString("kategori_produk") != null ? rs.getString("kategori_produk") : "All Categories" %></td>
                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_sales_program.jsp?id=<%= rs.getInt("program_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_sales_program?id=<%= rs.getInt("program_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
