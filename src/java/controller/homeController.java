package controller;

import dal.CategoryDAO;
import dal.ClaimDAO;
import dal.ItemDAO;
import dal.LocationDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Categories;
import model.Claims;
import model.Items;
import model.Locations;
import model.Users;

public class homeController extends HttpServlet {

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String parseFirstImagePath(String imagesJson) {
        if (isBlank(imagesJson)) {
            return null;
        }

        String raw = imagesJson.trim();
        if (raw.startsWith("[")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("]")) {
            raw = raw.substring(0, raw.length() - 1);
        }

        if (isBlank(raw)) {
            return null;
        }

        String[] tokens = raw.split(",");
        if (tokens.length == 0) {
            return null;
        }

        String value = tokens[0] == null ? "" : tokens[0].trim();
        if (value.startsWith("\"")) {
            value = value.substring(1);
        }
        if (value.endsWith("\"")) {
            value = value.substring(0, value.length() - 1);
        }
        value = value.replace("\\\"", "\"").replace("\\\\", "\\");

        return isBlank(value) ? null : value;
    }

    private Map<Integer, String> buildImageMap(List<Items> items) {
        Map<Integer, String> imageMap = new HashMap<>();
        for (Items item : items) {
            imageMap.put(item.getItemId(), parseFirstImagePath(item.getImagesJSON()));
        }
        return imageMap;
    }

    private Map<Integer, String> buildOwnerNameMap(List<Items> items, List<Users> users) {
        Map<Integer, String> usersById = new HashMap<>();
        Map<Integer, String> ownerNames = new HashMap<>();

        for (Users user : users) {
            usersById.put(user.getUserId(), user.getFullName());
        }
        for (Items item : items) {
            ownerNames.put(item.getItemId(), usersById.get(item.getUserId()));
        }

        return ownerNames;
    }

    private Map<Integer, String> buildLocationNameMap(List<Items> items, List<Locations> locations) {
        Map<Integer, String> locationsById = new HashMap<>();
        Map<Integer, String> locationNames = new HashMap<>();

        for (Locations location : locations) {
            locationsById.put(location.getLocationId(), location.getName());
        }
        for (Items item : items) {
            locationNames.put(item.getItemId(), locationsById.get(item.getLocationId()));
        }

        return locationNames;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ItemDAO itemDAO = new ItemDAO();
        UserDAO userDAO = new UserDAO();
        LocationDAO locationDAO = new LocationDAO();
        ClaimDAO claimDAO = new ClaimDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Categories> categories = categoryDAO.getAllCategories();
        List<Locations> locations = locationDAO.getAllLocations();
        List<Items> lostItems = itemDAO.getActiveItemsByType("lost");
        List<Items> foundItems = itemDAO.getActiveItemsByType("found");
        List<Items> allItems = new ArrayList<>();
        int pendingItems = 0;
        int pendingClaims = 0;
        int totalProcessingItems = 0;
        int totalCompletedItems = 0;

        allItems.addAll(lostItems);
        allItems.addAll(foundItems);

        for (Items item : allItems) {
            if ("processing".equalsIgnoreCase(item.getStatus())) {
                pendingItems++;
                totalProcessingItems++;
            } else if ("completed".equalsIgnoreCase(item.getStatus())) {
                totalCompletedItems++;
            }
        }

        List<Items> latestLostItems = itemDAO.getLatestActiveItems("lost", 4);
        List<Items> latestFoundItems = itemDAO.getLatestActiveItems("found", 4);

        for (Claims claim : claimDAO.getAllClaims()) {
            if ("pending".equalsIgnoreCase(claim.getStatus())) {
                pendingClaims++;
            }
        }

        int pendingSupports = 0;
        dal.SupportRequestDAO supportDAO = new dal.SupportRequestDAO();
        for (model.SupportRequest sr : supportDAO.getAllSupportRequests()) {
            if ("processing".equalsIgnoreCase(sr.getStatus())) {
                pendingSupports++;
            }
        }

        dal.MessageDAO msgDao = new dal.MessageDAO();
        int pendingModerations = pendingItems + msgDao.getReportedItems().size();

        request.setAttribute("lostItems", lostItems);
        request.setAttribute("foundItems", foundItems);
        request.setAttribute("latestLostItems", latestLostItems);
        request.setAttribute("latestFoundItems", latestFoundItems);
        request.setAttribute("lostItemImages", buildImageMap(lostItems));
        request.setAttribute("foundItemImages", buildImageMap(foundItems));
        request.setAttribute("ownerNames", buildOwnerNameMap(allItems, userDAO.getAllUsers()));
        request.setAttribute("locationNames", buildLocationNameMap(allItems, locationDAO.getAllLocations()));
        request.setAttribute("totalUsers", userDAO.getTotalUsers());
        request.setAttribute("totalLostItems", lostItems.size());
        request.setAttribute("totalFoundItems", foundItems.size());
        request.setAttribute("pendingModerationsCount", pendingModerations);
        request.setAttribute("pendingSupportsCount", pendingSupports);

        request.setAttribute("categories", categories);
        request.setAttribute("locations", locations);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
