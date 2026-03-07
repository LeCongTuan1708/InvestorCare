package com.investorcare.controller;

import com.investorcare.dao.AlertDAO;
import com.investorcare.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteAlertController", urlPatterns = {"/DeleteAlertController"})
public class DeleteAlertController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_USER") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            AlertDAO dao = new AlertDAO();
            dao.deleteAlert(alertId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("MainController?action=dashboard");
    }
}