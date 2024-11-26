<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String reservasiId = request.getParameter("id");
    if (reservasiId == null || reservasiId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_reservations.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement reservationStmt = null;
    PreparedStatement tableStmt = null;
    ResultSet reservationRs = null;
    ResultSet tableRs = null;

    String namaPelanggan = "", nomorKontak = "", waktuReservasi = "", status = "";
    int nomorMeja = 0;

    try {
        connection = com.example.DatabaseConnection.getConnection();

        // Fetch reservation details
        String reservationQuery = "SELECT nama_pelanggan, nomor_kontak, waktu_reservasi, nomor_meja, status FROM reservations WHERE reservasi_id = ?";
        reservationStmt = connection.prepareStatement(reservationQuery);
        reservationStmt.setInt(1, Integer.parseInt(reservasiId));
        reservationRs = reservationStmt.executeQuery();

        if (reservationRs.next()) {
            namaPelanggan = reservationRs.getString("nama_pelanggan");
            nomorKontak = reservationRs.getString("nomor_kontak");
            waktuReservasi = reservationRs.getTimestamp("waktu_reservasi").toString().replace(" ", "T");
            nomorMeja = reservationRs.getInt("nomor_meja");
            status = reservationRs.getString("status");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_reservations.jsp&error=Reservation not found");
            return;
        }

        // Fetch available tables
        tableStmt = connection.prepareStatement("SELECT nomor_meja FROM tables");
        tableRs = tableStmt.executeQuery();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Reservation</h1>
        <form action="<%= request.getContextPath() %>/edit_reservation" method="post">
            <input type="hidden" name="reservasi_id" value="<%= reservasiId %>">
            <div class="mb-3">
                <label for="nama_pelanggan" class="form-label">Customer Name</label>
                <input type="text" class="form-control" id="nama_pelanggan" name="nama_pelanggan" value="<%= namaPelanggan %>" required>
            </div>
            <div class="mb-3">
                <label for="nomor_kontak" class="form-label">Contact Number</label>
                <input type="text" class="form-control" id="nomor_kontak" name="nomor_kontak" value="<%= nomorKontak %>" required>
            </div>
            <div class="mb-3">
                <label for="waktu_reservasi" class="form-label">Reservation Time</label>
                <input type="datetime-local" class="form-control" id="waktu_reservasi" name="waktu_reservasi" value="<%= waktuReservasi %>" required>
            </div>
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <select class="form-control" id="nomor_meja" name="nomor_meja" required>
                    <% while (tableRs.next()) { %>
                    <option value="<%= tableRs.getInt("nomor_meja") %>" <%= tableRs.getInt("nomor_meja") == nomorMeja ? "selected" : "" %>>
                        <%= tableRs.getInt("nomor_meja") %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="terjadwal" <%= "terjadwal".equals(status) ? "selected" : "" %>>Terjadwal</option>
                    <option value="dibatalkan" <%= "dibatalkan".equals(status) ? "selected" : "" %>>Dibatalkan</option>
                    <option value="selesai" <%= "selesai".equals(status) ? "selected" : "" %>>Selesai</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update Reservation</button>
        </form>
    </div>
</body>
</html>
<%
    try {
        if (reservationRs != null) reservationRs.close();
        if (tableRs != null) tableRs.close();
        if (reservationStmt != null) reservationStmt.close();
        if (tableStmt != null) tableStmt.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
