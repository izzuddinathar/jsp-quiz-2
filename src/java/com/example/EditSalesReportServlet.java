package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_sales_report")
public class EditSalesReportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reportId = Integer.parseInt(request.getParameter("report_id"));
        String tanggal = request.getParameter("tanggal");
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        double harga = Double.parseDouble(request.getParameter("harga"));
        double total = Double.parseDouble(request.getParameter("total"));

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE sales_reports SET tanggal = ?, menu_id = ?, harga = ?, total = ?, updated_at = NOW() WHERE report_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, tanggal);
            stmt.setInt(2, menuId);
            stmt.setDouble(3, harga);
            stmt.setDouble(4, total);
            stmt.setInt(5, reportId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_reports.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_sales_report.jsp?id=" + reportId + "&error=Error updating sales report.");
        }
    }
}
