package controller;

import dal.MessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Users;

public class inboxController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }
        Users currentUser = (Users) session.getAttribute("currentUser");
        MessageDAO msgDAO = new MessageDAO();

        // Lấy danh sách tin nhắn từ DAO
        List<Map<String, Object>> inbox = msgDAO.getInbox(currentUser.getUserId());
        List<Map<String, Object>> outbox = msgDAO.getOutbox(currentUser.getUserId());

        // Đánh dấu tất cả tin nhắn đến là đã đọc trong DB
        msgDAO.markAllInboxMessagesAsRead(currentUser.getUserId());

        request.setAttribute("inbox", inbox);
        request.setAttribute("outbox", outbox);
        request.setAttribute("unreadInboxCount", 0);
        request.getRequestDispatcher("/WEB-INF/views/inbox.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
