package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

@WebServlet(name = "UpdateUserController", urlPatterns = {"/updateuser"})
public class UpdateUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_raw = request.getParameter("id");
        int id;
        UserDAO usd = new UserDAO();
        try {
            id = Integer.parseInt(id_raw);
            Users uNew = usd.getUserById(id);
            request.setAttribute("user", uNew);
            request.getRequestDispatcher("/WEB-INF/views/updateUser.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_raw = request.getParameter("id");
        String active = request.getParameter("isactive");
        String role = request.getParameter("role");
        try {
            UserDAO usd = new UserDAO();
            int id = Integer.parseInt(id_raw);
            boolean isActive = Boolean.parseBoolean(active);
            
            usd.updateUserRoleAndStatus(id, role, isActive);
            
            dal.ItemDAO itemDAO = new dal.ItemDAO();
            if (isActive) {
                itemDAO.unsuspendItemsByUserId(id);
                new dal.MessageDAO().insertAccountNotification(id, "Account", "Tài khoản của bạn đã được mở khóa bởi Admin.");
            } else {
                itemDAO.suspendItemsByUserId(id);
                new dal.MessageDAO().insertAccountNotification(id, "Account", "Tài khoản của bạn đã bị khóa bởi Admin.");
            }
            
            response.sendRedirect("manage_users");
            
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
