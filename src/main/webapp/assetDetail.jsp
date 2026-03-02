<%@page import="com.investorcare.model.Asset"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asset Control Center</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    </head>
    <body class="bg-black text-light">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card bg-dark border-secondary shadow-lg rounded-3">
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="edit-asset">
                            
                            <div class="card-header bg-transparent py-4 border-bottom border-secondary">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <h2 class="mb-0 fw-bold text-info text-uppercase">
                                            <i class="bi bi-cpu me-2"></i>Asset Control Center
                                        </h2>
                                    </div>
                                    <div class="col-auto">
                                        <button type="button" class="btn btn-outline-secondary px-4 me-2 fw-bold" onclick="window.location.href='MainController?action=asset-search'">
                                            CANCEL
                                        </button>
                                        <button type="submit" class="btn btn-info px-4 fw-bold text-dark">
                                            SAVE CHANGES
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <%
                                Asset old = (Asset) request.getAttribute("oldAsset");
                                if (old == null) {
                                    out.println("<div class='p-5 text-center'><h3 class='text-danger'>Asset not found!</h3></div>");
                                    return;
                                }
                            %>

                            <div class="card-body p-4 p-md-5">
                                <div class="row g-5">
                                    <div class="col-md-6">
                                        <p class="fw-bold text-info mb-4 border-start border-3 border-info ps-2">BASIC INFORMATION</p>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-secondary text-uppercase">Asset ID</label>
                                            <input type="text" class="form-control form-control-lg bg-black border-secondary text-info fw-bold" name="assetId" value="<%= old.getAssetId()%>" readonly>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-secondary text-uppercase">Symbol</label>
                                            <input type="text" class="form-control form-control-lg bg-black border-secondary text-info fw-bold" name="symbol" value="<%= old.getSymbol()%>" readonly>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-secondary text-uppercase">Type</label>
                                            <select name="type" class="form-select form-select-lg bg-black border-secondary text-light">
                                                <option value="STOCK" <%= "STOCK".equals(old.getType()) ? "selected" : ""%>>STOCK</option>
                                                <option value="GOLD" <%= "GOLD".equals(old.getType()) ? "selected" : ""%>>GOLD</option>
                                                <option value="SILVER" <%= "SILVER".equals(old.getType()) ? "selected" : ""%>>SILVER</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label small fw-bold text-secondary text-uppercase">Exchange</label>
                                            <input type="text" class="form-control form-control-lg bg-black border-secondary text-light" name="exchange" value="<%= old.getExchange()%>">
                                        </div>

                                        <div class="mb-4">
                                            <label class="form-label small fw-bold text-secondary text-uppercase">Company Name</label>
                                            <input type="text" class="form-control form-control-lg bg-black border-secondary text-light" name="name" value="<%= old.getName()%>">
                                        </div>

                                        <div class="mb-4">
                                            <label class="form-label small fw-bold text-secondary text-uppercase d-block mb-2">Visibility</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="visible" value="1" id="yes" <%= old.isVisible() ? "checked" : ""%>>
                                                    <label class="form-check-label text-success fw-bold" for="yes">Visible</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="visible" value="0" id="no" <%= !old.isVisible() ? "checked" : ""%>>
                                                    <label class="form-check-label text-warning fw-bold" for="no">Hidden</label>
                                                </div>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="form-label small fw-bold text-secondary text-uppercase d-block mb-2">System Status</label>
                                            <div class="d-flex gap-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="active" value="Active" <%= "Active".equals(old.getStatus()) ? "checked" : ""%>>
                                                    <label class="form-check-label text-info fw-bold" for="active">Active</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" value="Inactive" id="inactive" <%= !"Active".equals(old.getStatus()) ? "checked" : ""%>>
                                                    <label class="form-check-label text-secondary fw-bold" for="inactive">Inactive</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <p class="fw-bold text-info mb-4 border-start border-3 border-info ps-2">DATA HEALTH STATUS</p>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Total PriceBars</span>
                                            <span class="fw-bold">1,245</span>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Latest Price Update</span>
                                            <span class="fw-bold text-info">2026-02-24</span>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Total NewsItems</span>
                                            <span class="fw-bold">87</span>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Latest News Sync</span>
                                            <span class="fw-bold text-info">2026-02-23</span>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Total Signals</span>
                                            <span class="fw-bold">56</span>
                                        </div>

                                        <div class="d-flex justify-content-between mb-4 border-bottom border-secondary pb-2">
                                            <span class="text-secondary small text-uppercase fw-semibold">Latest Signal Calc</span>
                                            <span class="fw-bold text-info">2026-02-24</span>
                                        </div>
                                        
                                        <div class="mt-5 p-3 rounded bg-black border border-secondary">
                                            <p class="fw-bold text-secondary small mb-3">SYSTEM CONTROL</p>
                                            <div class="d-grid gap-2">
                                                <button type="button" class="btn btn-sm btn-outline-info fw-bold">RE-FETCH PRICE DATA</button>
                                                <button type="button" class="btn btn-sm btn-outline-info fw-bold">RE-FETCH NEWS DATA</button>
                                                <button type="button" class="btn btn-sm btn-outline-danger fw-bold">RECALCULATE SIGNALS</button>
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