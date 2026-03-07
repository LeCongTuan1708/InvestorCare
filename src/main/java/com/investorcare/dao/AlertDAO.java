package com.investorcare.dao;

import com.investorcare.model.Alert;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AlertDAO {

    private static final String INSERT
            = "INSERT INTO ALERT (USER_ID, ASSET_ID, SIGNAL_ID, SEVERITY, MESSAGE) "
            + "VALUES (?, ?, ?, ?, ?)";

    private static final String SELECT_BY_USER
            = "SELECT TOP 5 * FROM ALERT WHERE USER_ID = ? ORDER BY TS DESC";

    private static final String COUNT_UNREAD
            = "SELECT COUNT(*) FROM ALERT WHERE USER_ID = ? AND STATUS = 'NEW'";

    private static final String UPDATE_STATUS
            = "UPDATE ALERT SET STATUS = ? WHERE ALERT_ID = ?";

    private static final String SELECT_BY_ID
            = "SELECT * FROM ALERT WHERE ALERT_ID = ?";

    // ===============================
    // INSERT ALERT
    // ===============================
    public int insert(Alert a) throws ClassNotFoundException, SQLException {

        int kq = 0;
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(INSERT);

            pst.setInt(1, a.getUserId());
            pst.setInt(2, a.getAssetId());
            pst.setInt(3, a.getSignalId());
            pst.setString(4, a.getSeverity());
            pst.setString(5, a.getMessage());

            kq = pst.executeUpdate();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(AlertDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return kq;
    }

    // ===============================
    // UPDATE STATUS (READ / DISMISSED)
    // ===============================
    public int updateStatus(int alertId, String status)
            throws ClassNotFoundException, SQLException {

        int kq = 0;
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(UPDATE_STATUS);

            pst.setString(1, status);
            pst.setInt(2, alertId);

            kq = pst.executeUpdate();

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(AlertDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return kq;
    }

    // ===============================
    // SELECT BY ID
    // ===============================
    public Alert selectById(int alertId)
            throws ClassNotFoundException, SQLException {

        Alert a = null;
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(SELECT_BY_ID);
            pst.setInt(1, alertId);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                a = new Alert();

                a.setAlertId(rs.getInt("ALERT_ID"));
                a.setUserId(rs.getInt("USER_ID"));
                a.setAssetId(rs.getInt("ASSET_ID"));
                a.setSignalId(rs.getInt("SIGNAL_ID"));
                a.setSeverity(rs.getString("SEVERITY"));
                a.setMessage(rs.getString("MESSAGE"));
                a.setStatus(rs.getString("STATUS"));
                a.setTimestamp(rs.getTimestamp("TS"));
            }

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(AlertDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return a;
    }
    // ── Thêm 2 method này vào AlertDAO.java hiện có ──

    /**
     * Lưu alert do user tạo thủ công.
     */
    public int insertAlert(Alert alert) {
        // SỬA 1: Đổi tên cột từ TIMESTAMP thành TS cho khớp với DB
        String sql = "INSERT INTO ALERT (USER_ID, ASSET_ID, SIGNAL_ID, TS, SEVERITY, MESSAGE, STATUS) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(sql);

            pst.setInt(1, alert.getUserId());
            pst.setInt(2, alert.getAssetId());
            pst.setNull(3, java.sql.Types.INTEGER);
            pst.setTimestamp(4, alert.getTimestamp());
            pst.setString(5, alert.getSeverity());   // đúng
            pst.setString(6, alert.getMessage());    // đúng
            pst.setString(7, alert.getStatus());     // đúng

            return pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (Exception ignored) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * Đếm số alert chưa đọc (status = 'ACTIVE') của user.
     */
    public int countUnread(int userId) {
        String sql = "SELECT COUNT(*) FROM ALERT WHERE USER_ID = ? AND STATUS = 'NEW'";
        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy tất cả alert của user, mới nhất trước.
     */
    public List<Alert> getAlertsByUser(int userId) {
        List<Alert> list = new ArrayList<>();
        // Trong DB cột thời gian là TS nên query này hợp lệ
        String sql = "SELECT * FROM ALERT WHERE USER_ID = ? ORDER BY TS DESC";

        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Alert a = new Alert();
                a.setAlertId(rs.getInt("ALERT_ID"));
                a.setUserId(rs.getInt("USER_ID"));
                a.setAssetId(rs.getInt("ASSET_ID"));
                a.setSignalId(rs.getInt("SIGNAL_ID"));
                a.setSeverity(rs.getString("SEVERITY"));
                a.setMessage(rs.getString("MESSAGE"));
                a.setStatus(rs.getString("STATUS"));

                // SỬA 3: Đổi rs.getTimestamp("TIMESTAMP") thành rs.getTimestamp("TS")
                a.setTimestamp(rs.getTimestamp("TS"));

                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Xóa alert theo ID.
     */
    public int deleteAlert(int alertId) {
        String sql = "DELETE FROM ALERT WHERE ALERT_ID = ?";
        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, alertId);
            return pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    public int updateAlert(Alert alert) {
        String sql = "UPDATE ALERT SET ASSET_ID=?, SEVERITY=?, MESSAGE=?, STATUS=? WHERE ALERT_ID=?";
        try (Connection conn = JDBCUtils.getConnection(); 
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, alert.getAssetId());
            pst.setString(2, alert.getSeverity());
            pst.setString(3, alert.getMessage());
            pst.setString(4, alert.getStatus());
            pst.setInt(5, alert.getAlertId());
            return pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
