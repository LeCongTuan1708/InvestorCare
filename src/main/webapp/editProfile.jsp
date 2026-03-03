<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.investorcare.model.User"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String error = (String) request.getAttribute("ERROR");
    String success = (String) request.getAttribute("SUCCESS");
    String editEmail = request.getParameter("editEmail");
    boolean isEditEmail = "true".equals(editEmail);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Profile - TrustStock</title>
        <link rel="stylesheet" href="editProfile.css">
    </head>
    <body>
 <!-- TOP NAVBAR -->
        <div class="navbar">
            <div class="navbar-brand">📈 TrustStock</div>
            <div class="navbar-right">
                <span class="navbar-greeting">Welcome <strong><%= acc.getUsername()%></strong></span>
                <div class="navbar-avatar">J</div>
                <a href="login.jsp" class="navbar-logout">
    Logout
</a>
            </div>
        </div>
                 <div class="page-wrapper">

        <div class="edit-container">

           
            
       

                
        <div class="edit-container">

            <!-- HEADER -->
            <div class="edit-header">
                <h2>✏️ Edit Profile</h2>
                <p>Update your information</p>
            </div>

            <!-- ERROR MESSAGE -->
            <% if (error != null) {%>
            <div class="error-message"><%= error%></div>
            <% } %>

            <!-- SUCCESS MESSAGE -->
            <% if (success != null) {%>
            <div class="success-message"><%= success%></div>
            <% }%>

            <form action="MainController" method="POST">
                <input type="hidden" name="action" value="UpdateProfile">

                <!-- ===== BASIC INFO ===== -->
                <div class="edit-section">
                    <div class="section-title">👤 Basic Information</div>

                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" value="<%= acc.getUsername()%>" required>
                        <div class="helper-text">Username must be unique</div>
                    </div>

                    <div class="form-group">
                        <div class="form-group">
                            <label>Email</label>

                            <div class="email-row">

                                <input type="email"
                                       name="email"
                                       value="<%= acc.getEmail() != null ? acc.getEmail() : ""%>"
                                       <%= isEditEmail ? "" : "readonly"%> >

                                <% if (!isEditEmail) { %>
                                <button type="submit"
                                        name="editEmail"
                                        value="true"
                                        formaction="editProfile.jsp"
                                        class="change-btn">
                                    Change
                                </button>
                                <% } %>

                            </div>
                    <% if (isEditEmail) { %>
                            <div class="helper-text">Email must be unique</div>
                        </div>
                            <%}%>
                    </div>


                    <% if (isEditEmail) { %>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password"
                               name="confirmPassword"
                               placeholder="Enter password to confirm"
                               required>
                    </div>
                    <% }%>
                </div>

                <div class="divider"></div>

                <!-- ===== CHANGE PASSWORD ===== -->
                <div class="edit-section">
                    <div class="section-title">🔒 Change password</div>

                    <div class="form-group">
                        <label>Old Password</label>
                        <input type="password" name="oldPassword" placeholder="Enter old password">
                    </div>

                    <div class="form-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" placeholder="Enter new password">
                    </div>

                    <div class="form-group">
                        <label>Re-enter New Password</label>
                        <input type="password" name="reNewPassword" placeholder="Re-enter new password">
                    </div>
                </div>

                <!-- ===== ACTIONS ===== -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">💾 Save changes</button>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href = 'MainController?action=dashboard'">
                        ❌ Cancel
                    </button>
                </div>

            </form>

        </div>
                 </div>

    </div>

    </body>
</html>