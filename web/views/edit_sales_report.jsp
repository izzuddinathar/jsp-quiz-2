<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String reportId = request.getParameter("id");
    if (reportId == null || reportId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_reports.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement reportStmt = null;
    PreparedStatement menuStmt = null;
    ResultSet reportRs = null;
    ResultSet menuRs = null;

    String tanggal = "";
    int menuId = 0;
    double harga = 0, total = 0;

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch report details
        String reportQuery = "SELECT tanggal, menu_id, harga, total FROM sales_reports WHERE report_id = ?";
        reportStmt = connection.prepareStatement(reportQuery);
        reportStmt.setInt(1, Integer.parseInt(reportId));
        reportRs = reportStmt.executeQuery();

        if (reportRs.next()) {
            tanggal = reportRs.getDate("tanggal").toString();
            menuId = reportRs.getInt("menu_id");
            harga = reportRs.getDouble("harga");
            total = reportRs.getDouble("total");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_reports.jsp&error=Report not found");
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
    <title>Edit Sales Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Sales Report</h1>
        <form action="<%= request.getContextPath() %>/edit_sales_report" method="post">
            <input type="hidden" name="report_id" value="<%= reportId %>">
            <div class="mb-3">
                <label for="tanggal" class="form-label">Date</label>
                <input type="date" class="form-control" id="tanggal" name="tanggal" value="<%= tanggal %>" required>
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
                <label for="harga" class="form-label">Price</label>
                <input type="number" step="0.01" class="form-control" id="harga" name="harga" value="<%= harga %>" required>
            </div>
            <div class="mb-3">
                <label for="total" class="form-label">Total</label>
                <input type="number" step="0.01" class="form-control" id="total" name="total" value="<%= total %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Report</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (reportRs != null) reportRs.close();
        if (menuRs != null) menuRs.close();
        if (reportStmt != null) reportStmt.close();
        if (menuStmt != null) menuStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
