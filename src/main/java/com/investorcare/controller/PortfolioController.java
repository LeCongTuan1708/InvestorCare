/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.PortfolioDAO;
import com.investorcare.dao.PortfolioHoldingDAO;
import com.investorcare.model.Portfolio;
import com.investorcare.model.PortfolioHolding;
import com.investorcare.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author khait
 */
@WebServlet(name = "PortfolioController", urlPatterns = {"/PortfolioController"})
public class PortfolioController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {

            User user = (User) request.getSession()
                    .getAttribute("LOGIN_USER");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String portfolioAction = request.getParameter("portfolioAction");

            PortfolioDAO portfolioDAO = new PortfolioDAO();

            /* ================= CREATE ================= */
            if ("create".equals(portfolioAction)) {

                String name = request.getParameter("portfolioName");
                int userId = Integer.parseInt(
                        request.getParameter("userId"));

                portfolioDAO.createPortfolio(userId, name);

                // reload dashboard
                response.sendRedirect("DashBoardController");
                return;
            }/* ================= RENAME ================= */
            if ("rename".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                String newName = request.getParameter("portfolioName");
                portfolioDAO.updatePortfolio(portfolioId, newName);
                response.sendRedirect("DashBoardController");
                return;
            }

            /* ================= DELETE ================= */
            if ("delete".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                portfolioDAO.deletePortfolio(portfolioId);
                response.sendRedirect("DashBoardController");
                return;
            }

            /* ================= ADD ASSET ================= */
            if ("addAsset".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                int assetId = Integer.parseInt(request.getParameter("assetId"));
                double qty = Double.parseDouble(request.getParameter("qty"));
                double avgCost = Double.parseDouble(request.getParameter("avgCost"));

                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                holdingDAO.addAsset(portfolioId, assetId, qty, avgCost);
                response.sendRedirect("DashBoardController");
                return;
            }

            /* ================= OPEN ================= */
            if ("open".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                response.sendRedirect("DashBoardController?openPortfolioId=" + portfolioId);
                return;
            }

            /* ================= REMOVE ASSET ================= */
            if ("removeAsset".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                int assetId = Integer.parseInt(request.getParameter("assetId"));

                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                holdingDAO.removeAsset(portfolioId, assetId);
                response.sendRedirect("DashBoardController?openPortfolioId=" + portfolioId);
                return;
            }

            // fallback
            response.sendRedirect("DashBoardController");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashBoardController");
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
