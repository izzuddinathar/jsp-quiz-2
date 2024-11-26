package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_payment")
public class CreatePaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String metodePembayaran = request.getParameter("metode_pembayaran");
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO payments (nomor_meja, menu_id, jumlah, metode_pembayaran, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, menuId);
            stmt.setInt(3, jumlah);
            stmt.setString(4, metodePembayaran);
            stmt.setString(5, status);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_payment.jsp?error=Error creating payment.");
        }
    }
}
