package controller;

import dal.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.Categories;
import model.Items;
import model.Locations;

public class listPublicItemsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String typeParam = request.getParameter("type");
        String type;
        if ("found".equalsIgnoreCase(typeParam)) {
            type = "found";
        } else if ("all".equalsIgnoreCase(typeParam)) {
            type = "all";
        } else {
            type = "lost";
        }

        ItemDAO itemDAO = new ItemDAO();
        String categoryParam = request.getParameter("categoryId");
        String locationParam = request.getParameter("locationId");
        String fromParam = request.getParameter("fromDate");
        String toParam = request.getParameter("toDate");

        Integer categoryId = null;
        Integer locationId = null;
        Date fromDate = null;
        Date toDate = null;

        try {
            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
        } catch (NumberFormatException e) {
            categoryId = null;
        }

        try {
            if (locationParam != null && !locationParam.trim().isEmpty()) {
                locationId = Integer.parseInt(locationParam);
            }
        } catch (NumberFormatException e) {
            locationId = null;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if (fromParam != null && !fromParam.trim().isEmpty()) {
                fromDate = sdf.parse(fromParam.trim());
            }
        } catch (Exception e) {
            fromDate = null;
        }
        try {
            if (toParam != null && !toParam.trim().isEmpty()) {
                toDate = sdf.parse(toParam.trim());
            }
        } catch (Exception e) {
            toDate = null;
        }

        String searchKeyword = request.getParameter("search");
        // When type is "all", pass null to DAO so it searches both lost and found
        String daoType = "all".equals(type) ? null : type;

        List<Items> items;
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            items = itemDAO.searchItems(searchKeyword.trim(), daoType, categoryId, locationId);
        } else {
            items = itemDAO.getItemsByTypeWithFilter(daoType, categoryId, locationId, fromDate, toDate);
        }

        // Paging logic
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int pageSize = 12; // 3 columns * 4 rows = 12
        int totalItems = items.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (page < 1) page = 1;
        if (totalPages > 0 && page > totalPages) page = totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalItems);
        List<Items> pagedItems = new java.util.ArrayList<>();
        if (totalItems > 0) {
            pagedItems = items.subList(startIndex, endIndex);
        }

        List<Categories> categories = itemDAO.getAllCategories();
        List<Locations> locations = itemDAO.getAllLocations();
 
        request.setAttribute("items", pagedItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItemsCount", totalItems);
        request.setAttribute("type", type);
        request.setAttribute("categories", categories);
        request.setAttribute("locations", locations);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedLocationId", locationId);
        request.setAttribute("fromDate", fromParam);
        request.setAttribute("toDate", toParam);
        request.setAttribute("searchKeyword", searchKeyword);
 
        request.getRequestDispatcher("/WEB-INF/views/items.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

