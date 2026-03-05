package com.investorcare.dao;

import com.investorcare.model.PortfolioHolding;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PortfolioHoldingDAO {

    // =============================
    // ADD ASSET (INSERT hoặc UPDATE nếu đã tồn tại)
    // =============================
    public boolean addAsset(int portfolioId, int assetId, double qty, double avgCost)
            throws Exception {
        String sql = "IF NOT EXISTS ( "
                   + "    SELECT 1 FROM PORTFOLIO_HOLDING "
                   + "    WHERE PORTFOLIO_ID = ? AND ASSET_ID = ? "
                   + ") "
                   + "    INSERT INTO PORTFOLIO_HOLDING (PORTFOLIO_ID, ASSET_ID, QTY, AVG_COST) "
                   + "    VALUES (?, ?, ?, ?) "
                   + "ELSE "
                   + "    UPDATE PORTFOLIO_HOLDING "
                   + "    SET AVG_COST = ((AVG_COST * QTY) + (? * ?)) / (QTY + ?), "
                   + "        QTY = QTY + ? "
                   + "    WHERE PORTFOLIO_ID = ? AND ASSET_ID = ?";

        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // IF NOT EXISTS check
            ps.setInt(1, portfolioId);
            ps.setInt(2, assetId);
            // INSERT values
            ps.setInt(3, portfolioId);
            ps.setInt(4, assetId);
            ps.setDouble(5, qty);
            ps.setDouble(6, avgCost);
            // UPDATE: tính AVG_COST mới TRƯỚC khi cộng QTY
            // AVG_COST mới = (giá vốn cũ * qty cũ + giá mới * qty mới) / (qty cũ + qty mới)
            ps.setDouble(7, avgCost);   // ? * ? → avgCost * qty
            ps.setDouble(8, qty);       // avgCost * ?
            ps.setDouble(9, qty);       // / (QTY + ?)
            // QTY = QTY + ?
            ps.setDouble(10, qty);
            // WHERE
            ps.setInt(11, portfolioId);
            ps.setInt(12, assetId);

            return ps.executeUpdate() > 0;
        }
    }

    // =============================
    // GET HOLDINGS BY PORTFOLIO
    // =============================
    public List<PortfolioHolding> getHoldingsByPortfolio(int portfolioId)
            throws Exception {
        String sql = "SELECT ph.PORTFOLIO_ID, ph.ASSET_ID, "
                   + "       ph.QTY, ph.AVG_COST, "
                   + "       a.SYMBOL, a.NAME, a.EXCHANGE, "
                   + "       ISNULL(pb.[CLOSE], 0) AS CURRENT_PRICE "
                   + "FROM PORTFOLIO_HOLDING ph "
                   + "JOIN ASSET a ON a.ASSET_ID = ph.ASSET_ID "
                   + "LEFT JOIN PRICE_BAR pb ON pb.ASSET_ID = ph.ASSET_ID "
                   + "    AND pb.TS = ( "
                   + "        SELECT MAX(TS) FROM PRICE_BAR "
                   + "        WHERE ASSET_ID = ph.ASSET_ID "
                   + "    ) "
                   + "WHERE ph.PORTFOLIO_ID = ? "
                   + "ORDER BY a.SYMBOL ASC";

        List<PortfolioHolding> list = new ArrayList<>();
        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, portfolioId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new PortfolioHolding(
                            rs.getInt("PORTFOLIO_ID"),
                            rs.getInt("ASSET_ID"),
                            rs.getDouble("QTY"),
                            rs.getDouble("AVG_COST"),
                            rs.getString("SYMBOL"),
                            rs.getString("NAME"),
                            rs.getString("EXCHANGE"),
                            rs.getDouble("CURRENT_PRICE")
                    ));
                }
            }
        }
        return list;
    }

    // =============================
    // REMOVE ASSET
    // =============================
    public boolean removeAsset(int portfolioId, int assetId) throws Exception {
        String sql = "DELETE FROM PORTFOLIO_HOLDING "
                   + "WHERE PORTFOLIO_ID = ? AND ASSET_ID = ?";
        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, portfolioId);
            ps.setInt(2, assetId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean userHasAsset(int userId, int assetId) throws Exception {

    String sql =
        "SELECT COUNT(*) " +
        "FROM PORTFOLIO_HOLDING ph " +
        "JOIN PORTFOLIO p ON ph.PORTFOLIO_ID = p.PORTFOLIO_ID " +
        "WHERE p.USER_ID = ? AND ph.ASSET_ID = ?";

    try (Connection con = JDBCUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ps.setInt(2, assetId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    }

    return false;
}
}