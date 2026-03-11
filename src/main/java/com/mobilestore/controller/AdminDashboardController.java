package com.mobilestore.controller;

import com.mobilestore.model.DashboardStats;
import com.mobilestore.model.Order;
import com.mobilestore.model.Product;
import com.mobilestore.service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Admin Dashboard Controller
 * Displays admin dashboard with statistics
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private DashboardService dashboardService;
    
    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
    }
    
    /**
     * Show dashboard
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get dashboard statistics
        DashboardStats stats = dashboardService.getDashboardStats();
        request.setAttribute("stats", stats);
        
        // Get recent orders (last 5)
        List<Order> recentOrders = dashboardService.getRecentOrders(5);
        request.setAttribute("recentOrders", recentOrders);
        
        // Get low stock products
        List<Product> lowStockProducts = dashboardService.getLowStockProducts();
        request.setAttribute("lowStockProducts", lowStockProducts);
        
        // Forward to dashboard view
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }
}
