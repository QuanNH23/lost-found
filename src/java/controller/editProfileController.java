package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

public class editProfileController extends HttpServlet {

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        String username = currentUser.getUsername();
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        if (isBlank(fullName) || isBlank(email)) {
            request.setAttribute("ERROR", "Vui lòng nhập đầy đủ Họ và tên, Email.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        String newPasswordOrNull = null;
        if (!isBlank(password) || !isBlank(confirm)) {
            if (isBlank(password) || isBlank(confirm) || !password.equals(confirm) || password.length() < 6) {
                request.setAttribute("ERROR", "Mật khẩu không hợp lệ (cần khớp nhau và ít nhất 6 ký tự).");
                request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                return;
            }
            newPasswordOrNull = password;
        }

        UserDAO dao = new UserDAO();
        if (dao.checkDuplicateExcept(currentUser.getUserId(), username.trim(), email.trim())) {
            request.setAttribute("ERROR", "Email đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        boolean ok = dao.updateUserProfile(
                currentUser.getUserId(),
                fullName.trim(),
                email.trim(),
                phone == null ? null : phone.trim(),
                newPasswordOrNull
        );

        if (!ok) {
            request.setAttribute("ERROR", "Cập nhật thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email.trim());
        currentUser.setPhoneNumber(phone == null ? null : phone.trim());
        if (newPasswordOrNull != null) {
            currentUser.setPassword(newPasswordOrNull);
        }

        session.setAttribute("currentUser", currentUser);
        session.setAttribute("message", "Cập nhật tài khoản thành công!");
        response.sendRedirect("home");
    }
}
