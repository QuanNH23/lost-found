package controller;

import dal.ItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Items;

@WebServlet(name = "ListItemController", urlPatterns = {"/manage_items"})
public class ListItemController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ItemDAO dao = new ItemDAO();

        List<Items> lostItems = dao.getItemsByType("lost");
        List<Items> foundItems = dao.getItemsByType("found");

        request.setAttribute("lostItems", lostItems);
        request.setAttribute("foundItems", foundItems);
        request.setAttribute("lostCount", lostItems.size());
        request.setAttribute("foundCount", foundItems.size());
        request.setAttribute("totalCount", lostItems.size() + foundItems.size());

        request.getRequestDispatcher("/WEB-INF/views/listItems.jsp").forward(request, response);
    }
}
