package com.mobilestore.filter;

import com.mobilestore.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Protects admin pages from unauthorized access
 */
@WebFilter("/admin/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get session
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        // If user is not logged in, redirect to login with return URL
        if (user == null) {
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String redirectUrl = requestURI;
            if (queryString != null) {
                redirectUrl += "?" + queryString;
            }
            // Remove context path from redirect URL
            redirectUrl = redirectUrl.substring(httpRequest.getContextPath().length());
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" + 
                                    java.net.URLEncoder.encode(redirectUrl, "UTF-8"));
            return;
        }
        
        // If user is not admin or staff, deny access
        if (!"ADMIN".equals(user.getRole()) && !"STAFF".equals(user.getRole())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/403.jsp");
            return;
        }
        
        // User is authenticated and authorized, continue
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
