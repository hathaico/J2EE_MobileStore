
package com.mobilestore.util;
import com.mobilestore.util.PasswordUtil;

/**
 * Generate password hash for database
 * Run this to generate BCrypt hashes for passwords
 */
public class GeneratePasswordHash {
    public static void main(String[] args) {
        // Generate hash for admin123
        String password1 = "admin123";
        String hash1 = PasswordUtil.hashPassword(password1);
        System.out.println("Password: " + password1);
        System.out.println("Hash: " + hash1);
        System.out.println();
        
        // Generate hash for staff123
        String password2 = "staff123";
        String hash2 = PasswordUtil.hashPassword(password2);
        System.out.println("Password: " + password2);
        System.out.println("Hash: " + hash2);
        System.out.println();
        
        // Verify
        System.out.println("Verify admin123: " + PasswordUtil.verifyPassword(password1, hash1));
        System.out.println("Verify staff123: " + PasswordUtil.verifyPassword(password2, hash2));
    }
}
