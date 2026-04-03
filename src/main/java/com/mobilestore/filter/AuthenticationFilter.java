package com.mobilestore.filter;

import com.mobilestore.model.User;
import com.mobilestore.service.NotificationService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Protects admin pages from unauthorized access
 * Also injects notification data for all admin pages
 */
@WebFilter("/admin/*")
public class AuthenticationFilter implements Filter {
    private NotificationService notificationService;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.notificationService = new NotificationService();
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
        
        // Add notification data to all admin pages
        try {
            httpRequest.setAttribute("notifications", notificationService.getNotifications());
            httpRequest.setAttribute("totalNotificationCount", notificationService.getTotalNotificationCount());
            httpRequest.setAttribute("hasNotifications", notificationService.hasNotifications());
        } catch (Exception e) {
            e.printStackTrace();
            // Continue even if notification service fails
        }
        
        // User is authenticated and authorized, continue
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
