package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Random;
import model.Users;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 2 * 1024 * 1024,      // 2MB
    maxRequestSize = 10 * 1024 * 1024   // 10MB
)
public class editProfileController extends HttpServlet {

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Reset verify states on fresh page loads
        session.removeAttribute("phone_verified");
        session.removeAttribute("edit_otp");
        request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        UserDAO dao = new UserDAO();
        String action = request.getParameter("action");

        if ("send_otp".equals(action)) {
            String currentPhone = currentUser.getPhoneNumber();
            if (isBlank(currentPhone)) {
                // No phone to verify, should not happen if button is shown
                request.setAttribute("ERROR", "Bạn chưa có số điện thoại đăng ký cũ để xác thực OTP.");
                request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                return;
            }

            // Generate OTP
            String otp = String.format("%06d", new Random().nextInt(1000000));
            session.setAttribute("edit_otp", otp);

            // Mock SMS sending
            System.out.println("\n=======================================================");
            System.out.println("[SMS GATEWAY MOCK] Gửi mã OTP [" + otp + "] xác thực đổi số điện thoại hiện tại: " + currentPhone);
            System.out.println("=======================================================\n");

            request.setAttribute("otp_sent", true);
            request.setAttribute("message", "Mã xác thực OTP đã được gửi đến số điện thoại " + currentPhone + ".");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;

        } else if ("verify_otp".equals(action)) {
            String userOtp = request.getParameter("otp");
            String correctOtp = (String) session.getAttribute("edit_otp");

            if (userOtp == null || correctOtp == null || !userOtp.trim().equals(correctOtp)) {
                request.setAttribute("ERROR", "Mã OTP xác thực đổi SĐT không chính xác!");
                request.setAttribute("otp_sent", true);
                request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                return;
            }

            session.setAttribute("phone_verified", true);
            session.removeAttribute("edit_otp");
            request.setAttribute("phone_unlocked", true);
            request.setAttribute("message", "Xác minh OTP thành công! Vui lòng nhập số điện thoại mới ở khung bên dưới.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        // Standard profile update (action is 'update' or default)
        String username = request.getParameter("username");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");

        if (isBlank(username) || isBlank(fullName) || isBlank(email)) {
            request.setAttribute("ERROR", "Vui lòng nhập đầy đủ Tên đăng nhập, Họ và tên, Email.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        // Handle phone number update
        String phone = currentUser.getPhoneNumber();
        String inputPhone = request.getParameter("phone_number");
        
        if (isBlank(currentUser.getPhoneNumber())) {
            // Can update phone number directly if old one was blank
            phone = isBlank(inputPhone) ? null : inputPhone.trim();
        } else {
            // Old phone is not blank, must be verified to change
            Boolean isVerified = (Boolean) session.getAttribute("phone_verified");
            if (isVerified != null && isVerified) {
                phone = isBlank(inputPhone) ? null : inputPhone.trim();
            } else {
                // If not verified, ignore new phone input and keep old phone number
                phone = currentUser.getPhoneNumber();
            }
        }

        if (phone != null && !phone.isEmpty()) {
            if (phone.length() != 10 || !phone.startsWith("0") || !phone.matches("\\d+")) {
                request.setAttribute("ERROR", "Số điện thoại phải chứa đúng 10 chữ số và bắt đầu bằng số 0!");
                request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                return;
            }
            if (!phone.equals(currentUser.getPhoneNumber())) {
                if (dao.getUserByPhone(phone) != null) {
                    request.setAttribute("ERROR", "Số điện thoại mới đã được đăng ký bởi tài khoản khác.");
                    request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                    return;
                }
            }
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

        // Handle Avatar File Upload
        String avatarUrl = currentUser.getAvatarUrl();
        try {
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String contentType = avatarPart.getContentType();
                if (contentType != null && contentType.startsWith("image/")) {
                    String uploadRealPath = getServletContext().getRealPath("/uploads");
                    Path uploadPath = Paths.get(uploadRealPath);
                    Files.createDirectories(uploadPath);

                    String submittedName = avatarPart.getSubmittedFileName();
                    String extension = ".jpg"; // fallback
                    if ("image/png".equalsIgnoreCase(contentType)) extension = ".png";
                    else if ("image/gif".equalsIgnoreCase(contentType)) extension = ".gif";
                    else if ("image/webp".equalsIgnoreCase(contentType)) extension = ".webp";
                    else if (submittedName != null && submittedName.lastIndexOf(".") > 0) {
                        extension = submittedName.substring(submittedName.lastIndexOf("."));
                    }

                    String savedName = "avatar_" + currentUser.getUserId() + "_" + System.currentTimeMillis() + extension;
                    Path targetPath = uploadPath.resolve(savedName);
                    try (InputStream in = avatarPart.getInputStream()) {
                        Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
                    }
                    avatarUrl = "uploads/" + savedName;
                } else {
                    request.setAttribute("ERROR", "Tệp tải lên làm avatar bắt buộc phải là ảnh.");
                    request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (dao.checkDuplicateExcept(currentUser.getUserId(), username.trim(), email.trim())) {
            request.setAttribute("ERROR", "Tên đăng nhập hoặc Email đã tồn tại ở tài khoản khác.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        boolean ok = dao.updateUserProfile(
                currentUser.getUserId(),
                username.trim(),
                fullName.trim(),
                email.trim(),
                phone,
                avatarUrl,
                newPasswordOrNull
        );

        if (!ok) {
            request.setAttribute("ERROR", "Cập nhật thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/edit_profile.jsp").forward(request, response);
            return;
        }

        // Clean up verify states
        session.removeAttribute("phone_verified");

        // Sync model session
        currentUser.setUsername(username.trim());
        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email.trim());
        currentUser.setPhoneNumber(phone);
        currentUser.setAvatarUrl(avatarUrl);
        if (newPasswordOrNull != null) {
            currentUser.setPassword(newPasswordOrNull);
        }

        session.setAttribute("currentUser", currentUser);
        session.setAttribute("message", "Cập nhật tài khoản thành công!");
        response.sendRedirect("home");
    }
}
