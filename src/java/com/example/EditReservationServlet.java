package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_reservation")
public class EditReservationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reservasiId = Integer.parseInt(request.getParameter("reservasi_id"));
        String namaPelanggan = request.getParameter("nama_pelanggan");
        String nomorKontak = request.getParameter("nomor_kontak");
        String waktuReservasi = request.getParameter("waktu_reservasi");
        int nomorMeja = Integer.parseInt(request.getParameter("nomor_meja"));
        String status = request.getParameter("status");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "UPDATE reservations SET nama_pelanggan = ?, nomor_kontak = ?, waktu_reservasi = ?, nomor_meja = ?, status = ?, updated_at = NOW() WHERE reservasi_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, namaPelanggan);
            stmt.setString(2, nomorKontak);
            stmt.setString(3, waktuReservasi);
            stmt.setInt(4, nomorMeja);
            stmt.setString(5, status);
            stmt.setInt(6, reservasiId);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_reservations.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_reservation.jsp?id=" + reservasiId + "&error=Error updating reservation.");
        }
    }
}
