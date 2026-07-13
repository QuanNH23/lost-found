package controller;

import dal.ClaimDAO;
import dal.ItemDAO;
import dal.MessageDAO;
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
import model.Claims;
import model.Items;
import model.Message;
import model.Users;

public class itemDetailController extends HttpServlet {

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private List<String> parseImagePaths(String imagesJson) {
        List<String> paths = new ArrayList<>();
        if (isBlank(imagesJson)) {
            return paths;
        }

        String raw = imagesJson.trim();
        if (raw.startsWith("[")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("]")) {
            raw = raw.substring(0, raw.length() - 1);
        }
        if (isBlank(raw)) {
            return paths;
        }

        String[] tokens = raw.split(",");
        for (String token : tokens) {
            String value = token == null ? "" : token.trim();
            if (value.startsWith("\"")) {
                value = value.substring(1);
            }
            if (value.endsWith("\"")) {
                value = value.substring(0, value.length() - 1);
            }
            value = value.replace("\\\"", "\"").replace("\\\\", "\\");
            if (!isBlank(value)) {
                paths.add(value);
            }
        }
        return paths;
    }

    private void forwardDetail(int itemId, HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        ItemDAO itemDAO = new ItemDAO();
        Items itemDetail = itemDAO.getItemById(itemId);
        if (itemDetail == null) {
            response.sendRedirect("my_items");
            return;
        }

        MessageDAO messageDAO = new MessageDAO();
        if (currentUser != null) {
            // Mark as read any unread messages sent TO the current user for this item
            messageDAO.markMessagesAsRead(itemId, currentUser.getUserId());
            
            // Immediately update the unread count in the request so the navbar shows the updated number
            request.setAttribute("unreadInboxCount", messageDAO.countUnreadInbox(currentUser.getUserId()));
        }
        
        List<Message> allMessages = messageDAO.getMessagesByItemId(itemId);
        List<Message> itemMessages = new ArrayList<>();
        for (Message msg : allMessages) {
            if ("Comment".equalsIgnoreCase(msg.getTitle())) {
                itemMessages.add(msg);
            }
        }
        boolean isItemOwner = currentUser != null && currentUser.getUserId() == itemDetail.getUserId();

        ClaimDAO claimDAO = new ClaimDAO();
        List<Claims> claims = claimDAO.getClaimsByItemId(itemId);
        Map<Integer, Claims> claimByClaimer = new HashMap<>();
        for (Claims claim : claims) {
            claimByClaimer.put(claim.getClaimerId(), claim);
        }

        Users owner = new UserDAO().getUserById(itemDetail.getUserId());

        // Parse custom SĐT from description if present
        String customPhone = null;
        String desc = itemDetail.getDescription();
        String cleanDesc = desc;
        if (desc != null) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("\\s*\\[SĐT:\\s*(\\d+)\\]").matcher(desc);
            if (m.find()) {
                customPhone = m.group(1);
                cleanDesc = desc.replace(m.group(0), "");
            }
        }

        request.setAttribute("cleanDescription", cleanDesc);
        request.setAttribute("itemOwnerPhone", customPhone != null ? customPhone : (owner != null ? owner.getPhoneNumber() : "—"));

        List<Items> relatedItems = new ItemDAO().getLatestActiveItems(itemDetail.getType(), 4);
        relatedItems.removeIf(it -> it.getItemId() == itemId);
        Map<Integer, String> relatedImages = new HashMap<>();
        for (Items rit : relatedItems) {
            relatedImages.put(rit.getItemId(), parseFirstImagePath(rit.getImagesJSON()));
        }

