package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.dao.AssetDAO;
import com.investorcare.model.Alert;
import com.investorcare.model.Asset;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ShowEditAlertController", urlPatterns = {"/ShowEditAlertController"})
public class ShowEditAlertController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            AlertDAO alertDao = new AlertDAO();
            Alert alert = alertDao.selectById(alertId);
            
            // Tách dữ liệu Condition từ Message
            String rawMsg = alert.getMessage() != null ? alert.getMessage() : "";
            String condition = "PRICE_ABOVE"; // default
            String conditionValue = "";
            String userMsg = rawMsg;
            String alertName = ""; // Tuỳ chọn, nếu bạn thiết kế alertName trong msg hoặc bỏ qua

            if (rawMsg.startsWith("[CONDITION:")) {
                int end = rawMsg.indexOf("]");
                if (end > 0) {
                    String tag = rawMsg.substring(11, end);
                    String[] parts = tag.split(":");
                    if (parts.length == 2) {
                        condition = parts[0];
                        conditionValue = parts[1];
                    }
                    userMsg = rawMsg.substring(end + 1).trim();
                }
            }

            // Load danh sách asset
            AssetDAO assetDao = new AssetDAO();
            List<Asset> assets = assetDao.getAllAssets();

            request.setAttribute("alert", alert);
            request.setAttribute("assets", assets);
            request.setAttribute("condition", condition);
            request.setAttribute("conditionValue", conditionValue);
            request.setAttribute("userMsg", userMsg);
            
            request.getRequestDispatcher("editAlert.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MainController?action=dashboard");
        }
    }
}