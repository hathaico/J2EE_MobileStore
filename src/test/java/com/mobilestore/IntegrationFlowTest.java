package com.mobilestore;

import com.mobilestore.model.Cart;
import com.mobilestore.model.Product;
import com.mobilestore.model.User;
import com.mobilestore.service.CartService;
import com.mobilestore.service.ProductService;
import com.mobilestore.service.UserService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class IntegrationFlowTest {
    private UserService userService;
    private ProductService productService;
    private CartService cartService;

    private com.mobilestore.service.OrderService orderService;

    @BeforeEach
    public void setUp() {
        userService = new UserService();
        productService = new ProductService();
        cartService = new CartService();
        orderService = new com.mobilestore.service.OrderService();
    }

    @Test
    public void testRegisterLoginAddToCartFlow() {
        // Dọn dẹp dữ liệu test
        String username = "flowuser";
        String email = "flowuser@example.com";
        User user = userService.getUserByUsername(username);
        if (user != null) {
            com.mobilestore.dao.UserDAO userDAO = new com.mobilestore.dao.UserDAO();
            userDAO.deleteUserByUsername(username);
            userDAO.deleteUserByEmail(email);
        }

        // Đăng ký
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword("flowpass");
        newUser.setFullName("Flow User");
        newUser.setRole("USER");
        boolean reg = userService.register(newUser);
        Assertions.assertTrue(reg, "Đăng ký thành công");

        // Đăng nhập
        User loggedIn = userService.authenticate(email, "flowpass");
        Assertions.assertNotNull(loggedIn, "Đăng nhập thành công");

        // Lấy sản phẩm đầu tiên trong hệ thống
        Product product = productService.getAllProducts().stream().findFirst().orElse(null);
        Assertions.assertNotNull(product, "Phải có ít nhất 1 sản phẩm để kiểm thử");

        // Thêm vào giỏ hàng
        Cart cart = cartService.createCart();
        cartService.addProductToCart(cart, product, 1);
        Assertions.assertEquals(1, cart.getItems().size(), "Giỏ hàng phải có 1 sản phẩm");
        Assertions.assertEquals(product.getProductId(), cart.getItems().get(0).getProduct().getProductId(), "Sản phẩm trong giỏ đúng");
    }

    @Test
    public void testFullOrderFlow() {
        // Dọn dẹp dữ liệu test
        String username = "orderflowuser";
        String email = "orderflowuser@example.com";
        com.mobilestore.dao.UserDAO userDAO = new com.mobilestore.dao.UserDAO();
        User user = userService.getUserByUsername(username);
        if (user != null) {
            userDAO.deleteUserByUsername(username);
            userDAO.deleteUserByEmail(email);
        }

        // Đăng ký
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword("orderpass");
        newUser.setFullName("Order Flow User");
        newUser.setRole("USER");
        boolean reg = userService.register(newUser);
        Assertions.assertTrue(reg, "Đăng ký thành công");

        // Đăng nhập
        User loggedIn = userService.authenticate(email, "orderpass");
        Assertions.assertNotNull(loggedIn, "Đăng nhập thành công");

        // Lấy sản phẩm đầu tiên trong hệ thống
        Product product = productService.getAllProducts().stream().findFirst().orElse(null);
        Assertions.assertNotNull(product, "Phải có ít nhất 1 sản phẩm để kiểm thử");

        // Thêm vào giỏ hàng
        Cart cart = cartService.createCart();
        cartService.addProductToCart(cart, product, 2);
        Assertions.assertEquals(1, cart.getItems().size(), "Giỏ hàng phải có 1 sản phẩm");

        // Đặt hàng
        String shippingAddress = "123 Test Street";
        String paymentMethod = "CASH";
        String notes = "Test order integration flow";
        // Lấy customerId từ userId
        com.mobilestore.dao.CustomerDAO customerDAO = new com.mobilestore.dao.CustomerDAO();
        com.mobilestore.model.Customer customer = null;
        int retry = 5;
        while (retry-- > 0) {
            customer = customerDAO.getCustomerByUserId(loggedIn.getUserId());
            if (customer != null) break;
            try { Thread.sleep(100); } catch (InterruptedException ignored) {}
        }
        Assertions.assertNotNull(customer, "Customer phải tồn tại sau khi đăng ký user");
        int customerId = customer.getCustomerId();
        int orderId = orderService.createOrder(cart, shippingAddress, paymentMethod, notes, customerId, null, null);
        Assertions.assertTrue(orderId > 0, "Đặt hàng thành công, orderId > 0");

        // Xác minh đơn hàng vừa tạo
        com.mobilestore.dao.OrderDAO orderDAO = new com.mobilestore.dao.OrderDAO();
        com.mobilestore.model.Order order = orderDAO.getOrderById(orderId);
        Assertions.assertNotNull(order, "Đơn hàng phải tồn tại");
        Assertions.assertEquals(customerId, order.getCustomerId(), "Đơn hàng thuộc về đúng user");
        Assertions.assertEquals(shippingAddress, order.getShippingAddress(), "Địa chỉ giao hàng đúng");
        Assertions.assertEquals(paymentMethod, order.getPaymentMethod(), "Phương thức thanh toán đúng");
        Assertions.assertEquals(notes, order.getNotes(), "Ghi chú đúng");
        Assertions.assertEquals(1, order.getOrderItems().size(), "Đơn hàng có đúng 1 sản phẩm");
        Assertions.assertEquals(product.getProductId(), order.getOrderItems().get(0).getProductId(), "Sản phẩm đúng trong đơn hàng");
        Assertions.assertEquals(2, order.getOrderItems().get(0).getQuantity(), "Số lượng đúng trong đơn hàng");
    }
}
