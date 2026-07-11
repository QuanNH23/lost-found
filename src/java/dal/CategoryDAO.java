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

    public void deleteCategory(int id) {

        String sql = "DELETE FROM Categories WHERE category_id=?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e);
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
