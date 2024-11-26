<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String paymentId = request.getParameter("id");
    if (paymentId == null || paymentId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement paymentStmt = null;
    PreparedStatement tableStmt = null;
    PreparedStatement menuStmt = null;
    ResultSet paymentRs = null;
    ResultSet tableRs = null;
    ResultSet menuRs = null;

    int nomorMeja = 0, menuId = 0, jumlah = 0;
    String metodePembayaran = "", status = "";

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch payment details
        String paymentQuery = "SELECT nomor_meja, menu_id, jumlah, metode_pembayaran, status FROM payments WHERE payment_id = ?";
        paymentStmt = connection.prepareStatement(paymentQuery);
        paymentStmt.setInt(1, Integer.parseInt(paymentId));
        paymentRs = paymentStmt.executeQuery();

        if (paymentRs.next()) {
            nomorMeja = paymentRs.getInt("nomor_meja");
            menuId = paymentRs.getInt("menu_id");
            jumlah = paymentRs.getInt("jumlah");
            metodePembayaran = paymentRs.getString("metode_pembayaran");
            status = paymentRs.getString("status");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp&error=Payment not found");
            return;
        }

        // Fetch available tables and menus
        tableStmt = connection.prepareStatement("SELECT nomor_meja FROM tables");
        menuStmt = connection.prepareStatement("SELECT menu_id, nama_menu FROM menus");
        tableRs = tableStmt.executeQuery();
        menuRs = menuStmt.executeQuery();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Payment</h1>
        <form action="<%= request.getContextPath() %>/edit_payment" method="post">
            <input type="hidden" name="payment_id" value="<%= paymentId %>">
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <select class="form-control" id="nomor_meja" name="nomor_meja" required>
                    <% while (tableRs.next()) { %>
                    <option value="<%= tableRs.getInt("nomor_meja") %>" <%= tableRs.getInt("nomor_meja") == nomorMeja ? "selected" : "" %>>
                        <%= tableRs.getInt("nomor_meja") %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="menu_id" class="form-label">Menu</label>
                <select class="form-control" id="menu_id" name="menu_id" required>
                    <% while (menuRs.next()) { %>
                    <option value="<%= menuRs.getInt("menu_id") %>" <%= menuRs.getInt("menu_id") == menuId ? "selected" : "" %>>
                        <%= menuRs.getString("nama_menu") %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="jumlah" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="jumlah" name="jumlah" value="<%= jumlah %>" required>
            </div>
            <div class="mb-3">
                <label for="metode_pembayaran" class="form-label">Payment Method</label>
                <select class="form-control" id="metode_pembayaran" name="metode_pembayaran" required>
                    <option value="tunai" <%= "tunai".equals(metodePembayaran) ? "selected" : "" %>>Tunai</option>
                    <option value="kartu kredit" <%= "kartu kredit".equals(metodePembayaran) ? "selected" : "" %>>Kartu Kredit</option>
                    <option value="kartu debit" <%= "kartu debit".equals(metodePembayaran) ? "selected" : "" %>>Kartu Debit</option>
                    <option value="qris" <%= "qris".equals(metodePembayaran) ? "selected" : "" %>>QRIS</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="belum dibayar" <%= "belum dibayar".equals(status) ? "selected" : "" %>>Belum Dibayar</option>
                    <option value="lunas" <%= "lunas".equals(status) ? "selected" : "" %>>Lunas</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update Payment</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (paymentRs != null) paymentRs.close();
        if (tableRs != null) tableRs.close();
        if (menuRs != null) menuRs.close();
        if (paymentStmt != null) paymentStmt.close();
        if (tableStmt != null) tableStmt.close();
        if (menuStmt != null) menuStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
