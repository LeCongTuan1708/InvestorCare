package com.investorcare.controller;

import com.investorcare.dao.AssetDAO;
import com.investorcare.dao.UserDAO;
import com.investorcare.model.Asset;
import com.investorcare.model.User;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "loginController", urlPatterns = {"/loginController"})
public class loginController extends HttpServlet {

    // Gom đủ 3 link xịn qua MainController
    private final static String USER_MANAGEMENT = "MainController?action=user-list";
    private final static String TICKER_MANAGEMENT = "MainController?action=asset-search";
    private final static String USER_DASHBOARD = "MainController?action=dashboard";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "login.jsp";

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            UserDAO userDao = new UserDAO();
            User loginUser = userDao.checkLogin(username, password);

            if (loginUser != null) {
                java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                String currentTime = dtf.format(java.time.LocalDateTime.now());
                String lastLoginTime = "First time login";
                
                javax.servlet.http.Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (javax.servlet.http.Cookie cookie : cookies) {
                        if (cookie.getName().equals("lastLogin_" + loginUser.getUsername())) {
                            lastLoginTime = java.net.URLDecoder.decode(cookie.getValue(), "UTF-8");
                            break;
                        }
                    }
                }
                loginUser.setLastLogin(lastLoginTime);
                
                javax.servlet.http.Cookie loginCookie = new javax.servlet.http.Cookie("lastLogin_" + loginUser.getUsername(), java.net.URLEncoder.encode(currentTime, "UTF-8"));
                loginCookie.setMaxAge(60 * 60 * 24 * 30); // Cookie sống trong 30 ngày
                response.addCookie(loginCookie);
                
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", loginUser);
                session.setAttribute("ROLE", loginUser.getRole());

                if ("Admin".equalsIgnoreCase(loginUser.getRole())) {
                    response.sendRedirect(USER_MANAGEMENT);
                    return;
                } else if ("User".equalsIgnoreCase(loginUser.getRole())) {
                    response.sendRedirect(USER_DASHBOARD);
                    return;
                } else {
                    response.sendRedirect(USER_MANAGEMENT);
                    return;
                }
            } else {
                request.setAttribute("ERROR", "Incorrect Username or Password!");
            }
        } catch (Exception e) {
            log("Error at loginController: " + e.toString());
        }

        // Trả về login.jsp nếu đăng nhập tạch
        request.getRequestDispatcher(url).forward(request, response);
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
