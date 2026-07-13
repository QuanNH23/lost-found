/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author phant
 */
@WebServlet(name="DeleteUserController", urlPatterns={"/deleteuser"})
public class DeleteUserController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet DeleteUserController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteUserController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String id_raw = request.getParameter("id");
        HttpSession session = request.getSession();
        UserDAO usd = new UserDAO();
        try {
            int id = Integer.parseInt(id_raw);
            Users currentUser = (Users) session.getAttribute("currentUser");

            if (currentUser != null && currentUser.getUserId() == id) {
                session.setAttribute("userDeleteError", "Ban khong the xoa chinh tai khoan dang dang nhap.");
                response.sendRedirect(request.getContextPath() + "/admin/data_management?tab=users");
                return;
            }

            boolean deleted = usd.deleteUser(id);
            if (deleted) {
                session.setAttribute("userDeleteSuccess", "Da xoa tai khoan thanh cong.");
            } else {
                session.setAttribute("userDeleteError", "Khong the xoa tai khoan nay. Vui long kiem tra du lieu lien quan.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/data_management?tab=users");
        } catch (NumberFormatException e) {
            session.setAttribute("userDeleteError", "ID nguoi dung khong hop le.");
            response.sendRedirect(request.getContextPath() + "/admin/data_management?tab=users");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
