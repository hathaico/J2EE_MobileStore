package com.mobilestore.util;

import java.time.YearMonth;

/**
 * Utility methods for validating card payment inputs.
 */
public final class PaymentCardUtil {
    private PaymentCardUtil() {
    }

    public static String normalizeCardNumber(String cardNumber) {
        if (cardNumber == null) {
            return "";
        }
        return cardNumber.replaceAll("[^0-9]", "");
    }

    public static boolean isValidCardNumber(String cardNumber) {
        String normalized = normalizeCardNumber(cardNumber);
        if (normalized.length() < 13 || normalized.length() > 19) {
            return false;
        }

        int sum = 0;
        boolean shouldDouble = false;
        for (int i = normalized.length() - 1; i >= 0; i--) {
            int digit = normalized.charAt(i) - '0';
            if (shouldDouble) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            sum += digit;
            shouldDouble = !shouldDouble;
        }

        return sum % 10 == 0;
    }

    public static boolean isValidCvv(String cvv) {
        if (cvv == null) {
            return false;
        }
        return cvv.matches("^[0-9]{3,4}$");
    }

    public static boolean isValidExpiry(String expiry) {
        if (expiry == null || !expiry.matches("^(0[1-9]|1[0-2])/([0-9]{2})$")) {
            return false;
        }

        String[] parts = expiry.split("/");
        int month = Integer.parseInt(parts[0]);
        int year = Integer.parseInt(parts[1]) + 2000;

        YearMonth now = YearMonth.now();
        YearMonth input = YearMonth.of(year, month);
        return !input.isBefore(now);
    }

    public static String maskCardNumber(String cardNumber) {
        String normalized = normalizeCardNumber(cardNumber);
        if (normalized.length() < 4) {
            return "****";
        }
        String last4 = normalized.substring(normalized.length() - 4);
        return "**** **** **** " + last4;
    }
}