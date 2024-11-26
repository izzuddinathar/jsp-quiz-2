<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = com.example.DatabaseConnection.getConnection();
    PreparedStatement menuStmt = connection.prepareStatement("SELECT menu_id, nama_menu FROM menus");
    ResultSet menuRs = menuStmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Sales Program</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Sales Program</h1>
        <form action="<%= request.getContextPath() %>/create_sales_program" method="post">
            <div class="mb-3">
                <label for="nama_program" class="form-label">Program Name</label>
                <input type="text" class="form-control" id="nama_program" name="nama_program" required>
            </div>
            <div class="mb-3">
                <label for="diskon" class="form-label">Discount (%)</label>
                <input type="number" step="0.01" class="form-control" id="diskon" name="diskon" required>
            </div>
            <div class="mb-3">
                <label for="tanggal_berlaku" class="form-label">Valid Date</label>
                <input type="datetime-local" class="form-control" id="tanggal_berlaku" name="tanggal_berlaku" required>
            </div>
            <div class="mb-3">
                <label for="jam_berlaku" class="form-label">Valid Time</label>
                <input type="time" class="form-control" id="jam_berlaku" name="jam_berlaku" required>
            </div>
            <div class="mb-3">
                <label for="menu_id" class="form-label">Menu (Optional)</label>
                <select class="form-control" id="menu_id" name="menu_id">
                    <option value="">All Menus</option>
                    <% while (menuRs.next()) { %>
                    <option value="<%= menuRs.getInt("menu_id") %>"><%= menuRs.getString("nama_menu") %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="kategori_produk" class="form-label">Category (Optional)</label>
                <select class="form-control" id="kategori_produk" name="kategori_produk">
                    <option value="">All Categories</option>
                    <option value="cemilan">Cemilan</option>
                    <option value="makanan">Makanan</option>
                    <option value="minuman">Minuman</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Program</button>
        </form>
    </div>
</body>
</html>
<%
    menuRs.close();
    menuStmt.close();
    connection.close();
%>
