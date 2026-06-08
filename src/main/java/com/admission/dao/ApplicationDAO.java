package com.admission.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.admission.model.Application;
import com.admission.util.DBConnection;

public class ApplicationDAO {

    public int submitApplication(Application app) throws SQLException {
        String sql = "INSERT INTO applications (student_id, course_id, application_number, tenth_percent, twelfth_percent, graduation_percent) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, app.getStudentId());
            ps.setInt(2, app.getCourseId());
            ps.setString(3, app.getApplicationNumber());
            ps.setDouble(4, app.getTenthPercent());
            ps.setDouble(5, app.getTwelfthPercent());
            ps.setDouble(6, app.getGraduationPercent());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public List<Application> getApplicationsByStudent(int studentId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.full_name, s.email, s.phone, c.course_name, c.course_code, c.fees " +
                     "FROM applications a JOIN students s ON a.student_id=s.id JOIN courses c ON a.course_id=c.id " +
                     "WHERE a.student_id=? ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapApplication(rs));
        }
        return list;
    }

    public List<Application> getAllApplications() throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.full_name, s.email, s.phone, c.course_name, c.course_code, c.fees " +
                     "FROM applications a JOIN students s ON a.student_id=s.id JOIN courses c ON a.course_id=c.id " +
                     "ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapApplication(rs));
        }
        return list;
    }

    public List<Application> getApplicationsByStatus(String status) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.full_name, s.email, s.phone, c.course_name, c.course_code, c.fees " +
                     "FROM applications a JOIN students s ON a.student_id=s.id JOIN courses c ON a.course_id=c.id " +
                     "WHERE a.status=? ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapApplication(rs));
        }
        return list;
    }

    public Application getApplicationById(int id) throws SQLException {
        String sql = "SELECT a.*, s.full_name, s.email, s.phone, c.course_name, c.course_code, c.fees " +
                     "FROM applications a JOIN students s ON a.student_id=s.id JOIN courses c ON a.course_id=c.id " +
                     "WHERE a.id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapApplication(rs);
        }
        return null;
    }

    public boolean updateApplicationStatus(int appId, String status, String remarks) throws SQLException {
        String sql = "UPDATE applications SET status=?, remarks=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, appId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean hasAlreadyApplied(int studentId, int courseId) throws SQLException {
        String sql = "SELECT id FROM applications WHERE student_id=? AND course_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeQuery().next();
        }
    }

    // Stats for dashboard
    public int countByStatus(String status) throws SQLException {
        String sql = status == null ? "SELECT COUNT(*) FROM applications" : "SELECT COUNT(*) FROM applications WHERE status=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (status != null) ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private Application mapApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setCourseId(rs.getInt("course_id"));
        a.setApplicationNumber(rs.getString("application_number"));
        a.setTenthPercent(rs.getDouble("tenth_percent"));
        a.setTwelfthPercent(rs.getDouble("twelfth_percent"));
        a.setGraduationPercent(rs.getDouble("graduation_percent"));
        a.setStatus(rs.getString("status"));
        a.setRemarks(rs.getString("remarks"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        // Joined
        try { a.setStudentName(rs.getString("full_name")); } catch(Exception ignored) {}
        try { a.setStudentEmail(rs.getString("email")); } catch(Exception ignored) {}
        try { a.setStudentPhone(rs.getString("phone")); } catch(Exception ignored) {}
        try { a.setCourseName(rs.getString("course_name")); } catch(Exception ignored) {}
        try { a.setCourseCode(rs.getString("course_code")); } catch(Exception ignored) {}
        try { a.setCourseFees(rs.getDouble("fees")); } catch(Exception ignored) {}
        return a;
    }
}
