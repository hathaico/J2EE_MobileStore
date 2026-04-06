package com.mobilestore.model;

import java.io.Serializable;

public class ChatProductSpec implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    private String brand;
    private Integer price;
    private Integer discountedPrice;
    private String cpu;
    private Integer ram;
    private Integer storage;
    private Integer battery;
    private String frontCamera;
    private String rearCamera;
    private String colors;
    private Integer stock;
    private String description;
    private Double rating;
    private String imageUrl;

    public ChatProductSpec() {}

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Integer getDiscountedPrice() {
        return discountedPrice;
    }

    public void setDiscountedPrice(Integer discountedPrice) {
        this.discountedPrice = discountedPrice;
    }

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public Integer getRam() {
        return ram;
    }

    public void setRam(Integer ram) {
        this.ram = ram;
    }

    public Integer getStorage() {
        return storage;
    }

    public void setStorage(Integer storage) {
        this.storage = storage;
    }

    public Integer getBattery() {
        return battery;
    }

    public void setBattery(Integer battery) {
        this.battery = battery;
    }

    public String getFrontCamera() {
        return frontCamera;
    }

    public void setFrontCamera(String frontCamera) {
        this.frontCamera = frontCamera;
    }

    public String getRearCamera() {
        return rearCamera;
    }

    public void setRearCamera(String rearCamera) {
        this.rearCamera = rearCamera;
    }

    public String getColors() {
        return colors;
    }

    public void setColors(String colors) {
        this.colors = colors;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getStockStatus() {
        return stock > 0 ? "Còn hàng (" + stock + " sản phẩm)" : "Hết hàng";
    }

    public String formatPrice() {
        return String.format("%,d ₫", price);
    }

    public String formatDiscountedPrice() {
        if (discountedPrice != null && discountedPrice < price) {
            return String.format("%,d ₫", discountedPrice);
        }
        return null;
    }

    public Integer getDiscount() {
        if (discountedPrice != null && discountedPrice < price) {
            return (price - discountedPrice) * 100 / price;
        }
        return 0;
    }
}
