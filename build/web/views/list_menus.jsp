<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Debug: Check database connection
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Fetch a fresh connection using DatabaseConnection utility
        connection = com.example.DatabaseConnection.getConnection();

        if (connection == null) {
            throw new IllegalStateException("Database connection is null!");
        }
        if (connection.isClosed()) {
            throw new IllegalStateException("Database connection is closed!");
        }

        // SQL query to fetch menu data
        String sql = "SELECT menu_id, nama_menu, kategori, harga, deskripsi, gambar, created_at, updated_at FROM menus";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<div>
    <h1 class="mb-4">Menu Management</h1>
    <a href="create_menu.jsp" class="btn btn-primary mb-3">Add New Menu</a>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Description</th>
                <th>Photo</th>
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
                <td><%= rs.getString("nama_menu") %></td>
                <td><%= rs.getString("kategori") %></td>
                <td><%= rs.getBigDecimal("harga") %></td>
                <td><%= rs.getString("deskripsi") %></td>
                <td>
    <% 
        String photo = rs.getString("gambar");
        if (photo != null && !photo.isEmpty()) { 
    %>
        <img src="<%= request.getContextPath() + "/uploads/" + photo %>" alt="Menu Photo" style="width: 50px; height: 50px; border-radius: 10px;">
    <% 
        } else { 
    %>
        No Photo
    <% 
        } 
    %>
</td>

                <td><%= rs.getTimestamp("created_at") %></td>
                <td><%= rs.getTimestamp("updated_at") %></td>
                <td>
                    <a href="edit_menu.jsp?id=<%= rs.getInt("menu_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="<%= request.getContextPath() %>/delete_menu?id=<%= rs.getInt("menu_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
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
        throw new RuntimeException("Error fetching menus: " + e.getMessage());
    } finally {
        // Properly close resources
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (connection != null) {
            try {
                connection.close(); // Close the connection if it was freshly opened
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
