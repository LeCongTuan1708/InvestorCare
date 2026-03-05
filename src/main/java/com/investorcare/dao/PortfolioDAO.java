package com.investorcare.dao;

import com.investorcare.model.Portfolio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PortfolioDAO {

    // =============================
    // GET USER PORTFOLIOS
    // =============================
    public List<Portfolio> getPortfolioByUser(int userId) throws Exception {
        String sql = "SELECT PORTFOLIO_ID, USER_ID, NAME "
                   + "FROM PORTFOLIO "
                   + "WHERE USER_ID = ? "
                   + "ORDER BY PORTFOLIO_ID DESC";
        List<Portfolio> list = new ArrayList<>();
        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Portfolio(
                            rs.getInt("PORTFOLIO_ID"),
                            rs.getInt("USER_ID"),
                            rs.getString("NAME")
                    ));
                }
            }
        }
        return list;
    }

    // =============================
    // CREATE
    // =============================
    public boolean createPortfolio(int userId, String name) throws Exception {
        String sql = "INSERT INTO PORTFOLIO(USER_ID, NAME) VALUES (?, ?)";
        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, name);
            return ps.executeUpdate() > 0;
        }
    }

    // =============================
    // UPDATE NAME
    // =============================
    public boolean updatePortfolio(int id, String name) throws Exception {
        String sql = "UPDATE PORTFOLIO SET NAME = ? WHERE PORTFOLIO_ID = ?";
        try (Connection con = JDBCUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // =============================
    // DELETE (xoá holdings trước, rồi mới xoá portfolio)
    // =============================
    public boolean deletePortfolio(int id) throws Exception {
        // Dùng cùng 1 connection cho cả 2 DELETE để đảm bảo nhất quán
        try (Connection con = JDBCUtils.getConnection()) {
            // Xoá holdings trước
            try (PreparedStatement ps1 = con.prepareStatement(
                    "DELETE FROM PORTFOLIO_HOLDING WHERE PORTFOLIO_ID = ?")) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }
            // Sau đó xoá portfolio
            try (PreparedStatement ps2 = con.prepareStatement(
                    "DELETE FROM PORTFOLIO WHERE PORTFOLIO_ID = ?")) {
                ps2.setInt(1, id);
                return ps2.executeUpdate() > 0;
            }
        }
    }
}