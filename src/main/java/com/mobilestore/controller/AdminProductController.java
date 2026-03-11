package com.mobilestore.controller;

import com.mobilestore.model.Category;
import com.mobilestore.model.Product;
import com.mobilestore.service.CategoryService;
import com.mobilestore.service.ProductService;
import com.mobilestore.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Admin Product Controller
 * Handles admin product management requests
 */
@WebServlet("/admin/products")
public class AdminProductController extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryService = new CategoryService();
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
    
    private Product extractProductFromRequest(HttpServletRequest request) {
        Product product = new Product();
        
        product.setProductName(request.getParameter("productName"));
        product.setBrand(request.getParameter("brand"));
        product.setModel(request.getParameter("model"));
        product.setDescription(request.getParameter("description"));
        product.setImageUrl(request.getParameter("imageUrl"));
        
        String priceStr = request.getParameter("price");
        if (ValidationUtil.isDecimal(priceStr)) {
            product.setPrice(new java.math.BigDecimal(priceStr));
        }
        
        String stockStr = request.getParameter("stockQuantity");
        if (ValidationUtil.isInteger(stockStr)) {
            product.setStockQuantity(Integer.parseInt(stockStr));
        }
        
        String categoryIdStr = request.getParameter("categoryId");
        if (ValidationUtil.isInteger(categoryIdStr)) {
            product.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        
        return product;
    }
}
