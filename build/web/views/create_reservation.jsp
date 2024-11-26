<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Connection connection = com.example.DatabaseConnection.getConnection();
    PreparedStatement tableStmt = connection.prepareStatement("SELECT nomor_meja FROM tables");
    ResultSet tableRs = tableStmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Create Reservation</h1>
        <form action="<%= request.getContextPath() %>/create_reservation" method="post">
            <div class="mb-3">
                <label for="nama_pelanggan" class="form-label">Customer Name</label>
                <input type="text" class="form-control" id="nama_pelanggan" name="nama_pelanggan" required>
            </div>
            <div class="mb-3">
                <label for="nomor_kontak" class="form-label">Contact Number</label>
                <input type="text" class="form-control" id="nomor_kontak" name="nomor_kontak" required>
            </div>
            <div class="mb-3">
                <label for="waktu_reservasi" class="form-label">Reservation Time</label>
                <input type="datetime-local" class="form-control" id="waktu_reservasi" name="waktu_reservasi" required>
            </div>
            <div class="mb-3">
                <label for="nomor_meja" class="form-label">Table Number</label>
                <select class="form-control" id="nomor_meja" name="nomor_meja" required>
                    <% while (tableRs.next()) { %>
                    <option value="<%= tableRs.getInt("nomor_meja") %>"><%= tableRs.getInt("nomor_meja") %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-control" id="status" name="status" required>
                    <option value="terjadwal">Terjadwal</option>
                    <option value="dibatalkan">Dibatalkan</option>
                    <option value="selesai">Selesai</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Create Reservation</button>
        </form>
    </div>
</body>
</html>
<%
    tableRs.close();
    tableStmt.close();
    connection.close();
%>
