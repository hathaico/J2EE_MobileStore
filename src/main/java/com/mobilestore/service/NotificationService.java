package com.mobilestore.service;

import com.mobilestore.dao.OrderDAO;
import com.mobilestore.dao.ProductDAO;
import com.mobilestore.dao.ProductReviewDAO;
import com.mobilestore.model.Notification;
import com.mobilestore.model.Order;
import com.mobilestore.model.Product;
import com.mobilestore.model.ProductReview;

import java.util.ArrayList;
import java.util.List;

/**
 * Notification Service
 * Provides notification data for admin panel
 */
public class NotificationService {
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    private final ProductReviewDAO reviewDAO;

    public NotificationService() {
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
        this.reviewDAO = new ProductReviewDAO();
    }

    /**
     * Get all notifications for admin
     * @return List of notifications
     */
    public List<Notification> getNotifications() {
        List<Notification> notifications = new ArrayList<>();

        // 1. Pending Orders Notification
        try {
            List<Order> pendingOrders = orderDAO.getOrdersByStatus("PENDING");
            int pendingCount = pendingOrders != null ? pendingOrders.size() : 0;
            if (pendingCount > 0) {
                notifications.add(new Notification(
                    "pending_order",
                    "Đơn hàng chờ xác nhận",
                    pendingCount + " đơn hàng cần xác nhận",
                    pendingCount,
                    "/admin/orders",
                    "bi-clock",
                    "text-warning"
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Pending Reviews Notification
        try {
            List<ProductReview> pendingReviews = reviewDAO.getAllReviews(false);
            int pendingReviewCount = 0;
            if (pendingReviews != null) {
                for (ProductReview review : pendingReviews) {
                    if (!review.isApproved()) {
                        pendingReviewCount++;
                    }
                }
            }
            if (pendingReviewCount > 0) {
                notifications.add(new Notification(
                    "pending_review",
                    "Đánh giá chờ duyệt",
                    pendingReviewCount + " đánh giá cần duyệt",
                    pendingReviewCount,
                    "/admin/reviews",
                    "bi-star",
                    "text-warning"
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. Low Stock & Out of Stock Notification
        try {
            List<Product> allProducts = productDAO.getAllProducts();
            int lowStockCount = 0;
            int outOfStockCount = 0;
            if (allProducts != null) {
                for (Product product : allProducts) {
                    if (product.getStockQuantity() == 0) {
                        outOfStockCount++;
                    } else if (product.isLowStock()) {
                        lowStockCount++;
                    }
                }
            }
            int totalStockAlert = lowStockCount + outOfStockCount;
            if (totalStockAlert > 0) {
                notifications.add(new Notification(
                    "stock_alert",
                    "Sản phẩm hết/sắp hết hàng",
                    outOfStockCount + " hết hàng, " + lowStockCount + " sắp hết",
                    totalStockAlert,
                    "/admin/products",
                    "bi-exclamation-triangle",
                    "text-danger"
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return notifications;
    }

    /**
     * Get total notification count
     * @return Total count of all notifications
     */
    public int getTotalNotificationCount() {
        List<Notification> notifications = getNotifications();
        int total = 0;
        for (Notification notif : notifications) {
            total += notif.getCount();
        }
        return total;
    }

    /**
     * Check if there are any notifications
     * @return true if there are notifications, false otherwise
     */
    public boolean hasNotifications() {
        return getTotalNotificationCount() > 0;
    }
}
