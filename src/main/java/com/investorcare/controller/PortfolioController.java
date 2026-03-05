package com.investorcare.controller;

import com.investorcare.dao.PortfolioDAO;
import com.investorcare.dao.PortfolioHoldingDAO;
import com.investorcare.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PortfolioController", urlPatterns = {"/PortfolioController"})
public class PortfolioController extends HttpServlet {

    // Redirect về MainController thay vì gọi thẳng DashBoardController
    private static final String DASHBOARD = "MainController?action=dashboard";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            // Lấy user từ SESSION - không tin form input
            User user = (User) request.getSession().getAttribute("LOGIN_USER");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String portfolioAction = request.getParameter("portfolioAction");
            PortfolioDAO portfolioDAO = new PortfolioDAO();

            /* ================= CREATE ================= */
            if ("create".equals(portfolioAction)) {
                String name = request.getParameter("portfolioName");
                // FIX: lấy userId từ session, không từ hidden input
                int userId = user.getUserId();
                portfolioDAO.createPortfolio(userId, name);
                response.sendRedirect(DASHBOARD);
                return;
            }

            /* ================= RENAME ================= */
            if ("rename".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                String newName = request.getParameter("portfolioName");
                portfolioDAO.updatePortfolio(portfolioId, newName);
                response.sendRedirect(DASHBOARD);
                return;
            }

            /* ================= DELETE ================= */
            if ("delete".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                portfolioDAO.deletePortfolio(portfolioId);
                response.sendRedirect(DASHBOARD);
                return;
            }

            /* ================= ADD ASSET ================= */
            if ("addAsset".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                int assetId     = Integer.parseInt(request.getParameter("assetId"));
                double qty      = Double.parseDouble(request.getParameter("qty"));
                double avgCost  = Double.parseDouble(request.getParameter("avgCost"));

                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                holdingDAO.addAsset(portfolioId, assetId, qty, avgCost);
                response.sendRedirect(DASHBOARD);
                return;
            }

            /* ================= OPEN ================= */
            if ("open".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                response.sendRedirect(DASHBOARD + "&openPortfolioId=" + portfolioId);
                return;
            }

            /* ================= REMOVE ASSET ================= */
            if ("removeAsset".equals(portfolioAction)) {
                int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));
                int assetId     = Integer.parseInt(request.getParameter("assetId"));

                PortfolioHoldingDAO holdingDAO = new PortfolioHoldingDAO();
                holdingDAO.removeAsset(portfolioId, assetId);
                response.sendRedirect(DASHBOARD + "&openPortfolioId=" + portfolioId);
                return;
            }

            // fallback
            response.sendRedirect(DASHBOARD);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(DASHBOARD);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}