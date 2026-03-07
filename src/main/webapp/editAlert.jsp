<%@page import="com.investorcare.model.Alert"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) { response.sendRedirect("login.jsp"); return; }
    
    Alert alert = (Alert) request.getAttribute("alert");
    List<Asset> assets = (List<Asset>) request.getAttribute("assets");
    String condition = (String) request.getAttribute("condition");
    String conditionValue = (String) request.getAttribute("conditionValue");
    String userMsg = (String) request.getAttribute("userMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Alert — TrustStock</title>
        <link rel="stylesheet" href="style_dashboard.css">

    <link rel="stylesheet" href="style_editAlert.css">
    
</head>
<body>

<nav class="navbar">
    <div class="navbar-brand">
        <div class="navbar-brand-icon">📈</div> InvestorCare
    </div>
    <div class="navbar-right">
        <a href="MainController?action=dashboard" class="navbar-back" style="display:flex;align-items:center;gap:6px;padding:6px 14px;border-radius:8px;border:1px solid var(--border);color:var(--text-secondary);text-decoration:none;font-size:12px;font-weight:600;transition:.2s;">
            ← Dashboard
        </a>
        <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername()%></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase()%></div>
    </div>
</nav>

<div class="page-wrapper">
    <div class="form-card">
        <div class="form-card-header">
            <h2>✏️ Edit Alert #<%= alert.getAlertId() %></h2>
            <p>Update your alert notification preferences.</p>
        </div>
        <div class="form-body">
            <form action="MainController" method="POST" id="alertForm">
                <input type="hidden" name="action" value="update-alert">
                <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>">

                <div class="form-section-title">📋 Basic Information</div>
                
                <div class="form-group">
                    <label>Alert Message</label>
                    <textarea name="alertMessage" required><%= userMsg %></textarea>
                </div>

                <div class="form-section-title" style="margin-top:8px;">⚙️ Condition Setting</div>
                <div class="setting-grid">
                    <div class="form-group" style="margin-bottom:0">
                        <label>Condition</label>
                        <select name="condition" required>
                            <option value="PRICE_ABOVE" <%= "PRICE_ABOVE".equals(condition) ? "selected" : "" %>>Price Above ▲</option>
                            <option value="PRICE_BELOW" <%= "PRICE_BELOW".equals(condition) ? "selected" : "" %>>Price Below ▼</option>
                            <option value="PRICE_EQUALS" <%= "PRICE_EQUALS".equals(condition) ? "selected" : "" %>>Price Equals =</option>
                            <option value="CHANGE_PCT_UP" <%= "CHANGE_PCT_UP".equals(condition) ? "selected" : "" %>>Change % Up ▲</option>
                            <option value="CHANGE_PCT_DOWN" <%= "CHANGE_PCT_DOWN".equals(condition) ? "selected" : "" %>>Change % Down ▼</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label>Value</label>
                        <input type="number" name="conditionValue" step="0.01" value="<%= conditionValue %>" required>
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label>Symbol</label>
                        <select name="assetId" required>
                            <% if (assets != null) { for (Asset a : assets) { %>
                                <option value="<%= a.getAssetId()%>" <%= (a.getAssetId() == alert.getAssetId()) ? "selected" : "" %>>
                                    <%= a.getSymbol()%> — <%= a.getName()%>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                </div>

                <div class="form-section-title" style="margin-top:22px;">🔧 Alert Options</div>
                
                <div class="form-group">
                    <label>Status</label>
                    <select name="status">
                        <option value="NEW" <%= "NEW".equals(alert.getStatus()) ? "selected" : "" %>>NEW (Active)</option>
                        <option value="READ" <%= "READ".equals(alert.getStatus()) ? "selected" : "" %>>READ</option>
                        <option value="DISMISSED" <%= "DISMISSED".equals(alert.getStatus()) ? "selected" : "" %>>DISMISSED</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Severity</label>
                    <div class="severity-group" id="severityGroup">
                        <label class="severity-btn <%= "LOW".equals(alert.getSeverity()) ? "sel-low" : "" %>" id="lbl-low">
                            <input type="radio" name="severity" value="LOW" <%= "LOW".equals(alert.getSeverity()) ? "checked" : "" %> onchange="updateSeverity()"> 🟢 Low
                        </label>
                        <label class="severity-btn <%= "MEDIUM".equals(alert.getSeverity()) ? "sel-medium" : "" %>" id="lbl-medium">
                            <input type="radio" name="severity" value="MEDIUM" <%= "MEDIUM".equals(alert.getSeverity()) ? "checked" : "" %> onchange="updateSeverity()"> 🟡 Medium
                        </label>
                        <label class="severity-btn <%= "HIGH".equals(alert.getSeverity()) ? "sel-high" : "" %>" id="lbl-high">
                            <input type="radio" name="severity" value="HIGH" <%= "HIGH".equals(alert.getSeverity()) ? "checked" : "" %> onchange="updateSeverity()"> 🔴 High
                        </label>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-dark">💾 Save Changes</button>
                    <button type="button" class="btn btn-outline" onclick="window.location.href='MainController?action=dashboard'">✕ Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function updateSeverity() {
    const val = document.querySelector('input[name="severity"]:checked').value;
    document.getElementById('lbl-low').className    = 'severity-btn' + (val === 'LOW'    ? ' sel-low'    : '');
    document.getElementById('lbl-medium').className = 'severity-btn' + (val === 'MEDIUM' ? ' sel-medium' : '');
    document.getElementById('lbl-high').className   = 'severity-btn' + (val === 'HIGH'   ? ' sel-high'   : '');
}
</script>
</body>
</html>