        request.setAttribute("itemDetail", itemDetail);
        request.setAttribute("itemMessages", itemMessages);
        request.setAttribute("senderNames", messageDAO.getSenderNamesByItemId(itemId));
        request.setAttribute("imagePaths", parseImagePaths(itemDetail.getImagesJSON()));
        request.setAttribute("claimByClaimer", claimByClaimer);
        request.setAttribute("isItemOwner", isItemOwner);
        request.setAttribute("itemOwnerName", owner != null ? owner.getFullName() : null);
        request.setAttribute("itemOwnerId", itemDetail.getUserId());
        request.setAttribute("itemType", itemDetail.getType());
        request.setAttribute("relatedItems", relatedItems);
        request.setAttribute("relatedImages", relatedImages);
        request.getRequestDispatcher("/WEB-INF/views/item_detail.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            forwardDetail(itemId, request, response, currentUser);
        } catch (Exception e) {
            response.sendRedirect("home");
        }
    }

    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        Items itemDetail = new ItemDAO().getItemById(itemId);

        String title = "Comment";
        String content = request.getParameter("message");
        MessageDAO messageDAO = new MessageDAO();

        if (messageDAO.insertMessage(currentUser.getUserId(), itemId, title, content)) {
            request.getSession().setAttribute("message", "Da gui binh luan!");
            response.sendRedirect("item_detail?id=" + itemId);
        } else {
            request.setAttribute("ERROR", "Loi khi gui binh luan.");
            forwardDetail(itemId, request, response, currentUser);
        }
    }

    private void handleRespondClaim(HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimId = Integer.parseInt(request.getParameter("claim_id"));
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);

        ClaimDAO claimDAO = new ClaimDAO();
        Claims claim = claimDAO.getClaimById(claimId);

        if (item != null && claim != null && currentUser.getUserId() == item.getUserId() && "pending".equals(claim.getStatus())) {
            String newStatus = "accept".equals(decision) ? "approved" : "rejected";
            String msg = "accept".equals(decision) ? "Da duyet tra do" : "Da tu choi";

            if (claimDAO.updateClaimStatus(claimId, newStatus, msg, currentUser.getUserId())) {
                itemDAO.updateItemStatus(itemId, "approved".equals(newStatus) ? "completed" : "active");
                request.getSession().setAttribute("message", "Da phan hoi yeu cau thanh cong!");
            }
        } else {
            request.getSession().setAttribute("message", "Loi: Ban khong co quyen duyet hoac yeu cau da duoc xu ly.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    private void handleOwnerRequestLost(HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimerId = Integer.parseInt(request.getParameter("claimer_id"));
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);
        ClaimDAO claimDAO = new ClaimDAO();

        if (item != null && currentUser.getUserId() == item.getUserId()
                && claimDAO.getClaimByItemAndClaimer(itemId, claimerId) == null) {
            if ("request".equals(decision)) {
                claimDAO.insertClaimWithStatus(itemId, claimerId, currentUser.getUserId(),
                        "Chu bai yeu cau nhan lai do", "pending");
                request.getSession().setAttribute("message", "Da gui yeu cau nhan lai do! Cho nguoi tim thay xac nhan.");
            } else if ("reject".equals(decision)) {
                claimDAO.insertClaimWithStatus(itemId, claimerId, currentUser.getUserId(),
                        "Chu bai xac nhan day khong phai do cua ho", "rejected");
                request.getSession().setAttribute("message", "Da xac nhan day khong phai do cua ban.");
            } else {
                request.getSession().setAttribute("message", "Loi: Hanh dong khong hop le.");
            }
        } else {
            request.getSession().setAttribute("message", "Loi: Ban khong co quyen hoac yeu cau da duoc xu ly.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    private void handleFinderRespondLost(HttpServletRequest request, HttpServletResponse response, Users currentUser)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int claimId = Integer.parseInt(request.getParameter("claim_id"));
        String decision = request.getParameter("decision");

        ItemDAO itemDAO = new ItemDAO();
        Items item = itemDAO.getItemById(itemId);

        ClaimDAO claimDAO = new ClaimDAO();
        Claims claim = claimDAO.getClaimById(claimId);

        if (item != null && claim != null
                && currentUser.getUserId() == claim.getClaimerId()
                && "pending".equals(claim.getStatus())) {
            if ("accept".equals(decision)) {
                claimDAO.updateClaimStatus(claimId, "approved", "Nguoi tim thay dong y tra lai do", currentUser.getUserId());
                itemDAO.updateItemStatus(itemId, "completed");
                request.getSession().setAttribute("message", "Da chap nhan! Lien he voi chu do de sap xep tra lai.");
            } else if ("reject".equals(decision)) {
                claimDAO.updateClaimStatus(claimId, "rejected", "Nguoi tim thay tu choi tra lai do", currentUser.getUserId());
                itemDAO.updateItemStatus(itemId, "active");
                request.getSession().setAttribute("message", "Da tu choi yeu cau.");
            } else {
                request.getSession().setAttribute("message", "Loi: Hanh dong khong hop le.");
            }
        } else {
            request.getSession().setAttribute("message", "Loi: Ban khong co quyen hoac yeu cau da duoc xu ly.");
        }
        response.sendRedirect("item_detail?id=" + itemId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login");
            return;
        }

        Users currentUser = (Users) session.getAttribute("currentUser");
        if ("respond_claim".equals(request.getParameter("action"))) {
            handleRespondClaim(request, response, currentUser);
        } else if ("owner_request_lost".equals(request.getParameter("action"))) {
            handleOwnerRequestLost(request, response, currentUser);
        } else if ("finder_respond_lost".equals(request.getParameter("action"))) {
            handleFinderRespondLost(request, response, currentUser);
        } else {
            handleSendMessage(request, response, currentUser);
        }
    }

    private String parseFirstImagePath(String imagesJson) {
        if (imagesJson == null || imagesJson.trim().isEmpty()) {
            return null;
        }
        String raw = imagesJson.trim();
        if (raw.startsWith("[")) {
            raw = raw.substring(1);
        }
        if (raw.endsWith("]")) {
            raw = raw.substring(0, raw.length() - 1);
        }
        if (raw.trim().isEmpty()) {
            return null;
        }
        String[] tokens = raw.split(",");
        String value = tokens[0] == null ? "" : tokens[0].trim();
        if (value.startsWith("\"")) {
            value = value.substring(1);
        }
        if (value.endsWith("\"")) {
            value = value.substring(0, value.length() - 1);
        }
        value = value.replace("\\\"", "\"").replace("\\\\", "\\");
        return value.trim().isEmpty() ? null : value;
    }
}
