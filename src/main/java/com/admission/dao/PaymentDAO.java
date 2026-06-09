package com.admission.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.admission.model.Payment;
import com.admission.util.DBConnection;

public class PaymentDAO {

    public boolean savePayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO fee_payments (application_id, amount, payment_mode, transaction_id, payment_status) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, payment.getApplicationId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMode());
            ps.setString(4, payment.getTransactionId());
            ps.setString(5, payment.getPaymentStatus());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Payment> getPaymentsByStudent(int studentId) throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT fp.*, s.full_name, a.application_number, c.course_name FROM fee_payments fp " +
                     "JOIN applications a ON fp.application_id=a.id " +
                     "JOIN students s ON a.student_id=s.id " +
                     "JOIN courses c ON a.course_id=c.id WHERE a.student_id=? ORDER BY fp.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapPayment(rs));
        }
        return list;
    }

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT fp.*, s.full_name, a.application_number, c.course_name FROM fee_payments fp " +
                     "JOIN applications a ON fp.application_id=a.id " +
                     "JOIN students s ON a.student_id=s.id " +
                     "JOIN courses c ON a.course_id=c.id ORDER BY fp.payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapPayment(rs));
        }
        return list;
    }

    public boolean hasAlreadyPaid(int applicationId) throws SQLException {
        String sql = "SELECT id FROM fee_payments WHERE application_id=? AND payment_status='SUCCESS'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            return ps.executeQuery().next();
        }
    }

    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM fee_payments WHERE payment_status='SUCCESS'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        p.setApplicationId(rs.getInt("application_id"));
        p.setAmount(rs.getDouble("amount"));
        p.setPaymentMode(rs.getString("payment_mode"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        try { p.setStudentName(rs.getString("full_name")); } catch(Exception ignored) {}
        try { p.setApplicationNumber(rs.getString("application_number")); } catch(Exception ignored) {}
        try { p.setCourseName(rs.getString("course_name")); } catch(Exception ignored) {}
        return p;
    }
}
