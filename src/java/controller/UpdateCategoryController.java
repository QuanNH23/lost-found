/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Categories;

/**
 *
 * @author phant
 */
@WebServlet(name = "UpdateCategoryController", urlPatterns = {"/update"})
public class UpdateCategoryController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateCategoryController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCategoryController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_raw = request.getParameter("id");
        int id;
        CategoryDAO cdb = new CategoryDAO();
        try {
            id = Integer.parseInt(id_raw);
            Categories c = cdb.getCategorieById(id);
            request.setAttribute("category", c);
            request.getRequestDispatcher("/WEB-INF/views/updateCategory.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
// 1. Lấy id từ thẻ hidden (quan trọng nhất)
        String id_raw = request.getParameter("id");
        String name = request.getParameter("name");
        String describe = request.getParameter("describe");

        CategoryDAO cdb = new CategoryDAO();
        try {
            // 2. Parse ID từ String sang int
            int id = Integer.parseInt(id_raw);

            // 3. Truyền đúng ID vào constructor (thay vì truyền số 0)
            Categories cNew = new Categories(id, name, describe);

            // 4. Thực thi update
            cdb.updateCategory(cNew);

            // 5. Chuyển hướng về trang danh sách (đảm bảo urlPatterns "manage_categories" là đúng)
            response.sendRedirect("manage_categories");
        } catch (Exception e) {
            System.out.println("Update Error: " + e);
        }
    }

    /**
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
