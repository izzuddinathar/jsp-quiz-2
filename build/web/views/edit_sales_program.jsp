<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String programId = request.getParameter("id");
    if (programId == null || programId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_programs.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement programStmt = null;
    PreparedStatement menuStmt = null;
    ResultSet programRs = null;
    ResultSet menuRs = null;

    String namaProgram = "", tanggalBerlaku = "", jamBerlaku = "", kategoriProduk = "";
    double diskon = 0;
    int menuId = 0;

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch program details
        String programQuery = "SELECT nama_program, diskon, tanggal_berlaku, jam_berlaku, menu_id, kategori_produk FROM sales_programs WHERE program_id = ?";
        programStmt = connection.prepareStatement(programQuery);
        programStmt.setInt(1, Integer.parseInt(programId));
        programRs = programStmt.executeQuery();

        if (programRs.next()) {
            namaProgram = programRs.getString("nama_program");
            diskon = programRs.getDouble("diskon");
            tanggalBerlaku = programRs.getTimestamp("tanggal_berlaku").toString().replace(" ", "T");
            jamBerlaku = programRs.getTime("jam_berlaku").toString();
            menuId = programRs.getInt("menu_id");
            kategoriProduk = programRs.getString("kategori_produk");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_programs.jsp&error=Program not found");
            return;
        }

        // Fetch available menus
        menuStmt = connection.prepareStatement("SELECT menu_id, nama_menu FROM menus");
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
    <title>Edit Sales Program</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Sales Program</h1>
        <form action="<%= request.getContextPath() %>/edit_sales_program" method="post">
            <input type="hidden" name="program_id" value="<%= programId %>">
            <div class="mb-3">
                <label for="nama_program" class="form-label">Program Name</label>
                <input type="text" class="form-control" id="nama_program" name="nama_program" value="<%= namaProgram %>" required>
            </div>
            <div class="mb-3">
                <label for="diskon" class="form-label">Discount (%)</label>
                <input type="number" step="0.01" class="form-control" id="diskon" name="diskon" value="<%= diskon %>" required>
            </div>
            <div class="mb-3">
                <label for="tanggal_berlaku" class="form-label">Valid Date</label>
                <input type="datetime-local" class="form-control" id="tanggal_berlaku" name="tanggal_berlaku" value="<%= tanggalBerlaku %>" required>
            </div>
            <div class="mb-3">
                <label for="jam_berlaku" class="form-label">Valid Time</label>
                <input type="time" class="form-control" id="jam_berlaku" name="jam_berlaku" value="<%= jamBerlaku %>" required>
            </div>
            <div class="mb-3">
                <label for="menu_id" class="form-label">Menu (Optional)</label>
                <select class="form-control" id="menu_id" name="menu_id">
                    <option value="">All Menus</option>
                    <% while (menuRs.next()) { %>
                    <option value="<%= menuRs.getInt("menu_id") %>" <%= menuRs.getInt("menu_id") == menuId ? "selected" : "" %>>
                        <%= menuRs.getString("nama_menu") %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="kategori_produk" class="form-label">Category (Optional)</label>
                <select class="form-control" id="kategori_produk" name="kategori_produk">
                    <option value="">All Categories</option>
                    <option value="cemilan" <%= "cemilan".equals(kategoriProduk) ? "selected" : "" %>>Cemilan</option>
                    <option value="makanan" <%= "makanan".equals(kategoriProduk) ? "selected" : "" %>>Makanan</option>
                    <option value="minuman" <%= "minuman".equals(kategoriProduk) ? "selected" : "" %>>Minuman</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update Program</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (programRs != null) programRs.close();
        if (menuRs != null) menuRs.close();
        if (programStmt != null) programStmt.close();
        if (menuStmt != null) menuStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
