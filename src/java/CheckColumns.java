import dal.DBContext;
import java.sql.Connection;
import java.sql.ResultSet;

public class CheckColumns extends DBContext {
    public static void main(String[] args) {
        CheckColumns db = new CheckColumns();
        try {
            Connection conn = db.connection;
            if (conn == null) return;
            ResultSet rs = conn.getMetaData().getColumns(null, null, "Items", null);
            while (rs.next()) {
                System.out.println(rs.getString("COLUMN_NAME") + " - " + rs.getString("TYPE_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
