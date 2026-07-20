import dal.UserDAO;
import model.Users;

public class TestLoginCheck {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        Users u1 = dao.checkLogin("student02", "123456");
        System.out.println("checkLogin student02: " + (u1 != null));
        
        Users u2 = dao.checkLogin("dsad", "123456");
        System.out.println("checkLogin dsad: " + (u2 != null));
    }
}
