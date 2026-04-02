package com.mobilestore.util;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.UUID;

/**
 * Resolves product image URLs for JSP and handles admin upload storage under /assets/images/products.
 */
public final class ProductImageUtil {

    public static final String RELATIVE_DIR = "/assets/images/products";
    private static final String PART_NAME = "productImageFile";

    private ProductImageUtil() {
    }

    /**
     * Build browser URL for a stored image value (filename, absolute path, external URL, etc.).
     */
    public static String resolveSrc(String contextPath, String imageUrl) {
        if (imageUrl == null) {
            return null;
        }
        String s = imageUrl.trim();
        if (s.isEmpty()) {
            return null;
        }
        String lower = s.toLowerCase(Locale.ROOT);
        if (lower.startsWith("http://") || lower.startsWith("https://")) {
            return s;
        }
        if (s.startsWith("/")) {
            return contextPath + s;
        }
        if (s.contains("assets/images/products")) {
            return contextPath + "/" + s;
        }
        return contextPath + RELATIVE_DIR + "/" + s;
    }

    /**
     * Save multipart part {@code productImageFile} into webapp assets folder. Returns stored filename, or null.
     */
    public static String saveUploadedProductImage(HttpServletRequest request) throws IOException, ServletException {
        Part part = request.getPart(PART_NAME);
        if (part == null || part.getSize() == 0) {
            return null;
        }
        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.isBlank()) {
            return null;
        }
        String ext = "";
        int dot = submitted.lastIndexOf('.');
        if (dot >= 0) {
            ext = submitted.substring(dot).toLowerCase(Locale.ROOT);
        }
        if (!ext.matches("\\.(jpg|jpeg|png|gif|webp|svg)")) {
            return null;
        }
        String baseDir = request.getServletContext().getRealPath(RELATIVE_DIR);
        if (baseDir == null) {
            return null;
        }
        Path dir = Paths.get(baseDir);
        Files.createDirectories(dir);
        String filename = UUID.randomUUID().toString().replace("-", "") + ext;
        Path target = dir.resolve(filename);
        part.write(target.toString());
        return filename;
    }
}
