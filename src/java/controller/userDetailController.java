package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

public class userDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Users u = new UserDAO().getUserById(id);
            if (u == null) {
                response.sendRedirect("home");
                return;
            }
            request.setAttribute("userDetail", u);
            request.getRequestDispatcher("/WEB-INF/views/user_detail.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("home");
        }
    }
}

