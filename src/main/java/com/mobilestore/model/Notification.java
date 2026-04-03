package com.mobilestore.model;

/**
 * Notification Model
 * Represents a notification in the admin panel
 */
public class Notification {
    private String type; // "pending_order", "pending_review", "low_stock"
    private String title;
    private String message;
    private int count;
    private String actionUrl;
    private String icon;
    private String color; // CSS color class

    public Notification(String type, String title, String message, int count, String actionUrl, String icon, String color) {
        this.type = type;
        this.title = title;
        this.message = message;
        this.count = count;
        this.actionUrl = actionUrl;
        this.icon = icon;
        this.color = color;
    }

    // Getters and Setters
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public boolean hasNotifications() {
        return count > 0;
    }
}
