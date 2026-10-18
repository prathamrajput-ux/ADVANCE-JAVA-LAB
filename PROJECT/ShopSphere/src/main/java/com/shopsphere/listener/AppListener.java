package com.shopsphere.listener;

import com.shopsphere.util.DBConnection;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.sql.Connection;
import java.sql.SQLException;

@WebListener
public class AppListener implements ServletContextListener, HttpSessionListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute("appName", "ShopSphere");
        context.setAttribute("appTagline", "Next-Gen Java Enterprise E-Commerce System");

        System.out.println("=============================================================");
        System.out.println(">>> [ShopSphere] Application Initialized on Tomcat.");
        System.out.println(">>> Checking database connectivity and schema...");

        // Ensure database tables and seed data are populated
        com.shopsphere.util.DatabaseInitializer.initializeDatabaseIfEmpty();

        try (Connection con = DBConnection.getConnection()) {
            if (con != null && !con.isClosed()) {
                System.out.println(">>> [ShopSphere] Database Connection: SUCCESS.");
            }
        } catch (SQLException e) {
            System.err.println(">>> [ShopSphere] Database Connection Check: " + e.getMessage());
        }
        System.out.println("=============================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=============================================================");
        System.out.println(">>> [ShopSphere] Application Destroyed / Server Shutting Down.");
        System.out.println("=============================================================");
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("[ShopSphere] Client Session Created: " + se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        System.out.println("[ShopSphere] Client Session Invalidated: " + se.getSession().getId());
    }
}
