package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/create_menu")
@MultipartConfig
public class CreateMenuServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "/opt/uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nama = request.getParameter("nama");
        String kategori = request.getParameter("kategori");
        BigDecimal harga = new BigDecimal(request.getParameter("harga"));
        String deskripsi = request.getParameter("deskripsi");

        Part filePart = request.getPart("foto");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadDir + File.separator + fileName);
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO menus (nama_menu, kategori, harga, deskripsi, gambar) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, nama);
            stmt.setString(2, kategori);
            stmt.setBigDecimal(3, harga);
            stmt.setString(4, deskripsi);
            stmt.setString(5, fileName);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_menus.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_menu.jsp?error=Error creating menu.");
        }
    }
}
