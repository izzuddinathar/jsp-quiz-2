package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/delete_user")
public class DeleteUserServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads"; // External upload directory

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userId = request.getParameter("id");

        try (Connection connection = DatabaseConnection.getConnection()) {
            // Fetch the user's photo
            String photo = null;
            String fetchPhotoSql = "SELECT foto FROM users WHERE user_id = ?";
            try (PreparedStatement fetchStmt = connection.prepareStatement(fetchPhotoSql)) {
                fetchStmt.setInt(1, Integer.parseInt(userId));
                ResultSet rs = fetchStmt.executeQuery();
                if (rs.next()) {
                    photo = rs.getString("foto");
                }
            }

            // Delete the user
            String sql = "DELETE FROM users WHERE user_id = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userId));
            stmt.executeUpdate();

            // Delete the photo file if it exists
            if (photo != null) {
                File photoFile = new File(UPLOAD_DIRECTORY + File.separator + photo);
                if (photoFile.exists()) {
                    photoFile.delete();
                }
            }

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp&error=Error deleting user");
        }
    }
}
