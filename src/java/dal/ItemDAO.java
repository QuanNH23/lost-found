package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Categories;
import model.Items;
import model.Locations;

public class ItemDAO extends DBContext {

    public List<Categories> getAllCategories() {
        return new CategoryDAO().getAllCategories();
    }

    public List<Locations> getAllLocations() {
        return new LocationDAO().getAllLocations();
    }

    public List<Items> getAllItems() {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertLostItem(Items item) {
        return insertItemByType(item, "lost");
    }

    public boolean insertItemByType(Items item, String type) {
        if (connection == null) {
            return false;
        }

        String normalizedType = "found".equalsIgnoreCase(type) ? "found" : "lost";
        String status = (item.getStatus() != null && !item.getStatus().trim().isEmpty()) ? item.getStatus() : "active";
        
        String sql = "INSERT INTO Items "
                + "(user_id, category_id, location_id, title, description, type, status, date_incident, images_json, location_details) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getCategoryId());
            ps.setInt(3, item.getLocationId());
            ps.setString(4, item.getTitle());
            ps.setString(5, item.getDescription());
            ps.setString(6, normalizedType);
            ps.setString(7, status);
            ps.setTimestamp(8, new Timestamp(item.getDateIncident().getTime()));

            if (item.getImagesJSON() == null || item.getImagesJSON().trim().isEmpty()) {
                ps.setNull(9, Types.NVARCHAR);
            } else {
                ps.setString(9, item.getImagesJSON().trim());
            }

            if (item.getLocationDetails() == null || item.getLocationDetails().trim().isEmpty()) {
                ps.setNull(10, Types.NVARCHAR);
            } else {
                ps.setString(10, item.getLocationDetails().trim());
            }

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Items> getItemsByUserId(int userId) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.user_id = ? "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Items getItemById(int itemId) {
        if (connection == null) {
            return null;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Items getItemByIdAndUser(int itemId, int userId) {
        if (connection == null) {
            return null;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.item_id = ? AND i.user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Items> getItemsByType(String type) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.type = ? "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Items> getItemsByTypeWithFilter(String type, Integer categoryId, Integer locationId,
            java.util.Date fromDate, java.util.Date toDate) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, ")
                .append("i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, ")
                .append("c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name ")
                .append("FROM Items i ")
                .append("INNER JOIN Categories c ON i.category_id = c.category_id ")
                .append("INNER JOIN Locations l ON i.location_id = l.location_id ")
                .append("INNER JOIN Users u ON i.user_id = u.user_id ")
                .append("WHERE i.status = 'active' ");

        List<Object> params = new ArrayList<>();

        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND i.type = ? ");
            params.add(type);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND i.category_id = ? ");
            params.add(categoryId);
        }

        if (locationId != null && locationId > 0) {
            sql.append("AND i.location_id = ? ");
            params.add(locationId);
        }

        if (fromDate != null) {
            sql.append("AND i.date_incident >= ? ");
            params.add(new Timestamp(fromDate.getTime()));
        }

        if (toDate != null) {
            sql.append("AND i.date_incident <= ? ");
            params.add(new Timestamp(toDate.getTime()));
        }

        // Prioritize 'found' items first when showing all types
        if (type == null || type.trim().isEmpty()) {
            sql.append("ORDER BY CASE WHEN i.type = 'found' THEN 0 ELSE 1 END, i.created_at DESC");
        } else {
            sql.append("ORDER BY i.created_at DESC");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else if (p instanceof Timestamp) {
                    ps.setTimestamp(i + 1, (Timestamp) p);
                } else if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateItemByOwner(Items item) {
        if (connection == null) {
            return false;
        }

        String sql = "UPDATE Items SET category_id = ?, location_id = ?, title = ?, description = ?, "
                + "date_incident = ?, images_json = ?, location_details = ?, updated_at = GETDATE() "
                + "WHERE item_id = ? AND user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getCategoryId());
            ps.setInt(2, item.getLocationId());
            ps.setString(3, item.getTitle());
            ps.setString(4, item.getDescription());
            ps.setTimestamp(5, new Timestamp(item.getDateIncident().getTime()));

            if (item.getImagesJSON() == null || item.getImagesJSON().trim().isEmpty()) {
                ps.setNull(6, Types.NVARCHAR);
            } else {
                ps.setString(6, item.getImagesJSON().trim());
            }

            if (item.getLocationDetails() == null || item.getLocationDetails().trim().isEmpty()) {
                ps.setNull(7, Types.NVARCHAR);
            } else {
                ps.setString(7, item.getLocationDetails().trim());
            }

            ps.setInt(8, item.getItemId());
            ps.setInt(9, item.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteItemByIdAndUser(int itemId, int userId) {
        if (connection == null) {
            return false;
        }

        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            try (PreparedStatement deleteClaims = connection.prepareStatement("DELETE FROM Claims WHERE item_id = ?")) {
                deleteClaims.setInt(1, itemId);
                deleteClaims.executeUpdate();
            }

            int deletedRows;
            try (PreparedStatement deleteItem = connection.prepareStatement("DELETE FROM Items WHERE item_id = ? AND user_id = ?")) {
                deleteItem.setInt(1, itemId);
                deleteItem.setInt(2, userId);
                deletedRows = deleteItem.executeUpdate();
            }

            if (deletedRows <= 0) {
                connection.rollback();
                connection.setAutoCommit(oldAutoCommit);
                return false;
            }

            connection.commit();
            connection.setAutoCommit(oldAutoCommit);
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }

        return false;
    }



    public boolean updateItemStatus(int itemId, String status) {
        if (connection == null) {
            return false;
        }

        String sql = "UPDATE Items SET status = ?, updated_at = GETDATE() WHERE item_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteItem(int id) {
        if (connection == null) {
            return false;
        }

        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            try (PreparedStatement deleteClaims = connection.prepareStatement("DELETE FROM Claims WHERE item_id = ?")) {
                deleteClaims.setInt(1, id);
                deleteClaims.executeUpdate();
            }

            try (PreparedStatement deleteMessages = connection.prepareStatement("DELETE FROM Message WHERE related_item_id = ?")) {
                deleteMessages.setInt(1, id);
                deleteMessages.executeUpdate();
            }

            int deletedRows;
            try (PreparedStatement deleteItem = connection.prepareStatement("DELETE FROM Items WHERE item_id = ?")) {
                deleteItem.setInt(1, id);
                deletedRows = deleteItem.executeUpdate();
            }

            if (deletedRows <= 0) {
                connection.rollback();
                connection.setAutoCommit(oldAutoCommit);
                return false;
            }

            connection.commit();
            connection.setAutoCommit(oldAutoCommit);
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return false;
    }

    private Items mapItem(ResultSet rs) throws SQLException {
        Items item = new Items();
        item.setItemId(rs.getInt("item_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setLocationId(rs.getInt("location_id"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setType(rs.getString("type"));
        item.setStatus(rs.getString("status"));
        item.setCategoryName(rs.getString("category_name"));
        item.setLocationName(rs.getString("location_name"));
        item.setOwnerFullName(rs.getString("owner_full_name"));
        item.setDateIncident(rs.getTimestamp("date_incident"));
        item.setImagesJSON(rs.getString("images_json"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        item.setLocationDetails(rs.getString("location_details"));
        return item;
    }



    public List<Items> getActiveItemsByType(String type) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.type = ? AND i.status = 'active' "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Items> getItemsByStatus(String status) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.status = ? "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Items> getLatestActiveItems(String type, int limit) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT TOP (?) i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, "
                + "c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name "
                + "FROM Items i "
                + "INNER JOIN Categories c ON i.category_id = c.category_id "
                + "INNER JOIN Locations l ON i.location_id = l.location_id "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.type = ? AND i.status = 'active' "
                + "ORDER BY i.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setString(2, type);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Items> searchItems(String keyword, String type, Integer categoryId, Integer locationId) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, ")
                .append("i.type, i.status, i.date_incident, i.images_json, i.location_details, i.created_at, i.updated_at, ")
                .append("c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name ")
                .append("FROM Items i ")
                .append("INNER JOIN Categories c ON i.category_id = c.category_id ")
                .append("INNER JOIN Locations l ON i.location_id = l.location_id ")
                .append("INNER JOIN Users u ON i.user_id = u.user_id ")
                .append("WHERE i.status = 'active' ");

        List<Object> params = new ArrayList<>();

        // If type is specified (not null), filter by type; otherwise search all
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND i.type = ? ");
            params.add(type);
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Smart synonym mapping for Vietnamese search
            java.util.Map<String, java.util.List<String>> synonyms = new java.util.HashMap<>();
            java.util.List<String> cccdList = java.util.Arrays.asList("cccd", "căn cước", "can cuoc", "cmnd", "chứng minh", "chung minh", "giấy tờ", "giay to");
            for (String s : cccdList) synonyms.put(s, cccdList);
            
            java.util.List<String> mtList = java.util.Arrays.asList("mt", "máy tính", "may tinh", "laptop", "notebook");
            for (String s : mtList) synonyms.put(s, mtList);
            
            java.util.List<String> watchList = java.util.Arrays.asList("watch", "đồng hồ", "dong ho");
            for (String s : watchList) synonyms.put(s, watchList);
            
            java.util.List<String> phoneList = java.util.Arrays.asList("phone", "điện thoại", "dien thoai", "dt", "đt", "iphone", "samsung");
            for (String s : phoneList) synonyms.put(s, phoneList);
            
            java.util.List<String> walletList = java.util.Arrays.asList("wallet", "ví", "bóp", "vi", "bop");
            for (String s : walletList) synonyms.put(s, walletList);
            
            java.util.List<String> keyList = java.util.Arrays.asList("key", "chìa khóa", "chia khoa", "chìa", "chia");
            for (String s : keyList) synonyms.put(s, keyList);
            
            java.util.List<String> sdtList = java.util.Arrays.asList("sđt", "sdt", "số điện thoại", "so dien thoai");
            for (String s : sdtList) synonyms.put(s, sdtList);

            java.util.List<String> bagList = java.util.Arrays.asList("bag", "túi", "tui", "balo", "ba lô", "ba lo", "cặp", "cap");
            for (String s : bagList) synonyms.put(s, bagList);

            java.util.List<String> petList = java.util.Arrays.asList("pet", "thú cưng", "thu cung", "chó", "cho", "mèo", "meo", "dog", "cat");
            for (String s : petList) synonyms.put(s, petList);

            java.util.List<String> bookList = java.util.Arrays.asList("book", "sách", "sach", "vở", "vo", "tập", "tap");
            for (String s : bookList) synonyms.put(s, bookList);

            String lowerKey = keyword.toLowerCase().trim();
            java.util.List<String> searchWords = synonyms.get(lowerKey);
            if (searchWords == null) {
                searchWords = java.util.Collections.singletonList(lowerKey);
            }
            
            sql.append("AND (");
            for (int k = 0; k < searchWords.size(); k++) {
                if (k > 0) {
                    sql.append(" OR ");
                }
                sql.append("LOWER(i.title) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(c.name) LIKE ? OR LOWER(l.name) LIKE ?");
            }
            sql.append(") ");
            
            for (String sw : searchWords) {
                String searchPattern = "%" + sw + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND i.category_id = ? ");
            params.add(categoryId);
        }

        if (locationId != null && locationId > 0) {
            sql.append("AND i.location_id = ? ");
            params.add(locationId);
        }

        // Prioritize 'found' items first, then sort by newest
        if (type == null || type.trim().isEmpty()) {
            sql.append("ORDER BY CASE WHEN i.type = 'found' THEN 0 ELSE 1 END, i.created_at DESC");
        } else {
            sql.append("ORDER BY i.created_at DESC");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void suspendItemsByUserId(int userId) {
        if (connection == null) return;
        String sql = "UPDATE Items SET status = 'processing' WHERE user_id = ? AND status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsuspendItemsByUserId(int userId) {
        if (connection == null) return;
        String sql = "UPDATE Items SET status = 'active' WHERE user_id = ? AND status = 'processing'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void suspendItemsByUserPhone(String phone) {
        if (connection == null) return;
        String sql = "UPDATE Items SET status = 'processing' WHERE status = 'active' AND user_id IN (SELECT user_id FROM Users WHERE phone_number = ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsuspendItemsByUserPhone(String phone) {
        if (connection == null) return;
        String sql = "UPDATE Items SET status = 'active' WHERE status = 'processing' AND user_id IN (SELECT user_id FROM Users WHERE phone_number = ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
