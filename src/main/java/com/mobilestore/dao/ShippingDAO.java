package com.mobilestore.dao;

import com.mobilestore.model.ShippingInfo;
import java.util.*;

public class ShippingDAO {
    private static final Map<String, ShippingInfo> shippingRates = new LinkedHashMap<>();

    static {
        initializeShippingRates();
    }

    private static void initializeShippingRates() {
        shippingRates.put("HN", new ShippingInfo("Hà Nội", 0, 1));
        shippingRates.put("TPHCM", new ShippingInfo("TP. Hồ Chí Minh", 0, 1));
        shippingRates.put("NORTH", new ShippingInfo("Miền Bắc (ngoài HN)", 30000, 2));
        shippingRates.put("SOUTH", new ShippingInfo("Miền Nam (ngoài TPHCM)", 30000, 2));
        shippingRates.put("CENTRAL", new ShippingInfo("Miền Trung", 40000, 3));
    }

    public ShippingInfo getShippingInfo(String region) {
        return shippingRates.getOrDefault(region, null);
    }

    public List<ShippingInfo> getAllShippingOptions() {
        return new ArrayList<>(shippingRates.values());
    }

    public String getShippingDescription() {
        StringBuilder sb = new StringBuilder();
        sb.append("📦 <b>PHÍ VẬN CHUYỂN:</b>\n\n");
        for (ShippingInfo info : shippingRates.values()) {
            sb.append("• ").append(info.getDescription()).append("\n");
        }
        return sb.toString();
    }
}
