package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;
import com.example.util.PasswordUtils;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection connection = DatabaseConnection.getConnection()) {
            String sql = "SELECT password, role FROM users WHERE username = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                String normalizedHash = hashedPassword.replaceFirst("\\$2y\\$", "\\$2a\\$");

                if (PasswordUtils.verifyPassword(password, normalizedHash)) {
                    // Store user info in session
                    HttpSession session = request.getSession();
                    request.getSession().setAttribute("username", username);
                    request.getSession().setAttribute("role", rs.getString("role"));
                    
                    // Redirect to dashboard
                    response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp");
                    return;
                }
            }

            // Redirect back to login with error message
            response.sendRedirect(request.getContextPath() + "/views/login.jsp?error=true");
        } catch (Exception e) {
            logger.severe("Database connection error: " + e.getMessage());
            response.getWriter().println("Database error!");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.getWriter().println("GET method not allowed for login");
    }
}
