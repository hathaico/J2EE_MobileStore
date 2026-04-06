package com.mobilestore.model;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
public class Order {
    private Integer orderId;
    private Integer customerId;
    private Integer voucherId; // <--- Thêm dòng này
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String shippingAddress;
    private BigDecimal totalAmount;
    private String status; // PENDING, CONFIRMED, SHIPPING, DELIVERED, CANCELLED
    private String paymentMethod; // CASH, CREDIT_CARD
    private String paymentStatus; // UNPAID, PAID
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Order items
    private List<OrderItem> orderItems;
        public Integer getVoucherId() {
            return voucherId;
        }
        public void setVoucherId(Integer voucherId) {
            this.voucherId = voucherId;
        }
    
    public Order() {
        this.orderItems = new ArrayList<>();
    }
    
    // Getters and Setters
    public Integer getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }
    
    public Integer getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    /**
     * Add order item
     */
    public void addOrderItem(OrderItem item) {
        this.orderItems.add(item);
    }
    
    /**
     * Get formatted total amount
     * @return Formatted total in VND
     */
    public String getFormattedTotal() {
        return totalAmount != null ? String.format("%,d ₫", totalAmount.longValue()) : "0 ₫";
    }
    
    /**
     * Get status badge class for Bootstrap
     * @return Badge class name
     */
    public String getStatusBadgeClass() {
        if (status == null) return "bg-secondary";
        
        switch (status) {
            case "PENDING":
                return "bg-warning";
            case "CONFIRMED":
                return "bg-info";
            case "SHIPPING":
                return "bg-primary";
            case "DELIVERED":
                return "bg-success";
            case "CANCELLED":
                return "bg-danger";
            default:
                return "bg-secondary";
        }
    }
    
    /**
     * Get status label in Vietnamese
     * @return Status label
     */
    public String getStatusLabel() {
        if (status == null) return "Không xác định";
        
        switch (status) {
            case "PENDING":
                return "Chờ xác nhận";
            case "CONFIRMED":
                return "Đã xác nhận";
            case "SHIPPING":
                return "Đang giao hàng";
            case "DELIVERED":
                return "Đã giao hàng";
            case "CANCELLED":
                return "Đã hủy";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Get payment method label in Vietnamese
     * @return Payment method label
     */
    public String getPaymentMethodLabel() {
        if (paymentMethod == null) return "Không xác định";
        
        switch (paymentMethod) {
            case "CASH":
                return "Thanh toán khi nhận hàng";
            case "CREDIT_CARD":
                return "VNPay (ATM/Visa/Mastercard)";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Get payment status label in Vietnamese
     * @return Payment status label
     */
    public String getPaymentStatusLabel() {
        if (paymentStatus == null) return "Không xác định";
        
        switch (paymentStatus) {
            case "UNPAID":
                return "Chưa thanh toán";
            case "PAID":
                return "Đã thanh toán";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Get formatted createdAt string for JSP display
     * @return formatted date string or empty if null
     */
    public String getCreatedAtString() {
        if (createdAt == null) return "";
        return createdAt.toString().replace('T', ' ');
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getUpdatedAtFormatted() {
        if (updatedAt == null) return "";
        return updatedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", customerName='" + customerName + '\'' +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
