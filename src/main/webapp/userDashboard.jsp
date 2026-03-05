<%@page import="com.investorcare.model.AssetQuote"%>
<%@page import="com.investorcare.model.PortfolioHolding"%>
<%@page import="com.investorcare.model.Portfolio"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="com.investorcare.model.Alert"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Portfolio> portfolios = (List<Portfolio>) request.getAttribute("portfolios");
    List<Asset> assets = (List<Asset>) request.getAttribute("assets");
    Map<Integer, AssetQuote> quotes = (Map<Integer, AssetQuote>) request.getAttribute("quotes");
    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) unreadCount = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TrustStock — Dashboard</title>
    <link rel="stylesheet" href="style_dashboard.css">
</head>
<body>

    <nav class="navbar">
        <div class="navbar-brand">
            <div class="navbar-brand-icon">📈</div>
            TrustStock
        </div>
        <div class="navbar-right">
            <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername()%></strong></span>
            <div class="navbar-avatar"><%= acc.getUsername().substring(0, 1).toUpperCase()%></div>
            <a href="MainController?action=logout" class="navbar-logout">Logout</a>
        </div>
    </nav>

    <div class="nav-tabs">
        <a href="#account"   class="tab-link active"><span class="icon">👤</span> Account</a>
        <a href="#market"    class="tab-link"><span class="icon">📊</span> Market</a>
        <a href="#portfolio" class="tab-link"><span class="icon">💼</span> Portfolio</a>
        <a href="#watchlist" class="tab-link"><span class="icon">👁️</span> WatchList</a>
        <a href="#alerts"    class="tab-link">
            <span class="icon">🔔</span> Alerts 
            <% if (unreadCount > 0) { %><span class="badge-count"><%= unreadCount %> new</span><% } %>
        </a>
        <a href="#carenote"  class="tab-link"><span class="icon">📝</span> Care Note</a>
    </div>

    <div class="content">

        <section id="account" class="section-card">
            <div class="section-header">
                <div class="section-title"><span class="icon">👤</span> Account</div>
                <form action="MainController" method="GET">
                    <button type="submit" name="action" value="editProfile" class="btn btn-light">✏️ Edit Profile</button>
                </form>
            </div>
            <div class="account-info">
                <div class="account-avatar"><%= acc.getUsername().substring(0, 1).toUpperCase()%></div>
                <div>
                    <div class="account-name"><%= acc.getUsername()%></div>
                    <div style="margin-top:6px;"><span class="badge badge-green">● Active</span></div>
                </div>
            </div>
            <div class="account-stats">
                <div class="stat-box"><div class="stat-label">Member Since</div><div class="stat-value">01/01/2025</div></div>
                <div class="stat-box"><div class="stat-label">Last Login</div><div class="stat-value">26/02/2026</div></div>
            </div>
        </section>

        <section id="market" class="section-card">
            <div class="section-header">
                <div class="section-title"><span class="icon">📊</span> Market Assets</div>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Symbol</th><th>Name</th><th>Exchange</th>
                            <th class="right">Price</th><th class="right">Change</th><th class="right">Change %</th>
                            <th class="right">Open</th><th class="right">High</th><th class="right">Low</th><th class="right">Prev Close</th>
                            <th class="center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (assets != null) {
                        for (Asset a : assets) {
                            AssetQuote q = quotes != null ? quotes.get(a.getAssetId()) : null;
                            boolean up = q != null && q.getChange() >= 0;
                            String changeClass = up ? "text-green" : "text-red";
                            String arrow = up ? "▲" : "▼";
                    %>
                    <tr>
                        <td class="bold"><span class="ticker-tag"><%= a.getSymbol()%></span></td>
                        <td class="muted"><%= a.getName()%></td>
                        <td><span class="exchange-tag"><%= a.getExchange()%></span></td>
                        <td class="right"><span class="price-cell"><%= q != null && q.getCurrentPrice() > 0 ? String.format("$%.2f", q.getCurrentPrice()) : "N/A"%></span></td>
                        <td class="right"><% if (q != null && q.getCurrentPrice() > 0) { %><span class="<%= changeClass%>"><%= arrow%> <%= String.format("$%.2f", Math.abs(q.getChange()))%></span><% } else { %>—<% } %></td>
                        <td class="right"><% if (q != null && q.getCurrentPrice() > 0) { %><span class="change-badge <%= up ? "badge-up" : "badge-down"%>"><%= arrow%> <%= String.format("%.2f", Math.abs(q.getChangePercent()))%>%</span><% } else { %>—<% } %></td>
                        <td class="right mono"><%= q != null && q.getOpen() > 0 ? String.format("$%.2f", q.getOpen()) : "—"%></td>
                        <td class="right mono text-green"><%= q != null && q.getDayHigh() > 0 ? String.format("$%.2f", q.getDayHigh()) : "—"%></td>
                        <td class="right mono text-red"><%= q != null && q.getDayLow() > 0 ? String.format("$%.2f", q.getDayLow()) : "—"%></td>
                        <td class="right mono muted"><%= q != null && q.getPrevClose() > 0 ? String.format("$%.2f", q.getPrevClose()) : "—"%></td>
                        <td class="center">
                            <div class="td-actions">
                                <form action="PortfolioController" method="post">
                                    <input type="hidden" name="portfolioAction" value="addAsset">
                                    <input type="hidden" name="assetId" value="<%= a.getAssetId()%>">
                                    <select name="portfolioId" class="input-dark" required>
                                        <option value="">-- Select --</option>
                                        <% if (portfolios != null) { for (Portfolio pOpt : portfolios) { %>
                                        <option value="<%= pOpt.getPortfolioId()%>"><%= pOpt.getName()%></option>
                                        <% } } %>
                                    </select>
                                    <input type="number" name="qty" step="0.0001" placeholder="Qty" class="input-dark sm" required>
                                    <input type="number" name="avgCost" step="0.01" placeholder="Cost" class="input-dark sm" required>
                                    <button type="submit" class="btn btn-dark btn-sm">+ Add</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="portfolio" class="section-card">
            <div class="section-header">
                <div class="section-title"><span class="icon">💼</span> My Portfolios</div>
                <form action="MainController" method="post" style="display:flex;gap:8px;align-items:center;">
                    <input type="hidden" name="action" value="portfolio">
                    <input type="hidden" name="portfolioAction" value="create">
                    <input class="input-dark" name="portfolioName" placeholder="New portfolio name..." required>
                    <button class="btn btn-dark">+ Create</button>
                </form>
            </div>
            <div class="portfolio-list">
            <% if (portfolios != null && !portfolios.isEmpty()) {
                    for (Portfolio p : portfolios) { %>
            <div class="portfolio-card">
                <input type="checkbox" id="rename-toggle-<%= p.getPortfolioId()%>" class="rename-toggle">
                <div class="portfolio-main">
                    <div class="portfolio-name">💼 <%= p.getName()%></div>
                    <div class="portfolio-actions">
                        <form action="PortfolioController" method="post" style="display:inline">
                            <input type="hidden" name="portfolioAction" value="open">
                            <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                            <button type="submit" class="btn btn-light btn-sm">📂 Open</button>
                        </form>
                        <label for="rename-toggle-<%= p.getPortfolioId()%>" class="btn btn-light btn-sm">✏️ Rename</label>
                        <form action="PortfolioController" method="post" style="display:inline" onsubmit="return confirm('Delete portfolio <%= p.getName()%>?')">
                            <input type="hidden" name="portfolioAction" value="delete">
                            <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                            <button type="submit" class="btn btn-danger btn-sm">🗑 Delete</button>
                        </form>
                    </div>
                </div>
                <form action="PortfolioController" method="post" class="rename-form">
                    <input type="hidden" name="portfolioAction" value="rename">
                    <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                    <input class="input-dark" name="portfolioName" value="<%= p.getName()%>" required>
                    <button type="submit" class="btn btn-dark btn-sm">✔ Save</button>
                    <label for="rename-toggle-<%= p.getPortfolioId()%>" class="btn btn-outline btn-sm">Cancel</label>
                </form>
            </div>
            <% } } else { %>
            <p class="empty-msg">No portfolios yet. Create one to get started!</p>
            <% } %>
            </div>
        </section>

        <section id="alerts" class="section-card">
            <div class="section-header">
                <div class="section-title"><span class="icon">🔔</span> Alerts</div>
            </div>
            <div class="alert-list">
                <% if (alerts != null && !alerts.isEmpty()) {
                    for (Alert a : alerts) {
                        String severityClass = "warn";
                        if ("HIGH".equalsIgnoreCase(a.getSeverity())) severityClass = "danger";
                %>
                <div class="alert-item <%= severityClass %>">
                    <div class="alert-body">
                        <span class="alert-icon">⚠️</span>
                        <div>
                            <div class="alert-title"><%= a.getMessage() %></div>
                            <div class="alert-desc">Asset ID: <%= a.getAssetId() %></div>
                        </div>
                    </div>
                    <div class="alert-meta">
                        <span class="alert-time"><%= a.getTimestamp() %></span>
                        <button class="btn btn-outline btn-sm">View</button>
                    </div>
                </div>
                <% } } else { %>
                <p style="color:gray; padding:20px; text-align:center;">No alerts found.</p>
                <% } %>
            </div>
        </section>

        <section id="carenote" class="section-card">
            <div class="section-header"><div class="section-title"><span class="icon">📝</span> Care Note</div></div>
            <div class="note-grid">
                <div class="note-card blue">
                    <div class="note-header">📌 Strategy</div>
                    <div class="note-body">Monitor market volatility. Long-term hold.</div>
                    <div class="note-date">24/02/2026</div>
                </div>
            </div>
        </section>

    </div>

    <script>
        (function () {
            const navbar = document.querySelector('.navbar');
            const navTabs = document.querySelector('.nav-tabs');
            function getOffset() {
                return (navbar ? navbar.offsetHeight : 64) + (navTabs ? navTabs.offsetHeight : 48) + 8;
            }
            document.querySelectorAll('.nav-tabs .tab-link').forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    const targetId = this.getAttribute('href').replace('#', '');
                    const target = document.getElementById(targetId);
                    if (!target) return;
                    window.scrollTo({
                        top: target.getBoundingClientRect().top + window.scrollY - getOffset(),
                        behavior: 'smooth'
                    });
                });
            });
            const sections = Array.from(document.querySelectorAll('section[id]'));
            const tabLinks = Array.from(document.querySelectorAll('.nav-tabs .tab-link'));
            window.addEventListener('scroll', () => {
                const offset = getOffset() + 20;
                let current = sections[0];
                sections.forEach(sec => {
                    if (sec.getBoundingClientRect().top <= offset) current = sec;
                });
                tabLinks.forEach(l => l.classList.toggle('active', l.getAttribute('href') === '#' + current.id));
            }, { passive: true });
        })();
    </script>
</body>
</html>