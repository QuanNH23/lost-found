package controller;

import dal.ItemDAO;
import dal.MessageDAO;
import model.Items;
import model.Users;
import java.io.IOException;
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
        List<Items> processingItems = new ArrayList<>();
        dal.UserDAO uDao = new dal.UserDAO();
        for (Items item : rawProcessingItems) {
            model.Users owner = uDao.getUserById(item.getUserId());
            if (owner != null && owner.isIsActive() && !util.ContentFilter.getAllBlacklistPhones().contains(owner.getPhoneNumber())) {
                processingItems.add(item);
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
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        ItemDAO itemDao = new ItemDAO();
        
        if ("approve".equals(action)) {
            // Restore post to active
            itemDao.updateItemStatus(itemId, "active");
            session.setAttribute("message", "Da duyet lai bai viet.");
        } else if ("delete".equals(action)) {
            // Hard delete
            itemDao.deleteItem(itemId);
            session.setAttribute("message", "Da xoa bai viet vinh vien.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/moderation");
    }
}
