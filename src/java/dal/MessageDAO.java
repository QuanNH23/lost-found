package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Message;

public class MessageDAO extends DBContext {

    public List<Message> getMessagesByItemId(int itemId) {
        List<Message> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT message_id, user_id, title, message, is_read, related_item_id, created_at "
                + "FROM Message "
                + "WHERE related_item_id = ? "
                + "ORDER BY created_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setMessageId(rs.getInt("message_id"));
                    msg.setUserId(rs.getInt("user_id"));
                    msg.setTitle(rs.getString("title"));
                    msg.setMessage(rs.getString("message"));
                    msg.setIsRead(rs.getBoolean("is_read"));
                    msg.setRelatedItemId(rs.getInt("related_item_id"));
                    msg.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(msg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<Integer, String> getSenderNamesByItemId(int itemId) {
        Map<Integer, String> map = new HashMap<>();
        if (connection == null) {
            return map;
        }

        String sql = "SELECT DISTINCT m.user_id, u.full_name "
                + "FROM Message m "
                + "INNER JOIN Users u ON m.user_id = u.user_id "
                + "WHERE m.related_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("user_id"), rs.getString("full_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    public boolean hasUserMessagedItem(int userId, int itemId) {
        if (connection == null) {
            return false;
        }

        String sql = "SELECT TOP 1 message_id FROM Message WHERE user_id = ? AND related_item_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertMessage(int userId, int itemId, String title, String content) {
        if (connection == null) {
            return false;
        }

        String sql = "INSERT INTO Message (user_id, title, message, is_read, related_item_id) VALUES (?, ?, ?, 0, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, content);
            ps.setInt(4, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertAccountNotification(int userId, String title, String content) {
        if (connection == null) {
            return false;
        }
        String sql = "INSERT INTO Message (user_id, title, message, is_read, related_item_id) VALUES (?, ?, ?, 0, NULL)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, content);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================================================
    // 2 HÀM MỚI THÊM CHO TÍNH NĂNG HÒM THƯ (INBOX)
    // =========================================================

    // 1. Lấy danh sách Tin nhắn đến (Inbox)
    public List<Map<String, Object>> getInbox(int receiverId) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT m.message_id, m.title, m.message, m.is_read, m.created_at, "
                   + "u.user_id AS sender_id, u.full_name AS sender_name, i.title AS item_title, i.item_id "
                   + "FROM Message m "
                   + "LEFT JOIN Items i ON m.related_item_id = i.item_id "
                   + "LEFT JOIN Users u ON m.user_id = u.user_id "
                   + "WHERE (i.user_id = ? AND m.title = 'Comment' AND m.user_id != i.user_id) "
                   + "   OR (m.related_item_id IS NULL AND m.user_id = ? AND m.title IN ('System', 'Account', 'Notification', 'Support_Resolved', 'Support_Rejected')) "
                   + "ORDER BY m.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            ps.setInt(2, receiverId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("messageId", rs.getInt("message_id"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("isRead", rs.getBoolean("is_read"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    map.put("senderId", rs.getInt("sender_id"));
                    map.put("senderName", rs.getString("sender_name"));
                    map.put("itemTitle", rs.getString("item_title"));
                    map.put("itemId", rs.getInt("item_id"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countUnreadInbox(int receiverId) {
        if (connection == null) return 0;
        String sql = "SELECT COUNT(m.message_id) "
                   + "FROM Message m "
                   + "LEFT JOIN Items i ON m.related_item_id = i.item_id "
                   + "WHERE (i.user_id = ? AND m.is_read = 0 AND m.user_id != i.user_id AND m.title = 'Comment') "
                   + "   OR (m.related_item_id IS NULL AND m.user_id = ? AND m.is_read = 0 AND m.title IN ('System', 'Account', 'Notification', 'Support_Resolved', 'Support_Rejected'))";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            ps.setInt(2, receiverId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public void markMessagesAsRead(int itemId, int receiverId) {
        if (connection == null) return;
        String sql = "UPDATE Message SET is_read = 1 WHERE related_item_id = ? AND user_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, receiverId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void markAllInboxMessagesAsRead(int receiverId) {
        if (connection == null) return;
        String sql = "UPDATE Message SET is_read = 1 "
                   + "WHERE (related_item_id IN (SELECT item_id FROM Items WHERE user_id = ?) AND is_read = 0 AND user_id != ?) "
                   + "   OR (related_item_id IS NULL AND user_id = ? AND is_read = 0 AND title IN ('System', 'Account', 'Notification', 'Support_Resolved', 'Support_Rejected'))";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, receiverId);
            ps.setInt(2, receiverId);
            ps.setInt(3, receiverId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void markMessageAsReadById(int messageId) {
        if (connection == null) return;
        String sql = "UPDATE Message SET is_read = 1 WHERE message_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, messageId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. Lấy danh sách Tin nhắn đã gửi (Outbox)
    public List<Map<String, Object>> getOutbox(int senderId) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT m.message_id, m.title, m.message, m.is_read, m.created_at, "
                   + "i.title AS item_title, i.item_id "
                   + "FROM Message m "
                   + "LEFT JOIN Items i ON m.related_item_id = i.item_id "
                   + "WHERE m.user_id = ? AND m.title = 'Comment' "
                   + "ORDER BY m.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("messageId", rs.getInt("message_id"));
                    map.put("title", rs.getString("title"));
                    map.put("message", rs.getString("message"));
                    map.put("isRead", rs.getBoolean("is_read"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    map.put("itemTitle", rs.getString("item_title"));
                    map.put("itemId", rs.getInt("item_id"));
                    list.add(map);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================
    // 3 HÀM MỚI THÊM CHO TÍNH NĂNG REPORT (CỘNG ĐỒNG BÁO CÁO)
    // =========================================================

    public int countReportsByItemId(int itemId) {
        if (connection == null) return 0;
        
        String sql = "SELECT COUNT(DISTINCT user_id) FROM Message WHERE related_item_id = ? AND title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean hasUserReportedItem(int userId, int itemId) {
        if (connection == null) return false;
        
        String sql = "SELECT TOP 1 message_id FROM Message WHERE user_id = ? AND related_item_id = ? AND title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getReportedItems() {
        List<Map<String, Object>> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT i.item_id, i.title, i.user_id as owner_id, u.full_name as owner_name, u.phone_number as owner_phone, "
                   + "COUNT(DISTINCT m.user_id) as report_count, MAX(m.created_at) as latest_report_time, "
                   + "(SELECT TOP 1 message FROM Message sub_m WHERE sub_m.related_item_id = i.item_id AND sub_m.title LIKE '[REPORT]%' ORDER BY sub_m.created_at DESC) as latest_reason "
                   + "FROM Items i "
                   + "INNER JOIN Message m ON i.item_id = m.related_item_id "
                   + "INNER JOIN Users u ON i.user_id = u.user_id "
                   + "WHERE m.title LIKE '[REPORT]%' AND i.status = 'active' "
                   + "GROUP BY i.item_id, i.title, i.user_id, u.full_name, u.phone_number "
                   + "ORDER BY latest_report_time DESC";
                   
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                int itemId = rs.getInt("item_id");
                map.put("itemId", itemId);
                map.put("title", rs.getString("title"));
                map.put("ownerId", rs.getInt("owner_id"));
                map.put("ownerName", rs.getString("owner_name"));
                map.put("ownerPhone", rs.getString("owner_phone"));
                map.put("reportCount", rs.getInt("report_count"));
                map.put("latestReportTime", rs.getTimestamp("latest_report_time"));
                map.put("latestReason", rs.getString("latest_reason"));
                
                // Fetch reporter details
                map.put("reportersList", getReportersDetails(itemId));
                
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, String>> getReportersDetails(int itemId) {
        List<Map<String, String>> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT DISTINCT u.full_name, u.phone_number FROM Message m "
                   + "INNER JOIN Users u ON m.user_id = u.user_id "
                   + "WHERE m.related_item_id = ? AND m.title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("fullName", rs.getString("full_name"));
                    map.put("phoneNumber", rs.getString("phone_number"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public String getReportersForItem(int itemId) {
        if (connection == null) return "";
        List<String> reporters = new ArrayList<>();
        String sql = "SELECT DISTINCT u.full_name FROM Message m "
                   + "INNER JOIN Users u ON m.user_id = u.user_id "
                   + "WHERE m.related_item_id = ? AND m.title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reporters.add(rs.getString("full_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return String.join(", ", reporters);
    }

    public int countTotalReportsByUserId(int userId) {
        if (connection == null) return 0;
        String sql = "SELECT COUNT(m.message_id) "
                   + "FROM Message m "
                   + "INNER JOIN Items i ON m.related_item_id = i.item_id "
                   + "WHERE i.user_id = ? AND m.title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteReportsByItemId(int itemId) {
        if (connection == null) return false;
        String sql = "DELETE FROM Message WHERE related_item_id = ? AND title LIKE '[REPORT]%'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<java.util.Map<String, String>> getAdminNotifications() {
        java.util.List<java.util.Map<String, String>> notifs = new java.util.ArrayList<>();
        if (connection == null) return notifs;
        
        // 1. Count pending support requests
        String sqlSupport = "SELECT COUNT(*) FROM SupportRequests WHERE status = 'processing'";
        try (PreparedStatement ps = connection.prepareStatement(sqlSupport);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
                java.util.Map<String, String> n = new java.util.HashMap<>();
                n.put("type", "support");
                n.put("title", "Hỗ trợ");
                n.put("message", "Có yêu cầu hỗ trợ mới cần xử lý.");
                n.put("link", "/admin/support");
                n.put("count", String.valueOf(rs.getInt(1)));
                notifs.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 2. Count posts hidden by system (status = 'processing')
        String sqlItems = "SELECT COUNT(*) FROM Items WHERE status = 'processing'";
        try (PreparedStatement ps = connection.prepareStatement(sqlItems);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
                java.util.Map<String, String> n = new java.util.HashMap<>();
                n.put("type", "hidden");
                n.put("title", "Bài viết bị ẩn");
                n.put("message", "Có bài đăng bị hệ thống tạm ẩn cần kiểm tra.");
                n.put("link", "/admin/moderation");
                n.put("count", String.valueOf(rs.getInt(1)));
                notifs.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 3. Count reported items (active posts with at least 1 report)
        String sqlReports = "SELECT COUNT(DISTINCT i.item_id) FROM Items i INNER JOIN Message m ON i.item_id = m.related_item_id WHERE m.title LIKE '[REPORT]%' AND i.status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sqlReports);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) > 0) {
                java.util.Map<String, String> n = new java.util.HashMap<>();
                n.put("type", "reported");
                n.put("title", "Bài viết bị báo cáo");
                n.put("message", "Có bài viết bị báo cáo vi phạm cần kiểm tra.");
                n.put("link", "/admin/moderation");
                n.put("count", String.valueOf(rs.getInt(1)));
                notifs.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
        
        return notifs;
    }
}