package com.mobilestore.util;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class ProductColorUtil {
    private static final Map<String, String> COLOR_MAP = new HashMap<>();

    static {
        COLOR_MAP.put("đen", "#111827");
        COLOR_MAP.put("den", "#111827");
        COLOR_MAP.put("trắng", "#FFFFFF");
        COLOR_MAP.put("trang", "#FFFFFF");
        COLOR_MAP.put("bạc", "#C0C0C0");
        COLOR_MAP.put("bac", "#C0C0C0");
        COLOR_MAP.put("xám", "#6B7280");
        COLOR_MAP.put("xam", "#6B7280");
        COLOR_MAP.put("đỏ", "#EF4444");
        COLOR_MAP.put("do", "#EF4444");
        COLOR_MAP.put("xanh dương", "#2563EB");
        COLOR_MAP.put("xanh duong", "#2563EB");
        COLOR_MAP.put("xanh lá", "#10B981");
        COLOR_MAP.put("xanh la", "#10B981");
        COLOR_MAP.put("xanh lục", "#10B981");
        COLOR_MAP.put("xanh luc", "#10B981");
        COLOR_MAP.put("tím", "#8B5CF6");
        COLOR_MAP.put("tim", "#8B5CF6");
        COLOR_MAP.put("hồng", "#EC4899");
        COLOR_MAP.put("hong", "#EC4899");
        COLOR_MAP.put("vàng", "#F59E0B");
        COLOR_MAP.put("vang", "#F59E0B");
        COLOR_MAP.put("cam", "#FB923C");
        COLOR_MAP.put("nâu", "#92400E");
        COLOR_MAP.put("nau", "#92400E");
        COLOR_MAP.put("xanh ngọc", "#14B8A6");
        COLOR_MAP.put("xanh ngoc", "#14B8A6");
        COLOR_MAP.put("xanh rêu", "#65A30D");
        COLOR_MAP.put("xanh reu", "#65A30D");
        COLOR_MAP.put("hồng nhạt", "#F9A8D4");
        COLOR_MAP.put("hong nhat", "#F9A8D4");
        COLOR_MAP.put("xám đậm", "#374151");
        COLOR_MAP.put("xam dam", "#374151");
        COLOR_MAP.put("trắng sữa", "#F8FAFC");
        COLOR_MAP.put("trang sua", "#F8FAFC");
    }

    private ProductColorUtil() {
        // Utility class
    }

    public static List<String> splitColors(String colors) {
        List<String> result = new ArrayList<>();
        if (colors == null) {
            return result;
        }

        String[] tokens = colors.split("[,;/]+");
        for (String token : tokens) {
            String value = token.trim();
            if (!value.isEmpty()) {
                result.add(value);
            }
        }
        return result;
    }

    public static String resolveCssColor(String colorLabel) {
        if (colorLabel == null) {
            return "transparent";
        }

        String value = colorLabel.trim();
        if (value.isEmpty()) {
            return "transparent";
        }

        if (isValidCssColor(value)) {
            return value;
        }

        String normalized = normalize(value);
        String mapped = COLOR_MAP.get(normalized);
        return mapped != null ? mapped : "transparent";
    }

    private static boolean isValidCssColor(String value) {
        String lower = value.toLowerCase(Locale.ROOT).trim();
        if (lower.matches("#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})")) {
            return true;
        }
        if (lower.matches("rgb\\(\\s*\\d{1,3}\\s*,\\s*\\d{1,3}\\s*,\\s*\\d{1,3}\\s*\\)")) {
            return true;
        }
        if (lower.matches("rgba\\(\\s*\\d{1,3}\\s*,\\s*\\d{1,3}\\s*,\\s*\\d{1,3}\\s*,\\s*(0|1|0?\\.?\\d+)\\s*\\)")) {
            return true;
        }
        return lower.matches("[a-z]+( [a-z]+)*");
    }

    private static String normalize(String text) {
        String normalized = Normalizer.normalize(text.toLowerCase(Locale.ROOT), Normalizer.Form.NFD);
        normalized = normalized.replace('đ', 'd');
        normalized = normalized.replaceAll("\\p{M}+", "");
        normalized = normalized.replaceAll("[^a-z0-9 ]", " ");
        normalized = normalized.replaceAll("\\s+", " ").trim();
        return normalized;
    }
}
