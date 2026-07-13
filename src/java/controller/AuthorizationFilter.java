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
        
        // 1. Let assets and uploads pass unconditionally
        if (path.startsWith("/assets/") || path.startsWith("/uploads/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Set unread count for ALL pages if user is logged in
        if (session != null && session.getAttribute("currentUser") != null) {
            Users currUser = (Users) session.getAttribute("currentUser");
            MessageDAO msgDao = new MessageDAO();
            
            String role = (String) session.getAttribute("userRole");
            if ("admin".equalsIgnoreCase(role)) {
                if (path.equals("/admin/support")) {
                    session.setAttribute("adminRead_support", true);
                } else if (path.equals("/admin/moderation")) {
                    session.setAttribute("adminRead_hidden", true);
                    session.setAttribute("adminRead_reported", true);
                }

                java.util.List<java.util.Map<String, String>> dbNotifs = msgDao.getAdminNotifications();
                java.util.List<java.util.Map<String, String>> finalNotifs = new java.util.ArrayList<>();
                int unreadCount = 0;

                for (java.util.Map<String, String> notif : dbNotifs) {
                    String type = notif.get("type");
                    int currentCount = Integer.parseInt(notif.get("count"));
                    
                    Integer lastCount = (Integer) session.getAttribute("adminLastCount_" + type);
                    if (lastCount == null || lastCount != currentCount) {
                        session.setAttribute("adminLastCount_" + type, currentCount);
                        session.setAttribute("adminRead_" + type, false);
                    }

                    Boolean isRead = (Boolean) session.getAttribute("adminRead_" + type);
                    if (isRead == null) isRead = false;

                    if (!isRead) {
                        unreadCount++;
                    }
                    
                    notif.put("isRead", String.valueOf(isRead));
                    finalNotifs.add(notif);
                }
                
                req.setAttribute("adminNotifications", finalNotifs);
                req.setAttribute("adminUnreadCount", unreadCount);
            } else {
                int unreadCount = msgDao.countUnreadInbox(currUser.getUserId());
                req.setAttribute("unreadInboxCount", unreadCount);
                req.setAttribute("inboxNotificationsList", msgDao.getInbox(currUser.getUserId()));
            }
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
