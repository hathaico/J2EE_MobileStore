package com.mobilestore.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mobilestore.model.Cart;
import com.mobilestore.service.CartService;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/api/cart")
public class CartApiServlet extends HttpServlet {
    private final CartService cartService = new CartService();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, (com.google.gson.JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
            new com.google.gson.JsonPrimitive(src.toString())
        )
        .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        Cart cart = cartService.getCart(session);
        resp.getWriter().write(gson.toJson(cart));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        // Nhận dữ liệu JSON: {"productId":..., "quantity":...}
        try {
            com.google.gson.JsonObject json = gson.fromJson(req.getReader(), com.google.gson.JsonObject.class);
            int productId = json.get("productId").getAsInt();
            int quantity = json.get("quantity").getAsInt();
            boolean updated = cartService.updateCartItem(session, productId, quantity);
            if (updated) {
                // Trả về danh sách sản phẩm trong giỏ hàng (dạng mảng)
                resp.getWriter().write(gson.toJson(cartService.getCart(session).getItems()));
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Failed to update cart\"}");
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid request\"}");
        }
    }
}
