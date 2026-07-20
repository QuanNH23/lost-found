/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author HungKNHE194779
 */
public class loginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet loginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect("home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("[LOGIN ATTEMPT] RAW Username: '" + username + "', RAW Password: '" + password + "'");

        if (username != null) {
            username = username.trim();
        }

        System.out.println("[LOGIN ATTEMPT] TRIMMED Username: '" + username + "'");

        UserDAO dao = new UserDAO();
        Users loggedInUser = dao.checkLogin(username, password);
        
        System.out.println("[LOGIN ATTEMPT] Result loggedInUser: " + (loggedInUser != null ? loggedInUser.getUsername() : "null"));

        if (loggedInUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", loggedInUser);
            session.setAttribute("userRole", loggedInUser.getRole());
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Sai tai khoan hoac mat khau!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
