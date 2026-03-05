package com.investorcare.controller;

import com.investorcare.dao.UserDAO;
import com.investorcare.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateProfileController", urlPatterns = {"/UpdateProfileController"})
public class UpdateProfileController extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("LOGIN_USER");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String confirmPassword = request.getParameter("confirmPassword");

    String oldPassword = request.getParameter("oldPassword");
    String newPassword = request.getParameter("newPassword");
    String reNewPassword = request.getParameter("reNewPassword");

    UserDAO dao = new UserDAO();

    try {

        int userId = user.getUserId();

        /* ===============================
           UPDATE USERNAME / EMAIL
        =============================== */

        // check username duplicate
        if (!username.equals(user.getUsername())
                && dao.checkUsernameExists(username, userId)) {

            request.setAttribute("ERROR", "Username already exists!");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }

        boolean emailChanged = !email.equals(user.getEmail());

        // nếu đổi email -> phải confirm password
        if (emailChanged) {

            if (confirmPassword == null
                    || !confirmPassword.equals(user.getPassword())) {

                request.setAttribute("ERROR",
                        "Wrong password confirmation!");
                request.getRequestDispatcher("editProfile.jsp?editEmail=true")
                        .forward(request, response);
                return;
            }

            if (dao.checkEmailExists(email, userId)) {
                request.setAttribute("ERROR", "Email already exists!");
                request.getRequestDispatcher("editProfile.jsp?editEmail=true")
                        .forward(request, response);
                return;
            }
        }

        // update basic info
        dao.updateBasicInfo(userId, username, email);

        user.setUsername(username);
        user.setEmail(email);

        /* ===============================
           CHANGE PASSWORD
        =============================== */

        if (oldPassword != null && !oldPassword.isEmpty()) {

            if (!oldPassword.equals(user.getPassword())) {

                request.setAttribute("ERROR", "Old password incorrect!");
                request.getRequestDispatcher("editProfile.jsp")
                        .forward(request, response);
                return;
            }

            if (newPassword == null || !newPassword.equals(reNewPassword)) {

                request.setAttribute("ERROR",
                        "New passwords do not match!");
                request.getRequestDispatcher("editProfile.jsp")
                        .forward(request, response);
                return;
            }

            dao.updatePassword(userId, newPassword);
            user.setPassword(newPassword);
        }

        /* ===============================
           UPDATE SESSION
        =============================== */
        session.setAttribute("LOGIN_USER", user);

        request.setAttribute("SUCCESS",
                "Profile updated successfully!");

        request.getRequestDispatcher("editProfile.jsp")
                .forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("ERROR", "System error!");
        request.getRequestDispatcher("editProfile.jsp")
                .forward(request, response);
    }
}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("userDashboard.jsp");
    }
}