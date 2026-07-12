import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckConstraint extends DBContext {
    public static void main(String[] args) {
        CheckConstraint db = new CheckConstraint();
        try {
            Connection conn = db.connection;
            if (conn == null) {
                return;
            }
            String sql = "SELECT definition FROM sys.check_constraints WHERE name = 'CK_Items_Status'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("Constraint: " + rs.getString("definition"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
