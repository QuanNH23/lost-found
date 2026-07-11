package controller;

import dal.LocationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Locations;

@WebServlet(name = "AddLocationController", urlPatterns = {"/addlocations"})
public class AddLocationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/addLocation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        request.setAttribute("oldName", name);

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Vui long nhap ten vi tri.");
            request.getRequestDispatcher("/WEB-INF/views/addLocation.jsp").forward(request, response);
            return;
        }

        try {
            LocationDAO dao = new LocationDAO();
            dao.addLocation(new Locations(0, name.trim()));
            response.sendRedirect("manage_locations");
        } catch (Exception e) {
            request.setAttribute("error", "Khong the them vi tri.");
            request.getRequestDispatcher("/WEB-INF/views/addLocation.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
