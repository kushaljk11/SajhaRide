package com.riderental.myriderental.dao;

import com.riderental.myriderental.model.KycVerification;
import com.riderental.myriderental.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class KycDAO {

    public boolean createKycRequest(KycVerification kyc) throws SQLException {
        String sql = "INSERT INTO renter_verifications (user_id, document_path, document_type, status) VALUES (?, ?, ?, 'PENDING')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, kyc.getUserId());
            stmt.setString(2, kyc.getDocumentPath());
            stmt.setString(3, kyc.getDocumentType());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public KycVerification findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM renter_verifications WHERE user_id = ? ORDER BY uploaded_at DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public KycVerification findById(int id) throws SQLException {
        String sql = "SELECT * FROM renter_verifications WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public List<KycVerification> findAllPending() throws SQLException {
        String sql = "SELECT k.*, u.fullName FROM renter_verifications k JOIN users u ON k.user_id = u.userId WHERE k.status = 'PENDING' ORDER BY k.uploaded_at ASC";
        List<KycVerification> list = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                KycVerification kyc = map(rs);
                kyc.setUserFullName(rs.getString("fullName"));
                list.add(kyc);
            }
        }
        return list;
    }

    public boolean updateStatus(int id, String status, String reason, int adminId) throws SQLException {
        String sql = "UPDATE renter_verifications SET status = ?, rejection_reason = ?, reviewed_at = CURRENT_TIMESTAMP, reviewed_by = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, status);
            stmt.setString(2, reason);
            stmt.setInt(3, adminId);
            stmt.setInt(4, id);
            
            return stmt.executeUpdate() > 0;
        }
    }

    private KycVerification map(ResultSet rs) throws SQLException {
        KycVerification kyc = new KycVerification();
        kyc.setId(rs.getInt("id"));
        kyc.setUserId(rs.getInt("user_id"));
        kyc.setDocumentPath(rs.getString("document_path"));
        kyc.setDocumentType(rs.getString("document_type"));
        kyc.setStatus(rs.getString("status"));
        kyc.setRejectionReason(rs.getString("rejection_reason"));
        
        Timestamp uploadedTs = rs.getTimestamp("uploaded_at");
        if (uploadedTs != null) {
            kyc.setUploadedAt(uploadedTs.toLocalDateTime());
        }
        
        Timestamp reviewedTs = rs.getTimestamp("reviewed_at");
        if (reviewedTs != null) {
            kyc.setReviewedAt(reviewedTs.toLocalDateTime());
        }
        
        int reviewedBy = rs.getInt("reviewed_by");
        if (!rs.wasNull()) {
            kyc.setReviewedBy(reviewedBy);
        }
        
        return kyc;
    }
}
