<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.investorcare.model.User"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String error   = (String) request.getAttribute("ERROR");
    String success = (String) request.getAttribute("SUCCESS");
    String editEmail  = request.getParameter("editEmail");
    boolean isEditEmail = "true".equals(editEmail);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — TrustStock</title>
    <link rel="stylesheet" href="editProfile.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
    <div class="navbar-brand">
        <div class="navbar-brand-icon">📈</div>
        TrustStock
    </div>
    <div class="navbar-right">
        <a href="MainController?action=dashboard" class="navbar-back">← Back</a>
        <span class="navbar-greeting">Xin chào, <strong><%= acc.getUsername()%></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase()%></div>
        <a href="MainController?action=logout" class="navbar-logout">Đăng xuất</a>
    </div>
</nav>

<!-- ===== PAGE WRAPPER ===== -->
<div class="page-wrapper">
    <div class="edit-container">

        <!-- HEADER -->
        <div class="edit-header">
            <h2>✏️ Edit Profile</h2>
            <p>Update your account information</p>
        </div>

        <!-- MESSAGES -->
        <% if (error != null) { %>
        <div style="padding:0 40px;margin-top:24px;">
            <div class="error-message"><%= error%></div>
        </div>
        <% } %>
        <% if (success != null) { %>
        <div style="padding:0 40px;margin-top:24px;">
            <div class="success-message"><%= success%></div>
        </div>
        <% } %>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="UpdateProfile">

            <!-- BASIC INFO -->
            <div class="edit-section">
                <div class="section-title">👤 Basic Information</div>

                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" value="<%= acc.getUsername()%>" required>
                    <div class="helper-text">Username must be unique</div>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <div class="email-row">
                        <input type="email" name="email"
                               value="<%= acc.getEmail() != null ? acc.getEmail() : ""%>"
                               <%= isEditEmail ? "" : "readonly"%>>
                        <% if (!isEditEmail) { %>
                        <button type="submit" name="editEmail" value="true"
                                formaction="editProfile.jsp" class="change-btn">Change</button>
                        <% } %>
                    </div>
                    <% if (isEditEmail) { %>
                    <div class="helper-text">Email must be unique</div>
                    <% } %>
                </div>

                <% if (isEditEmail) { %>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword"
                           placeholder="Enter password to confirm" required>
                </div>
                <% } %>
            </div>

            <div class="divider"></div>

            <!-- CHANGE PASSWORD -->
            <div class="edit-section">
                <div class="section-title">🔒 Change Password</div>

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

            <!-- ACTIONS -->
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">💾 Save changes</button>
                <button type="button" class="btn btn-secondary"
                        onclick="window.location.href='MainController?action=dashboard'">
                    ❌ Cancel
                </button>
            </div>
        </form>

    </div>
</div>

</body>
</html>
