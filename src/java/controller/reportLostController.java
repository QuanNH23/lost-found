package controller;

import dal.ItemDAO;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.UUID;
import model.Items;
import model.Users;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024
)
public class reportLostController extends HttpServlet {

    private static final String UPLOAD_FOLDER = "uploads";

    private void loadReferenceData(HttpServletRequest request) {
        ItemDAO dao = new ItemDAO();
        request.setAttribute("categories", dao.getAllCategories());
        request.setAttribute("locations", dao.getAllLocations());
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String normalizeReportType(String rawType) {
        return "found".equalsIgnoreCase(rawType) ? "found" : "lost";
    }

    private String resolveReportType(HttpServletRequest request) {
        String fromForm = request.getParameter("report_type");
        if (isBlank(fromForm)) {
            fromForm = request.getParameter("type");
        }
        if (!isBlank(fromForm)) {
            return normalizeReportType(fromForm);
        }

        String servletPath = request.getServletPath();
        if ("/report_found".equalsIgnoreCase(servletPath)) {
            return "found";
        }

        return "lost";
    }

    private void bindFormMeta(HttpServletRequest request, String reportType) {
        boolean isFound = "found".equalsIgnoreCase(reportType);

        request.setAttribute("reportType", reportType);
        request.setAttribute("formTitle", isFound ? "Đăng tin báo Nhặt được đồ" : "Đăng tin báo Mất đồ");
        request.setAttribute("locationLabel", isFound ? "Vị trí nhặt (*)" : "Vị trí mất (*)");
        request.setAttribute("dateLabel", isFound ? "Thời điểm nhặt (*)" : "Thời điểm mất (*)");
        request.setAttribute("submitLabel", isFound ? "Gửi báo nhặt" : "Gửi báo mất");
    }

    private LocalDateTime parseDateIncident(String raw) {
        String value = raw == null ? "" : raw.trim();
        DateTimeFormatter[] formats = new DateTimeFormatter[]{
            DateTimeFormatter.ISO_LOCAL_DATE_TIME,
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
        };

        for (DateTimeFormatter format : formats) {
            try {
                return LocalDateTime.parse(value, format);
            } catch (DateTimeParseException ignored) {
            }
        }

        throw new DateTimeParseException("Invalid date_incident", value, 0);
    }

    private String jsonEscape(String text) {
        if (text == null) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        for (char ch : text.toCharArray()) {
            switch (ch) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '\b' -> sb.append("\\b");
                case '\f' -> sb.append("\\f");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                default -> {
                    if (ch < 0x20) {
                        sb.append(String.format("\\u%04x", (int) ch));
                    } else {
                        sb.append(ch);
                    }
                }
            }
        }

        return sb.toString();
    }

    private String resolveExtension(String fileName, String contentType) {
        if (!isBlank(fileName)) {
            int dotIndex = fileName.lastIndexOf('.');
            if (dotIndex >= 0 && dotIndex < fileName.length() - 1) {
                String ext = fileName.substring(dotIndex).toLowerCase();
                if (ext.matches("\\.[a-z0-9]{1,10}")) {
                    return ext;
                }
            }
        }

        if ("image/jpeg".equalsIgnoreCase(contentType)) {
            return ".jpg";
        }
        if ("image/png".equalsIgnoreCase(contentType)) {
            return ".png";
        }
        if ("image/gif".equalsIgnoreCase(contentType)) {
            return ".gif";
        }
        if ("image/webp".equalsIgnoreCase(contentType)) {
            return ".webp";
        }

        return ".img";
    }

