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
    <title>View Alert — TrustStock</title>
    <link rel="stylesheet" href="style_dashboard.css">
    <link rel="stylesheet" href="style_viewAlert.css">
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
            <h2>👁️ View Alert #<%= alert.getAlertId() %></h2>
            <p>Created on: <%= alert.getTimestamp() %></p>
        </div>
        <div class="form-body">
            <div class="form-section-title">📋 Basic Information</div>
            
            <div class="form-group">
                <label>Alert Message</label>
                <textarea disabled><%= userMsg %></textarea>
            </div>

            <div class="form-section-title" style="margin-top:8px;">⚙️ Condition Setting</div>
            <div class="setting-grid">
                <div class="form-group" style="margin-bottom:0">
                    <label>Condition</label>
                    <select disabled>
                        <option value="PRICE_ABOVE" <%= "PRICE_ABOVE".equals(condition) ? "selected" : "" %>>Price Above ▲</option>
                        <option value="PRICE_BELOW" <%= "PRICE_BELOW".equals(condition) ? "selected" : "" %>>Price Below ▼</option>
                        <option value="PRICE_EQUALS" <%= "PRICE_EQUALS".equals(condition) ? "selected" : "" %>>Price Equals =</option>
                        <option value="CHANGE_PCT_UP" <%= "CHANGE_PCT_UP".equals(condition) ? "selected" : "" %>>Change % Up ▲</option>
                        <option value="CHANGE_PCT_DOWN" <%= "CHANGE_PCT_DOWN".equals(condition) ? "selected" : "" %>>Change % Down ▼</option>
                    </select>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>Value</label>
                    <input type="number" value="<%= conditionValue %>" disabled>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>Symbol</label>
                    <select disabled>
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
                <select disabled>
                    <option value="NEW" <%= "NEW".equals(alert.getStatus()) ? "selected" : "" %>>NEW (Active)</option>
                    <option value="READ" <%= "READ".equals(alert.getStatus()) ? "selected" : "" %>>READ</option>
                    <option value="DISMISSED" <%= "DISMISSED".equals(alert.getStatus()) ? "selected" : "" %>>DISMISSED</option>
                </select>
            </div>

            <div class="form-group">
                <label>Severity</label>
                <div class="severity-group">
                    <label class="severity-btn <%= "LOW".equals(alert.getSeverity()) ? "sel-low" : "" %>">
                        <input type="radio" checked disabled> 🟢 Low
                    </label>
                    <label class="severity-btn <%= "MEDIUM".equals(alert.getSeverity()) ? "sel-medium" : "" %>">
                        <input type="radio" checked disabled> 🟡 Medium
                    </label>
                    <label class="severity-btn <%= "HIGH".equals(alert.getSeverity()) ? "sel-high" : "" %>">
                        <input type="radio" checked disabled> 🔴 High
                    </label>
                </div>
            </div>

            <div class="form-actions">
                <a href="MainController?action=show-edit-alert&alertId=<%= alert.getAlertId()%>" class="btn btn-dark" style="text-decoration: none;">✏️ Edit This Alert</a>
                <button type="button" class="btn btn-outline" onclick="window.location.href='MainController?action=dashboard'">← Back</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>