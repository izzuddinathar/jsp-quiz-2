package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_sales_report")
public class CreateSalesReportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tanggal = request.getParameter("tanggal");
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        double harga = Double.parseDouble(request.getParameter("harga"));
        double total = Double.parseDouble(request.getParameter("total"));

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO sales_reports (tanggal, menu_id, harga, total) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, tanggal);
            stmt.setInt(2, menuId);
            stmt.setDouble(3, harga);
            stmt.setDouble(4, total);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_reports.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_sales_report.jsp?error=Error creating sales report.");
        }
    }
}