    private String buildImagesJson(HttpServletRequest request) throws IOException, ServletException {
        String uploadRealPath = getServletContext().getRealPath("/" + UPLOAD_FOLDER);
        if (uploadRealPath == null) {
            throw new ServletException("Khong xac dinh duoc thu muc uploads tren server.");
        }

        Path uploadDir = Paths.get(uploadRealPath);
        Files.createDirectories(uploadDir);

        StringBuilder json = new StringBuilder("[");
        boolean hasImage = false;

        for (Part part : request.getParts()) {
            if (!"images".equals(part.getName()) || part.getSize() <= 0) {
                continue;
            }

            String contentType = part.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                throw new ServletException("Chi duoc upload file anh.");
            }

            String extension = resolveExtension(part.getSubmittedFileName(), contentType);
            String savedName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().replace("-", "") + extension;
            Path targetPath = uploadDir.resolve(savedName);

            try (InputStream in = part.getInputStream()) {
                Files.copy(in, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }

            String relativePath = UPLOAD_FOLDER + "/" + savedName;

            if (hasImage) {
                json.append(",");
            }
            json.append("\"").append(jsonEscape(relativePath)).append("\"");
            hasImage = true;
        }

        json.append("]");
        return hasImage ? json.toString() : null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        String reportType = resolveReportType(request);
        bindFormMeta(request, reportType);
        loadReferenceData(request);
        request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        String reportType = resolveReportType(request);

        // Check if user is blacklisted or deactivated
        if (!currentUser.isIsActive() || util.ContentFilter.getAllBlacklistPhones().contains(currentUser.getPhoneNumber())) {
            request.setAttribute("ERROR", "Tài khoản của bạn đã bị khóa hoặc nằm trong danh sách đen, không thể thực hiện đăng bài!");
            loadReferenceData(request);
            bindFormMeta(request, reportType);
            request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String categoryIdRaw = request.getParameter("category_id");
        String locationIdRaw = request.getParameter("location_id");
        String dateIncidentRaw = request.getParameter("date_incident");

        request.setAttribute("oldTitle", title);
        request.setAttribute("oldDescription", description);
        request.setAttribute("oldPhone", phone);
        request.setAttribute("oldCategoryId", categoryIdRaw);
        request.setAttribute("oldLocationId", locationIdRaw);
        request.setAttribute("oldDateIncident", dateIncidentRaw);
        request.setAttribute("reportType", reportType);

        if (isBlank(title) || isBlank(description) || isBlank(categoryIdRaw)
                || isBlank(locationIdRaw) || isBlank(dateIncidentRaw) || isBlank(phone)) {
            request.setAttribute("ERROR", "Vui long nhap day du thong tin bat buoc bao gom ca so dien thoai.");
            bindFormMeta(request, reportType);
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdRaw);
            int locationId = Integer.parseInt(locationIdRaw);
            LocalDateTime dateIncident = parseDateIncident(dateIncidentRaw);
            String imagesJson = buildImagesJson(request);

            if (categoryId <= 0 || locationId <= 0) {
                request.setAttribute("ERROR", "Danh muc hoac vi tri khong hop le.");
                bindFormMeta(request, reportType);
                loadReferenceData(request);
                request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
                return;
            }

            // Append phone number to description
            String fullDescription = description.trim();
            if (!isBlank(phone)) {
                fullDescription += "\n\n[SĐT: " + phone.trim() + "]";
            }

            Items item = new Items();
            item.setUserId(currentUser.getUserId());
            item.setCategoryId(categoryId);
            item.setLocationId(locationId);
            item.setTitle(title.trim());
            item.setDescription(fullDescription);
            item.setDateIncident(java.sql.Timestamp.valueOf(dateIncident));
            item.setImagesJSON(imagesJson);

            // Bot scan for bad words / blacklisted phone
            String violation = util.ContentFilter.scan(item.getTitle(), item.getDescription());
            if (violation != null) {
                item.setStatus("processing"); // hide, await admin review
            } else {
                item.setStatus("active"); // auto publish
            }

            ItemDAO dao = new ItemDAO();
            boolean inserted = dao.insertItemByType(item, reportType);

            if (inserted) {
                if ("found".equals(reportType)) {
                    session.setAttribute("message", "Bao nhat do thanh cong!");
                } else {
                    session.setAttribute("message", "Bao mat do thanh cong!");
                }
                response.sendRedirect("my_items");
            } else {
                request.setAttribute("ERROR", "Khong the luu tin vao database. Vui long thu lai.");
                bindFormMeta(request, reportType);
                loadReferenceData(request);
                request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
            }

        } catch (NumberFormatException | DateTimeParseException e) {
            request.setAttribute("ERROR", "Du lieu nhap vao khong hop le.");
            bindFormMeta(request, reportType);
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
        } catch (IllegalStateException e) {
            request.setAttribute("ERROR", "Kich thuoc file qua lon (toi da 5MB moi anh).");
            bindFormMeta(request, reportType);
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "He thong dang loi khi gui bao. Vui long thu lai.");
            bindFormMeta(request, reportType);
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/report_lost.jsp").forward(request, response);
        }
    }
}
