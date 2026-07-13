package controller;

import dal.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.SupportRequest;
import model.Users;

@WebServlet(name = "SupportController", urlPatterns = {"/support"})
public class SupportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/views/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if ("admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String reason = request.getParameter("reason");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");

        // Validate that at least one of email or phone is filled
        boolean hasEmail = email != null && !email.trim().isEmpty();
        boolean hasPhone = phone != null && !phone.trim().isEmpty();

        if (!hasEmail && !hasPhone) {
            request.setAttribute("error", "Bạn phải điền ít nhất Email hoặc Số điện thoại để liên hệ!");
            request.getRequestDispatcher("/WEB-INF/views/support.jsp").forward(request, response);
            return;
        }

        SupportRequest req = new SupportRequest();
        req.setUserId(currentUser.getUserId());
        req.setReason(reason);
        req.setEmail(email.trim());
        req.setPhone(phone.trim());
        String imgUrlTrim = (imageUrl != null) ? imageUrl.trim() : "";
        if (!imgUrlTrim.isEmpty() && !imgUrlTrim.startsWith("http://") && !imgUrlTrim.startsWith("https://") && !imgUrlTrim.startsWith("/")) {
            imgUrlTrim = "";
        }
        req.setImageUrl(imgUrlTrim);
        req.setDescription(description.trim());

        SupportRequestDAO dao = new SupportRequestDAO();
        if (dao.insertSupportRequest(req)) {
            session.setAttribute("message", "Yêu cầu hỗ trợ của bạn đã được gửi thành công đến Admin!");
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi gửi yêu cầu hỗ trợ. Vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/support.jsp").forward(request, response);
        }
    }
}
