package controller;

import dal.ItemDAO;
import dal.MessageDAO;
import model.Items;
import model.Message;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;

@WebServlet(name = "ReportController", urlPatterns = {"/report_item"})
public class ReportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                session.setAttribute("error", "Vui long nhap ly do bao cao.");
                response.sendRedirect("item_detail?id=" + itemId);
                return;
            }

            MessageDAO msgDao = new MessageDAO();
            
            // 1. Check if user already reported this item
            if (msgDao.hasUserReportedItem(currentUser.getUserId(), itemId)) {
                session.setAttribute("error", "Ban da bao cao bai viet nay roi.");
                response.sendRedirect("item_detail?id=" + itemId);
                return;
            }

            ItemDAO itemDao = new ItemDAO();
            Items item = itemDao.getItemById(itemId);
            
            if (item == null) {
                response.sendRedirect("home");
                return;
            }

            boolean reported = msgDao.insertMessage(
                currentUser.getUserId(),
                itemId,
                "[REPORT] " + currentUser.getFullName(),
                reason.trim()
            );

            if (reported) {
                // 3. Auto-hide logic: if >= 3 reports, change status to processing
                int reportCount = msgDao.countReportsByItemId(itemId);
                if (reportCount >= 3) {
                    itemDao.updateItemStatus(itemId, "processing");
                }
                
                session.setAttribute("message", "Bao cao thanh cong. Cam on ban da gop phan giu sach cong dong.");
            } else {
                session.setAttribute("error", "Co loi xay ra khi gui bao cao.");
            }
            
            response.sendRedirect("item_detail?id=" + itemId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Du lieu khong hop le.");
            response.sendRedirect("home");
        }
    }
}
