package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_inventory")
public class EditInventoryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int inventoryId = Integer.parseInt(request.getParameter("inventory_id"));
        String namaBahanPokok = request.getParameter("nama_bahan_pokok");
        int jumlah = Integer.parseInt(request.getParameter("jumlah"));
        String satuan = request.getParameter("satuan");
        String supplier = request.getParameter("supplier");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE inventories SET nama_bahan_pokok = ?, jumlah = ?, satuan = ?, supplier = ?, updated_at = NOW() WHERE inventory_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, namaBahanPokok);
            stmt.setInt(2, jumlah);
            stmt.setString(3, satuan);
            stmt.setString(4, supplier);
            stmt.setInt(5, inventoryId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_inventory.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_inventory.jsp?id=" + inventoryId + "&error=Error updating inventory item.");
        }
    }
}
