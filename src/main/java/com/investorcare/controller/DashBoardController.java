package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.dao.AssetDAO;
import com.investorcare.dao.PortfolioDAO;
import com.investorcare.dao.PortfolioHoldingDAO;
import com.investorcare.dao.PriceBarDAO;
import com.investorcare.model.Asset;
import com.investorcare.model.AssetQuote;
import com.investorcare.model.Portfolio;
import com.investorcare.model.PortfolioHolding;
import com.investorcare.model.PriceBar;
import com.investorcare.model.User;
import com.investorcare.service.SignalEngine;
import java.io.IOException;
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

@WebServlet(name = "DashBoardController", urlPatterns = {"/DashBoardController"})
public class DashBoardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("LOGIN_USER");

        if (!"User".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        // ── 1. Load portfolios ──
        PortfolioDAO portfolioDAO = new PortfolioDAO();
        List<Portfolio> portfolios = null;

        try {
            portfolios = portfolioDAO.getPortfolioByUser(user.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ── 2. Load assets ──
        AssetDAO assetDAO = new AssetDAO();
        List<Asset> assets = assetDAO.getAllAssets();

        // ── 3. Gom symbols ──
        List<String> symbols = new ArrayList<>();
        for (Asset a : assets) {
            symbols.add(a.getSymbol());
        }

        // ── 4. Gọi API → Map<symbol, AssetQuote> ──
        Map<String, AssetQuote> apiQuotes = new HashMap<>();

        try {
            apiQuotes = StockAPIService.getBatchQuotes(symbols);
        } catch (Exception e) {
            System.out.println(">>> API error: " + e.getMessage());
        }

        // ── 5. Build Map<assetId, AssetQuote> cho JSP + lưu price history ──
        Map<Integer, AssetQuote> quoteMap = new HashMap<>();

        PriceBarDAO priceBarDAO = new PriceBarDAO();
        SignalEngine engine = new SignalEngine();

        for (Asset a : assets) {

            AssetQuote q = apiQuotes.getOrDefault(a.getSymbol(), new AssetQuote());
            quoteMap.put(a.getAssetId(), q);

            if (q.getCurrentPrice() > 0) {

                try {

                    PriceBar latest = priceBarDAO.getLatest(a.getAssetId());

                    if (latest == null || latest.getClose() != q.getCurrentPrice()) {

                        assetDAO.savePriceToHistory(a.getAssetId(), q.getCurrentPrice());

                        // Trigger Signal + Alert system
                        engine.checkVolatility(a.getAssetId(), user.getUserId());

                    }

                } catch (Exception e) {
                    System.out.println(">>> Save price error: " + e.getMessage());
                }

            }
        }

        request.setAttribute("assets", assets);
        request.setAttribute("quotes", quoteMap);
        request.setAttribute("portfolios", portfolios);

        // ── 6. Load holdings nếu user mở portfolio ──
        String openParam = request.getParameter("openPortfolioId");

        if (openParam != null) {

            try {

                int openPortfolioId = Integer.parseInt(openParam);

                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                List<PortfolioHolding> holdings
                        = holdingDAO.getHoldingsByPortfolio(openPortfolioId);

                request.setAttribute("holdings", holdings);
                request.setAttribute("openPortfolioId", openPortfolioId);

            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        // ── 7. Load Alerts ──
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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        processRequest(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        processRequest(req, res);
    }
}