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
import java.math.BigDecimal;
import java.util.List;

/**
 * Product Controller
 * Handles product-related requests
 */
@WebServlet("/products")
public class ProductController extends HttpServlet {
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
                case "detail":
                    viewProductDetail(request, response);
                    break;
                case "search":
                    searchProducts(request, response);
                    break;
                case "category":
                    filterByCategory(request, response);
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
            } else if ("delete".equals(action)) {
                deleteProduct(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error/500.jsp").forward(request, response);
        }
    }
    
    /**
     * List all products with pagination
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Pagination parameters
        int page = 1;
        int pageSize = 12;
        
        String pageParam = request.getParameter("page");
        if (ValidationUtil.isInteger(pageParam)) {
            page = Integer.parseInt(pageParam);
        }
        
        // Get products and pagination info
        List<Product> products = productService.getProductsWithPagination(page, pageSize);
        int totalProducts = productService.getTotalProductCount();
        int totalPages = productService.getTotalPages(pageSize);
        
        // Get categories for filter
        List<Category> categories = categoryService.getAllCategories();
        
        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        
        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }
    
    /**
     * View product detail
     */
    private void viewProductDetail(HttpServletRequest request, HttpServletResponse response)
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
        
        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/views/product/detail.jsp").forward(request, response);
    }
    
    /**
     * Search products by keyword
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        List<Product> products = productService.searchProducts(keyword);
        List<Category> categories = categoryService.getAllCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalProducts", products.size());
        
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }
    
    /**
     * Filter products by category
     */
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (!ValidationUtil.isInteger(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid category ID");
            return;
        }
        
        int categoryId = Integer.parseInt(idParam);
        
        List<Product> products = productService.getProductsByCategory(categoryId);
        List<Category> categories = categoryService.getAllCategories();
        Category selectedCategory = categoryService.getCategoryById(categoryId);
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", selectedCategory);
        request.setAttribute("totalProducts", products.size());
        
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }
    
    /**
     * Create a new product (Admin only - will be protected by filter)
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Product product = extractProductFromRequest(request);
            int productId = productService.createProduct(product);
            
            if (productId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create product");
                request.getRequestDispatcher("/WEB-INF/views/admin/product/add.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/product/add.jsp").forward(request, response);
        }
    }
    
    /**
     * Update a product (Admin only)
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Product product = extractProductFromRequest(request);
            
            String idParam = request.getParameter("id");
            if (!ValidationUtil.isInteger(idParam)) {
                throw new IllegalArgumentException("Invalid product ID");
            }
            
            product.setProductId(Integer.parseInt(idParam));
            
            boolean success = productService.updateProduct(product);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/products?action=list&success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update product");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/views/admin/product/edit.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/product/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete a product (Admin only)
     */
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
    
    /**
     * Extract product data from request
     */
    private Product extractProductFromRequest(HttpServletRequest request) {
        Product product = new Product();
        
        String productName = request.getParameter("productName");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        String categoryIdStr = request.getParameter("categoryId");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        
        product.setProductName(productName);
        product.setBrand(brand);
        product.setModel(model);
        
        if (ValidationUtil.isDecimal(priceStr)) {
            product.setPrice(new BigDecimal(priceStr));
        }
        
        if (ValidationUtil.isInteger(stockStr)) {
            product.setStockQuantity(Integer.parseInt(stockStr));
        }
        
        if (ValidationUtil.isInteger(categoryIdStr)) {
            product.setCategoryId(Integer.parseInt(categoryIdStr));
        }
        
        product.setDescription(description);
        product.setImageUrl(imageUrl);
        
        return product;
    }
}
