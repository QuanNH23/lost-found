/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Locations;
import java.sql.*;
import java.util.*;

/**
 *
 * @author phant
 */
public class LocationDAO extends DBContext {

    public List<Locations> getAllLocations() {

        List<Locations> list = new ArrayList<>();

        String sql = "SELECT * FROM Locations";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Locations c = new Locations();

                c.setLocationId(rs.getInt("location_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }

        } catch (Exception e) {
            System.out.println(e);
        }

        return list;
    }

    public void addLocation(Locations c) {

        // Không chèn category_id vì nó là IDENTITY
        String sql = "INSERT INTO Locations(name) VALUES (?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            // Chỉ truyền 2 tham số: name và description
            st.setString(1, c.getName());
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Add Category Error: " + e);
        }
    }

    public void deleteLocations(int id) {
        String sql = "DELETE FROM Locations WHERE location_id=?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void updateLocation(Locations c) {

        String sql = "UPDATE locations SET name=? WHERE location_id=?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setInt(2, c.getLocationId());

            st.executeUpdate();

        } catch (Exception e) {
        }
    }

    public Locations getLocationById(int id) {

        String sql = "SELECT * FROM Locations where location_id=?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                Locations c = new Locations();

                c.setLocationId(rs.getInt("location_id"));
                c.setName(rs.getString("name"));
                
                return c;

            }

        } catch (Exception e) {
            System.out.println(e);
        }

        return null;
    }
}
