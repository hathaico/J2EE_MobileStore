package com.mobilestore;

import com.mobilestore.model.Product;
import com.mobilestore.service.ProductService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

public class ProductServiceTest {
    private ProductService productService;

    @BeforeEach
    public void setUp() {
        productService = new ProductService();
    }

    @Test
    public void testGetAllProducts() {
        List<Product> products = productService.getAllProducts();
        Assertions.assertNotNull(products, "Danh sách sản phẩm không được null");
    }

    @Test
    public void testGetProductByIdNotFound() {
        Product product = productService.getProductById(-1);
        Assertions.assertNull(product, "Tìm sản phẩm với id không tồn tại phải trả về null");
    }

    // Có thể bổ sung thêm test thêm/sửa/xóa sản phẩm nếu ProductService hỗ trợ
}
