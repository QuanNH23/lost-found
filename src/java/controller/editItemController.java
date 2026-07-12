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
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.Items;
import model.Users;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024
)
public class editItemController extends HttpServlet {

    private static final String UPLOAD_FOLDER = "uploads";

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private Integer parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }

    private void loadReferenceData(HttpServletRequest request) {
        ItemDAO dao = new ItemDAO();
        request.setAttribute("categories", dao.getAllCategories());
        request.setAttribute("locations", dao.getAllLocations());
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

    private List<String> parseImagePaths(String imagesJson) {
        List<String> paths = new ArrayList<>();

        if (isBlank(imagesJson)) {
            return paths;
        }

        String raw = imagesJson.trim();
        if (raw.startsWith("[")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("]")) {
            raw = raw.substring(0, raw.length() - 1);
        }

        if (isBlank(raw)) {
            return paths;
        }

        String[] tokens = raw.split(",");
        for (String token : tokens) {
            String value = token == null ? "" : token.trim();
            if (value.startsWith("\"")) {
                value = value.substring(1);
            }
            if (value.endsWith("\"")) {
                value = value.substring(0, value.length() - 1);
            }
            value = value.replace("\\\"", "\"").replace("\\\\", "\\");

            if (!isBlank(value)) {
                paths.add(value);
            }
        }

        return paths;
    }

    private void deleteImageFiles(List<String> relativePaths) {
        String appRoot = getServletContext().getRealPath("/");
        if (appRoot == null || relativePaths == null) {
            return;
        }

        Path root = Paths.get(appRoot);
        for (String relPath : relativePaths) {
            try {
                Path filePath = root.resolve(relPath.replace("/", "\\")).normalize();
                Files.deleteIfExists(filePath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void bindOldValues(HttpServletRequest request, Items item) {
        request.setAttribute("oldTitle", item.getTitle());
        String customPhone = null;
        String desc = item.getDescription();
        String cleanDesc = desc;
        if (desc != null) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("\\s*\\[SĐT:\\s*(\\d+)\\]").matcher(desc);
            if (m.find()) {
                customPhone = m.group(1);
                cleanDesc = desc.replace(m.group(0), "");
            }
        }
        request.setAttribute("oldDescription", cleanDesc);
        request.setAttribute("oldPhone", customPhone);
        request.setAttribute("oldCategoryId", item.getCategoryId());
        request.setAttribute("oldLocationId", item.getLocationId());
        if (item.getDateIncident() != null) {
            String dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(item.getDateIncident());
            request.setAttribute("oldDateIncident", dateTime);
        }
        request.setAttribute("existingImagePaths", parseImagePaths(item.getImagesJSON()));
        request.setAttribute("itemId", item.getItemId());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        Integer itemId = parseInt(request.getParameter("id"));

        if (itemId == null || itemId <= 0) {
            session.setAttribute("message", "Item id khong hop le.");
            response.sendRedirect("my_items");
            return;
        }

        ItemDAO dao = new ItemDAO();
        Items item = dao.getItemByIdAndUser(itemId, currentUser.getUserId());

        if (item == null) {
            session.setAttribute("message", "Khong tim thay bai dang hoac ban khong co quyen sua.");
            response.sendRedirect("my_items");
            return;
        }

        bindOldValues(request, item);
        loadReferenceData(request);
        request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
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

        // Check if user is blacklisted or deactivated
        if (!currentUser.isIsActive() || util.ContentFilter.getAllBlacklistPhones().contains(currentUser.getPhoneNumber())) {
            session.setAttribute("message", "Tài khoản của bạn đã bị khóa hoặc nằm trong danh sách đen, không thể thực hiện sửa bài!");
            response.sendRedirect("my_items");
            return;
        }

        Integer itemId = parseInt(request.getParameter("item_id"));

        if (itemId == null || itemId <= 0) {
            session.setAttribute("message", "Item id khong hop le.");
            response.sendRedirect("my_items");
            return;
        }

        ItemDAO dao = new ItemDAO();
        Items existingItem = dao.getItemByIdAndUser(itemId, currentUser.getUserId());
        if (existingItem == null) {
            session.setAttribute("message", "Khong tim thay bai dang hoac ban khong co quyen sua.");
            response.sendRedirect("my_items");
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
        request.setAttribute("existingImagePaths", parseImagePaths(existingItem.getImagesJSON()));
        request.setAttribute("itemId", existingItem.getItemId());

        if (isBlank(title) || isBlank(description) || isBlank(categoryIdRaw)
                || isBlank(locationIdRaw) || isBlank(dateIncidentRaw) || isBlank(phone)) {
            request.setAttribute("ERROR", "Vui long nhap day du thong tin bat buoc.");
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdRaw);
            int locationId = Integer.parseInt(locationIdRaw);
            LocalDateTime dateIncident = parseDateIncident(dateIncidentRaw);
            String newImagesJson = buildImagesJson(request);

            if (categoryId <= 0 || locationId <= 0) {
                request.setAttribute("ERROR", "Danh muc hoac vi tri khong hop le.");
                loadReferenceData(request);
                request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
                return;
            }

            String finalImagesJson = newImagesJson != null ? newImagesJson : existingItem.getImagesJSON();

            String fullDescription = description.trim();
            if (!isBlank(phone)) {
                fullDescription += "\n\n[SĐT: " + phone.trim() + "]";
            }

            Items updatedItem = new Items();
            updatedItem.setItemId(existingItem.getItemId());
            updatedItem.setUserId(currentUser.getUserId());
            updatedItem.setCategoryId(categoryId);
            updatedItem.setLocationId(locationId);
            updatedItem.setTitle(title.trim());
            updatedItem.setDescription(fullDescription);
            updatedItem.setDateIncident(java.sql.Timestamp.valueOf(dateIncident));
            updatedItem.setImagesJSON(finalImagesJson);

            // Recheck content filter on update
            String violation = util.ContentFilter.scan(updatedItem.getTitle(), updatedItem.getDescription());
            if (violation != null) {
                updatedItem.setStatus("processing");
            } else {
                updatedItem.setStatus(existingItem.getStatus()); // keep existing status (active / completed)
            }

            boolean updated = dao.updateItemByOwner(updatedItem);

            if (updated) {
                if (newImagesJson != null) {
                    deleteImageFiles(parseImagePaths(existingItem.getImagesJSON()));
                }
                session.setAttribute("message", "Da cap nhat bai dang thanh cong.");
                response.sendRedirect("my_items");
            } else {
                if (newImagesJson != null) {
                    deleteImageFiles(parseImagePaths(newImagesJson));
                }
                request.setAttribute("ERROR", "Khong the cap nhat bai dang.");
                loadReferenceData(request);
                request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
            }

        } catch (NumberFormatException | DateTimeParseException e) {
            request.setAttribute("ERROR", "Du lieu nhap vao khong hop le.");
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
        } catch (IllegalStateException e) {
            request.setAttribute("ERROR", "Kich thuoc file qua lon (toi da 5MB moi anh)." );
            loadReferenceData(request);
            request.getRequestDispatcher("/WEB-INF/views/edit_item.jsp").forward(request, response);
        }
    }
}
