package com.mobilestore.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * MoMo helper for env config and simple callback signature validation.
 */
public final class MoMoUtil {
    public static final String MOMO_PARTNER_CODE = getEnvOrDefault("MOMO_PARTNER_CODE", "DEMO_MOMO_PARTNER");
    public static final String MOMO_ACCESS_KEY = getEnvOrDefault("MOMO_ACCESS_KEY", "DEMO_MOMO_ACCESS");
    public static final String MOMO_SECRET_KEY = getEnvOrDefault("MOMO_SECRET_KEY", "DEMO_MOMO_SECRET");
    public static final boolean MOMO_DEV_MODE = Boolean.parseBoolean(getEnvOrDefault("MOMO_DEV_MODE", "true"));

    private MoMoUtil() {
    }

    public static boolean isConfigured() {
        return !("DEMO_MOMO_PARTNER".equals(MOMO_PARTNER_CODE)
                || "DEMO_MOMO_ACCESS".equals(MOMO_ACCESS_KEY)
                || "DEMO_MOMO_SECRET".equals(MOMO_SECRET_KEY));
    }

    public static boolean isDevMode() {
        return MOMO_DEV_MODE;
    }

    public static String signReturn(String orderId, String resultCode) {
        String raw = "orderId=" + safe(orderId) + "&resultCode=" + safe(resultCode);
        return hmacSHA256(MOMO_SECRET_KEY, raw);
    }

    public static boolean verifyReturn(String orderId, String resultCode, String signature) {
        if (signature == null || signature.trim().isEmpty()) {
            return false;
        }
        String expected = signReturn(orderId, resultCode);
        return expected.equalsIgnoreCase(signature);
    }

    public static Map<String, String> buildMockLinks(String contextPath, int orderId) {
        Map<String, String> links = new HashMap<>();
        String okSig = signReturn(String.valueOf(orderId), "0");
        String failSig = signReturn(String.valueOf(orderId), "1");

        links.put("success", contextPath + "/payment/momo/return?orderId=" + orderId + "&resultCode=0&signature=" + okSig);
        links.put("failed", contextPath + "/payment/momo/return?orderId=" + orderId + "&resultCode=1&signature=" + failSig);
        return links;
    }

    private static String getEnvOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }
        return value.trim();
    }

    private static String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private static String hmacSHA256(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            hmac.init(secretKeySpec);
            byte[] bytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hash.append('0');
                }
                hash.append(hex);
            }
            return hash.toString();
        } catch (Exception ex) {
            throw new RuntimeException("Unable to sign MoMo payload", ex);
        }
    }
}
