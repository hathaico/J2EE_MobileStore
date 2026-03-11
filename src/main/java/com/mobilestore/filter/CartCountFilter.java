package com.mobilestore.filter;

import com.mobilestore.service.CartService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Cart Count Filter
 * Updates cart count in session for header display
 */
@WebFilter("/*")
public class CartCountFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null) {
            // Update cart count in session
            CartService cartService = new CartService();
            int cartCount = cartService.getCartItemCount(session);
            session.setAttribute("cartCount", cartCount);
        }
        
        // Continue filter chain
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
