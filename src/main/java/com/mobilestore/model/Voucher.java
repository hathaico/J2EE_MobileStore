package com.mobilestore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;


public class Voucher {
    private int voucherId;
    private String code;
    private String description;
    private String discountType; // PERCENT or AMOUNT
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private BigDecimal maxDiscount;
    private Integer quantity;
    private Integer usedCount;
    private Date startDate;
    private Date endDate;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Getters and setters
    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }
    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }
    public BigDecimal getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(BigDecimal maxDiscount) { this.maxDiscount = maxDiscount; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Integer getUsedCount() { return usedCount; }
    public void setUsedCount(Integer usedCount) { this.usedCount = usedCount; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
