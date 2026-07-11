package controller;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Categories;

@WebServlet(name = "addCategoryController", urlPatterns = {"/add"})
public class AddCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/addCategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String describe = request.getParameter("describe");

        request.setAttribute("oldName", name);
        request.setAttribute("oldDescribe", describe);

        if (name == null || name.trim().isEmpty() || describe == null || describe.trim().isEmpty()) {
            request.setAttribute("error", "Vui long nhap day du thong tin.");
            request.getRequestDispatcher("/WEB-INF/views/addCategory.jsp").forward(request, response);
            return;
        }

        try {
            CategoryDAO dao = new CategoryDAO();
            dao.addCategory(new Categories(0, name.trim(), describe.trim()));
            response.sendRedirect("manage_categories");
        } catch (Exception e) {
            request.setAttribute("error", "Khong the them danh muc.");
            request.getRequestDispatcher("/WEB-INF/views/addCategory.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
