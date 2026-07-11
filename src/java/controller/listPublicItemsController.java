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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        String typeParam = request.getParameter("type");
        String type;
        if ("found".equalsIgnoreCase(typeParam)) {
            type = "found";
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

        List<Items> items = itemDAO.getItemsByTypeWithFilter(type, categoryId, locationId, fromDate, toDate);
        List<Categories> categories = itemDAO.getAllCategories();
        List<Locations> locations = itemDAO.getAllLocations();

        request.setAttribute("items", items);
        request.setAttribute("type", type);
        request.setAttribute("categories", categories);
        request.setAttribute("locations", locations);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedLocationId", locationId);
        request.setAttribute("fromDate", fromParam);
        request.setAttribute("toDate", toParam);

        request.getRequestDispatcher("/WEB-INF/views/items.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

