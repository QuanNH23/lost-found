package dal;

import java.sql.Statement;

public class CreateSupportTable extends DBContext {
    public static void main(String[] args) {
        CreateSupportTable creator = new CreateSupportTable();
        if (creator.connection == null) {
            System.err.println("Database connection failed!");
            return;
        }
        String sql = "IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SupportRequests]') AND type in (N'U'))\n" +
                     "BEGIN\n" +
                     "CREATE TABLE SupportRequests (\n" +
                     "    support_id INT IDENTITY(1,1) PRIMARY KEY,\n" +
                     "    user_id INT NOT NULL,\n" +
                     "    reason NVARCHAR(100) NOT NULL,\n" +
                     "    email NVARCHAR(100),\n" +
                     "    phone NVARCHAR(100),\n" +
                     "    image_url NVARCHAR(255),\n" +
                     "    description NVARCHAR(MAX) NOT NULL,\n" +
                     "    status NVARCHAR(20) DEFAULT 'processing',\n" +
                     "    admin_feedback NVARCHAR(MAX),\n" +
                     "    created_at DATETIME DEFAULT GETDATE(),\n" +
                     "    is_read_by_user BIT DEFAULT 0,\n" +
                     "    FOREIGN KEY (user_id) REFERENCES Users(user_id)\n" +
                     ");\n" +
                     "END";
        try (Statement st = creator.connection.createStatement()) {
            st.execute(sql);
            System.out.println("SupportRequests table checked/created successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
