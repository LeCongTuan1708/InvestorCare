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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "editAssetController", urlPatterns = {"/editAssetController"})
public class editAssetController extends HttpServlet {

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
        String idStr = request.getParameter("assetId");
        int assetId = Integer.parseInt(idStr);
        String symbol = request.getParameter("symbol");
        if (symbol == null){
            try {
                Asset oldAsset = dao.selectById(assetId);
                
                request.setAttribute("oldAsset", oldAsset);
                
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/assetDetail.jsp");
                rd.forward(request, response);
                return;
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(editAssetController.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(editAssetController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        String type = request.getParameter("type");
        String exchange = request.getParameter("exchange");
        String name = request.getParameter("name");
        String visible = request.getParameter("visible");
        boolean isvisible = "1".equals(visible);
        String status = request.getParameter("status");
        
        Asset updateAsset = new Asset(assetId, type, symbol, exchange, name, status, isvisible);
        try {
            dao.update(updateAsset);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(editAssetController.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(editAssetController.class.getName()).log(Level.SEVERE, null, ex);
        }
        response.sendRedirect("AssetListController");
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
