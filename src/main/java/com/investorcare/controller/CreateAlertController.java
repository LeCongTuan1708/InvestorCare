package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.dao.AssetDAO;
import com.investorcare.model.Alert;
import com.investorcare.model.Asset;
import com.investorcare.model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CreateAlertController", urlPatterns = {"/CreateAlertController"})
public class CreateAlertController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("LOGIN_USER");

        // ── Load asset list cho dropdown ──
        AssetDAO assetDAO = new AssetDAO();
        List<Asset> assets = assetDAO.getAllAssets();
        request.setAttribute("assets", assets);

        String method = request.getMethod();

        // GET → chỉ hiển thị form
        if ("GET".equalsIgnoreCase(method)) {
            request.getRequestDispatcher("createAlert.jsp").forward(request, response);
            return;
        }

        // POST → xử lý tạo alert
        try {
            String alertName     = request.getParameter("alertName");
            String alertMessage  = request.getParameter("alertMessage");
            String condition     = request.getParameter("condition");
            String condValueStr  = request.getParameter("conditionValue");
            String assetIdStr    = request.getParameter("assetId");
            String severity      = request.getParameter("severity");

            // Validation
            if (alertName == null || alertName.trim().isEmpty()) {
                request.setAttribute("ERROR", "Alert name is required.");
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                return;
            }
            if (assetIdStr == null || assetIdStr.trim().isEmpty()) {
                request.setAttribute("ERROR", "Please select a symbol.");
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                return;
            }
            if (condValueStr == null || condValueStr.trim().isEmpty()) {
                request.setAttribute("ERROR", "Condition value is required.");
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
                return;
            }

            int    assetId    = Integer.parseInt(assetIdStr);
            double condValue  = Double.parseDouble(condValueStr);

            // Build message nếu user không điền
            if (alertMessage == null || alertMessage.trim().isEmpty()) {
                alertMessage = alertName;
            }

            // Gộp condition + value vào message để lưu DB
            // Format: "[CONDITION:PRICE_ABOVE:200.0] User message"
            String fullMessage = "[CONDITION:" + condition + ":" + condValue + "] " + alertMessage.trim();

            Alert alert = new Alert();
            alert.setUserId(user.getUserId());
            alert.setAssetId(assetId);
            alert.setSeverity(severity != null ? severity : "LOW");
            alert.setMessage(fullMessage);
            alert.setStatus("NEW");
            alert.setTimestamp(new Timestamp(System.currentTimeMillis()));

            AlertDAO alertDAO = new AlertDAO();
            int result = alertDAO.insertAlert(alert);

            if (result > 0) {
                response.sendRedirect("MainController?action=dashboard");
            } else {
                request.setAttribute("ERROR", "Failed to create alert. Please try again.");
                request.getRequestDispatcher("createAlert.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("ERROR", "Invalid number format.");
            request.getRequestDispatcher("createAlert.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("ERROR", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("createAlert.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
}