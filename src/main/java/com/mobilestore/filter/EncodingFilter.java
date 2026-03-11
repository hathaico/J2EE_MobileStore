package com.mobilestore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Encoding Filter
 * Sets character encoding to UTF-8 for all requests and responses
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            encoding = encodingParam;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // Set request encoding
        request.setCharacterEncoding(encoding);
        
        // Set response encoding
        response.setCharacterEncoding(encoding);
        
        // Only set content type for non-static resources
        String path = ((jakarta.servlet.http.HttpServletRequest) request).getRequestURI();
        if (!path.endsWith(".svg") && !path.endsWith(".css") && !path.endsWith(".js") 
                && !path.endsWith(".png") && !path.endsWith(".jpg") && !path.endsWith(".gif")
                && !path.endsWith(".ico") && !path.endsWith(".woff") && !path.endsWith(".woff2")) {
            response.setContentType("text/html; charset=" + encoding);
        }
        
        // Continue with the filter chain
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
