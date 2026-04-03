package com.mobilestore.api;

import com.google.gson.GsonBuilder;
import com.google.gson.Gson;
import com.mobilestore.model.Product;
import com.mobilestore.service.ProductService;

import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;

public class ProductApiServlet extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
            new com.google.gson.JsonPrimitive(src.toString())
        )
        .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/products
                List<Product> products = productService.getAllProducts();
                writeSuccess(resp, products);
            } else {
                // GET /api/products/{id}
                try {
                    int id = Integer.parseInt(pathInfo.substring(1));
                    Product product = productService.getProductById(id);
                    if (product != null) {
                        writeSuccess(resp, product);
                    } else {
                        writeError(resp, "Product not found");
                    }
                } catch (NumberFormatException e) {
                    writeError(resp, "Invalid product ID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            Product product = gson.fromJson(req.getReader(), Product.class);
            int created = productService.createProduct(product);
            if (created > 0) {
                product.setProductId(created);
                writeSuccess(resp, product);
            } else {
                writeError(resp, "Failed to create product");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                writeError(resp, "Product ID required");
                return;
            }
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                Product product = gson.fromJson(req.getReader(), Product.class);
                product.setProductId(id);
                boolean updated = productService.updateProduct(product);
                if (updated) {
                    writeSuccess(resp, product);
                } else {
                    writeError(resp, "Product not found or update failed");
                }
            } catch (NumberFormatException e) {
                writeError(resp, "Invalid product ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        try {
            String pathInfo = req.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                writeError(resp, "Product ID required");
                return;
            }
            try {
                int id = Integer.parseInt(pathInfo.substring(1));
                boolean deleted = productService.deleteProduct(id);
                if (deleted) {
                    writeSuccess(resp, "Product deleted");
                } else {
                    writeError(resp, "Product not found or delete failed");
                }
            } catch (NumberFormatException e) {
                writeError(resp, "Invalid product ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writeError(resp, "Internal server error: " + e.getMessage());
        }
    }

    private void writeSuccess(HttpServletResponse resp, Object data) throws IOException {
        resp.getWriter().write(gson.toJson(new ApiResponse("success", data)));
    }

    private void writeError(HttpServletResponse resp, String message) throws IOException {
        resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        resp.getWriter().write(gson.toJson(new ApiResponse("error", message)));
    }

    static class ApiResponse {
        String status;
        Object data;
        ApiResponse(String status, Object data) {
            this.status = status;
            this.data = data;
        }
    }
}
