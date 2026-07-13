/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.Categories;

/**
 *
 * @author phant
 */
public class CategoryDAO extends DBContext {

    public List<Categories> getAllCategories() {

        List<Categories> list = new ArrayList<>();

        String sql = "SELECT * FROM Categories";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Categories c = new Categories();

                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));

                list.add(c);
            }

        } catch (Exception e) {
            System.out.println(e);
        }

        return list;
    }

    public void addCategory(Categories c) {

        // Không chèn category_id vì nó là IDENTITY
        String sql = "INSERT INTO Categories(name, description) VALUES (?,?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            // Chỉ truyền 2 tham số: name và description
            st.setString(1, c.getName());
            st.setString(2, c.getDescription());

            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Add Category Error: " + e);
        }
    }

    public boolean deleteCategory(int id) {
        try {
            // Xóa claims liên quan tới items thuộc danh mục này trước
            String sqlClaims = "DELETE FROM Claims WHERE item_id IN (SELECT item_id FROM Items WHERE category_id=?)";
            PreparedStatement psClaims = connection.prepareStatement(sqlClaims);
            psClaims.setInt(1, id);
            psClaims.executeUpdate();

            // Xóa messages (bao gồm cả reports) liên quan tới items thuộc danh mục này
            String sqlReports = "DELETE FROM Message WHERE related_item_id IN (SELECT item_id FROM Items WHERE category_id=?)";
            PreparedStatement psReports = connection.prepareStatement(sqlReports);
            psReports.setInt(1, id);
            psReports.executeUpdate();

            // Xóa items thuộc danh mục này
            String sqlItems = "DELETE FROM Items WHERE category_id=?";
            PreparedStatement psItems = connection.prepareStatement(sqlItems);
            psItems.setInt(1, id);
            psItems.executeUpdate();

            // Cuối cùng xóa danh mục
            String sql = "DELETE FROM Categories WHERE category_id=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();

            return true;
        } catch (Exception e) {
            System.out.println("Delete Category Error: " + e);
            return false;
        }
    }

    public void updateCategory(Categories c) {

        String sql = "UPDATE Categories SET name=?, description=? WHERE category_id=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setString(2, c.getDescription());
            st.setInt(3, c.getCategoryId());
              
            st.executeUpdate();

        } catch (Exception e) {
        }
    }

    public Categories getCategorieById(int id) {

        String sql = "SELECT * FROM Categories where category_id=?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                Categories c = new Categories();

                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                return c;

            }

        } catch (Exception e) {
            System.out.println(e);
        }

        return null;
    }
}
