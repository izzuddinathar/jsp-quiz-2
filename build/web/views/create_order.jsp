<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = null;
    PreparedStatement tableStmt = null;
    PreparedStatement menuStmt = null;
    ResultSet tableRs = null;
    ResultSet menuRs = null;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        tableStmt = connection.prepareStatement("SELECT nomor_meja FROM tables");
        menuStmt = connection.prepareStatement("SELECT menu_id, nama_menu FROM menus");

        tableRs = tableStmt.executeQuery();
        menuRs = menuStmt.executeQuery();
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>Error fetching data: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Order</h1>
        <form action="<%= request.getContextPath() %>/create_order" method="post">
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <select class="form-control" id="nomor_meja" name="nomor_meja" required>
                    <% while (tableRs.next()) { %>
                    <option value="<%= tableRs.getInt("nomor_meja") %>"><%= tableRs.getInt("nomor_meja") %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="menu_id" class="form-label">Menu</label>
                <select class="form-control" id="menu_id" name="menu_id" required>
                    <% while (menuRs.next()) { %>
                    <option value="<%= menuRs.getInt("menu_id") %>"><%= menuRs.getString("nama_menu") %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="jumlah" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="jumlah" name="jumlah" required>
            </div>
            <div class="mb-3">
                <label for="status_pesanan" class="form-label">Status</label>
                <select class="form-control" id="status_pesanan" name="status_pesanan" required>
                    <option value="dipesan">Dipesan</option>
                    <option value="diproses">Diproses</option>
                    <option value="disajikan">Disajikan</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Order</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (tableRs != null) tableRs.close();
        if (menuRs != null) menuRs.close();
        if (tableStmt != null) tableStmt.close();
        if (menuStmt != null) menuStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
