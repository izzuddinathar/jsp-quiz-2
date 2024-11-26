package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_order")
public class CreateOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String statusPesanan = request.getParameter("status_pesanan");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO orders (nomor_meja, menu_id, jumlah, status_pesanan) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, menuId);
            stmt.setInt(3, jumlah);
            stmt.setString(4, statusPesanan);
            stmt.executeUpdate();

            // Redirect back to the list of orders
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_orders.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_order.jsp?error=Error creating order.");
        }
    }
}
