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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "(user_id, category_id, location_id, title, description, type, status, date_incident, images_json) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                .append("i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, ")
                .append("c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name ")
                .append("FROM Items i ")
                .append("INNER JOIN Categories c ON i.category_id = c.category_id ")
                .append("INNER JOIN Locations l ON i.location_id = l.location_id ")
                .append("INNER JOIN Users u ON i.user_id = u.user_id ")
                .append("WHERE i.type = ? AND i.status = 'active' ");

        List<Object> params = new ArrayList<>();
        params.add(type);

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

        sql.append("ORDER BY i.created_at DESC");

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
                + "date_incident = ?, images_json = ?, updated_at = GETDATE() "
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

            ps.setInt(7, item.getItemId());
            ps.setInt(8, item.getUserId());
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

            try (PreparedStatement deleteMessages = connection.prepareStatement("DELETE FROM Messages WHERE item_id = ?")) {
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
        return item;
    }



    public List<Items> getActiveItemsByType(String type) {
        List<Items> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT i.item_id, i.user_id, i.category_id, i.location_id, i.title, i.description, "
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                + "i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, "
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
                .append("i.type, i.status, i.date_incident, i.images_json, i.created_at, i.updated_at, ")
                .append("c.name AS category_name, l.name AS location_name, u.full_name AS owner_full_name ")
                .append("FROM Items i ")
                .append("INNER JOIN Categories c ON i.category_id = c.category_id ")
                .append("INNER JOIN Locations l ON i.location_id = l.location_id ")
                .append("INNER JOIN Users u ON i.user_id = u.user_id ")
                .append("WHERE i.type = ? AND i.status = 'active' ");

        List<Object> params = new ArrayList<>();
        params.add(type);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.title LIKE ? OR i.description LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND i.category_id = ? ");
            params.add(categoryId);
        }

        if (locationId != null && locationId > 0) {
            sql.append("AND i.location_id = ? ");
            params.add(locationId);
        }

        sql.append("ORDER BY i.created_at DESC");

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
