package com.mobilestore.service;

import com.mobilestore.dao.CategoryDAO;
import com.mobilestore.model.Category;

import java.util.List;

/**
 * Category Service
 * Business logic for Category operations
 */
public class CategoryService {
    private final CategoryDAO categoryDAO;
    
    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }
    
    /**
     * Get all categories
     * @return List of all categories
     */
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }
    
    /**
     * Get category by ID
     * @param categoryId Category ID
     * @return Category object or null if not found
     */
    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }
    
    /**
     * Get category by name
     * @param categoryName Category name
     * @return Category object or null if not found
     */
    public Category getCategoryByName(String categoryName) {
        return categoryDAO.getCategoryByName(categoryName);
    }
    
    /**
     * Create a new category
     * @param category Category object
     * @return Category ID if successful, -1 if failed
     */
    public int createCategory(Category category) {
        // Validation
        if (category.getCategoryName() == null || category.getCategoryName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty");
        }
        
        // Check if category name already exists
        Category existing = categoryDAO.getCategoryByName(category.getCategoryName());
        if (existing != null) {
            throw new IllegalArgumentException("Category name already exists");
        }
        
        return categoryDAO.createCategory(category);
    }
    
    /**
     * Update a category
     * @param category Category object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateCategory(Category category) {
        // Validation
        if (category.getCategoryId() == null) {
            throw new IllegalArgumentException("Category ID cannot be null");
        }
        
        if (category.getCategoryName() == null || category.getCategoryName().trim().isEmpty()) {
            throw new IllegalArgumentException("Category name cannot be empty");
        }
        
        // Check if category exists
        Category existing = categoryDAO.getCategoryById(category.getCategoryId());
        if (existing == null) {
            throw new IllegalArgumentException("Category not found");
        }
        
        // Check if new name conflicts with another category
        Category nameCheck = categoryDAO.getCategoryByName(category.getCategoryName());
        if (nameCheck != null && !nameCheck.getCategoryId().equals(category.getCategoryId())) {
            throw new IllegalArgumentException("Category name already exists");
        }
        
        return categoryDAO.updateCategory(category);
    }
    
    /**
     * Delete a category
     * @param categoryId Category ID
     * @return true if successful, false otherwise
     */
    public boolean deleteCategory(int categoryId) {
        // Check if category has products
        int productCount = categoryDAO.getProductCountByCategory(categoryId);
        if (productCount > 0) {
            throw new IllegalArgumentException("Cannot delete category with existing products");
        }
        
        return categoryDAO.deleteCategory(categoryId);
    }
    
    /**
     * Get count of products in a category
     * @param categoryId Category ID
     * @return Number of products
     */
    public int getProductCountByCategory(int categoryId) {
        return categoryDAO.getProductCountByCategory(categoryId);
    }
}
