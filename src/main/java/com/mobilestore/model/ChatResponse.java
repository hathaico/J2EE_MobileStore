package com.mobilestore.model;

import java.io.Serializable;
import java.util.List;

public class ChatResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private String message;
    private String responseType; // "TEXT", "PRODUCT_LIST", "COMPARISON", "ORDER_INFO", "COMBO"
    private List<ChatProductSpec> products;
    private String comparisonTable; // HTML table for comparison
    private String orderInfo; // JSON string with order details
    private List<String> suggestedQuestions; // Follow-up questions for user
    private String timestamp;
    private Integer discount; // Discount percentage

    public ChatResponse() {}

    public ChatResponse(String message) {
        this.message = message;
        this.responseType = "TEXT";
    }

    // Getters and Setters
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getResponseType() {
        return responseType;
    }

    public void setResponseType(String responseType) {
        this.responseType = responseType;
    }

    public List<ChatProductSpec> getProducts() {
        return products;
    }

    public void setProducts(List<ChatProductSpec> products) {
        this.products = products;
    }

    public String getComparisonTable() {
        return comparisonTable;
    }

    public void setComparisonTable(String comparisonTable) {
        this.comparisonTable = comparisonTable;
    }

    public String getOrderInfo() {
        return orderInfo;
    }

    public void setOrderInfo(String orderInfo) {
        this.orderInfo = orderInfo;
    }

    public List<String> getSuggestedQuestions() {
        return suggestedQuestions;
    }

    public void setSuggestedQuestions(List<String> suggestedQuestions) {
        this.suggestedQuestions = suggestedQuestions;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }
}
