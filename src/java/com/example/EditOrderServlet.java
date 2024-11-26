package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_order")
public class EditOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String statusPesanan = request.getParameter("status_pesanan");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE orders SET nomor_meja = ?, menu_id = ?, jumlah = ?, status_pesanan = ?, updated_at = NOW() WHERE order_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, menuId);
            stmt.setInt(3, jumlah);
            stmt.setString(4, statusPesanan);
            stmt.setInt(5, orderId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_orders.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_order.jsp?id=" + orderId + "&error=Error updating order.");
        }
    }
}
