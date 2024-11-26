package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_inventory")
public class CreateInventoryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String namaBahanPokok = request.getParameter("nama_bahan_pokok");
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String satuan = request.getParameter("satuan");
        String supplier = request.getParameter("supplier");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO inventories (nama_bahan_pokok, jumlah, satuan, supplier) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, namaBahanPokok);
            stmt.setInt(2, jumlah);
            stmt.setString(3, satuan);
            stmt.setString(4, supplier);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_inventory.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_inventory.jsp?error=Error creating inventory item.");
        }
    }
}
