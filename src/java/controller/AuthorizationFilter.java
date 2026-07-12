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
        
        // 1. Let assets pass unconditionally
        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Set unread count for ALL pages if user is logged in
        if (session != null && session.getAttribute("currentUser") != null) {
            Users currUser = (Users) session.getAttribute("currentUser");
            MessageDAO msgDao = new MessageDAO();
            int unreadCount = msgDao.countUnreadInbox(currUser.getUserId());
            req.setAttribute("unreadInboxCount", unreadCount);
            req.setAttribute("inboxNotificationsList", msgDao.getInbox(currUser.getUserId()));
        }

        // 3. Public paths - skip auth checks
        if (path.equals("/login") || path.equals("/register") || path.equals("/home") 
            || path.equals("/items") || path.equals("/item_detail") || path.equals("/")) {
            chain.doFilter(request, response);
            return;
        }

        // 4. Check login for other paths
        if (session == null || session.getAttribute("currentUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String role = (String) session.getAttribute("userRole");
        
        // 5. Admin-only paths
        if (path.startsWith("/manage_") || path.startsWith("/update") || 
            path.startsWith("/delete") || path.startsWith("/add") ||
            path.startsWith("/admin/")) {
            if (!"admin".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/home");
                return;
            }
        }
        
        // 6. Pass to target for authenticated users
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
