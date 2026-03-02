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
                        rs.getString("CREATED_AT")));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<User> searchUsers(String keyword, String role, String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ArrayList<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [USER] WHERE 1=1";
        if(keyword != null && !keyword.trim().isEmpty()){
            sql += " AND USERNAME LIKE ?";
        }
        if (role != null && !role.isEmpty()) {
            sql += " AND ROLE = ?";
        }
        if ( status != null && !status.isEmpty()) {
            sql += " AND STATUS = ?";
        }
        
        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(sql);
            // 2. DÙNG BIẾN ĐẾM ĐỂ TRUYỀN THAM SỐ TỰ ĐỘNG
            int paramIndex = 1; 
            if(keyword != null && !keyword.trim().isEmpty()){
                pst.setString(paramIndex, "%" + keyword.trim() + "%");
                paramIndex++;
            }
            
            if (role != null && !role.isEmpty()) {
                pst.setString(paramIndex, role);
                paramIndex++; // Truyền xong thì tăng vị trí lên 1
            }
            
            if (status != null && !status.isEmpty()) {
                pst.setString(paramIndex, status);
                paramIndex++; // Đảm bảo luôn truyền vào đúng vị trí dấu ? đang có
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
                        rs.getString("CREATED_AT")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<User> searchUsers(String role) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    // lay thong tin cua 1 user dua vao id
    public User getUserById(int userId){
        Connection conn = null;
        PreparedStatement pst = null;
        String sql = "SELECT * FROM [USER] WHERE USER_ID = ?";
        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(sql);
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();
            
            if(rs.next()){
                return new User(
                        rs.getInt("USER_ID"),
                        rs.getString("USERNAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PASSWORD"),
                        rs.getString("ROLE"),
                        rs.getString("STATUS"),
                        rs.getString("CREATED_AT")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }         
    
    //cập nhật thông tin user (không cho sửa username)
    public boolean updateUser(User user){
        Connection conn = null;
        PreparedStatement pst = null;
        String sql = "UPDATE [USER] SET EMAIL = ?, ROLE = ?, STATUS = ? WHERE USER_ID = ?";
        try {
            conn = JDBCUtils.getConnection();
            pst = conn.prepareStatement(sql);
            pst.setString(1, user.getEmail());
            pst.setString(2, user.getRole());
            pst.setString(3, user.getStatus());
            pst.setInt(4, user.getUserId());
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
