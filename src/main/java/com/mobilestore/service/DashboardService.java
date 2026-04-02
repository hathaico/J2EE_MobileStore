package com.mobilestore.service;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.model.DashboardStats;
import com.mobilestore.model.Order;
import com.mobilestore.model.Product;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Dashboard Service
 * Business logic for dashboard statistics
 */
public class DashboardService {
    private final ProductDAO productDAO;
    private final OrderDAO orderDAO;
    
    public DashboardService() {
        this.productDAO = new ProductDAO();
        this.orderDAO = new OrderDAO();
    }
    
    /**
     * Get dashboard statistics
     * @return DashboardStats object
     */
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        
        // Product statistics
        List<Product> allProducts = productDAO.getAllProducts();
        stats.setTotalProducts(allProducts.size());
        
        int lowStock = 0;
        int outOfStock = 0;
        for (Product product : allProducts) {
            if (product.getStockQuantity() == 0) {
                outOfStock++;
            } else if (product.isLowStock()) {
                lowStock++;
            }
        }
        stats.setLowStockProducts(lowStock);
        stats.setOutOfStockProducts(outOfStock);
        
        // Order statistics
        List<Order> allOrders = orderDAO.getAllOrders();
        stats.setTotalOrders(allOrders.size());
        
        // Calculate total revenue and order status counts
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int pending = 0;
        int confirmed = 0;
        int shipping = 0;
        int delivered = 0;
        
        for (Order order : allOrders) {
            // Add to revenue only if confirmed
            if ("CONFIRMED".equals(order.getStatus()) && order.getTotalAmount() != null) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
            
            // Count by status
            if (order.getStatus() != null) {
                switch (order.getStatus()) {
                    case "PENDING":
                        pending++;
                        break;
                    case "CONFIRMED":
                        confirmed++;
                        break;
                    case "SHIPPING":
                        shipping++;
                        break;
                    case "DELIVERED":
                        delivered++;
                        break;
                }
            }
        }
        
        stats.setTotalRevenue(totalRevenue);
        stats.setPendingOrders(pending);
        stats.setConfirmedOrders(confirmed);
        stats.setShippingOrders(shipping);
        stats.setDeliveredOrders(delivered);
        
        // Today's statistics
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        int todayOrders = 0;
        BigDecimal todayRevenue = BigDecimal.ZERO;
        
        for (Order order : allOrders) {
            if (order.getCreatedAt() != null && order.getCreatedAt().isAfter(todayStart)) {
                todayOrders++;
                if ("CONFIRMED".equals(order.getStatus()) && order.getTotalAmount() != null) {
                    todayRevenue = todayRevenue.add(order.getTotalAmount());
                }
            }
        }
        
        stats.setTodayOrders(todayOrders);
        stats.setTodayRevenue(todayRevenue);
        
        // Customer count (can be enhanced with actual customer table)
        stats.setTotalCustomers(0); // Placeholder
        
        return stats;
    }
    
    /**
     * Get recent orders
     * @param limit Number of orders to retrieve
     * @return List of recent orders
     */
    public List<Order> getRecentOrders(int limit) {
        List<Order> allOrders = orderDAO.getAllOrders();
        
        // Orders are already sorted by created_at DESC in DAO
        if (allOrders.size() > limit) {
            return allOrders.subList(0, limit);
        }
        
        return allOrders;
    }
    
    /**
     * Get low stock products
     * @return List of low stock products
     */
    public List<Product> getLowStockProducts() {
        return productDAO.getLowStockProducts();
    }
}
