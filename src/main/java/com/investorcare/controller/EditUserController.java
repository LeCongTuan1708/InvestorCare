/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.UserDAO;
import com.investorcare.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pc
 */
@WebServlet(name = "EditUserController", urlPatterns = {"/EditUserController"})
public class EditUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        UserDAO userDao = new UserDAO();
        String url = "userDetail.jsp";
        try {
            if("edit-user".equalsIgnoreCase(action)){
                int userId = Integer.parseInt(request.getParameter("userId"));
                User user = userDao.getUserById(userId);
                request.setAttribute("USER_INFO", user);
                url = "userDetail.jsp";
            }else if("update-user".equalsIgnoreCase(action)){
                int userId = Integer.parseInt(request.getParameter("userId"));
                String email = request.getParameter("email");
                String role = request.getParameter("role");
                String status = request.getParameter("status");
                String password =request.getParameter("password");
                
                User userUpdate = new User();
                userUpdate.setUserId(userId);
                userUpdate.setEmail(email);
                userUpdate.setRole(role);
                userUpdate.setStatus(status);
                userUpdate.setPassword(password);
                userDao.updateUser(userUpdate);
                url = "MainController?action=user-list";
            }
            request.getRequestDispatcher(url).forward(request, response);
        } catch (Exception e) {
            log("Error at EditUserController: " + e.toString());
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
