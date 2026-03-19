package com.mobilestore;

import com.mobilestore.model.Cart;
import com.mobilestore.service.OrderService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class OrderServiceTest {
    private OrderService orderService;

    @BeforeEach
    public void setUp() {
        orderService = new OrderService();
    }

    @Test
    public void testCreateOrderWithNullCart() {
        Assertions.assertThrows(IllegalArgumentException.class, () -> {
                orderService.createOrder(null, "address", "CASH", "note", 1, null, null);
        });
    }

    @Test
    public void testCreateOrderWithEmptyCart() {
        Cart cart = new Cart();
        Assertions.assertThrows(IllegalArgumentException.class, () -> {
                orderService.createOrder(cart, "address", "CASH", "note", 1, null, null);
        });
    }
}
