package com.mobilestore.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Password Utility
 * Handles password hashing and verification using BCrypt
 */
public class PasswordUtil {
    
    // BCrypt work factor (log rounds)
    private static final int WORK_FACTOR = 12;
    
    /**
     * Hash a plain text password
     * @param plainPassword Plain text password
     * @return Hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORK_FACTOR));
    }
    
    /**
     * Verify a plain text password against a hashed password
     * @param plainPassword Plain text password
     * @param hashedPassword Hashed password from database
     * @return true if passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            System.err.println("Error verifying password: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Check if password needs rehashing (if work factor changed)
     * @param hashedPassword Hashed password from database
     * @return true if needs rehashing, false otherwise
     */
    public static boolean needsRehash(String hashedPassword) {
        try {
            return BCrypt.gensalt(WORK_FACTOR).length() != hashedPassword.length();
        } catch (Exception e) {
            return false;
        }
    }
}
