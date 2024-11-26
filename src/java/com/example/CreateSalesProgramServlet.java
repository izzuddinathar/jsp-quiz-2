package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_sales_program")
public class CreateSalesProgramServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String namaProgram = request.getParameter("nama_program");
        double diskon = Double.parseDouble(request.getParameter("diskon"));
        String tanggalBerlaku = request.getParameter("tanggal_berlaku");
        String jamBerlaku = request.getParameter("jam_berlaku");
        String menuId = request.getParameter("menu_id");
        String kategoriProduk = request.getParameter("kategori_produk");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO sales_programs (nama_program, diskon, tanggal_berlaku, jam_berlaku, menu_id, kategori_produk) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, namaProgram);
            stmt.setDouble(2, diskon);
            stmt.setString(3, tanggalBerlaku);
            stmt.setString(4, jamBerlaku);
            stmt.setString(5, menuId.isEmpty() ? null : menuId);
            stmt.setString(6, kategoriProduk.isEmpty() ? null : kategoriProduk);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_sales_programs.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_sales_program.jsp?error=Error creating sales program.");
        }
    }
}
