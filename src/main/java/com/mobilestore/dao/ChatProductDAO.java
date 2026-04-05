package com.mobilestore.dao;

import com.mobilestore.model.ChatProductSpec;
import com.mobilestore.model.Product;

import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ChatProductDAO {
    private static final Pattern NUMBER_GB_PATTERN = Pattern.compile("(\\d{1,3})\\s*gb", Pattern.CASE_INSENSITIVE);
    private static final Pattern NUMBER_MAH_PATTERN = Pattern.compile("(\\d{3,5})\\s*mah", Pattern.CASE_INSENSITIVE);
    private static final Pattern CAMERA_MP_PATTERN = Pattern.compile("(\\d{1,3})\\s*mp", Pattern.CASE_INSENSITIVE);

    private final ProductDAO productDAO = new ProductDAO();

    // Get all products
    public List<ChatProductSpec> getAllProducts() {
        List<Product> products = productDAO.getAllProducts();
        List<ChatProductSpec> mapped = new ArrayList<>();
        for (Product product : products) {
            mapped.add(mapToChatProduct(product));
        }
        return mapped;
    }

    // Get product by ID
    public ChatProductSpec getProductById(Integer id) {
        Product product = productDAO.getProductById(id);
        return product == null ? null : mapToChatProduct(product);
    }

    // Get products by brand
    public List<ChatProductSpec> getProductsByBrand(String brand) {
        if (brand == null || brand.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<ChatProductSpec> result = new ArrayList<>();
        String normalizedBrand = brand.trim().toLowerCase();
        for (ChatProductSpec product : getAllProducts()) {
            String pBrand = product.getBrand() == null ? "" : product.getBrand().toLowerCase();
            if (pBrand.contains(normalizedBrand)) {
                result.add(product);
            }
        }
        return result;
    }

    // Get products within price range
    public List<ChatProductSpec> getProductsByPriceRange(Integer minPrice, Integer maxPrice) {
        List<ChatProductSpec> result = new ArrayList<>();
        for (ChatProductSpec product : getAllProducts()) {
            Integer price = product.getDiscountedPrice() != null ? product.getDiscountedPrice() : product.getPrice();
            if (price >= minPrice && price <= maxPrice) {
                result.add(product);
            }
        }
        return result;
    }

    // Get products with minimum RAM
    public List<ChatProductSpec> getProductsByMinRam(Integer ramGB) {
        List<ChatProductSpec> result = new ArrayList<>();
        for (ChatProductSpec product : getAllProducts()) {
            if (product.getRam() >= ramGB) {
                result.add(product);
            }
        }
        return result;
    }

    // Get in-stock products
    public List<ChatProductSpec> getInStockProducts() {
        List<ChatProductSpec> result = new ArrayList<>();
        for (ChatProductSpec product : getAllProducts()) {
            if (product.getStock() > 0) {
                result.add(product);
            }
        }
        return result;
    }

    // Search products by name or brand
    public List<ChatProductSpec> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<Product> dbProducts = productDAO.searchProducts(keyword.trim());
        if (!dbProducts.isEmpty()) {
            List<ChatProductSpec> mapped = new ArrayList<>();
            for (Product p : dbProducts) {
                mapped.add(mapToChatProduct(p));
            }
            return mapped;
        }

        // fallback filter for fields not covered by ProductDAO.searchProducts
        List<ChatProductSpec> result = new ArrayList<>();
        String lowerKeyword = keyword.toLowerCase().trim();
        for (ChatProductSpec product : getAllProducts()) {
            String name = product.getName() == null ? "" : product.getName().toLowerCase();
            String brand = product.getBrand() == null ? "" : product.getBrand().toLowerCase();
            String desc = product.getDescription() == null ? "" : product.getDescription().toLowerCase();
            if (name.contains(lowerKeyword) || brand.contains(lowerKeyword) || desc.contains(lowerKeyword)) {
                result.add(product);
            }
        }
        return result;
    }

    // Top-rated products
    public List<ChatProductSpec> getTopRatedProducts(int limit) {
        List<ChatProductSpec> sorted = new ArrayList<>(getAllProducts());
        sorted.sort((a, b) -> Double.compare(b.getRating(), a.getRating()));
        return sorted.subList(0, Math.min(limit, sorted.size()));
    }

    private ChatProductSpec mapToChatProduct(Product product) {
        ChatProductSpec chat = new ChatProductSpec();
        chat.setId(product.getProductId());
        chat.setName(resolveName(product));
        chat.setBrand(defaultIfBlank(product.getBrand(), "Không rõ"));
        chat.setPrice(toSafeInt(product.getPrice()));
        chat.setDiscountedPrice(null);
        chat.setCpu(resolveCpu(product));
        chat.setRam(resolveRam(product));
        chat.setStorage(resolveStorage(product));
        chat.setBattery(resolveBattery(product));
        chat.setFrontCamera(resolveFrontCamera(product));
        chat.setRearCamera(resolveRearCamera(product));
        chat.setColors(defaultIfBlank(product.getColor(), "Nhiều màu"));
        chat.setStock(product.getStockQuantity() == null ? 0 : product.getStockQuantity());
        chat.setDescription(defaultIfBlank(product.getDescription(), "Sản phẩm chính hãng tại Mobile Store"));
        chat.setRating(4.5d);
        return chat;
    }

    private String resolveName(Product product) {
        String productName = defaultIfBlank(product.getProductName(), "Sản phẩm");
        String model = product.getModel();
        if (model != null && !model.trim().isEmpty() && !productName.toLowerCase().contains(model.trim().toLowerCase())) {
            return productName + " " + model.trim();
        }
        return productName;
    }

    private String resolveCpu(Product product) {
        String model = product.getModel();
        if (model != null && !model.trim().isEmpty()) {
            return model.trim();
        }
        return "Đang cập nhật";
    }

    private Integer resolveRam(Product product) {
        Integer fromCapacity = extractGB(defaultIfBlank(product.getCapacity(), ""));
        if (fromCapacity != null) {
            return fromCapacity;
        }

        Integer fromDescription = extractGB(defaultIfBlank(product.getDescription(), ""));
        if (fromDescription != null) {
            return fromDescription;
        }
        return 8;
    }

    private Integer resolveStorage(Product product) {
        Integer storage = extractGB(defaultIfBlank(product.getCapacity(), ""));
        if (storage != null) {
            return storage;
        }
        return 128;
    }

    private Integer resolveBattery(Product product) {
        Integer battery = extractMah(defaultIfBlank(product.getDescription(), ""));
        if (battery != null) {
            return battery;
        }
        return 5000;
    }

    private String resolveFrontCamera(Product product) {
        Integer camera = extractCameraMp(defaultIfBlank(product.getDescription(), ""));
        if (camera != null) {
            return camera + "MP";
        }
        return "Đang cập nhật";
    }

    private String resolveRearCamera(Product product) {
        Integer camera = extractCameraMp(defaultIfBlank(product.getDescription(), ""));
        if (camera != null) {
            return camera + "MP";
        }
        return "Đang cập nhật";
    }

    private Integer extractGB(String text) {
        Matcher matcher = NUMBER_GB_PATTERN.matcher(text);
        if (matcher.find()) {
            return parseSafeInt(matcher.group(1));
        }
        return null;
    }

    private Integer extractMah(String text) {
        Matcher matcher = NUMBER_MAH_PATTERN.matcher(text);
        if (matcher.find()) {
            return parseSafeInt(matcher.group(1));
        }
        return null;
    }

    private Integer extractCameraMp(String text) {
        Matcher matcher = CAMERA_MP_PATTERN.matcher(text);
        if (matcher.find()) {
            return parseSafeInt(matcher.group(1));
        }
        return null;
    }

    private Integer parseSafeInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private int toSafeInt(BigDecimal value) {
        if (value == null) {
            return 0;
        }
        return value.intValue();
    }

    private String defaultIfBlank(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }
        return value.trim();
    }
}
