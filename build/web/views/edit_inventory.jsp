<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String inventoryId = request.getParameter("id");
    if (inventoryId == null || inventoryId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_inventory.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String namaBahanPokok = "", satuan = "", supplier = "";
    int jumlah = 0;

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch inventory details
        String sql = "SELECT nama_bahan_pokok, jumlah, satuan, supplier FROM inventories WHERE inventory_id = ?";
        stmt = connection.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(inventoryId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            namaBahanPokok = rs.getString("nama_bahan_pokok");
            jumlah = rs.getInt("jumlah");
            satuan = rs.getString("satuan");
            supplier = rs.getString("supplier");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_inventory.jsp&error=Inventory not found");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Inventory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Inventory</h1>
        <form action="<%= request.getContextPath() %>/edit_inventory" method="post">
            <input type="hidden" name="inventory_id" value="<%= inventoryId %>">
            <div class="mb-3">
                <label for="nama_bahan_pokok" class="form-label">Item Name</label>
                <input type="text" class="form-control" id="nama_bahan_pokok" name="nama_bahan_pokok" value="<%= namaBahanPokok %>" required>
            </div>
            <div class="mb-3">
                <label for="jumlah" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="jumlah" name="jumlah" value="<%= jumlah %>" required>
            </div>
            <div class="mb-3">
                <label for="satuan" class="form-label">Unit</label>
                <input type="text" class="form-control" id="satuan" name="satuan" value="<%= satuan %>" required>
            </div>
            <div class="mb-3">
                <label for="supplier" class="form-label">Supplier</label>
                <input type="text" class="form-control" id="supplier" name="supplier" value="<%= supplier %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Item</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
