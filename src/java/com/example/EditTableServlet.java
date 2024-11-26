package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_table")
public class EditTableServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int tableId = Integer.parseInt(request.getParameter("table_id"));
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int kapasitas = Integer.parseInt(request.getParameter("kapasitas"));
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE tables SET nomor_meja = ?, kapasitas = ?, status = ?, updated_at = NOW() WHERE table_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, kapasitas);
            stmt.setString(3, status);
            stmt.setInt(4, tableId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_table.jsp?id=" + tableId + "&error=Error updating table.");
        }
    }
}
