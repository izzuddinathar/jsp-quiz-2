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
    <title>Create Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Sales Report</h1>
        <form action="<%= request.getContextPath() %>/create_sales_report" method="post">
            <div class="mb-3">
                <label for="tanggal" class="form-label">Date</label>
                <input type="date" class="form-control" id="tanggal" name="tanggal" required>
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
                <label for="harga" class="form-label">Price</label>
                <input type="number" step="0.01" class="form-control" id="harga" name="harga" required>
            </div>
            <div class="mb-3">
                <label for="total" class="form-label">Total</label>
                <input type="number" step="0.01" class="form-control" id="total" name="total" required>
            </div>
            <button type="submit" class="btn btn-primary">Create Report</button>
        </form>
    </div>
</body>
</html>
<%
    menuRs.close();
    menuStmt.close();
    connection.close();
%>
