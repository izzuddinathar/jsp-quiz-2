<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = com.example.DatabaseConnection.getConnection();
    PreparedStatement tableStmt = connection.prepareStatement("SELECT nomor_meja FROM tables");
    PreparedStatement menuStmt = connection.prepareStatement("SELECT menu_id, nama_menu FROM menus");
    ResultSet tableRs = tableStmt.executeQuery();
    ResultSet menuRs = menuStmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Payment</h1>
        <form action="<%= request.getContextPath() %>/create_payment" method="post">
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
                <label for="metode_pembayaran" class="form-label">Payment Method</label>
                <select class="form-control" id="metode_pembayaran" name="metode_pembayaran" required>
                    <option value="tunai">Tunai</option>
                    <option value="kartu kredit">Kartu Kredit</option>
                    <option value="kartu debit">Kartu Debit</option>
                    <option value="qris">QRIS</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="belum dibayar">Belum Dibayar</option>
                    <option value="lunas">Lunas</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Payment</button>
        </form>
    </div>
</body>
</html>
<%
    tableRs.close();
    menuRs.close();
    tableStmt.close();
    menuStmt.close();
    connection.close();
%>
