package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_reservation")
public class CreateReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String namaPelanggan = request.getParameter("nama_pelanggan");
        String nomorKontak = request.getParameter("nomor_kontak");
        String waktuReservasi = request.getParameter("waktu_reservasi");
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO reservations (nama_pelanggan, nomor_kontak, waktu_reservasi, nomor_meja, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, namaPelanggan);
            stmt.setString(2, nomorKontak);
            stmt.setString(3, waktuReservasi);
            stmt.setInt(4, nomorMeja);
            stmt.setString(5, status);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_reservations.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_reservation.jsp?error=Error creating reservation.");
        }
    }
}
