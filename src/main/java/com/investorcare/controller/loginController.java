/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.UserDAO;
import com.investorcare.model.User;
import java.io.IOException;;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author DELL
 */
@WebServlet(name = "loginController", urlPatterns = {"/loginController"})
public class loginController extends HttpServlet {

    private final static String USER_MANAGEMENT = "MainController?action=user-list";
    private final static String TICKER_MANAGEMENT = "MainController?action=asset-search";
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "login.jsp";
        
        try{
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            UserDAO userDao = new UserDAO();
            User loginUser = userDao.checkLogin(username, password);
            
            if(loginUser != null){
                HttpSession session = request.getSession();
                session.setAttribute("LOGIN_USER", loginUser);
                session.setAttribute("ROLE", loginUser.getRole());
                if("Admin".equalsIgnoreCase(loginUser.getRole())){
                    response.sendRedirect(USER_MANAGEMENT);
                }else{
                    response.sendRedirect(TICKER_MANAGEMENT); 
                }
                return;
            }else{
                request.setAttribute("ERROR", "Incorrect Username or Password!");
            }
        }catch(Exception e){
            log("Error at loginController" + e.toString());
        }
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
