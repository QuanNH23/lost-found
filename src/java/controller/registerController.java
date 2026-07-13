package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Users;

public class registerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        jakarta.servlet.http.HttpSession session = request.getSession();

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("send_otp".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phone_number");

            // Keep fields populated in form
            request.setAttribute("form_username", username);
            request.setAttribute("form_fullName", fullName);
            request.setAttribute("form_email", email);
            request.setAttribute("form_phone", phoneNumber);

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {
                request.setAttribute("ERROR", "Vui lòng nhập đầy đủ Tên đăng nhập, Mật khẩu, Họ tên và Số điện thoại!");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            if (password.length() < 6) {
                request.setAttribute("ERROR", "Mật khẩu phải chứa ít nhất 6 ký tự!");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("ERROR", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            String phoneClean = phoneNumber.trim();
            if (phoneClean.length() != 10 || !phoneClean.startsWith("0") || !phoneClean.matches("\\d+")) {
                request.setAttribute("ERROR", "Số điện thoại phải chứa đúng 10 chữ số và bắt đầu bằng số 0!");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            String cleanEmail = (email == null || email.trim().isEmpty()) ? null : email.trim();
            if (dao.checkDuplicate(username.trim(), cleanEmail)) {
                request.setAttribute("ERROR", "Username hoặc Email đã được sử dụng.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            if (dao.getUserByPhone(phoneNumber.trim()) != null) {
                request.setAttribute("ERROR", "Số điện thoại đã được đăng ký bởi tài khoản khác.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Generate OTP
            String otp = String.format("%06d", new java.util.Random().nextInt(1000000));
            session.setAttribute("reg_otp", otp);
            session.setAttribute("reg_username", username.trim());
            session.setAttribute("reg_password", password);
            session.setAttribute("reg_fullName", fullName.trim());
            session.setAttribute("reg_email", cleanEmail);
            session.setAttribute("reg_phone", phoneNumber.trim());

            // Mock SMS Gateway
            System.out.println("\n=======================================================");
            System.out.println("[SMS GATEWAY MOCK] Gửi mã OTP [" + otp + "] đến số điện thoại: " + phoneNumber.trim());
            System.out.println("=======================================================\n");

            request.setAttribute("step", "2");
            request.setAttribute("message", "Đã gửi mã OTP đến số điện thoại " + phoneNumber.trim() + ".");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);

        } else if ("verify_otp".equals(action)) {
            String userOtp = request.getParameter("otp");
            String correctOtp = (String) session.getAttribute("reg_otp");

            if (userOtp == null || correctOtp == null || !userOtp.trim().equals(correctOtp)) {
                request.setAttribute("ERROR", "Mã OTP xác thực không chính xác!");
                request.setAttribute("step", "2");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            String regPhone = (String) session.getAttribute("reg_phone");
            if (dao.getUserByPhone(regPhone) != null) {
                request.setAttribute("ERROR", "Số điện thoại này đã được đăng ký bởi tài khoản khác trong lúc bạn xác thực.");
                request.setAttribute("step", "2");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // OTP is correct, insert user
            Users user = new Users();
            user.setUsername((String) session.getAttribute("reg_username"));
            user.setPassword((String) session.getAttribute("reg_password"));
            user.setFullName((String) session.getAttribute("reg_fullName"));
            user.setEmail((String) session.getAttribute("reg_email"));
            user.setPhoneNumber(regPhone);
            user.setRole("student");
            user.setIsActive(true);

            if (dao.insertUser(user)) {
                // Clear session keys
                session.removeAttribute("reg_otp");
                session.removeAttribute("reg_username");
                session.removeAttribute("reg_password");
                session.removeAttribute("reg_fullName");
                session.removeAttribute("reg_email");
                session.removeAttribute("reg_phone");

                response.sendRedirect("login?msg=success");
            } else {
                request.setAttribute("ERROR", "Đăng ký thất bại, đã xảy ra lỗi hệ thống!");
                request.setAttribute("step", "2");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } else {
            // Default fallback
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
