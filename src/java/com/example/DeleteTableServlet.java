package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/delete_table")
public class DeleteTableServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tableId = request.getParameter("id");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "DELETE FROM tables WHERE table_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(tableId));
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_tables.jsp&error=Error deleting table.");
        }
    }
}
