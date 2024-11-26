package com.example;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            // Initialize and store the database connection in ServletContext
            Connection connection = DatabaseConnection.getConnection();
            sce.getServletContext().setAttribute("dbConnection", connection);
            System.out.println("Database connection initialized successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to initialize database connection.");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Connection connection = (Connection) sce.getServletContext().getAttribute("dbConnection");
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
