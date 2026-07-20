import dal.DBContext;
import java.sql.Connection;

public class UnlockAllUsers extends DBContext {
    public static void main(String[] args) {
        UnlockAllUsers db = new UnlockAllUsers();
        try {
            Connection conn = db.connection;
            if (conn != null) {
                int rows = conn.createStatement().executeUpdate("UPDATE Users SET is_active = 1");
                System.out.println("Unlocked " + rows + " users successfully.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
