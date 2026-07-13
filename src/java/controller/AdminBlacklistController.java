package controller;

import model.Users;
import util.ContentFilter;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminBlacklistController", urlPatterns = {"/admin/blacklist"})
public class AdminBlacklistController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<String> badWords = ContentFilter.getAllBadWords();
        List<String> blacklistPhones = ContentFilter.getAllBlacklistPhones();

        dal.UserDAO userDAO = new dal.UserDAO();
        java.util.Map<String, String> phoneOwnerMap = new java.util.HashMap<>();
        try {
            for (model.Users u : userDAO.getAllUsers()) {
                if (u.getPhoneNumber() != null && !u.getPhoneNumber().trim().isEmpty()) {
                    phoneOwnerMap.put(u.getPhoneNumber().trim(), u.getUsername());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("badWords", badWords);
        request.setAttribute("blacklistPhones", blacklistPhones);
        request.setAttribute("phoneOwnerMap", phoneOwnerMap);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/blacklist.jsp").forward(request, response);
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
        String phone = request.getParameter("phone");
        String word = request.getParameter("word");
        String appRealPath = getServletContext().getRealPath("/");

        if ("add".equals(action) && phone != null && !phone.trim().isEmpty()) {
            ContentFilter.addBlacklistPhone(phone.trim(), appRealPath);
            new dal.ItemDAO().suspendItemsByUserPhone(phone.trim());
            model.Users u = new dal.UserDAO().getUserByPhone(phone.trim());
            if (u != null) {
                new dal.MessageDAO().insertAccountNotification(u.getUserId(), "Account", "Số điện thoại " + phone.trim() + " của bạn đã bị đưa vào danh sách đen (Blacklist) của hệ thống.");
            }
            session.setAttribute("message", "Da them vao blacklist va an cac bai dang lien quan.");
        } else if ("remove".equals(action) && phone != null && !phone.trim().isEmpty()) {
            ContentFilter.removeBlacklistPhone(phone.trim(), appRealPath);
            new dal.ItemDAO().unsuspendItemsByUserPhone(phone.trim());
            model.Users u = new dal.UserDAO().getUserByPhone(phone.trim());
            if (u != null) {
                new dal.MessageDAO().insertAccountNotification(u.getUserId(), "Account", "Số điện thoại " + phone.trim() + " của bạn đã được xóa khỏi danh sách đen (Blacklist).");
            }
            session.setAttribute("message", "Da xoa khoi blacklist va khoi phuc cac bai dang.");
        } else if ("add_word".equals(action) && word != null && !word.trim().isEmpty()) {
            ContentFilter.addBadWord(word.trim(), appRealPath);
            session.setAttribute("message", "Đã thêm từ cấm mới thành công.");
        } else if ("remove_word".equals(action) && word != null && !word.trim().isEmpty()) {
            ContentFilter.removeBadWord(word.trim(), appRealPath);
            session.setAttribute("message", "Đã xóa từ cấm thành công.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/blacklist");
    }
}
