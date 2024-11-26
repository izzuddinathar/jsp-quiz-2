package com.example;

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
import java.sql.SQLException;
import com.example.util.PasswordUtils;
import jakarta.servlet.ServletException;

@WebServlet("/create_user")
@MultipartConfig
public class CreateUserServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nama = request.getParameter("nama");
        String noTelp = request.getParameter("no_telp");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (nama == null || noTelp == null || email == null || username == null || password == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/views/create_user.jsp?error=All fields are required.");
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(password);

        Part filePart = request.getPart("foto");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO users (nama, no_telp, email, username, password, role, foto) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, nama);
            stmt.setString(2, noTelp);
            stmt.setString(3, email);
            stmt.setString(4, username);
            stmt.setString(5, hashedPassword);
            stmt.setString(6, role);
            stmt.setString(7, fileName);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/create_user.jsp?error=Error creating user.");
        }
    }
}
