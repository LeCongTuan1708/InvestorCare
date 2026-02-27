<%-- 
    Document   : userManagement
    Created on : Jan 31, 2026, 3:03:22 PM
    Author     : DELL
--%>

<%@page import="java.util.List"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">

        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
                integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
        crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"
                integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
        crossorigin="anonymous"></script>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg bg-light navbar-light">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center w-100">
                    <h3 class="mb-0">Truck Stock Advisor - Admin Panel</h3>

                    <div class="collapse navbar-collapse">
                        <ul class="navbar-nav mx-auto">
                            <li class="nav-item">
                                <a href="#" class="nav-link active px-3">User</a>
                            </li>
                            <li class="nav-item">
                                <a href="#" class="nav-link px-3">Tickers</a>
                            </li>
                            <li class="nav-item">
                                <a href="#" class="nav-link px-3">Alert</a>
                            </li>
                            <li class="nav-item">
                                <a href="#" class="nav-link px-3">Explanation</a>
                            </li>
                            <li class="nav-item">
                                <a href="#" class="nav-link px-3">Dashboard</a>
                            </li>
                        </ul>

                        <form action="MainController" method="post" class="mb-0">
                            <input type="hidden" name="action" value="logout">
                            <button class="btn btn-dark">Log out</button>
                        </form>
                    </div>
                </div>
            </div>
        </nav>

        <!-- CONTENT -->
        <div class="container mt-4">

            <!-- SEARCH + FILTER FORM -->
            <form action="MainController" method="get">

                <!-- action cho controller -->
                <input type="hidden" name="action" value="user-list">

                <div class="row mb-4">

                    <!-- SEARCH -->
                    <div class="col-md-6">
                        <div class="d-flex mb-3 mb-md-0">
                            <input
                                class="shadow-sm form-control me-2"
                                type="search"
                                name="keyword"
                                placeholder="Search for users..."
                                >
                            <button class="btn btn-dark" type="submit">Search</button>
                        </div>
                    </div>

                    <!-- ADD USER -->
                    <div class="col-md-6 d-flex justify-content-end align-items-start">
                        <a href="MainController?action=add-user-form" class="btn btn-dark">
                            Add New User
                        </a>
                    </div>

                    <!-- FILTER -->
                    <div class="col-12 mt-3">
                        <div class="d-flex gap-3">

                            <div style="min-width: 150px;">
                                <label class="form-label small fw-bold text-muted">Filter by Role</label>
                                <select name="role" class="form-select form-select-sm shadow-sm" onchange="this.form.submit()">
                                    <option value="">All Roles</option>
                                    <option value="ADMIN">Admin</option>
                                    <option value="USER">User</option>
                                </select>
                            </div>

                            <div style="min-width: 150px;">
                                <label class="form-label small fw-bold text-muted">Filter by Status</label>
                                <select name="status" class="form-select form-select-sm shadow-sm">
                                    <option value="">All Status</option>
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>

                        </div>
                    </div>

                </div>
            </form>


            <!-- TABLE -->
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">User Management</h5>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">ID</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Last login</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                List<User> listUser = (List<User>) request.getAttribute("LIST_USER");

                                if(listUser != null){
                                    for (User user : listUser) {
                            %>
                            
                                
                                <tr>
                                    <td class="ps-3"><%=user.getUserId()%></td>
                                    <td><%=user.getUsername()%></td>
                                    <td><span class="badge bg-info text-dark"><%=user.getRole()%></span></td>
                                    <td><span class="badge bg-success"><%=user.getStatus()%></span></td>
                                    <td><span class="badge bg-primary"><%=user.getLastLogin()%></span></td>
                                    <td>
                                        <a href="#" class="btn btn-sm btn-outline-secondary">Edit</a>
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
            </div>

        </div>
    </body>
</html>
