/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.AssetDAO;
import com.investorcare.model.Asset;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "addAssetController", urlPatterns = {"/addAssetController"})
public class addAssetController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        AssetDAO dao = new AssetDAO();
        
        String symbol = request.getParameter("symbol");
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String exchange = request.getParameter("exchange");
        String status = "Active";
        
        try {
            int checkName = dao.selectByName(name);
            if( checkName !=0 ){
            request.setAttribute("ERROR", "Lỗi: sản phẩm " + name + " đã tồn tại!");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(addAssetController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addAssetController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        
        
        //Lấy thời gian thực lúc tạo mới 
        Timestamp now = new Timestamp(System.currentTimeMillis());
        
        Asset asset = new Asset(type, symbol, exchange, name, status , true, now, now);
        try {
            dao.insert(asset);
            response.sendRedirect("MainController?action=asset-search");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(addAssetController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(addAssetController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
