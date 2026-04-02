package com.mobilestore.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * VNPay helper for creating signed request URLs and validating callback signatures.
 */
public final class VnPayUtil {
    // Set these values from environment variables in production.
    public static final String VNP_TMN_CODE = getEnvOrDefault("VNPAY_TMN_CODE", "DEMO_TMN_CODE");
    public static final String VNP_HASH_SECRET = getEnvOrDefault("VNPAY_HASH_SECRET", "DEMO_HASH_SECRET");
    public static final String VNP_PAY_URL = getEnvOrDefault("VNPAY_PAY_URL", "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html");
    public static final boolean VNP_DEV_MODE = Boolean.parseBoolean(getEnvOrDefault("VNPAY_DEV_MODE", "false"));

    private VnPayUtil() {
    }

    public static boolean isConfigured() {
        return !("DEMO_TMN_CODE".equals(VNP_TMN_CODE) || "DEMO_HASH_SECRET".equals(VNP_HASH_SECRET));
    }

    public static boolean isDevMode() {
        return VNP_DEV_MODE;
    }

    public static String buildPaymentUrl(String returnUrl, long amountVnd, String orderInfo, String txnRef, String ipAddr) {
        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", "2.1.0");
        params.put("vnp_Command", "pay");
        params.put("vnp_TmnCode", VNP_TMN_CODE);
        params.put("vnp_Amount", String.valueOf(amountVnd * 100L));
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", txnRef);
        params.put("vnp_OrderInfo", orderInfo);
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", returnUrl);
        params.put("vnp_IpAddr", ipAddr == null ? "127.0.0.1" : ipAddr);

        Date now = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        params.put("vnp_CreateDate", formatter.format(now));

        String queryData = buildQuery(params, false);
        String hashData = buildQuery(params, true);
        String secureHash = hmacSHA512(VNP_HASH_SECRET, hashData);

        return VNP_PAY_URL + "?" + queryData + "&vnp_SecureHash=" + secureHash;
    }

    public static boolean verifySignature(Map<String, String> allParams) {
        if (allParams == null || allParams.isEmpty()) {
            return false;
        }

        String providedHash = allParams.get("vnp_SecureHash");
        if (providedHash == null || providedHash.isEmpty()) {
            return false;
        }

        Map<String, String> filtered = new HashMap<>(allParams);
        filtered.remove("vnp_SecureHash");
        filtered.remove("vnp_SecureHashType");

        String hashData = buildQuery(filtered, true);
        String expectedHash = hmacSHA512(VNP_HASH_SECRET, hashData);
        return expectedHash.equalsIgnoreCase(providedHash);
    }

    private static String buildQuery(Map<String, String> params, boolean encode) {
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);

        StringBuilder sb = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            if (value == null || value.isEmpty()) {
                continue;
            }
            if (sb.length() > 0) {
                sb.append('&');
            }
            if (encode) {
                sb.append(urlEncode(key)).append('=').append(urlEncode(value));
            } else {
                sb.append(urlEncode(key)).append('=').append(urlEncode(value));
            }
        }
        return sb.toString();
    }

    private static String hmacSHA512(String key, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
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
        } catch (Exception e) {
            throw new RuntimeException("Unable to sign VNPay payload", e);
        }
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

    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}