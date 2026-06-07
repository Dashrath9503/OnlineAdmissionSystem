package com.admission.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.admission.model.Course;
import com.admission.util.DBConnection;

public class CourseDAO {

    public List<Course> getAllActiveCourses() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE is_active = 1 ORDER BY course_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapCourse(rs));
        }
        return list;
    }

    public List<Course> getAllCourses() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY course_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapCourse(rs));
        }
        return list;
    }

    public Course getCourseById(int id) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapCourse(rs);
        }
        return null;
    }

    public boolean addCourse(Course course) throws SQLException {
        String sql = "INSERT INTO courses (course_name, course_code, duration, total_seats, available_seats, fees, description) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getCourseCode());
            ps.setString(3, course.getDuration());
            ps.setInt(4, course.getTotalSeats());
            ps.setInt(5, course.getTotalSeats());
            ps.setDouble(6, course.getFees());
            ps.setString(7, course.getDescription());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateCourse(Course course) throws SQLException {
        String sql = "UPDATE courses SET course_name=?, duration=?, total_seats=?, fees=?, description=?, is_active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getDuration());
            ps.setInt(3, course.getTotalSeats());
            ps.setDouble(4, course.getFees());
            ps.setString(5, course.getDescription());
            ps.setBoolean(6, course.isActive());
            ps.setInt(7, course.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean decrementAvailableSeats(int courseId, Connection conn) throws SQLException {
        String sql = "UPDATE courses SET available_seats = available_seats - 1 WHERE id = ? AND available_seats > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    private Course mapCourse(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setCourseName(rs.getString("course_name"));
        c.setCourseCode(rs.getString("course_code"));
        c.setDuration(rs.getString("duration"));
        c.setTotalSeats(rs.getInt("total_seats"));
        c.setAvailableSeats(rs.getInt("available_seats"));
        c.setFees(rs.getDouble("fees"));
        c.setDescription(rs.getString("description"));
        c.setActive(rs.getBoolean("is_active"));
        return c;
    }
}
