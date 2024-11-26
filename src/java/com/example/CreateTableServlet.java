package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_table")
public class CreateTableServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        int kapasitas = Integer.parseInt(request.getParameter("kapasitas"));
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO tables (nomor_meja, kapasitas, status) VALUES (?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, nomorMeja);
            stmt.setInt(2, kapasitas);
            stmt.setString(3, status);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_table.jsp?error=Error creating table.");
        }
    }
}
