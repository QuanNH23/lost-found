import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class UpdateDBStatus extends DBContext {
    public static void main(String[] args) {
        UpdateDBStatus db = new UpdateDBStatus();
        try {
            Connection conn = db.connection;
            if (conn == null) {
                System.out.println("Connection failed.");
                return;
            }
            String sql = "UPDATE Items SET status = 'active' WHERE status = 'processing'";
            PreparedStatement ps = conn.prepareStatement(sql);
            int updatedRows = ps.executeUpdate();
            System.out.println("Updated rows: " + updatedRows);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
