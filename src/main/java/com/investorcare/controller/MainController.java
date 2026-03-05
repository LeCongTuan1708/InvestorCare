package com.investorcare.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String LOGIN = "login";
    private static final String LOGIN_CONTROLLER = "loginController";
    private static final String SIGNUP = "signup";
    private static final String SIGNUP_CONTROLLER = "SignupController";
    private static final String USER_LIST = "user-list";
    private static final String USER_MANAGEMENT = "UserManagementController";
    private static final String LOGOUT = "logout";
    // Gộp khai báo biến của m và nhánh main
    private static final String WATCH_LIST = "watch-list";
    private static final String WATCH_LIST_CONTROLLER = "WatchListController";
    private static final String EDIT_USER = "edit-user";
    private static final String UPDATE_USER = "update-user";
    private static final String EDIT_USER_CONTROLLER = "EditUserController";
    private static final String SEARCH_ASSET = "asset-search";
    private static final String SEARCH_ASSET_Controller = "AssetListController";
    private static final String ADD_ASSET = "add-asset";
    private static final String ADD_ASSET_Controller = "addAssetController";
    private static final String EDIT_ASSET = "edit-asset";
    private static final String EDIT_ASSET_controller = "editAssetController";
    private static final String ADD_ASSET_BUTTON = "add-asset-button";
    private static final String ADD_ASSET_JSP = "insertAsset.jsp";
    private static final String EDIT_ASSET_Controller = "editAssetController";
    private static final String EDIT_PROFILE = "editProfile";
    private static final String EDIT_PROFILE_CONTROLLER = "EditProfileController";
    private static final String UPDATE_PROFILE = "UpdateProfile";
    private static final String UPDATE_PROFILE_CONTROLLER = "UpdateProfileController";
    private static final String PORTFOLIO = "portfolio";
    private static final String PORTFOLIO_CONTROLLER = "PortfolioController";
    private static final String USER_DASHBOARD="dashboard";
    private static final String USER_DASHBOARD_CONTROLLER="DashBoardController";

    private static final String LOGOUT_Controller = "logoutController";

    private static final String EDIT_WATCHLIST = "edit-watchlist";
    private static final String EDIT_WATCHLIST_CONTROLLER = "EditWatchListController";
    private static final String SHOW_EDIT_WATCHLIST = "show-edit-watchlist";

    private static final String SHOW_ADD_WATCHLIST = "show-add-watchlist";
    private static final String ADD_WATCHLIST_CONTROLLER = "AddWatchListController";
    private static final String ADD_WATCHLIST = "add-watchlist";

    private final static String WATCHLIST_ITEM = "watchlist-item";
    private static final String WATCHLIST_ITEM_CONTROLLER = "WatchListItemController";

    private static final String SHOW_ADD_ITEM = "show-add-item";
    private static final String SHOW_ADD_ITEM_CONTROLLER = "ShowAddWatchListItemController";
    private static final String ADD_ITEM = "add-item";
    private static final String ADD_ITEM_CONTROLLER = "AddWatchListItemController";

    private static final String REMOVE_ITEM = "remove-item";
    private static final String REMOVE_ITEM_CONTROLLER = "RemoveWatchListItemController";

    private static final String REMOVE_WATCHLIST = "remove-watchlist";
    private static final String REMOVE_WATCHLIST_CONTROLLER = "RemoveWatchListController";

    private static final String CARE_NOTE_LIST = "care-note-list";
    private static final String CARE_NOTE_LIST_CONTROLLER = "CareNoteListController";

    private static final String SHOW_ADD_CARE_NOTE_LIST = "show-add-care-note";
    private static final String SHOW_ADD_CARE_NOTE_LIST_CONTROLLER = "ShowAddCareNoteController";
    private static final String ADD_CARE_NOTE = "add-care-note";
    private static final String ADD_CARE_NOTE_CONTROLLER = "AddCareNoteController";

    private static final String SHOW_EDIT_CARE_NOTE_LIST = "show-edit-care-note";
    private static final String SHOW_EDIT_CARE_NOTE_LIST_CONTROLLER = "ShowEditCareNoteController";
    private static final String EDIT_CARE_NOTE = "edit-care-note";
    private static final String EDIT_CARE_NOTE_CONTROLLER = "EditCareNoteController";

    private static final String REMOVE_CARE_NOTE = "remove-care-note";
    private static final String REMOVE_CARE_NOTE_CONTROLLER = "RemoveCareNoteController";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            String action = request.getParameter("action");
            if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            } else if (SEARCH_ASSET.equals(action)) {
                url = SEARCH_ASSET_Controller;
            } else if (ADD_ASSET_BUTTON.equals(action)) {
                url = ADD_ASSET_JSP;
            } else if (ADD_ASSET.equals(action)) {
                url = ADD_ASSET_Controller;

            } else if (EDIT_ASSET.equals(action)) {
                url = EDIT_ASSET_Controller;
            } else if (SIGNUP.equals(action)) {
                url = SIGNUP_CONTROLLER;
            } else if (USER_LIST.equals(action)) {
                url = USER_MANAGEMENT;

            } else if (EDIT_PROFILE.equals(action)) {
                url = EDIT_PROFILE_CONTROLLER;
            } else if (UPDATE_PROFILE.equals(action)) {
                url = UPDATE_PROFILE_CONTROLLER;
            } else if (PORTFOLIO.equals(action)) {
                url = PORTFOLIO_CONTROLLER;
            }else if(USER_DASHBOARD.equals(action)){
                url =USER_DASHBOARD_CONTROLLER;
            
            }else if (WATCH_LIST.equals(action)) {
                url = WATCH_LIST_CONTROLLER;
            } else if (EDIT_WATCHLIST.equals(action)) {
                url = EDIT_WATCHLIST_CONTROLLER;
            } else if (SHOW_EDIT_WATCHLIST.equals(action)) {
                url = "editWatchList.jsp";
            } else if (ADD_WATCHLIST.equals(action)) {
                url = ADD_WATCHLIST_CONTROLLER;
            } else if (SHOW_ADD_WATCHLIST.equals(action)) {
                url = "addWatchList.jsp";
            } else if (USER_DASHBOARD.equals(action)) {
                url = "userDashboard.jsp";
            } else if (WATCHLIST_ITEM.equals(action)) {
                url = WATCHLIST_ITEM_CONTROLLER;
            } else if (SHOW_ADD_ITEM.equals(action)) {
                url = SHOW_ADD_ITEM_CONTROLLER;
            } else if (ADD_ITEM.equals(action)) {
                url = ADD_ITEM_CONTROLLER;
            } else if (REMOVE_ITEM.equals(action)) {
                url = REMOVE_ITEM_CONTROLLER;
            } else if (REMOVE_WATCHLIST.equals(action)) {
                url = REMOVE_WATCHLIST_CONTROLLER;
            } else if (CARE_NOTE_LIST.equals(action)) {
                url = CARE_NOTE_LIST_CONTROLLER;
            } else if (SHOW_ADD_CARE_NOTE_LIST.equals(action)) {
                url = SHOW_ADD_CARE_NOTE_LIST_CONTROLLER;
            } else if (ADD_CARE_NOTE.equals(action)) {
                url = ADD_CARE_NOTE_CONTROLLER;
            } else if (SHOW_EDIT_CARE_NOTE_LIST.equals(action)) {
                url = SHOW_EDIT_CARE_NOTE_LIST_CONTROLLER;
            } else if (EDIT_CARE_NOTE.equals(action)) {
                url = EDIT_CARE_NOTE_CONTROLLER;
            } else if (REMOVE_CARE_NOTE.equals(action)) {
                url = REMOVE_CARE_NOTE_CONTROLLER;
            } else if (EDIT_USER.equals(action) || UPDATE_USER.equals(action)) {
                url = EDIT_USER_CONTROLLER;
            } else if (LOGOUT.equals(action)) {
                url = LOGOUT_Controller;
            } else {
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
