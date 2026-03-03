/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.dao;

import com.investorcare.model.Asset;
import com.investorcare.model.AssetHealth;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author DELL
 */
public class AssetDAO implements DAOInterface<Asset> {

    private static final String SELECT_ALL = "SELECT * from ASSET WHERE 1=1";
    private static final String SELECT = "SELECT * FROM ASSET WHERE (SYMBOL LIKE ? OR NAME LIKE ?)";
    private static final String SELECT_ID = "SELECT * FROM ASSET WHERE ASSET_ID = ? ";
    private static final String INSERT = "INSERT INTO ASSET(TYPE,SYMBOL,EXCHANGE,NAME,STATUS) VALUES(?,?,?,?,?)";
    private static final String UPDATE = "UPDATE ASSET set TYPE = ?, SYMBOL = ?, EXCHANGE = ?, NAME = ?, STATUS =?,VISIBLE = ?, updated_at = SYSDATETIME() WHERE ASSET_ID = ?";

    public ArrayList<Asset> selectAll() throws ClassNotFoundException, SQLException {
        ArrayList<Asset> kq = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();

            pst = conn.prepareStatement(SELECT_ALL);

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                int assetId = rs.getInt("ASSET_ID");
                String type = rs.getString("TYPE");
                String symbol = rs.getString("SYMBOL");
                String exchange = rs.getString("EXCHANGE");
                String name = rs.getString("NAME");
                String status = rs.getString("STATUS");
                boolean visible = rs.getBoolean("VISIBLE");

                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                Asset asset = new Asset(assetId, type, symbol, exchange, name, status, visible);
                asset.setCreatedAt(createdAt);
                asset.setUpdatedAt(updatedAt);
                kq.add(asset);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    @Override
    public int insert(Asset t) throws ClassNotFoundException, SQLException {
        int kq = 0;
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();

            pst = conn.prepareStatement(INSERT);
            pst.setString(1, t.getType());
            pst.setString(2, t.getSymbol());
            pst.setString(3, t.getExchange());
            pst.setString(4, t.getName());
            pst.setString(5, t.getStatus());
            kq = pst.executeUpdate();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    public int insertAll(ArrayList<Asset> arr) throws ClassNotFoundException, SQLException {
        int dem = 0;
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();

            pst = conn.prepareStatement(INSERT);
            for (Asset t : arr) {
                pst.setString(1, t.getType());
                pst.setString(2, t.getSymbol());
                pst.setString(3, t.getExchange());
                pst.setString(4, t.getName());
                pst.setString(5, t.getStatus());

                int kq = pst.executeUpdate();
                if (kq > 0) {
                    dem++;
                }

            }

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return dem;
    }

    public int delete(Asset t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int deleteAll(ArrayList<Asset> arr) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int update(Asset t) throws ClassNotFoundException, SQLException {
        int kq = 0;
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();

            pst = conn.prepareStatement(UPDATE);
            pst.setString(1, t.getType());
            pst.setString(2, t.getSymbol());
            pst.setString(3, t.getExchange());
            pst.setString(4, t.getName());
            pst.setString(5, t.getStatus());
            pst.setBoolean(6, t.isVisible());
            pst.setInt(7, t.getAssetId());

            kq = pst.executeUpdate();
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    public Asset selectById(int t) throws ClassNotFoundException, SQLException {
        Asset kq = new Asset();
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();

            pst = conn.prepareStatement(SELECT_ID);
            pst.setInt(1, t);

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                int assetId = rs.getInt("ASSET_ID");
                String type = rs.getString("TYPE");
                String symbol = rs.getString("SYMBOL");
                String exchange = rs.getString("EXCHANGE");
                String name = rs.getString("NAME");
                String status = rs.getString("STATUS");
                boolean visible = rs.getBoolean("VISIBLE");

                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                kq = new Asset(assetId, type, symbol, exchange, name, status, visible);
                kq.setCreatedAt(createdAt);
                kq.setUpdatedAt(updatedAt);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    public ArrayList<Asset> searchAssetByStatusAndVisible(String keyword, String s, String v) throws ClassNotFoundException, SQLException {
        ArrayList<Asset> kq = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();
            StringBuilder sql = new StringBuilder(SELECT);

            if (s != null) {
                sql.append(" AND STATUS = ?");
            }
            if (v != null) {
                sql.append(" AND VISIBLE = ?");
            }
            pst = conn.prepareStatement(sql.toString());
            int cnt = 1;
            pst.setString(cnt++, "%" + keyword + "%");
            pst.setString(cnt++, "%" + keyword + "%");
            if (s != null) {
                pst.setString(cnt++, s);
            }
            if (v != null) {
                boolean isVisible = v.equals("1");
                pst.setBoolean(cnt++, isVisible);
            }

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                int assetId = rs.getInt("ASSET_ID");
                String type = rs.getString("TYPE");
                String symbol = rs.getString("SYMBOL");
                String exchange = rs.getString("EXCHANGE");
                String name = rs.getString("NAME");
                String status = rs.getString("STATUS");
                boolean visible = rs.getBoolean("VISIBLE");

                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");

                Asset asset = new Asset(assetId, type, symbol, exchange, name, status, visible);
                asset.setCreatedAt(createdAt);
                asset.setUpdatedAt(updatedAt);

                kq.add(asset);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AssetDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    public AssetHealth getAssetHealth(int assetId, String symbol) throws Exception {

        AssetHealth h = new AssetHealth();

        try ( Connection conn = JDBCUtils.getConnection()) {

            // ===== PRICE =====
            String priceSql
                    = "SELECT COUNT(*) AS total, "
                    + "MAX(TS) AS latest "
                    + "FROM PRICE_BAR "
                    + "WHERE ASSET_ID = ?";

            try ( PreparedStatement pst = conn.prepareStatement(priceSql)) {
                pst.setInt(1, assetId);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    h.setTotalPriceRecords(rs.getInt("total"));

                    Timestamp latest = rs.getTimestamp("latest");
                    if (latest != null) {
                        h.setLatestPriceDate(
                                latest.toLocalDateTime().toLocalDate()
                        );
                    }
                }
            }

            // ===== NEWS =====
            String newsSql
                    = "SELECT COUNT(*) AS total, "
                    + "MAX(TS) AS latest "
                    + "FROM NEWS_ITEM "
                    + "WHERE RELATED_SYMBOLS LIKE ?";

            try ( PreparedStatement pst = conn.prepareStatement(newsSql)) {
                pst.setString(1, "%" + symbol + "%");
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    h.setTotalNewsRecords(rs.getInt("total"));

                    Timestamp latest = rs.getTimestamp("latest");
                    if (latest != null) {
                        h.setLatestNewsDate(
                                latest.toLocalDateTime().toLocalDate()
                        );
                    }
                }
            }

        }

        determineStatus(h);
        return h;
    }

    private void determineStatus(AssetHealth h) {

        if (h.getTotalPriceRecords() == 0) {
            h.setStatus("NO_PRICE");
            return;
        }

        if (h.getTotalNewsRecords() == 0) {
            h.setStatus("NO_NEWS");
            return;
        }

        if (h.getLatestPriceDate() != null) {

            long days = ChronoUnit.DAYS.between(
                    h.getLatestPriceDate(),
                    LocalDate.now()
            );

            if (days > 7) {
                h.setStatus("FAILED");
                return;
            }

            if (days <= 2) {
                h.setStatus("HEALTHY");
                return;
            }
        }

        h.setStatus("UNKNOWN");
    }

    @Override
    public Asset selectById(Asset t) throws ClassNotFoundException, SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    
    //kiểm tra trùng symbol
    public boolean existsBySymbol(String symbol) throws Exception {
        String sql = "SELECT COUNT(*) FROM ASSET WHERE symbol = ?";
        Connection conn = JDBCUtils.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, symbol);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }
    
    public void savePriceToHistory(int assetId, double price) {
    String sql = 
        "IF NOT EXISTS ( "
      + "    SELECT 1 FROM PRICE_BAR "
      + "    WHERE ASSET_ID = ? "
      + "    AND TS >= DATEADD(MINUTE, -1, SYSDATETIME()) "
      + ") "
      + "INSERT INTO PRICE_BAR (ASSET_ID, TS, [OPEN], HIGH, LOW, [CLOSE], VOLUME, SOURCE) "
      + "VALUES (?, SYSDATETIME(), ?, ?, ?, ?, 0, 'YahooFinance')";

    Connection conn = null;
    PreparedStatement pst = null;
    try {
        conn = JDBCUtils.getConnection();
        pst = conn.prepareStatement(sql);
        pst.setInt(1, assetId);   // cho IF NOT EXISTS
        pst.setInt(2, assetId);   // cho INSERT
        pst.setDouble(3, price);  // OPEN
        pst.setDouble(4, price);  // HIGH
        pst.setDouble(5, price);  // LOW
        pst.setDouble(6, price);  // CLOSE
        pst.executeUpdate();
    } catch (Exception e) {
        System.out.println("Lỗi khi lưu lịch sử giá: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}

    public double getLatestPrice(int assetId) {
    double price = 0;

    try {
        Connection conn = JDBCUtils.getConnection();

        String sql = "SELECT TOP 1 [CLOSE] FROM PRICE_BAR "
                   + "WHERE ASSET_ID = ? ORDER BY TS DESC";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, assetId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            price = rs.getDouble("CLOSE");
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return price;
}
    //GET ASSET LIST IN THE DATABASE
    public List<Asset> getAllAssets() {

    List<Asset> list = new ArrayList<>();

    try {
        Connection conn = JDBCUtils.getConnection();

        String sql = "SELECT * FROM ASSET WHERE STATUS = 'Active' AND VISIBLE = 1";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Asset a = new Asset();

            a.setAssetId(rs.getInt("ASSET_ID"));
            a.setType(rs.getString("TYPE"));
            a.setSymbol(rs.getString("SYMBOL"));
            a.setExchange(rs.getString("EXCHANGE"));
            a.setName(rs.getString("NAME"));
            a.setStatus(rs.getString("STATUS"));
            a.setVisible(rs.getBoolean("VISIBLE"));
            a.setCreatedAt(rs.getTimestamp("CREATED_AT"));
            a.setUpdatedAt(rs.getTimestamp("UPDATED_AT"));

            list.add(a);
        }

        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
}
