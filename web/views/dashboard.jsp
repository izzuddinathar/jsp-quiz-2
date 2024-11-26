<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.util.RBACConfigLoader, java.util.*" %>
<%
    // Load RBAC configuration
    String realPath = getServletContext().getRealPath("/");
    Map<String, List<String>> rbacPermissions = RBACConfigLoader.loadRBACConfig(realPath);

    // Get user role from session
    String role = (String) session.getAttribute("role");
    List<String> userMenus = rbacPermissions.getOrDefault(role, Collections.emptyList());

    // Get the page parameter and resolve it to an absolute path
    String includedPage = request.getParameter("page");
    if (includedPage == null || includedPage.isEmpty()) {
        includedPage = "/views/default.jsp"; // Default page
    } else if (!includedPage.startsWith("/")) {
        includedPage = "/views/" + includedPage; // Ensure absolute path
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-nav .nav-link.active {
            background-color: #007bff;
            color: white;
            border-radius: 5px;
        }
        .content {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>">My Project</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <% 
                        if (!userMenus.isEmpty()) {
                            for (String menu : userMenus) {
                                String menuUrl = "";
                                switch (menu) {
                                    case "User": menuUrl = "list_users.jsp"; break;
                                    case "Menu": menuUrl = "list_menus.jsp"; break;
                                    case "Pembayaran": menuUrl = "list_payments.jsp"; break;
                                    case "Inventory": menuUrl = "inventory.jsp"; break;
                                    case "Meja": menuUrl = "list_tables.jsp"; break;
                                    case "Reservasi": menuUrl = "reservations.jsp"; break;
                                    case "Pesanan": menuUrl = "list_orders.jsp"; break;
                                    case "Laporan Penjualan": menuUrl = "sales_reports.jsp"; break;
                                    case "Program Penjualan": menuUrl = "sales_programs.jsp"; break;
                                }
                    %>
                    <li class="nav-item">
                        <a class="nav-link <%= includedPage.contains(menuUrl) ? "active" : "" %>" 
                           href="<%= request.getContextPath() %>/views/dashboard.jsp?page=<%= menuUrl %>"><%= menu %></a>
                    </li>
                    <% 
                            }
                        } else { 
                    %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">No Menu Available</a>
                    </li>
                    <% 
                        } 
                    %>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <%= (String) session.getAttribute("username") %>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="#">Profile</a></li>
                            <li>
    <form action="<%= request.getContextPath() %>/logout" method="post" style="display:inline;">
        <button type="submit" class="dropdown-item">Logout</button>
    </form>
</li>

                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container content">
        <jsp:include page="<%= includedPage %>" />
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
