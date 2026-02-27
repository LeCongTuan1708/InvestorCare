/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.investorcare.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author PC
 */
public class JDBCUtils {

    public static final Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");// load driver
        String url = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=INVESTORCARE;encrypt=false;trustServerCertificate=true";
        conn = DriverManager.getConnection(url, "sa", "12345");
        return conn;
    }
}
