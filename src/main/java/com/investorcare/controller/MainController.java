/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.investorcare.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author DELL
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

  
    private static final String ERROR = "error.jsp";
    private static final String LOGIN = "login";
    private static final String LOGIN_CONTROLLER = "loginController";
    private static final String SIGNUP = "signup";
    private static final String SIGNUP_CONTROLLER = "SignupController";
    private static final String USER_LIST = "user-list";
    private static final String USER_MANAGEMENT = "UserManagementController";
    

    private static final String SEARCH_ASSET = "asset-search";
    private static final String SEARCH_ASSET_Controller = "AssetListController";

    private static final String ADD_ASSET = "add-asset";
    private static final String ADD_ASSET_Controller = "addAssetController";
    
    private static final String EDIT_ASSET = "edit-asset";
    private static final String EDIT_ASSET_Controller = "editAssetController";


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            String action = request.getParameter("action");
            if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            } else if (SEARCH_ASSET.equals(action)) {
                url = SEARCH_ASSET_Controller;
            } else if (ADD_ASSET.equals(action)) {
                url = ADD_ASSET_Controller;
            
            } else if (EDIT_ASSET.equals(action)) {
                url = EDIT_ASSET_Controller;
            }
            else if(SIGNUP.equals(action)){
                url = SIGNUP_CONTROLLER;
            }
            else if(USER_LIST.equals(action)){
                url = USER_MANAGEMENT;
            }
            else{
                request.setAttribute("ERROR", "Your action not support");
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
