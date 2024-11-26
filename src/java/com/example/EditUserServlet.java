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
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/edit_user")
@MultipartConfig
public class EditUserServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads"; // External upload directory

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String userId = request.getParameter("user_id");
        String nama = request.getParameter("nama");
        String noTelp = request.getParameter("no_telp");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String role = request.getParameter("role");

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
            String sql = "UPDATE users SET nama = ?, no_telp = ?, email = ?, username = ?, role = ?, foto = COALESCE(?, foto) WHERE user_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, nama);
            stmt.setString(2, noTelp);
            stmt.setString(3, email);
            stmt.setString(4, username);
            stmt.setString(5, role);
            stmt.setString(6, fileName);
            stmt.setInt(7, Integer.parseInt(userId));
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/edit_user.jsp?id=" + userId + "&error=Error updating user");
        }
    }
}
