package com.investorcare.dao;

import com.investorcare.model.Signal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SignalDAO {

    private static final String INSERT
            = "INSERT INTO SIGNAL (ASSET_ID, MODEL_ID, RISK_SCORE, ANOMALY_FLAG, TREND_PROB, EXPLANATION_TEXT) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_ASSET
            = "SELECT * FROM SIGNAL WHERE ASSET_ID = ? ORDER BY TS DESC";

    private static final String SELECT_LATEST_BY_ASSET
            = "SELECT TOP 1 * FROM SIGNAL WHERE ASSET_ID = ? ORDER BY TS DESC";

    private static final String SELECT_BY_ID
            = "SELECT * FROM SIGNAL WHERE SIGNAL_ID = ?";

    // ===============================
    // INSERT SIGNAL
    // ===============================
    public int insert(Signal s) throws Exception {

        Connection conn = JDBCUtils.getConnection();

        if (conn == null) {
            throw new SQLException("Database connection is null.");
        }

        try ( PreparedStatement pst
                = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {

            pst.setInt(1, s.getAssetId());
            pst.setInt(2, s.getModelId());
            pst.setDouble(3, s.getRiskScore());
            pst.setBoolean(4, s.isAnomalyFlag());
            pst.setDouble(5, s.getTrendProb());
            pst.setString(6, s.getExplanationText());

            int rows = pst.executeUpdate();

            try ( ResultSet rs = pst.getGeneratedKeys()) {
                if (rs.next()) {
                    s.setSignalId(rs.getInt(1));
                }
            }

            return rows;
        }
    }

    // ===============================
    // GET ALL SIGNALS BY ASSET
    // ===============================
    public List<Signal> getSignalsByAsset(int assetId) throws Exception {

        List<Signal> list = new ArrayList<>();

        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(SELECT_BY_ASSET)) {

            pst.setInt(1, assetId);

            try ( ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSignal(rs));
                }
            }
        }

        return list;
    }

    // ===============================
    // GET LATEST SIGNAL BY ASSET
    // ===============================
    public Signal getLatestByAsset(int assetId) throws Exception {

        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(SELECT_LATEST_BY_ASSET)) {

            pst.setInt(1, assetId);

            try ( ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return mapSignal(rs);
                }
            }
        }

        return null;
    }

    // ===============================
    // SELECT BY ID
    // ===============================
    public Signal selectById(int signalId) throws Exception {

        try ( Connection conn = JDBCUtils.getConnection();  PreparedStatement pst = conn.prepareStatement(SELECT_BY_ID)) {

            pst.setInt(1, signalId);

            try ( ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return mapSignal(rs);
                }
            }
        }

        return null;
    }

    // ===============================
    // MAP RESULTSET → SIGNAL
    // ===============================
    private Signal mapSignal(ResultSet rs) throws SQLException {

        Signal s = new Signal();

        s.setSignalId(rs.getInt("SIGNAL_ID"));
        s.setAssetId(rs.getInt("ASSET_ID"));
        s.setModelId(rs.getInt("MODEL_ID"));
        s.setTs(rs.getTimestamp("TS"));
        s.setRiskScore(rs.getDouble("RISK_SCORE"));
        s.setAnomalyFlag(rs.getBoolean("ANOMALY_FLAG"));
        s.setTrendProb(rs.getDouble("TREND_PROB"));
        s.setExplanationText(rs.getString("EXPLANATION_TEXT"));

        return s;
    }
}
