package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.model.Alert;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateAlertController", urlPatterns = {"/UpdateAlertController"})
public class UpdateAlertController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            String alertName = request.getParameter("alertName");
            String alertMessage = request.getParameter("alertMessage");
            String condition = request.getParameter("condition");
            String conditionValue = request.getParameter("conditionValue");
            int assetId = Integer.parseInt(request.getParameter("assetId"));
            String severity = request.getParameter("severity");
            String status = request.getParameter("status");

            // Format lại chuỗi message
            String finalMsg = "[CONDITION:" + condition + ":" + conditionValue + "] " + 
                              (alertName != null && !alertName.isEmpty() ? alertName + " - " : "") + alertMessage;

            AlertDAO alertDao = new AlertDAO();
            Alert alert = alertDao.selectById(alertId);
            if (alert != null) {
                alert.setAssetId(assetId);
                alert.setSeverity(severity);
                alert.setMessage(finalMsg);
                alert.setStatus(status);
                alertDao.updateAlert(alert);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("MainController?action=dashboard");
    }
}