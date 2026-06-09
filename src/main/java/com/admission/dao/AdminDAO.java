package com.admission.dao;

import com.admission.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class AdminDAO {

    public boolean loginAdmin(String username, String password) throws SQLException {
        System.out.println("=== Admin Login Debug ===");
        System.out.println("Username entered: " + username);
        System.out.println("Password entered: " + password);

        String sql = "SELECT password FROM admins WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashed = rs.getString("password");
                System.out.println("Hash from DB: " + hashed);
                boolean match = BCrypt.checkpw(password, hashed);
                System.out.println("Password match: " + match);
                return match;
            } else {
                System.out.println("No admin found with username: " + username);
            }
        }
        return false;
    }
}