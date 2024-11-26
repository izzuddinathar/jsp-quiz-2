package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_payment")
public class EditPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int paymentId = Integer.parseInt(request.getParameter("payment_id"));
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int menuId = Integer.parseInt(request.getParameter("menu_id"));
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String metodePembayaran = request.getParameter("metode_pembayaran");
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE payments SET nomor_meja = ?, menu_id = ?, jumlah = ?, metode_pembayaran = ?, status = ?, updated_at = NOW() WHERE payment_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, menuId);
            stmt.setInt(3, jumlah);
            stmt.setString(4, metodePembayaran);
            stmt.setString(5, status);
            stmt.setInt(6, paymentId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_payment.jsp?id=" + paymentId + "&error=Error updating payment.");
        }
    }
}
