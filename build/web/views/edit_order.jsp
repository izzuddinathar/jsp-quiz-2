<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String orderId = request.getParameter("id");
    if (orderId == null || orderId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_orders.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement orderStmt = null;
    PreparedStatement tableStmt = null;
    PreparedStatement menuStmt = null;
    ResultSet orderRs = null;
    ResultSet tableRs = null;
    ResultSet menuRs = null;

    int nomorMeja = 0, menuId = 0, jumlah = 0;
    String statusPesanan = "";

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch the order to edit
        String orderQuery = "SELECT nomor_meja, menu_id, jumlah, status_pesanan FROM orders WHERE order_id = ?";
        orderStmt = connection.prepareStatement(orderQuery);
        orderStmt.setInt(1, Integer.parseInt(orderId));
        orderRs = orderStmt.executeQuery();

        if (orderRs.next()) {
            nomorMeja = orderRs.getInt("nomor_meja");
            menuId = orderRs.getInt("menu_id");
            jumlah = orderRs.getInt("jumlah");
            statusPesanan = orderRs.getString("status_pesanan");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_orders.jsp&error=Order not found");
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
    <title>Edit Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Order</h1>
        <form action="<%= request.getContextPath() %>/edit_order" method="post">
            <input type="hidden" name="order_id" value="<%= orderId %>">
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
                <label for="status_pesanan" class="form-label">Status</label>
                <select class="form-control" id="status_pesanan" name="status_pesanan" required>
                    <option value="dipesan" <%= "dipesan".equals(statusPesanan) ? "selected" : "" %>>Dipesan</option>
                    <option value="diproses" <%= "diproses".equals(statusPesanan) ? "selected" : "" %>>Diproses</option>
                    <option value="disajikan" <%= "disajikan".equals(statusPesanan) ? "selected" : "" %>>Disajikan</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update Order</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (orderRs != null) orderRs.close();
        if (tableRs != null) tableRs.close();
        if (menuRs != null) menuRs.close();
        if (orderStmt != null) orderStmt.close();
        if (tableStmt != null) tableStmt.close();
        if (menuStmt != null) menuStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
