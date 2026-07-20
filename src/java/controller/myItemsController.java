package controller;

import dal.CategoryDAO;
import dal.ItemDAO;
import dal.LocationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Categories;
import model.Items;
import model.Locations;
import model.Users;

public class myItemsController extends HttpServlet {

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
        if (relativePaths == null) {
            return;
        }
        for (String relPath : relativePaths) {
            util.FileUtil.deleteFile(relPath, getServletContext());
        }
    }

    private void loadMyItems(HttpServletRequest request, int userId) {
        ItemDAO itemDAO = new ItemDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        LocationDAO locationDAO = new LocationDAO();
        List<Items> allItems = itemDAO.getItemsByUserId(userId);
        Map<Integer, String> categoriesById = new HashMap<>();
        Map<Integer, String> locationsById = new HashMap<>();
        Map<Integer, String> categoryNames = new HashMap<>();
        Map<Integer, String> locationNames = new HashMap<>();
        List<Items> lostItems = new ArrayList<>();
        List<Items> foundItems = new ArrayList<>();

        for (Categories category : categoryDAO.getAllCategories()) {
            categoriesById.put(category.getCategoryId(), category.getName());
        }
        for (Locations location : locationDAO.getAllLocations()) {
            locationsById.put(location.getLocationId(), location.getName());
        }

        for (Items item : allItems) {
            categoryNames.put(item.getItemId(), categoriesById.get(item.getCategoryId()));
            locationNames.put(item.getItemId(), locationsById.get(item.getLocationId()));

            if ("found".equalsIgnoreCase(item.getType())) {
                foundItems.add(item);
            } else {
                lostItems.add(item);
            }
        }

        request.setAttribute("lostMyItems", lostItems);
        request.setAttribute("foundMyItems", foundItems);
        request.setAttribute("categoryNames", categoryNames);
        request.setAttribute("locationNames", locationNames);
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

        loadMyItems(request, currentUser.getUserId());
        request.getRequestDispatcher("/WEB-INF/views/my_items.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        String action = request.getParameter("action");
        if ("complete".equalsIgnoreCase(action)) {
            Integer itemId = parseInt(request.getParameter("item_id"));
            if (itemId == null || itemId <= 0) {
                session.setAttribute("message", "Ma tin khong hop le.");
                response.sendRedirect("my_items");
                return;
            }
            ItemDAO dao = new ItemDAO();
            Items item = dao.getItemByIdAndUser(itemId, currentUser.getUserId());
            if (item == null) {
                session.setAttribute("message", "Khong tim thay bai dang hoặc ban khong co quyen.");
                response.sendRedirect("my_items");
                return;
            }
            boolean ok = dao.updateItemStatus(itemId, "completed");
            if (ok) {
                session.setAttribute("message", "Cap nhat trang thai thanh cong.");
            } else {
                session.setAttribute("message", "Cap nhat trang thai that bai.");
            }
            response.sendRedirect("my_items");
            return;
        }

        if (!"delete".equalsIgnoreCase(action)) {
            doGet(request, response);
            return;
        }

        Integer itemId = parseInt(request.getParameter("item_id"));
        if (itemId == null || itemId <= 0) {
            session.setAttribute("message", "Item id khong hop le.");
            response.sendRedirect("my_items");
            return;
        }

        ItemDAO dao = new ItemDAO();
        Items item = dao.getItemByIdAndUser(itemId, currentUser.getUserId());

        if (item == null) {
            session.setAttribute("message", "Khong tim thay bai dang hoac ban khong co quyen xoa.");
            response.sendRedirect("my_items");
            return;
        }

        List<String> imagePaths = parseImagePaths(item.getImagesJSON());
        boolean deleted = dao.deleteItemByIdAndUser(itemId, currentUser.getUserId());

        if (deleted) {
            deleteImageFiles(imagePaths);
            session.setAttribute("message", "Da xoa bai dang thanh cong.");
        } else {
            session.setAttribute("message", "Khong the xoa bai dang.");
        }

        response.sendRedirect("my_items");
    }
}
