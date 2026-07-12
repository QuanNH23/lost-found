import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class FixDBConstraint extends DBContext {
    public static void main(String[] args) {
        FixDBConstraint db = new FixDBConstraint();
        try {
            Connection conn = db.connection;
            if (conn == null) {
                System.out.println("Connection is null!");
                return;
            }
            
            System.out.println("Dropping old constraint CK_Items_Status if exists...");
            try {
                String dropSql = "ALTER TABLE Items DROP CONSTRAINT CK_Items_Status";
                conn.createStatement().execute(dropSql);
                System.out.println("Constraint dropped.");
            } catch (Exception e) {
                System.out.println("Constraint drop failed (maybe doesn't exist): " + e.getMessage());
            }
            
            System.out.println("Migrating suspended to processing...");
            String updateProcessingSql = "UPDATE Items SET status = 'processing' WHERE status = 'suspended'";
            int rowsProcessing = conn.createStatement().executeUpdate(updateProcessingSql);
            System.out.println("Migrated " + rowsProcessing + " rows to processing.");

            System.out.println("Migrating closed to completed...");
            String updateCompletedSql = "UPDATE Items SET status = 'completed' WHERE status = 'closed'";
            int rowsCompleted = conn.createStatement().executeUpdate(updateCompletedSql);
            System.out.println("Migrated " + rowsCompleted + " rows to completed.");
            
            System.out.println("Ensuring all other statuses are valid (default to active)...");
            String cleanSql = "UPDATE Items SET status = 'active' WHERE status NOT IN ('active', 'processing', 'completed')";
            int cleaned = conn.createStatement().executeUpdate(cleanSql);
            System.out.println("Cleaned up " + cleaned + " items.");

            System.out.println("Adding check constraint CK_Items_Status back to plan...");
            String addSql = "ALTER TABLE Items ADD CONSTRAINT CK_Items_Status CHECK (status IN ('active', 'processing', 'completed'))";
            conn.createStatement().execute(addSql);
            System.out.println("Check constraint added successfully!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
