<%@page import="com.investorcare.model.User"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) { response.sendRedirect("login.jsp"); return; }
    List<Asset> assets = (List<Asset>) request.getAttribute("assets");
    String error   = (String) request.getAttribute("ERROR");
    String success = (String) request.getAttribute("SUCCESS");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Alert — TrustStock</title>
    <link rel="stylesheet" href="style_dashboard.css">
    <style>
        /* ── Page layout ── */
        .page-wrapper {
            display: flex; justify-content: center;
            padding: 40px 20px;
        }
        .form-card {
            width: 100%; max-width: 680px;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            animation: fadeIn .3s ease-out;
        }
        @keyframes fadeIn {
            from { opacity:0; transform:translateY(8px); }
            to   { opacity:1; transform:translateY(0); }
        }

        /* ── Card header ── */
        .form-card-header {
            background: var(--bg-surface);
            padding: 28px 36px;
            border-bottom: 1px solid var(--border);
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
        }
        .form-card-header h2 { font-size: 20px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
        .form-card-header p  { font-size: 13px; color: var(--text-secondary); }

        /* ── Form body ── */
        .form-body { padding: 32px 36px; }

        .form-group { margin-bottom: 22px; }
        .form-group label {
            display: block; font-size: 11px; font-weight: 600;
            color: var(--text-secondary); text-transform: uppercase;
            letter-spacing: .5px; margin-bottom: 8px;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
            width: 100%; padding: 10px 14px;
            background: var(--bg-surface); border: 1px solid var(--border);
            border-radius: var(--radius-sm); color: var(--text-primary);
            font-family: inherit; font-size: 13px; transition: border-color .2s;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(0,229,160,.1);
        }
        .form-group input::placeholder,
        .form-group textarea::placeholder { color: var(--text-muted); }
        .form-group textarea { resize: vertical; min-height: 90px; }
        .form-group select option { background: var(--bg-surface); }

        /* ── Section divider ── */
        .form-section-title {
            font-size: 12px; font-weight: 700; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: .8px;
            padding-bottom: 12px; margin-bottom: 18px;
            border-bottom: 1px solid var(--border-subtle);
            display: flex; align-items: center; gap: 8px;
        }

        /* ── Setting row (condition + value + symbol in a grid) ── */
        .setting-grid {
            display: grid;
            grid-template-columns: 160px 1fr 1fr;
            gap: 14px;
        }

        /* ── Severity toggle ── */
        .severity-group { display: flex; gap: 10px; }
        .severity-btn {
            flex: 1; padding: 9px 0; border-radius: var(--radius-sm);
            border: 1px solid var(--border); background: var(--bg-surface);
            color: var(--text-secondary); font-size: 12px; font-weight: 600;
            cursor: pointer; text-align: center; transition: .2s;
        }
        .severity-btn:hover { border-color: var(--border); background: var(--bg-hover); }
        .severity-btn input[type="radio"] { display: none; }
        .severity-btn.sel-low    { border-color: var(--accent); color: var(--accent); background: var(--accent-dim); }
        .severity-btn.sel-medium { border-color: var(--amber);  color: var(--amber);  background: rgba(245,158,11,.1); }
        .severity-btn.sel-high   { border-color: var(--red);    color: var(--red);    background: var(--red-dim); }

        /* ── Actions ── */
        .form-actions {
            display: flex; gap: 12px; margin-top: 28px;
            padding-top: 20px; border-top: 1px solid var(--border-subtle);
        }
        .form-actions .btn { flex: 1; justify-content: center; padding: 11px; }

        /* ── Messages ── */
        .msg-error, .msg-success {
            padding: 12px 16px; border-radius: var(--radius-sm);
            font-size: 13px; font-weight: 500; margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .msg-error   { background: var(--red-dim);   border-left: 3px solid var(--red);   color: #fca5a5; }
        .msg-success { background: var(--accent-dim); border-left: 3px solid var(--accent); color: var(--accent); }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="navbar-brand">
        <div class="navbar-brand-icon">📈</div>
        InvestorCare
    </div>
    <div class="navbar-right">
        <a href="MainController?action=dashboard" class="navbar-back" style="
            display:flex;align-items:center;gap:6px;padding:6px 14px;
            border-radius:8px;border:1px solid var(--border);color:var(--text-secondary);
            text-decoration:none;font-size:12px;font-weight:600;transition:.2s;">
            ← Dashboard
        </a>
        <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername()%></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase()%></div>
        <a href="MainController?action=logout" class="navbar-logout">Logout</a>
    </div>
</nav>

<!-- PAGE -->
<div class="page-wrapper">
    <div class="form-card">

        <div class="form-card-header">
            <h2>🔔 Create Alert</h2>
            <p>Get notified when a stock hits your target condition</p>
        </div>

        <div class="form-body">

            <% if (error != null) { %>
            <div class="msg-error">⚠️ <%= error%></div>
            <% } %>
            <% if (success != null) { %>
            <div class="msg-success">✓ <%= success%></div>
            <% } %>

            <form action="MainController" method="POST" id="alertForm">
                <input type="hidden" name="action" value="create-alert">

                <!-- ── Basic Info ── -->
                <div class="form-section-title">📋 Basic Information</div>

                <div class="form-group">
                    <label>Alert Name</label>
                    <input type="text" name="alertName" placeholder="e.g. AAPL drops below $200" required>
                </div>

                <div class="form-group">
                    <label>Alert Message</label>
                    <textarea name="alertMessage" placeholder="Describe what this alert means to you and what action to take..."></textarea>
                </div>

                <!-- ── Condition Setting ── -->
                <div class="form-section-title" style="margin-top:8px;">⚙️ Condition Setting</div>

                <div class="setting-grid">
                    <div class="form-group" style="margin-bottom:0">
                        <label>Condition</label>
                        <select name="condition" required>
                            <option value="PRICE_ABOVE">Price Above ▲</option>
                            <option value="PRICE_BELOW">Price Below ▼</option>
                            <option value="PRICE_EQUALS">Price Equals =</option>
                            <option value="CHANGE_PCT_UP">Change % Up ▲</option>
                            <option value="CHANGE_PCT_DOWN">Change % Down ▼</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom:0">
                        <label>Value</label>
                        <input type="number" name="conditionValue" step="0.01" min="0"
                               placeholder="e.g. 200.00" required>
                    </div>

                    <div class="form-group" style="margin-bottom:0">
                        <label>Symbol</label>
                        <select name="assetId" required>
                            <option value="">-- Select --</option>
                            <% if (assets != null) { for (Asset a : assets) { %>
                            <option value="<%= a.getAssetId()%>"><%= a.getSymbol()%> — <%= a.getName()%></option>
                            <% } } %>
                        </select>
                    </div>
                </div>

                <!-- ── Severity ── -->
                <div class="form-group" style="margin-top:22px;">
                    <label>Severity</label>
                    <div class="severity-group" id="severityGroup">
                        <label class="severity-btn" id="lbl-low">
                            <input type="radio" name="severity" value="LOW" checked onchange="updateSeverity()">
                            🟢 Low
                        </label>
                        <label class="severity-btn" id="lbl-medium">
                            <input type="radio" name="severity" value="MEDIUM" onchange="updateSeverity()">
                            🟡 Medium
                        </label>
                        <label class="severity-btn" id="lbl-high">
                            <input type="radio" name="severity" value="HIGH" onchange="updateSeverity()">
                            🔴 High
                        </label>
                    </div>
                </div>

                <!-- ── Actions ── -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-dark">🔔 Create Alert</button>
                    <button type="button" class="btn btn-outline"
                            onclick="window.location.href='MainController?action=dashboard'">
                        ✕ Cancel
                    </button>
                </div>

            </form>
        </div><!-- /.form-body -->
    </div><!-- /.form-card -->
</div><!-- /.page-wrapper -->

<script>
function updateSeverity() {
    const val = document.querySelector('input[name="severity"]:checked').value;
    document.getElementById('lbl-low').className    = 'severity-btn' + (val === 'LOW'    ? ' sel-low'    : '');
    document.getElementById('lbl-medium').className = 'severity-btn' + (val === 'MEDIUM' ? ' sel-medium' : '');
    document.getElementById('lbl-high').className   = 'severity-btn' + (val === 'HIGH'   ? ' sel-high'   : '');
}
// Init on load
updateSeverity();
</script>

</body>
</html>
