package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dal.MessageDAO;
import model.Users;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
            
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String path = req.getServletPath();
        
        // Let assets pass unconditionally
        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // Public paths
        if (path.equals("/login") || path.equals("/register") || path.equals("/home") 
            || path.equals("/items") || path.equals("/item_detail") || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        // Check login for other paths
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String role = (String) session.getAttribute("userRole");
        
        // Admin-only paths
        if (path.startsWith("/manage_") || path.startsWith("/update") || 
            path.startsWith("/delete") || path.startsWith("/add") ||
            path.startsWith("/admin/")) {
            if ("admin".equals(role)) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(req.getContextPath() + "/home");
            }
            return;
        }
        
        // Set unread count if user is logged in
        if (session != null && session.getAttribute("currentUser") != null) {
            Users currUser = (Users) session.getAttribute("currentUser");
            MessageDAO msgDao = new MessageDAO();
            int unreadCount = msgDao.countUnreadInbox(currUser.getUserId());
            req.setAttribute("unreadInboxCount", unreadCount);
        }

        // Pass to target
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
