<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Details - Admin Panel</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    </head>
    <body class="bg-black text-light">
        <nav class="navbar navbar-expand-lg bg-dark border-bottom border-secondary shadow">
            <div class="container-fluid">
                <h4 class="text-info fw-bold mb-0 me-4">
                    <i class="bi bi-graph-up me-2"></i> Invenster Care
                </h4>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item">
                            <a href="MainController?action=user-list" class="nav-link active text-info fw-bold px-3">User Management</a>
                        </li>
                        <li class="nav-item">
                            <a href="MainController?action=asset-search" class="nav-link text-secondary px-3">Assets Management</a>
                        </li>
                    </ul>
                    <form action="MainController" method="post" class="mb-0">
                        <input type="hidden" name="action" value="logout">
                        <button class="btn btn-outline-danger btn-sm">
                            <i class="bi bi-box-arrow-right"></i> Log out
                        </button>
                    </form>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card bg-dark border-secondary shadow-lg">
                        <%
                            com.investorcare.model.User u = (com.investorcare.model.User) request.getAttribute("USER_INFO");
                            if (u == null) {
                                response.sendRedirect("MainController?action=user-list");
                                return;
                            }
                        %>
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="update-user"> 
                            <input type="hidden" name="userId" value="<%=u.getUserId()%>"> 

                            <div class="card-header border-secondary py-3">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <h5 class="mb-0 fw-bold text-info text-uppercase">
                                            <i class="bi bi-person-gear me-2"></i>User Configuration
                                        </h5>
                                    </div>
                                    <div class="col-auto">
                                        <a href="MainController?action=user-list" class="btn btn-outline-secondary btn-sm px-3 me-2">Cancel</a>
                                        <button type="submit" class="btn btn-info text-dark fw-bold btn-sm px-4">SAVE CHANGES</button>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body p-4">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-info text-uppercase">Username</label>
                                            <input type="text" class="form-control bg-black text-secondary border-secondary" 
                                                   value="<%=u.getUsername()%>" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-info text-uppercase">Email Address</label>
                                            <input type="email" class="form-control bg-black text-white border-secondary" 
                                                   name="email" value="<%=u.getEmail()%>">
                                        </div>
                                        <div class="mb-0">
                                            <label class="form-label small fw-bold text-info text-uppercase">Password</label>
                                            <input type="text" class="form-control bg-black text-white border-secondary" 
                                                   name="password" value="<%=u.getPassword()%>">
                                        </div>
                                    </div>

                                    <div class="col-md-6 ps-md-5">
                                        <div class="mb-4">
                                            <label class="form-label small fw-bold text-info text-uppercase d-block">Role</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="role" id="admin" value="Admin"
                                                           <%="Admin".equals(u.getRole()) ? "checked" : ""%>>
                                                    <label class="form-check-label" for="admin">Admin</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="role" id="user" value="User"
                                                           <%="User".equals(u.getRole()) ? "checked" : ""%>>
                                                    <label class="form-check-label" for="user">User</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="form-label small fw-bold text-info text-uppercase d-block">Status</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="active" value="Active"
                                                           <%="Active".equals(u.getStatus()) ? "checked" : ""%>>
                                                    <label class="form-check-label" for="active">Active</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="inactive" value="Inactive"
                                                           <%="Inactive".equals(u.getStatus()) ? "checked" : ""%>>
                                                    <label class="form-check-label" for="inactive">Inactive</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>