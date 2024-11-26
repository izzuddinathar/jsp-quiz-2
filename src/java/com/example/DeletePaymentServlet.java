package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/delete_payment")
public class DeletePaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String paymentId = request.getParameter("id");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "DELETE FROM payments WHERE payment_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(paymentId));
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_payments.jsp&error=Error deleting payment.");
        }
    }
}
