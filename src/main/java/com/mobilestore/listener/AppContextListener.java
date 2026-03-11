package com.mobilestore.listener;

import com.mobilestore.util.DBConnection;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Application Context Listener
 * Handles application startup and shutdown events
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("=== Mobile Store Application Started ===");
            
            // Test database connection
            try {
                if (DBConnection.testConnection()) {
                    System.out.println("✓ Database connection successful!");
                } else {
                    System.err.println("✗ Database connection failed - Please check MySQL service and credentials");
                }
            } catch (Exception e) {
                System.err.println("✗ Database connection error: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Load application configuration
            // Initialize cache, scheduled tasks, etc.
            
            System.out.println("=========================================");
        } catch (Exception e) {
            System.err.println("Error during application initialization: " + e.getMessage());
            e.printStackTrace();
            // Don't throw exception - allow app to start even if initialization fails
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Mobile Store Application Stopped ===");
        
        // Cleanup resources
        // Close database connections, stop scheduled tasks, etc.
    }
}
