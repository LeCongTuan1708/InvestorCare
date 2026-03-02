<%@page import="java.util.List"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    </head>
    <body class="bg-black text-light">
        <div class="container-fluid p-0">
            <div class="d-flex">
                <nav class="bg-dark border-end border-secondary-subtle position-fixed shadow" style="width: 280px; min-height: 100vh;">
                    <div class="p-4">
                        <h4 class="text-info fw-bold mb-4 d-flex align-items-center">
                            <i class="bi bi-graph-up me-2"></i> 
                            <div>
                                Investor Care
                                <span class="fs-6 text-secondary fw-normal d-block">Admin Panel</span>
                            </div>
                        </h4>
                        <hr class="text-secondary">
                        <ul class="nav flex-column gap-2">
                            <li class="nav-item">
                                <a class="nav-link active text-info fw-bold py-3 px-3 bg-secondary bg-opacity-10 rounded" href="MainController?action=user-list">
                                    <i class="bi bi-people me-2"></i> User Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-secondary py-3 px-3 rounded" href="MainController?action=asset-search">
                                    <i class="bi bi-graph-up-arrow me-2"></i> Assets Management
                                </a>
                            </li>
                        </ul>
                        <div class="position-absolute bottom-0 start-0 w-100 p-3">
                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="logout">
                                <button class="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 py-2">
                                    <i class="bi bi-box-arrow-right"></i> Log out
                                </button>
                            </form>
                        </div>
                    </div>
                </nav>

                <main class="px-md-4 py-4" style="margin-left: 280px; width: calc(100% - 280px);">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom border-secondary">
                        <h1 class="h2 text-info fw-bold">User Management</h1>
                    </div>

                    <div class="card bg-dark border-secondary mb-4 shadow-sm">
                        <div class="card-body">
                            <form action="MainController" method="POST" class="row g-3">
                                <input type="hidden" name="action" value="user-list">
                                
                                <%
                                    String currentKeyword = (String) request.getAttribute("CURRENT_KEYWORD");
                                    currentKeyword = (currentKeyword != null) ? currentKeyword : "";
                                %>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-info">SEARCH USERS</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-black border-secondary text-info"><i class="bi bi-search"></i></span>
                                        <input type="search" name="keyword" class="form-control bg-black text-white border-secondary" 
                                               placeholder="Search by username..." value="<%=currentKeyword%>">
                                        <button class="btn btn-info text-dark fw-bold" type="submit">SEARCH</button>
                                    </div>
                                </div>

                                <div class="col-md-3">
                                    <%
                                        String currentRole = request.getParameter("role");
                                        currentRole = (currentRole == null) ? "" : currentRole;
                                    %>
                                    <label class="form-label small fw-bold text-info">ROLE</label>
                                    <select name="role" class="form-select bg-black text-white border-secondary" onchange="this.form.submit()">
                                        <option value="" <%= currentRole.equals("") ? "selected" : ""%>>All Roles</option>
                                        <option value="Admin" <%= currentRole.equals("Admin") ? "selected" : ""%>>Admin</option>
                                        <option value="User" <%= currentRole.equals("User") ? "selected" : ""%>>User</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <%
                                        String currentStatus = request.getParameter("status");
                                        currentStatus = (currentStatus == null) ? "" : currentStatus;
                                    %>
                                    <label class="form-label small fw-bold text-info">STATUS</label>
                                    <select name="status" class="form-select bg-black text-white border-secondary" onchange="this.form.submit()">
                                        <option value="" <%=currentStatus.equals("") ? "selected" : "" %>>All Status</option>
                                        <option value="Active" <%=currentStatus.equals("Active") ? "selected" : "" %>>Active</option>
                                        <option value="Inactive" <%=currentStatus.equals("Inactive") ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card border-secondary bg-dark shadow-sm">
                        <div class="table-responsive">
                            <table class="table table-dark table-hover align-middle mb-0">
                                <thead class="table-active text-info border-bottom border-secondary">
                                    <tr>
                                        <th class="ps-2 py-3">ID</th>
                                        <th class="ps-2 py-3">USERNAME</th>
                                        <th class="ps-2 py-3">ROLE</th>
                                        <th class="ps-2 py-3">STATUS</th>
                                        <th class="ps-2 py-3">CREATED AT</th>
                                        <th class="ps-2 py-3 text-center">INFO</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<User> listUser = (List<User>) request.getAttribute("LIST_USER");
                                        if (listUser != null) {
                                            for (User user : listUser) {
                                    %>
                                    <tr class="border-bottom border-secondary-subtle">
                                        <td class="ps-2 text-secondary small align-middle">#<%=user.getUserId()%></td>
                                        <td class="fw-bold align-middle"><%=user.getUsername()%></td>
                                        <td class="align-middle">
                                            <span class="badge text-dark fw-bold bg-primary"><%=user.getRole()%></span>
                                        </td>
                                        <td class="align-middle">
                                            <span class="badge rounded-pill <%= user.getStatus().equals("Active") ? "bg-success" : "bg-danger" %>">
                                                <%=user.getStatus()%>
                                            </span>
                                        </td>
                                        <td class="text-light small align-middle"><%=user.getLastLogin()%></td>
                                        <td class="text-center align-middle">
                                            <a href="MainController?action=edit-user&userId=<%=user.getUserId()%>" 
                                               class="btn btn-outline-info rounded-circle d-inline-flex align-items-center justify-content-center p-0 shadow-sm"
                                               style="width: 20px; height: 20px;">
                                                <i class="bi bi-info-lg"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>