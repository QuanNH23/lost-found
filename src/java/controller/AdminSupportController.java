package controller;

import dal.SupportRequestDAO;
import dal.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.SupportRequest;
import model.Users;

@WebServlet(name = "AdminSupportController", urlPatterns = {"/admin/support"})
public class AdminSupportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        SupportRequestDAO dao = new SupportRequestDAO();
        List<SupportRequest> list = dao.getAllSupportRequests();
        request.setAttribute("requests", list);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/support_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String supportIdRaw = request.getParameter("supportId");
        String adminFeedback = request.getParameter("adminFeedback");

        if (supportIdRaw == null || action == null || adminFeedback == null || adminFeedback.trim().isEmpty()) {
            session.setAttribute("error", "Bắt buộc phải ghi rõ lý do/phản hồi!");
            response.sendRedirect(request.getContextPath() + "/admin/support");
            return;
        }

        try {
            int supportId = Integer.parseInt(supportIdRaw);
            SupportRequestDAO dao = new SupportRequestDAO();
            SupportRequest req = dao.getSupportRequestById(supportId);

            if (req != null) {
                String newStatus = "resolve".equalsIgnoreCase(action) ? "resolved" : "rejected";
                if (dao.updateSupportRequestStatus(supportId, newStatus, adminFeedback.trim())) {
                    
                    // Insert account notification for user
                    MessageDAO msgDao = new MessageDAO();
                    String title = "resolved".equals(newStatus) ? "Support_Resolved" : "Support_Rejected";
                    String messageText = "resolved".equals(newStatus) 
                        ? "Yêu cầu hỗ trợ [" + req.getReason() + "] của bạn đã ĐƯỢC XỬ LÝ. Phản hồi: " + adminFeedback.trim()
                        : "Yêu cầu hỗ trợ [" + req.getReason() + "] của bạn đã BỊ TỪ CHỐI. Lý do: " + adminFeedback.trim();
                    
                    msgDao.insertAccountNotification(req.getUserId(), title, messageText);
                    
                    session.setAttribute("message", "Đã xử lý yêu cầu #" + supportId + " thành công!");
                } else {
                    session.setAttribute("error", "Không thể cập nhật trạng thái yêu cầu hỗ trợ.");
                }
            } else {
                session.setAttribute("error", "Yêu cầu hỗ trợ không tồn tại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi xử lý yêu cầu hỗ trợ: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/support");
    }
}
