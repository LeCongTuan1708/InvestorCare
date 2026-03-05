/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.dao.AssetDAO;
import com.investorcare.dao.PortfolioDAO;
import com.investorcare.dao.PortfolioHoldingDAO;
import com.investorcare.dao.PriceBarDAO;
import com.investorcare.model.Asset;
import com.investorcare.model.Portfolio;
import com.investorcare.model.PortfolioHolding;
import com.investorcare.model.PriceBar;
import com.investorcare.model.User;
import com.investorcare.service.SignalEngine;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.StockAPIService;

/**
 *
 * @author khait
 */
@WebServlet(name = "DashBoardController", urlPatterns = {"/DashBoardController"})
public class DashBoardController extends HttpServlet {

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
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        //LOAD PORTFOLIO LIST
        User user = (User) session.getAttribute("LOGIN_USER");
        PortfolioDAO portfolioDAO = new PortfolioDAO();

        List<Portfolio> portfolios = null;

        try {
            portfolios = portfolioDAO.getPortfolioByUser(user.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!"User".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        //LOAD ASSETS LIST 
        // 1. Lấy danh sách tài sản từ DB
        AssetDAO dao = new AssetDAO();
        List<Asset> list = dao.getAllAssets();

        // 2. Gom tất cả Symbol vào một danh sách
        List<String> symbols = new ArrayList<>();
        for (Asset a : list) {
            symbols.add(a.getSymbol());
        }

        // 3. Gọi Finnhub API
        Map<String, Double> apiPrices = new HashMap<>();
        try {
            apiPrices = StockAPIService.getBatchPrices(symbols);
            System.out.println(">>> API RESULT SIZE: " + apiPrices.size());
            System.out.println(">>> API MAP: " + apiPrices);
        } catch (Exception e) {
            System.out.println(">>> API lỗi: " + e.getMessage());
        }

// 4. Map price + lưu DB
        Map<Integer, Double> priceMapForJSP = new HashMap<>();
        PriceBarDAO pbDao = new PriceBarDAO();
        for (Asset a : list) {
            Double price = apiPrices.getOrDefault(a.getSymbol(), 0.0);
            priceMapForJSP.put(a.getAssetId(), price);

            if (price > 0) {
                try {

                    
                    PriceBar latest = pbDao.getLatest(a.getAssetId());

                    if (latest == null || latest.getClose() != price) {
                        dao.savePriceToHistory(a.getAssetId(), price);

                        SignalEngine engine = new SignalEngine();
                        engine.checkVolatility(a.getAssetId(), user.getUserId());
                    }

                } catch (Exception e) {
                    System.out.println(">>> Lỗi lưu price: " + e.getMessage());
                }
            }
        }

        request.setAttribute("assets", list);
        request.setAttribute("prices", priceMapForJSP);
        request.setAttribute("portfolios", portfolios);

// THÊM: load holdings nếu user bấm mở portfolio
        String openParam = request.getParameter("openPortfolioId");
        System.out.println(">>> openPortfolioId param = " + openParam); // DEBUG
        if (openParam != null) {
            try {
                int openPortfolioId = Integer.parseInt(openParam);
                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                List<PortfolioHolding> holdings = holdingDAO.getHoldingsByPortfolio(openPortfolioId);
                System.out.println(">>> holdings size = " + holdings.size()); // DEBUG
                request.setAttribute("holdings", holdings);
                request.setAttribute("openPortfolioId", openPortfolioId);
            } catch (Exception e) {
                System.out.println(">>> ERROR loading holdings: " + e.getMessage()); // DEBUG
                e.printStackTrace();
            }
        }

        AlertDAO alertDAO = new AlertDAO();

        try {
            request.setAttribute("alerts",
                    alertDAO.getAlertsByUser(user.getUserId()));

            request.setAttribute("unreadCount",
                    alertDAO.countUnread(user.getUserId()));

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("userDashboard.jsp").forward(request, response);
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
