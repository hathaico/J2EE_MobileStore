package com.mobilestore.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ChatMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String sender; // "USER" or "BOT"
    private String message;
    private String messageType; // "TEXT", "PRODUCT_RECOMMENDATION", "COMPARISON", "FAQ"
    private LocalDateTime timestamp;
    private String metadata; // JSON string for additional data

    public ChatMessage() {}

    public ChatMessage(String sender, String message) {
        this.sender = sender;
        this.message = message;
        this.messageType = "TEXT";
        this.timestamp = LocalDateTime.now();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}
