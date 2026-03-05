package com.investorcare.dao;

import com.investorcare.model.PriceBar;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PriceBarDAO {

    // ===== INSERT =====
    private static final String INSERT_SQL =
        "INSERT INTO PRICE_BAR " +
        "(ASSET_ID, TS, [OPEN], HIGH, LOW, [CLOSE], VOLUME, SOURCE) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    public void insert(PriceBar p) throws Exception {

        try (Connection conn = JDBCUtils.getConnection();
             PreparedStatement pst = conn.prepareStatement(INSERT_SQL)) {

            pst.setInt(1, p.getAssetId());
            pst.setTimestamp(2, p.getTs());
            pst.setDouble(3, p.getOpen());
            pst.setDouble(4, p.getHigh());
            pst.setDouble(5, p.getLow());
            pst.setDouble(6, p.getClose());
            pst.setLong(7, p.getVolume());
            pst.setString(8, p.getSource());

            pst.executeUpdate();
        }
    }

    // ===== GET LAST N RECORDS =====
    private static final String GET_LAST_N =
        "SELECT TOP (?) * FROM PRICE_BAR " +
        "WHERE ASSET_ID = ? " +
        "ORDER BY TS DESC";

    public List<PriceBar> getLastN(int assetId, int n)
            throws Exception {

        List<PriceBar> list = new ArrayList<>();

        try (Connection conn = JDBCUtils.getConnection();
             PreparedStatement pst = conn.prepareStatement(GET_LAST_N)) {

            pst.setInt(1, n);
            pst.setInt(2, assetId);

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                PriceBar p = mapRow(rs);
                list.add(p);
            }
        }

        return list;
    }

    // ===== GET LATEST ONE =====
    public PriceBar getLatest(int assetId) throws Exception {

        List<PriceBar> list = getLastN(assetId, 1);

        if (list.isEmpty()) return null;

        return list.get(0);
    }

    // ===== MAP RESULTSET =====
    private PriceBar mapRow(ResultSet rs) throws Exception {

        PriceBar p = new PriceBar();

        p.setAssetId(rs.getInt("ASSET_ID"));
        p.setTs(rs.getTimestamp("TS"));
        p.setOpen(rs.getDouble("OPEN"));
        p.setHigh(rs.getDouble("HIGH"));
        p.setLow(rs.getDouble("LOW"));
        p.setClose(rs.getDouble("CLOSE"));
        p.setVolume(rs.getLong("VOLUME"));
        p.setSource(rs.getString("SOURCE"));

        return p;
    }
}