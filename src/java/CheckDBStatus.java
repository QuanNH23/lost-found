import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckDBStatus extends DBContext {
    public static void main(String[] args) {
        CheckDBStatus db = new CheckDBStatus();
        try {
            Connection conn = db.connection;
            if (conn == null) {
                System.out.println("Connection failed.");
                return;
            }
            String sql = "SELECT DISTINCT status FROM Items";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            System.out.println("Distinct statuses:");
            while (rs.next()) {
                System.out.println("'" + rs.getString("status") + "'");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
