/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.dao;

import com.investorcare.model.Asset;
import com.investorcare.model.WatchList;
import com.investorcare.model.WatchListItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author quyt2
 */
public class WatchListItemDAO {
    private final String INSERT = "INSERT INTO WATCHLIST_ITEM (WATCHLIST_ID, ASSET_ID) VALUES (?, ?)";
    
    private final String DELETE = "DELETE FROM WATCHLIST_ITEM WHERE ITEM_ID = ?";
    
    private final String SELECT_BY_WATCHLIST
            = "SELECT w.ITEM_ID, w.WATCHLIST_ID, w.ASSET_ID, w.ADDED_AT, "
            + "a.SYMBOL, a.NAME, a.TYPE "
            + "FROM WATCHLIST_ITEM w "
            + "JOIN ASSET a ON w.ASSET_ID = a.ASSET_ID "
            + "WHERE w.WATCHLIST_ID = ?";
    
    
    public boolean insert(WatchListItem watchListItem) throws SQLException {
        boolean checkInsert = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = JDBCUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(INSERT);
                ptm.setInt(1, watchListItem.getWatchListId());
                ptm.setInt(2, watchListItem.getAssetId());
                checkInsert = ptm.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return checkInsert;
    }
    
        
        
        
    public boolean deleteWatchListItem(int itemId) throws SQLException {
        boolean checkDelete = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = JDBCUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(DELETE);
                ptm.setInt(1, itemId);
                checkDelete = ptm.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return checkDelete;

    }
    
    public List<WatchListItem> getItemsByWatchListId(int watchListId) throws SQLException {
        List<WatchListItem> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SELECT_BY_WATCHLIST);
                ptm.setInt(1, watchListId);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    
                    WatchListItem item = new WatchListItem();
                    item.setItemId(rs.getInt("ITEM_ID"));
                    item.setWatchListId(rs.getInt("WATCHLIST_ID"));
                    item.setAssetId(rs.getInt("ASSET_ID"));
                    item.setAddedAt(rs.getTimestamp("ADDED_AT"));

                    Asset asset = new Asset();
                    asset.setAssetId(rs.getInt("ASSET_ID"));
                    asset.setSymbol(rs.getString("SYMBOL"));
                    asset.setName(rs.getString("NAME"));
                    asset.setType(rs.getString("TYPE"));

                    item.setAsset(asset);

                    list.add(item);
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return list;

    }
    
    public boolean checkItemExists(int watchListId, int assetId) throws SQLException {
        boolean isExist = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        String sql = "SELECT 1 FROM WATCHLIST_ITEM WHERE WATCHLIST_ID = ? AND ASSET_ID = ?";

        try {
            conn = JDBCUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(sql);
                ptm.setInt(1, watchListId);
                ptm.setInt(2, assetId);
                rs = ptm.executeQuery();

                // Nếu rs.next() trả về true nghĩa là đã có dòng dữ liệu trùng
                if (rs.next()) {
                    isExist = true;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return isExist;
    }
    
}
