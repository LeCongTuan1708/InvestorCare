/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.investorcare.dao;

import com.investorcare.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author pc
 */
public class UserDAO {

    private final static String CHECK_lOGIN = "SELECT * FROM [USER] WHERE USERNAME = ? AND PASSWORD = ?";
    private final static String SIGN_UP = "INSERT INTO [USER] (USERNAME, EMAIL, PASSWORD, ROLE, STATUS) VALUES (?, ?, ?, 'User', 'Active')";
    private final static String SELECT_ALL = "SELECT * FROM [USER]";

    public User checkLogin(String username, String password) throws Exception {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(CHECK_lOGIN);
            pst.setString(1, username);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("USERNAME"));
                user.setPassword(rs.getString("PASSWORD"));
                user.setRole(rs.getString("ROLE"));
                user.setUserId(rs.getInt("USER_ID"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean singUp(User user) throws Exception {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(SIGN_UP);
            pst.setString(1, user.getUsername());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static ArrayList<User> selectAll() {
        ArrayList<User> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(SELECT_ALL);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(new User(rs.getInt("USER_ID"),
                        rs.getString("USERNAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PASSWORD"),
                        rs.getString("ROLE"),
                        rs.getString("STATUS"),
                        rs.getString("LASTLOGIN")));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<User> searchUsers(String role) {
        Connection conn = null;
        PreparedStatement pst = null;
        ArrayList<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [USER] WHERE 1=1";
        if (role != null && !role.isEmpty()) {
            sql += " AND ROLE = ?";
        }

        try  {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(sql);
            if (role != null && !role.isEmpty()) {
                pst.setString(1, role);
            }
            ResultSet rs = pst.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("USER_ID"),
                        rs.getString("USERNAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PASSWORD"),
                        rs.getString("ROLE"),
                        rs.getString("STATUS"),
                        rs.getString("LASTLOGIN")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
