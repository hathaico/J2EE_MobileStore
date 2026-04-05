package com.mobilestore.model;

import java.io.Serializable;

public class ChatRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    private String userMessage;
    private String userId; // Optional: để track user session
    private String intent; // "GREETING", "PRODUCT_RECOMMENDATION", "COMPARISON", "ORDER_STATUS", etc.
    private String parameters; // JSON string with extracted parameters

    public ChatRequest() {}

    public ChatRequest(String userMessage) {
        this.userMessage = userMessage;
    }

    // Getters and Setters
    public String getUserMessage() {
        return userMessage;
    }

    public void setUserMessage(String userMessage) {
        this.userMessage = userMessage;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getIntent() {
        return intent;
    }

    public void setIntent(String intent) {
        this.intent = intent;
    }

    public String getParameters() {
        return parameters;
    }

    public void setParameters(String parameters) {
        this.parameters = parameters;
    }
}
