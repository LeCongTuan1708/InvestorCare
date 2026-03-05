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

    private static final String INSERT =
            "INSERT INTO ALERT (USER_ID, ASSET_ID, SIGNAL_ID, SEVERITY, MESSAGE) "
            + "VALUES (?, ?, ?, ?, ?)";

    private static final String SELECT_BY_USER =
            "SELECT TOP 5 * FROM ALERT WHERE USER_ID = ? ORDER BY TS DESC";

    private static final String COUNT_UNREAD =
            "SELECT COUNT(*) FROM ALERT WHERE USER_ID = ? AND STATUS = 'NEW'";

    private static final String UPDATE_STATUS =
            "UPDATE ALERT SET STATUS = ? WHERE ALERT_ID = ?";

    private static final String SELECT_BY_ID =
            "SELECT * FROM ALERT WHERE ALERT_ID = ?";

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
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }

        return kq;
    }

    // ===============================
    // GET ALL ALERTS OF USER
    // ===============================
    public List<Alert> getAlertsByUser(int userId)
            throws ClassNotFoundException, SQLException {

        List<Alert> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(SELECT_BY_USER);
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
                a.setTimestamp(rs.getTimestamp("TS"));

                list.add(a);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(AlertDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }

        return list;
    }

    // ===============================
    // COUNT UNREAD ALERTS
    // ===============================
    public int countUnread(int userId)
            throws ClassNotFoundException, SQLException {

        int count = 0;
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(COUNT_UNREAD);
            pst.setInt(1, userId);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(AlertDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }

        return count;
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
            if (pst != null) pst.close();
            if (conn != null) conn.close();
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
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }

        return a;
    }
}