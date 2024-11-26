<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    String menuId = request.getParameter("id");
    if (menuId == null || menuId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_menus.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String nama = "", kategori = "", deskripsi = "", foto = "";
    BigDecimal harga = BigDecimal.ZERO;

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = "SELECT nama_menu, kategori, harga, deskripsi, gambar FROM menus WHERE menu_id = ?";
        stmt = connection.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(menuId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            nama = rs.getString("nama_menu");
            kategori = rs.getString("kategori");
            harga = rs.getBigDecimal("harga");
            deskripsi = rs.getString("deskripsi");
            foto = rs.getString("gambar");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_menus.jsp?error=Menu not found");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Menu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Menu</h1>
        <form action="<%= request.getContextPath() %>/edit_menu" method="post" enctype="multipart/form-data">
            <input type="hidden" name="menu_id" value="<%= menuId %>">
            <div class="mb-3">
                <label for="nama" class="form-label">Name</label>
                <input type="text" class="form-control" id="nama" name="nama" value="<%= nama %>" required>
            </div>
            <div class="mb-3">
                <label for="kategori" class="form-label">Category</label>
                <select class="form-control" id="kategori" name="kategori" required>
                    <option value="makanan" <%= kategori.equals("makanan") ? "selected" : "" %>>Makanan</option>
                    <option value="minuman" <%= kategori.equals("minuman") ? "selected" : "" %>>Minuman</option>
                    <option value="cemilan" <%= kategori.equals("cemilan") ? "selected" : "" %>>Cemilan</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="harga" class="form-label">Price</label>
                <input type="number" class="form-control" id="harga" name="harga" value="<%= harga %>" required>
            </div>
            <div class="mb-3">
                <label for="deskripsi" class="form-label">Description</label>
                <textarea class="form-control" id="deskripsi" name="deskripsi"><%= deskripsi %></textarea>
            </div>
            <div class="mb-3">
                <label for="foto" class="form-label">Photo</label>
                <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                <% if (foto != null && !foto.isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/uploads/" + foto %>" alt="Menu Photo" style="width: 100px; height: 100px; border-radius: 10px;">
                <% } %>
            </div>
            <button type="submit" class="btn btn-primary">Update Menu</button>
        </form>
    </div>
</body>
</html>
