package controller;

import dal.CategoryDAO;
import dal.ClaimDAO;
import dal.ItemDAO;
import dal.LocationDAO;
import dal.UserDAO;
import model.Categories;
import model.Claims;
import model.Items;
import model.Locations;
import model.Users;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminDataManagementController", urlPatterns = {"/admin/data_management"})
public class AdminDataManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        UserDAO uDao = new UserDAO();
        CategoryDAO catDao = new CategoryDAO();
        LocationDAO locDao = new LocationDAO();
        ItemDAO itemDao = new ItemDAO();
        ClaimDAO claimDao = new ClaimDAO();

        List<Users> users = uDao.getAllUsers();
        List<Categories> categories = catDao.getAllCategories();
        List<Locations> locations = locDao.getAllLocations();
        List<Items> items = itemDao.getAllItems();
        List<Claims> claims = claimDao.getAllClaims();

        request.setAttribute("users", users);
        request.setAttribute("categories", categories);
        request.setAttribute("locations", locations);
        request.setAttribute("items", items);
        request.setAttribute("claims", claims);
        
        String activeTab = request.getParameter("tab");
        if (activeTab == null || activeTab.trim().isEmpty()) {
            activeTab = "users";
        }
        request.setAttribute("activeTab", activeTab);

        request.getRequestDispatcher("/WEB-INF/views/admin/data_management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
