package com.mobilestore.model;

import java.io.Serializable;

public class ShippingInfo implements Serializable {
    private static final long serialVersionUID = 1L;

    private String region;
    private Integer shippingFee;
    private Integer estimatedDays;

    public ShippingInfo(String region, Integer shippingFee, Integer estimatedDays) {
        this.region = region;
        this.shippingFee = shippingFee;
        this.estimatedDays = estimatedDays;
    }

    // Getters
    public String getRegion() {
        return region;
    }

    public Integer getShippingFee() {
        return shippingFee;
    }

    public Integer getEstimatedDays() {
        return estimatedDays;
    }

    public String getDescription() {
        return String.format("%s: %,d ₫, %d ngày", region, shippingFee, estimatedDays);
    }
}
