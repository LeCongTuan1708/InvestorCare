/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import com.investorcare.dao.UserDAO;
import com.investorcare.model.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pc
 */
@WebServlet(name = "UserManagementController", urlPatterns = {"/UserManagementController"})
public class UserManagementController extends HttpServlet {

 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "userManagement.jsp";
        try {
            String role = request.getParameter("role");
            UserDAO userDao = new UserDAO();
            ArrayList<User> listUser;
            if(role != null && !role.isEmpty()){
                listUser = userDao.searchUsers(role);
            }else{
                listUser = userDao.selectAll();
            }
            
            request.setAttribute("LIST_USER", listUser);
        } catch (Exception e) {
            log("Error at UserManagementController: " + e.toString());
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
