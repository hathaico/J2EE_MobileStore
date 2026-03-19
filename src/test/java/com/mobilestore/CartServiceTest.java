package com.mobilestore;

import com.mobilestore.model.Cart;
import com.mobilestore.model.Product;
import com.mobilestore.service.CartService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class CartServiceTest {
    private CartService cartService;

    @BeforeEach
    public void setUp() {
        cartService = new CartService();
    }

    @Test
    public void testCreateCartAndAddProduct() {
        Cart cart = cartService.createCart();
        Assertions.assertNotNull(cart, "Tạo giỏ hàng mới phải trả về đối tượng Cart");
        Product product = new Product();
        product.setProductId(1); // giả định id 1 tồn tại
        product.setProductName("Sản phẩm test");
        cartService.addProductToCart(cart, product, 2);
        Assertions.assertFalse(cart.getItems().isEmpty(), "Giỏ hàng phải có sản phẩm sau khi thêm");
    }

    @Test
    public void testAddProductWithZeroQuantity() {
        Cart cart = cartService.createCart();
        Product product = new Product();
        product.setProductId(2);
        product.setProductName("Sản phẩm số lượng 0");
        cartService.addProductToCart(cart, product, 0);
        Assertions.assertTrue(cart.getItems().isEmpty(), "Không được thêm sản phẩm với số lượng 0 vào giỏ hàng");
    }
}
