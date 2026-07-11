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

        request.setAttribute("badWords", badWords);
        request.setAttribute("blacklistPhones", blacklistPhones);
        
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
        String appRealPath = getServletContext().getRealPath("/");

        if ("add".equals(action) && phone != null && !phone.trim().isEmpty()) {
            ContentFilter.addBlacklistPhone(phone.trim(), appRealPath);
            session.setAttribute("message", "Da them vao blacklist.");
        } else if ("remove".equals(action) && phone != null && !phone.trim().isEmpty()) {
            ContentFilter.removeBlacklistPhone(phone.trim(), appRealPath);
            session.setAttribute("message", "Da xoa khoi blacklist.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/blacklist");
    }
}
