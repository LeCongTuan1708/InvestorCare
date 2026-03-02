<%-- 
    Document   : userDetail
    Created on : Jan 31, 2026, 3:07:26 PM
    Author     : DELL
--%>

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
    <body class="bg-light">

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-10">

                    <div class="card shadow-sm border-0 rounded-3 p-2">

                        <%
                            com.investorcare.model.User u = (com.investorcare.model.User) request.getAttribute("USER_INFO");
                            if(u == null){
                                response.sendRedirect("MainController?action=user-list");
                                return;
                            }
                        %>
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="update-user"> 
                            <input type="hidden" name="userId" value="<%=u.getUserId()%>"> 
                            <div class="card-header bg-white py-3 border-bottom">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <h5 class="mb-0 fw-bold text-dark fs-2">User Details</h5>
                                    </div>
                                    <div class="col-auto">
                                        <button type="button"
                                                class="btn btn-outline-secondary  px-4 me-2">Cancel</button>
                                        <button type="submit" class="btn btn-dark px-4">Save changes</button>
                                    </div>
                                </div>
                            </div>

                            <div class="card-body p-4">
                                <div class="row g-4">

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label
                                                class="form-label fw-semibold small text-uppercase text-muted">Username</label>
                                                <input type="text" class="form-control form-control-lg bg-light" value="<%=u.getUsername()%>"
                                                       readonly="" style="font-size: 0.9rem;">
                                        </div>
                                        <div class="mb-0">
                                            <label class="form-label fw-semibold small text-uppercase text-muted">Email
                                                Address</label>
                                            <input type="email" class="form-control form-control-lg bg-light" name="email"
                                                   value="<%=u.getEmail()%>" style="font-size: 0.9rem;">
                                        </div>
                                    </div>

                                    <div class="col-md-6 ps-md-5">
                                        <div class="mb-4">
                                            <label
                                                class="form-label fw-semibold small text-uppercase text-muted d-block">Role</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="role" id="admin" value="Admin"
                                                           <%="Admin".equals(u.getRole())?"checked":""%>>
                                                    <label class="form-check-label" for="admin">Admin</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="role" id="user" value="User"
                                                           <%="User".equals(u.getRole())?"checked":""%>>
                                                    <label class="form-check-label" for="user">User</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div>
                                            <label
                                                class="form-label fw-semibold small text-uppercase text-muted d-block">Status</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="active" value="Active"
                                                           <%="Active".equals(u.getStatus())?"checked":""%>>
                                                    <label class="form-check-label" for="active">Active</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="inactive" value="Inactive"
                                                           <%="Inactive".equals(u.getStatus())?"checked":""%>>
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
    </body>y>
</html>
