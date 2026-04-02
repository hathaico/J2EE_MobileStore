package com.mobilestore.model;

public class Brand {
    private Integer brandId;
    private String name;
    private String logoUrl;

    public Brand() {}

    public Brand(String name) {
        this.name = name;
    }

    public Brand(String name, String logoUrl) {
        this.name = name;
        this.logoUrl = logoUrl;
    }

    public Brand(Integer brandId, String name, String logoUrl) {
        this.brandId = brandId;
        this.name = name;
        this.logoUrl = logoUrl;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }
}
