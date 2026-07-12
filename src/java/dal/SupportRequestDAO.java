package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.SupportRequest;

public class SupportRequestDAO extends DBContext {

    public boolean insertSupportRequest(SupportRequest req) {
        if (connection == null) return false;
        String sql = "INSERT INTO SupportRequests (user_id, reason, email, phone, image_url, description, status, is_read_by_user) VALUES (?, ?, ?, ?, ?, ?, 'processing', 0)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, req.getUserId());
            ps.setString(2, req.getReason());
            ps.setString(3, req.getEmail());
            ps.setString(4, req.getPhone());
            ps.setString(5, req.getImageUrl());
            ps.setString(6, req.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<SupportRequest> getSupportRequestsByUser(int userId) {
        List<SupportRequest> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT * FROM SupportRequests WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSupportRequest(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SupportRequest> getAllSupportRequests() {
        List<SupportRequest> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT * FROM SupportRequests ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapSupportRequest(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public SupportRequest getSupportRequestById(int id) {
        if (connection == null) return null;
        String sql = "SELECT * FROM SupportRequests WHERE support_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSupportRequest(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateSupportRequestStatus(int supportId, String status, String adminFeedback) {
        if (connection == null) return false;
        String sql = "UPDATE SupportRequests SET status = ?, admin_feedback = ?, is_read_by_user = 0 WHERE support_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, adminFeedback);
            ps.setInt(3, supportId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markSupportRequestAsRead(int supportId) {
        if (connection == null) return false;
        String sql = "UPDATE SupportRequests SET is_read_by_user = 1 WHERE support_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supportId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private SupportRequest mapSupportRequest(ResultSet rs) throws Exception {
        SupportRequest req = new SupportRequest();
        req.setSupportId(rs.getInt("support_id"));
        req.setUserId(rs.getInt("user_id"));
        req.setReason(rs.getString("reason"));
        req.setEmail(rs.getString("email"));
        req.setPhone(rs.getString("phone"));
        req.setImageUrl(rs.getString("image_url"));
        req.setDescription(rs.getString("description"));
        req.setStatus(rs.getString("status"));
        req.setAdminFeedback(rs.getString("admin_feedback"));
        req.setCreatedAt(rs.getTimestamp("created_at"));
        req.setIsReadByUser(rs.getBoolean("is_read_by_user"));
        return req;
    }
}
