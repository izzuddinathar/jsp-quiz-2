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

@WebServlet("/delete_menu")
public class DeleteMenuServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String menuId = request.getParameter("id");

        try (Connection connection = DatabaseConnection.getConnection()) {
            // Fetch the menu's photo
            String photo = null;
            String fetchPhotoSql = "SELECT gambar FROM menus WHERE menu_id = ?";
            try (PreparedStatement fetchStmt = connection.prepareStatement(fetchPhotoSql)) {
                fetchStmt.setInt(1, Integer.parseInt(menuId));
                 ResultSet rs = fetchStmt.executeQuery();
                if (rs.next()) {
                    photo = rs.getString("gambar");
                }
            }

            // Delete the menu
            String sql = "DELETE FROM menus WHERE menu_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(menuId));
                stmt.executeUpdate();
            }

            // Delete the photo file if it exists
            if (photo != null) {
                File photoFile = new File(UPLOAD_DIRECTORY + File.separator + photo);
                if (photoFile.exists()) {
                    photoFile.delete();
                }
            }

            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_menus.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_menus.jsp&error=Error deleting menu.");
        }
    }
}
