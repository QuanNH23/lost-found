package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Claims;

public class ClaimDAO extends DBContext {

    public Claims getClaimByItemAndClaimer(int itemId, int claimerId) {
        if (connection == null) {
            return null;
        }

        String sql = "SELECT claim_id, item_id, claimer_id, status, proof_description, response_message, responded_by, created_at, updated_at "
                + "FROM Claims WHERE item_id = ? AND claimer_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, claimerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClaim(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Claims> getClaimsByItemId(int itemId) {
        List<Claims> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT claim_id, item_id, claimer_id, status, proof_description, response_message, responded_by, created_at, updated_at "
                + "FROM Claims WHERE item_id = ? ORDER BY created_at ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClaim(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Claims getClaimById(int claimId) {
        if (connection == null) {
            return null;
        }

        String sql = "SELECT claim_id, item_id, claimer_id, status, proof_description, response_message, responded_by, created_at, updated_at "
                + "FROM Claims WHERE claim_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClaim(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insertClaim(int itemId, int claimerId, int respondedBy, String proofDescription) {
        if (connection == null) {
            return false;
        }

        String sql = "INSERT INTO Claims (item_id, claimer_id, status, proof_description, response_message, responded_by) "
                + "VALUES (?, ?, 'pending', ?, NULL, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, claimerId);
            ps.setString(3, proofDescription);
            ps.setInt(4, respondedBy);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertClaimWithStatus(int itemId, int claimerId, int respondedBy, String proofDescription, String status) {
        if (connection == null) {
            return false;
        }

        String sql = "INSERT INTO Claims (item_id, claimer_id, status, proof_description, response_message, responded_by) "
                + "VALUES (?, ?, ?, ?, NULL, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, claimerId);
            ps.setString(3, status);
            ps.setString(4, proofDescription);
            ps.setInt(5, respondedBy);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateClaimStatus(int claimId, String status, String responseMessage, int respondedBy) {
        if (connection == null) {
            return false;
        }

        String sql = "UPDATE Claims SET status = ?, response_message = ?, responded_by = ?, updated_at = GETDATE() "
                + "WHERE claim_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, responseMessage);
            ps.setInt(3, respondedBy);
            ps.setInt(4, claimId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Claims> getAllClaims() {
        List<Claims> list = new ArrayList<>();
        if (connection == null) {
            return list;
        }

        String sql = "SELECT claim_id, item_id, claimer_id, status, proof_description, response_message, responded_by, created_at, updated_at "
                + "FROM Claims ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapClaim(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void deleteClaim(int id) {
        if (connection == null) {
            return;
        }

        String sql = "DELETE FROM Claims WHERE claim_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Claims mapClaim(ResultSet rs) throws Exception {
        Claims claim = new Claims();
        claim.setClaimId(rs.getInt("claim_id"));
        claim.setItemId(rs.getInt("item_id"));
        claim.setClaimerId(rs.getInt("claimer_id"));
        claim.setStatus(rs.getString("status"));
        claim.setProofDescription(rs.getString("proof_description"));
        claim.setResponseMessage(rs.getString("response_message"));
        claim.setRespondedBy(rs.getInt("responded_by"));
        claim.setCreatedAt(rs.getTimestamp("created_at"));
        claim.setUpdatedAt(rs.getTimestamp("updated_at"));
        return claim;
    }
}
