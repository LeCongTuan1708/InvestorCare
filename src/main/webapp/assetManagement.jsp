<%@page import="java.sql.Timestamp"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.ZoneId"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticker Management</title>
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
                                Invenster Care
                                <span class="fs-6 text-secondary fw-normal d-block">Admin Panel</span>
                            </div>
                        </h4>
                        <hr class="text-secondary">
                        <ul class="nav flex-column gap-2">
                            <li class="nav-item">
                                <a class="nav-link text-secondary py-3 px-3 rounded" href="MainController?action=user-list">
                                    <i class="bi bi-people me-2"></i> User Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active text-info fw-bold py-3 px-3 bg-secondary bg-opacity-10 rounded" href="">
                                    <i class="bi bi-graph-up-arrow me-2"></i> Assets Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-secondary py-3 px-3 rounded" href="#">
                                    <i class="bi bi-gear me-2"></i> Settings
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
                        <h1 class="h2 text-info fw-bold">Asset Management</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <a href="MainController?action=add-asset-button" class="btn btn-success fw-bold shadow-sm">
                                <i class="bi bi-plus-circle me-1"></i> Add New Ticker
                            </a>
                        </div>
                    </div>

                    <%
                        String oldKeyword = (request.getAttribute("oldKeyword") != null) ? (String) request.getAttribute("oldKeyword") : "";
                        String oldStatus = (request.getAttribute("oldStatus") != null) ? (String) request.getAttribute("oldStatus") : "";
                        String oldVisible = (request.getAttribute("oldVisible") != null) ? (String) request.getAttribute("oldVisible") : "";
                    %>

                    <div class="card bg-dark border-secondary mb-4 shadow-sm">
                        <div class="card-body">
                            <form action="MainController" method="post" class="row g-3">
                                <input type ="hidden" name="action" value="asset-search">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-info">SEARCH BY SYMBOL OR NAME</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-black border-secondary text-info"><i class="bi bi-search"></i></span>
                                        <input type="search" name="keyword" value="<%= oldKeyword%>" 
                                               class="form-control bg-black text-white border-secondary" 
                                               placeholder="Search for ticker...">
                                        <button class="btn btn-info text-dark fw-bold" type="submit">SEARCH</button>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-info">STATUS</label>
                                    <select name="status" class="form-select bg-black text-white border-secondary" onchange="this.form.submit()">
                                        <option value="">All</option>
                                        <option value="Active" <%= (oldStatus.equals("Active")) ? "selected" : ""%>>Active</option>
                                        <option value="Inactive" <%= (oldStatus.equals("Inactive")) ? "selected" : ""%>>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-info">VISIBILITY</label>
                                    <select name="visible" class="form-select bg-black text-white border-secondary" onchange="this.form.submit()">
                                        <option value="">All</option>
                                        <option value="1" <%= (oldVisible.equals("1")) ? "selected" : ""%>>Visible</option>
                                        <option value="0" <%= (oldVisible.equals("0")) ? "selected" : ""%>>Hidden</option>
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
                                        <th class="ps-3 py-3 align-middle">TICKER</th>
                                        <th class="align-middle">COMPANY NAME</th>
                                        <th class="align-middle">EXCHANGE</th>
                                        <th class="align-middle">HEALTH</th>
                                        <th class="align-middle">LAST UPDATE</th>
                                        <th class="align-middle">STATUS</th>
                                        <th class="align-middle">VISIBLE</th>
                                        <th class="text-center align-middle">INFO</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        ArrayList<Asset> list = (request.getAttribute("list") != null) ? (ArrayList<Asset>) request.getAttribute("list") : new ArrayList<Asset>();
                                        for (Asset asset : list) {
                                            String symbol = asset.getSymbol();
                                            String name = asset.getName();
                                            String status = asset.getStatus();
                                            boolean isVisible = asset.isVisible();
                                            String visible = isVisible ? "Visible" : "Hidden";
                                            String exchange = asset.getExchange();
                                            Timestamp last_update = asset.getUpdatedAt();
                                    %>
                                    <tr class="border-bottom border-secondary-subtle">
                                        <td class="ps-3 fw-bold text-info align-middle"><%= symbol%></td>
                                        <td class="align-middle"><%= name%></td>
                                        <td class="align-middle">
                                            <span class="badge border border-secondary text-secondary fw-normal text-uppercase"><%= exchange%></span>
                                        </td>
                                        <td class="align-middle">
                                            <% if (last_update == null) { %>
                                            <span class="badge bg-secondary opacity-50">N/A</span>
                                            <% } else {
                                                long diff = System.currentTimeMillis() - last_update.getTime();
                                                long days = diff / (1000 * 60 * 60 * 24);
                                                if (days <= 1) { %>
                                            <span class="badge bg-success bg-opacity-75">Healthy</span>
                                            <% } else if (days <= 3) { %>
                                            <span class="badge bg-warning text-dark">Stale</span>
                                            <% } else { %>
                                            <span class="badge bg-danger">Outdated</span>
                                            <% }
                                                } %>
                                        </td>
                                        <td class="text-secondary small align-middle">
                                            <% if (last_update != null) {
                                                    LocalDateTime ldt = last_update.toInstant().atZone(ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime();
                                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                                    out.print(ldt.format(formatter));
                                                } else {
                                                    out.print("<span class='text-muted'>-</span>");
                                                }%>
                                        </td>
                                        <td class="align-middle">
                                            <span class="badge rounded-pill <%= status.equals("Active") ? "bg-info text-dark" : "bg-dark border border-secondary text-secondary"%>">
                                                <%= status%>
                                            </span>
                                        </td>
                                        <td class="align-middle">
                                            <span class="badge rounded-pill <%= isVisible ? "bg-success" : "bg-warning text-dark"%>">
                                                <%= visible%>
                                            </span>
                                        </td>
                                        <td class="text-center align-middle">
                                            <a href="MainController?action=edit-asset&assetId=<%= asset.getAssetId()%>" 
                                               class="btn btn-outline-info rounded-circle d-inline-flex align-items-center justify-content-center p-0 shadow-sm"
                                               style="width: 20px; height: 20px;">
                                                <i class="bi bi-info"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%}%>
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