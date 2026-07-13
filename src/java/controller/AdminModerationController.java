package controller;

import dal.ItemDAO;
import dal.MessageDAO;
import model.Items;
import model.Users;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminModerationController", urlPatterns = {"/admin/moderation"})
public class AdminModerationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        // Basic check for admin
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        ItemDAO itemDao = new ItemDAO();
        MessageDAO msgDao = new MessageDAO();

        // 1. Get items hidden by bot (status = 'processing') and filter out suspended/blacklisted users
        List<Items> rawProcessingItems = itemDao.getItemsByStatus("processing");
        List<Map<String, Object>> processingItems = new ArrayList<>();
        dal.UserDAO uDao = new dal.UserDAO();
        for (Items item : rawProcessingItems) {
            model.Users owner = uDao.getUserById(item.getUserId());
            if (owner != null && owner.isIsActive() && !util.ContentFilter.getAllBlacklistPhones().contains(owner.getPhoneNumber())) {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("itemId", item.getItemId());
                map.put("title", item.getTitle());
                map.put("ownerFullName", item.getOwnerFullName());
                map.put("ownerPhone", owner.getPhoneNumber());
                map.put("type", item.getType());
                map.put("createdAt", item.getCreatedAt());
                
                int repCount = msgDao.countReportsByItemId(item.getItemId());
                map.put("reportCount", repCount);
                if (repCount >= 3) {
                    map.put("reason", "Tự động ẩn do nhận đủ " + repCount + " báo cáo vi phạm");
                } else {
                    map.put("reason", "Hệ thống phát hiện từ cấm hoặc số điện thoại blacklist");
                }
                map.put("reportersList", msgDao.getReportersDetails(item.getItemId()));
                
                processingItems.add(map);
            }
        }

        // 2. Get reported items (items with >= 1 report)
        List<Map<String, Object>> reportedItems = msgDao.getReportedItems();

        request.setAttribute("processingItems", processingItems);
        request.setAttribute("reportedItems", reportedItems);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/moderation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String itemIdRaw = request.getParameter("itemId");
        int itemId = (itemIdRaw != null && !itemIdRaw.trim().isEmpty()) ? Integer.parseInt(itemIdRaw.trim()) : 0;
        ItemDAO itemDao = new ItemDAO();
        MessageDAO msgDao = new MessageDAO();
        
        if ("approve".equals(action)) {
            // Restore post to active
            itemDao.updateItemStatus(itemId, "active");
            // Clear all report messages for this item so it clears from queue
            msgDao.deleteReportsByItemId(itemId);
            session.setAttribute("message", "Đã giữ lại bài viết và xóa các báo cáo vi phạm.");
        } else if ("delete".equals(action)) {
            // Hard delete
            itemDao.deleteItem(itemId);
            msgDao.deleteReportsByItemId(itemId);
            session.setAttribute("message", "Đã xóa bài viết vĩnh viễn.");
        } else if ("blacklist".equals(action)) {
            String phone = request.getParameter("phone");
            if (phone != null && !phone.trim().isEmpty()) {
                String appRealPath = getServletContext().getRealPath("/");
                util.ContentFilter.addBlacklistPhone(phone.trim(), appRealPath);
                itemDao.suspendItemsByUserPhone(phone.trim());
                model.Users u = new dal.UserDAO().getUserByPhone(phone.trim());
                if (u != null) {
                    msgDao.insertAccountNotification(u.getUserId(), "Account", "Số điện thoại " + phone.trim() + " của bạn đã bị đưa vào danh sách đen (Blacklist) của hệ thống.");
                }
                session.setAttribute("message", "Đã đưa SĐT " + phone.trim() + " vào Blacklist và tạm ẩn tất cả bài đăng liên quan.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/moderation");
    }
}
