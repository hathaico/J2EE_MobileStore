package com.mobilestore.controller;

import com.mobilestore.model.Category;
import com.mobilestore.model.Product;
import com.mobilestore.service.CategoryService;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.BrandService;
import com.mobilestore.util.ProductImageUtil;
import com.mobilestore.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.List;

/**
 * Admin Product Controller
 * Handles admin product management requests
 */
@WebServlet("/admin/products")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024, fileSizeThreshold = 0)
public class AdminProductController extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;
    private BrandService brandService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryService = new CategoryService();
        brandService = new BrandService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listProducts(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        // If action missing (multipart or form changes), default to 'create' for add form submissions
        if (action == null || action.trim().isEmpty()) {
            action = "create";
        }
        
        try {
            if ("create".equals(action)) {
                createProduct(request, response);
            } else if ("update".equals(action)) {
                updateProduct(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Only list active products here so deleted items no longer appear in the admin product table
        List<Product> products = productService.getAllProducts();
        List<Category> categories = categoryService.getAllCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        
        // Success/error messages
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        
        if (success != null) {
            switch (success) {
                case "created":
                    request.setAttribute("successMessage", "Thêm sản phẩm thành công!");
                    break;
                case "updated":
                    request.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
                    break;
                case "deleted":
                    request.setAttribute("successMessage", "Xóa sản phẩm thành công!");
                    break;
            }
        }
        
        if (error != null) {
            request.setAttribute("errorMessage", "Lỗi: " + error);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/product/list.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        
        // provide brands to the view (if available)
        try {
            request.setAttribute("brands", brandService.getAllBrands());
        } catch (Exception ignored) {
            // not critical - view will fallback to text input when brands is empty
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin/product/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (!ValidationUtil.isInteger(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            return;
        }
        
        int productId = Integer.parseInt(idParam);
        Product product = productService.getProductById(productId);
        
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }
        
        List<Category> categories = categoryService.getAllCategories();
        
        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/product/edit.jsp").forward(request, response);
    }
    
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Product product = extractProductFromRequest(request);
            int productId = productService.createProduct(product);
            
            if (productId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&success=created");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo sản phẩm");
                showAddForm(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            showAddForm(request, response);
        } catch (IOException | ServletException e) {
            request.setAttribute("errorMessage", "Không thể lưu ảnh: " + e.getMessage());
            showAddForm(request, response);
        }
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            if (!ValidationUtil.isInteger(idParam)) {
                throw new IllegalArgumentException("Invalid product ID");
            }
            
            int productId = Integer.parseInt(idParam);
            Product product = extractProductFromRequest(request);
            product.setProductId(productId);
            
            boolean success = productService.updateProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&success=updated");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật sản phẩm");
                showEditForm(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            showEditForm(request, response);
        } catch (IOException | ServletException e) {
            request.setAttribute("errorMessage", "Không thể lưu ảnh: " + e.getMessage());
            showEditForm(request, response);
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (!ValidationUtil.isInteger(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
            return;
        }
        
        int productId = Integer.parseInt(idParam);
        
        try {
            boolean success = productService.deleteProduct(productId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&error=delete_failed");
            }
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products?action=list&error=" + e.getMessage());
        }
    }
    
    private Product extractProductFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Product product = new Product();
        
        product.setProductName(request.getParameter("productName"));
        product.setBrand(request.getParameter("brand"));
        product.setModel(request.getParameter("model"));
        product.setDescription(request.getParameter("description"));
        String uploaded = ProductImageUtil.saveUploadedProductImage(request);
        if (uploaded != null) {
            product.setImageUrl(uploaded);
        } else {
            product.setImageUrl(request.getParameter("imageUrl"));
        }

        List<String> galleryImages = ProductImageUtil.saveUploadedProductImages(request, "productImageFiles");
        product.setImageUrls(mergeGalleryImages(request.getParameter("imageUrls"), galleryImages));
        
        String priceStr = request.getParameter("price");
        if (ValidationUtil.isDecimal(priceStr)) {
            product.setPrice(new java.math.BigDecimal(priceStr));
        }
        
        String stockStr = request.getParameter("stockQuantity");
        if (ValidationUtil.isInteger(stockStr)) {
            product.setStockQuantity(Integer.parseInt(stockStr));
        }
        
        product.setColor(request.getParameter("color"));
        product.setCapacity(request.getParameter("capacity"));
        
        String categoryIdStr = request.getParameter("categoryId");
        if (ValidationUtil.isInteger(categoryIdStr)) {
            product.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        
        return product;
    }

    private String mergeGalleryImages(String existingImageUrls, List<String> uploadedImages) {
        Set<String> merged = new LinkedHashSet<>();

        if (existingImageUrls != null && !existingImageUrls.trim().isEmpty()) {
            String[] currentImages = existingImageUrls.split(",");
            for (String currentImage : currentImages) {
                if (currentImage != null && !currentImage.trim().isEmpty()) {
                    merged.add(currentImage.trim());
                }
            }
        }

        if (uploadedImages != null) {
            for (String uploadedImage : uploadedImages) {
                if (uploadedImage != null && !uploadedImage.trim().isEmpty()) {
                    merged.add(uploadedImage.trim());
                }
            }
        }

        if (merged.isEmpty()) {
            return null;
        }

        return String.join(",", merged);
    }
}
