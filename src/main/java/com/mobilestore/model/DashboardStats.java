package com.mobilestore.model;

import java.math.BigDecimal;

/**
 * Dashboard Statistics Model
 * Contains statistics for admin dashboard
 */
public class DashboardStats {
    private int totalProducts;
    private int totalOrders;
    private int totalCustomers;
    private BigDecimal totalRevenue;

    private int pendingOrders;
    private int confirmedOrders;
    private int shippingOrders;
    private int deliveredOrders;

    private int lowStockProducts;
    private int outOfStockProducts;

    private int todayOrders;
    private BigDecimal todayRevenue;

    // Add usedVouchers for dashboard
    private int usedVouchers;

    // Add totalVoucherDiscount for dashboard
    private java.math.BigDecimal totalVoucherDiscount;
            public java.math.BigDecimal getTotalVoucherDiscount() {
                return totalVoucherDiscount;
            }

            public void setTotalVoucherDiscount(java.math.BigDecimal totalVoucherDiscount) {
                this.totalVoucherDiscount = totalVoucherDiscount;
            }
        public int getUsedVouchers() {
            return usedVouchers;
        }

        public void setUsedVouchers(int usedVouchers) {
            this.usedVouchers = usedVouchers;
        }
    
    public DashboardStats() {
    }
    
    // Getters and Setters
    public int getTotalProducts() {
        return totalProducts;
    }
    
    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }
    
    public int getTotalOrders() {
        return totalOrders;
    }
    
    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }
    
    public int getTotalCustomers() {
        return totalCustomers;
    }
    
    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }
    
    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public int getPendingOrders() {
        return pendingOrders;
    }
    
    public void setPendingOrders(int pendingOrders) {
        this.pendingOrders = pendingOrders;
    }
    
    public int getConfirmedOrders() {
        return confirmedOrders;
    }
    
    public void setConfirmedOrders(int confirmedOrders) {
        this.confirmedOrders = confirmedOrders;
    }
    
    public int getShippingOrders() {
        return shippingOrders;
    }
    
    public void setShippingOrders(int shippingOrders) {
        this.shippingOrders = shippingOrders;
    }
    
    public int getDeliveredOrders() {
        return deliveredOrders;
    }
    
    public void setDeliveredOrders(int deliveredOrders) {
        this.deliveredOrders = deliveredOrders;
    }
    
    public int getLowStockProducts() {
        return lowStockProducts;
    }
    
    public void setLowStockProducts(int lowStockProducts) {
        this.lowStockProducts = lowStockProducts;
    }
    
    public int getOutOfStockProducts() {
        return outOfStockProducts;
    }
    
    public void setOutOfStockProducts(int outOfStockProducts) {
        this.outOfStockProducts = outOfStockProducts;
    }
    
    public int getTodayOrders() {
        return todayOrders;
    }
    
    public void setTodayOrders(int todayOrders) {
        this.todayOrders = todayOrders;
    }
    
    public BigDecimal getTodayRevenue() {
        return todayRevenue;
    }
    
    public void setTodayRevenue(BigDecimal todayRevenue) {
        this.todayRevenue = todayRevenue;
    }
    
    /**
     * Get formatted total revenue
     */
    public String getFormattedTotalRevenue() {
        return totalRevenue != null ? String.format("%,d ₫", totalRevenue.longValue()) : "0 ₫";
    }
    
    /**
     * Get formatted today revenue
     */
    public String getFormattedTodayRevenue() {
        return todayRevenue != null ? String.format("%,d ₫", todayRevenue.longValue()) : "0 ₫";
    }
}
