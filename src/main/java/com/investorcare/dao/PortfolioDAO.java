/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.dao;

import com.investorcare.model.Portfolio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author khait
 */



public class PortfolioDAO {

    // =============================
    // GET USER PORTFOLIOS
    // =============================
    public List<Portfolio> getPortfolioByUser(int userId)
        throws Exception {

    List<Portfolio> list = new ArrayList<>();

    String sql =
        "SELECT PORTFOLIO_ID, USER_ID, NAME " +
        "FROM PORTFOLIO " +
        "WHERE USER_ID=? " +
        "ORDER BY PORTFOLIO_ID DESC";

    Connection con = JDBCUtils.getConnection();
    PreparedStatement ps = con.prepareStatement(sql);

    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {

        Portfolio p = new Portfolio(
                rs.getInt("PORTFOLIO_ID"),
                rs.getInt("USER_ID"),
                rs.getString("NAME")
        );

        list.add(p);
    }

    return list;
}

    // =============================
    // CREATE
    // =============================
    public boolean createPortfolio(int userId, String name)
            throws Exception {

        String sql =
        "INSERT INTO PORTFOLIO(USER_ID, NAME) VALUES (?,?)";

        Connection con = JDBCUtils.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, userId);
        ps.setString(2, name);

        return ps.executeUpdate() > 0;
    }

    // =============================
    // UPDATE NAME
    // =============================
    public boolean updatePortfolio(int id, String name)
            throws Exception {

        String sql =
        "UPDATE PORTFOLIO SET NAME=? WHERE PORTFOLIO_ID=?";

        Connection con = JDBCUtils.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, name);
        ps.setInt(2, id);

        return ps.executeUpdate() > 0;
    }

    // =============================
    // DELETE
    // =============================
    public boolean deletePortfolio(int id) throws Exception {
    Connection con = JDBCUtils.getConnection();

    // Xoá holdings trước
    String sqlHolding = "DELETE FROM PORTFOLIO_HOLDING WHERE PORTFOLIO_ID=?";
    PreparedStatement ps1 = con.prepareStatement(sqlHolding);
    ps1.setInt(1, id);
    ps1.executeUpdate();

    // Sau đó mới xoá portfolio
    String sqlPortfolio = "DELETE FROM PORTFOLIO WHERE PORTFOLIO_ID=?";
    PreparedStatement ps2 = con.prepareStatement(sqlPortfolio);
    ps2.setInt(1, id);
    return ps2.executeUpdate() > 0;
}
    
    
}

