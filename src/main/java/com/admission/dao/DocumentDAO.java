package com.admission.dao;

import com.admission.model.Document;
import com.admission.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    public boolean saveDocument(Document doc) throws SQLException {
        String sql = "INSERT INTO documents (application_id, document_type, file_name, file_path) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doc.getApplicationId());
            ps.setString(2, doc.getDocumentType());
            ps.setString(3, doc.getFileName());
            ps.setString(4, doc.getFilePath());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Document> getDocumentsByApplication(int applicationId) throws SQLException {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT * FROM documents WHERE application_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Document d = new Document();
                d.setId(rs.getInt("id"));
                d.setApplicationId(rs.getInt("application_id"));
                d.setDocumentType(rs.getString("document_type"));
                d.setFileName(rs.getString("file_name"));
                d.setFilePath(rs.getString("file_path"));
                d.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(d);
            }
        }
        return list;
    }
}