package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Users;

public class UserDAO extends DBContext {

    public Users checkLogin(String username, String password) {
        String sql = "SELECT * FROM Users "
                + "WHERE username = ? "
                + "AND password = ? "
                + "AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkDuplicate(String username, String email) {
        String sql = "SELECT TOP 1 username FROM Users WHERE username = ? OR email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean insertUser(Users user) {
        String sql = "INSERT INTO Users "
                + "(username, password, full_name, email, phone_number, role, is_active) "
                + "VALUES (?, ?, ?, ?, ?, 'student', 1)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addUser(Users user) {
        String sql = "INSERT INTO Users(username,password,full_name,email,phone_number,role,is_active) "
                + "VALUES(?,?,?,?,?,?,?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setString(6, user.getRole());
            ps.setBoolean(7, user.isIsActive());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateUserRoleAndStatus(int id, String role, boolean isActive) {
        String sql = "UPDATE Users SET role = ?, is_active = ? WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setBoolean(2, isActive);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean deleteUser(int id) {
        if (connection == null) {
            return false;
        }

        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            try (PreparedStatement deleteClaims = connection.prepareStatement(
                    "DELETE FROM Claims "
                    + "WHERE claimer_id = ? "
                    + "OR responded_by = ? "
                    + "OR item_id IN (SELECT item_id FROM Items WHERE user_id = ?)")) {
                deleteClaims.setInt(1, id);
                deleteClaims.setInt(2, id);
                deleteClaims.setInt(3, id);
                deleteClaims.executeUpdate();
            }

            try (PreparedStatement deleteMessages = connection.prepareStatement(
                    "DELETE FROM Message "
                    + "WHERE user_id = ? "
                    + "OR related_item_id IN (SELECT item_id FROM Items WHERE user_id = ?)")) {
                deleteMessages.setInt(1, id);
                deleteMessages.setInt(2, id);
                deleteMessages.executeUpdate();
            }

            try (PreparedStatement deleteItems = connection.prepareStatement(
                    "DELETE FROM Items WHERE user_id = ?")) {
                deleteItems.setInt(1, id);
                deleteItems.executeUpdate();
            }

            int deletedRows;
            try (PreparedStatement deleteUser = connection.prepareStatement(
                    "DELETE FROM Users WHERE user_id = ?")) {
                deleteUser.setInt(1, id);
                deletedRows = deleteUser.executeUpdate();
            }

            if (deletedRows <= 0) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public Users getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkDuplicateExcept(int userId, String username, String email) {
        String sql = "SELECT TOP 1 user_id FROM Users WHERE (username = ? OR email = ?) AND user_id <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserProfile(int userId, String fullName, String email, String phoneNumber, String newPasswordOrNull) {
        if (connection == null) {
            return false;
        }

        String sql = (newPasswordOrNull == null)
                ? "UPDATE Users SET full_name = ?, email = ?, phone_number = ? WHERE user_id = ?"
                : "UPDATE Users SET full_name = ?, email = ?, phone_number = ?, password = ? WHERE user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phoneNumber);
            if (newPasswordOrNull == null) {
                ps.setInt(4, userId);
            } else {
                ps.setString(4, newPasswordOrNull);
                ps.setInt(5, userId);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalLostItems() {
        String sql = "SELECT COUNT(*) FROM Items WHERE type = 'Lost'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Users mapUser(ResultSet rs) throws Exception {
        Users user = new Users();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getBoolean("is_active"));
        try {
            user.setCreatedAt(rs.getDate("created_at"));
        } catch (Exception ignored) {
        }
        return user;
    }
}
