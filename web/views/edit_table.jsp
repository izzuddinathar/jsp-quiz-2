<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String tableId = request.getParameter("id");
    if (tableId == null || tableId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int nomorMeja = 0, kapasitas = 0;
    String status = "";

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = "SELECT nomor_meja, kapasitas, status FROM tables WHERE table_id = ?";
        stmt = connection.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(tableId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            nomorMeja = rs.getInt("nomor_meja");
            kapasitas = rs.getInt("kapasitas");
            status = rs.getString("status");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp&error=Table not found");
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
    <title>Edit Table</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Table</h1>
        <form action="<%= request.getContextPath() %>/edit_table" method="post">
            <input type="hidden" name="table_id" value="<%= tableId %>">
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <input type="number" class="form-control" id="nomor_meja" name="nomor_meja" value="<%= nomorMeja %>" required>
            </div>
            <div class="mb-3">
                <label for="kapasitas" class="form-label">Capacity</label>
                <input type="number" class="form-control" id="kapasitas" name="kapasitas" value="<%= kapasitas %>" required>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="tersedia" <%= status.equals("tersedia") ? "selected" : "" %>>Tersedia</option>
                    <option value="dipesan" <%= status.equals("dipesan") ? "selected" : "" %>>Dipesan</option>
                    <option value="terisi" <%= status.equals("terisi") ? "selected" : "" %>>Terisi</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update Table</button>
        </form>
    </div>
</body>
</html>
