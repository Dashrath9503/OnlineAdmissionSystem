package com.admission.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import com.admission.model.Student;
import com.admission.util.DBConnection;

public class StudentDAO {

    public boolean registerStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (full_name, email, password, phone, dob, gender, address, city, state, pincode) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getFullName());
            ps.setString(2, student.getEmail());
            ps.setString(3, BCrypt.hashpw(student.getPassword(), BCrypt.gensalt()));
            ps.setString(4, student.getPhone());
            ps.setDate(5, student.getDob());
            ps.setString(6, student.getGender());
            ps.setString(7, student.getAddress());
            ps.setString(8, student.getCity());
            ps.setString(9, student.getState());
            ps.setString(10, student.getPincode());
            return ps.executeUpdate() > 0;
        }
    }

    public Student loginStudent(String email, String password) throws SQLException {
        String sql = "SELECT * FROM students WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashed = rs.getString("password");
                if (BCrypt.checkpw(password, hashed)) {
                    return mapStudent(rs);
                }
            }
        }
        return null;
    }

    public boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT id FROM students WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public Student getStudentById(int id) throws SQLException {
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapStudent(rs);
        }
        return null;
    }

    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET full_name=?, phone=?, dob=?, gender=?, address=?, city=?, state=?, pincode=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getFullName());
            ps.setString(2, student.getPhone());
            ps.setDate(3, student.getDob());
            ps.setString(4, student.getGender());
            ps.setString(5, student.getAddress());
            ps.setString(6, student.getCity());
            ps.setString(7, student.getState());
            ps.setString(8, student.getPincode());
            ps.setInt(9, student.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public int getTotalStudents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setPhone(rs.getString("phone"));
        s.setDob(rs.getDate("dob"));
        s.setGender(rs.getString("gender"));
        s.setAddress(rs.getString("address"));
        s.setCity(rs.getString("city"));
        s.setState(rs.getString("state"));
        s.setPincode(rs.getString("pincode"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}
