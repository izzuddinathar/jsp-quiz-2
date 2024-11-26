package com.example;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*") // Apply this filter to all URLs
public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false); // Fetch session if it exists

        // Allow access to login, logout, and static resources
        if (uri.endsWith("login.jsp") || uri.endsWith("login") || uri.endsWith("logout") || uri.contains("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // Redirect to login if user is not authenticated
        if (session == null || session.getAttribute("username") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/views/login.jsp");
        } else {
            chain.doFilter(request, response); // User is logged in; proceed
        }
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}