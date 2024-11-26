<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Fetch user details for pre-filling the form
    String userId = request.getParameter("id");
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp");
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String nama = "", noTelp = "", email = "", username = "", role = "", foto = "";

    try {
        connection = com.example.DatabaseConnection.getConnection();
        String sql = "SELECT nama, no_telp, email, username, role, foto FROM users WHERE user_id = ?";
        stmt = connection.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(userId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            nama = rs.getString("nama");
            noTelp = rs.getString("no_telp");
            email = rs.getString("email");
            username = rs.getString("username");
            role = rs.getString("role");
            foto = rs.getString("foto");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp?error=User not found");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?page=list_users.jsp?error=Error fetching user details");
        return;
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit User</h1>
        <form action="<%= request.getContextPath() %>/edit_user" method="post" enctype="multipart/form-data">
            <input type="hidden" name="user_id" value="<%= userId %>">
            <div class="mb-3">
                <label for="nama" class="form-label">Name</label>
                <input type="text" class="form-control" id="nama" name="nama" value="<%= nama %>" required>
            </div>
            <div class="mb-3">
                <label for="no_telp" class="form-label">Phone</label>
                <input type="text" class="form-control" id="no_telp" name="no_telp" value="<%= noTelp %>" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label for="role" class="form-label">Role</label>
                <select class="form-control" id="role" name="role" required>
                    <option value="admin" <%= role.equals("admin") ? "selected" : "" %>>Admin</option>
                    <option value="owner" <%= role.equals("owner") ? "selected" : "" %>>Owner</option>
                    <option value="waiters" <%= role.equals("waiters") ? "selected" : "" %>>Waiters</option>
                    <option value="cook" <%= role.equals("cook") ? "selected" : "" %>>Cook</option>
                    <option value="cleaner" <%= role.equals("cleaner") ? "selected" : "" %>>Cleaner</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="foto" class="form-label">Photo</label>
                <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                <% if (foto != null && !foto.isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/uploads/" + foto %>" alt="User Photo" style="width: 100px; height: 100px; border-radius: 10px;">
                <% } %>
            </div>
            <button type="submit" class="btn btn-primary">Update User</button>
        </form>
    </div>
</body>
</html>
