import dal.UserDAO;
import model.Users;
import java.util.List;

public class TestLogin {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        System.out.println("All Users:");
        List<Users> users = dao.getAllUsers();
        for (Users u : users) {
            System.out.println("ID: " + u.getUserId() + ", Username: '" + u.getUsername() + "', Password: '" + u.getPassword() + "', Active: " + u.isIsActive());
        }
    }
}
