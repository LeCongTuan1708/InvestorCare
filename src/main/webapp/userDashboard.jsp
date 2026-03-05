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
    if (acc == null) { response.sendRedirect("login.jsp"); return; }

    List<Portfolio>          portfolios     = (List<Portfolio>)          request.getAttribute("portfolios");
    List<Asset>              assets         = (List<Asset>)              request.getAttribute("assets");
    Map<Integer,AssetQuote>  quotes         = (Map<Integer,AssetQuote>)  request.getAttribute("quotes");
    List<Alert>              alerts         = (List<Alert>)              request.getAttribute("alerts");
    List<PortfolioHolding>   holdings       = (List<PortfolioHolding>)   request.getAttribute("holdings");
    Integer                  openPortfolioId= (Integer)                  request.getAttribute("openPortfolioId");
    Integer                  unreadCount    = (Integer)                  request.getAttribute("unreadCount");
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

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
    <div class="navbar-brand">
        <div class="navbar-brand-icon">📈</div>
        InvestorCare
    </div>
    <div class="navbar-right">
        <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername()%></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase()%></div>
        <a href="MainController?action=logout" class="navbar-logout">Log out</a>
    </div>
</nav>

<!-- ===== NAV TABS ===== -->
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

<!-- ===== CONTENT ===== -->
<div class="content">

    <!-- ACCOUNT -->
    <section id="account" class="section-card">
        <div class="section-header">
            <div class="section-title"><span class="icon">👤</span> Account</div>
            <form action="MainController" method="GET">
                <button type="submit" name="action" value="editProfile" class="btn btn-light">✏️ Edit Profile</button>
            </form>
        </div>
        <div class="account-info">
            <div class="account-avatar"><%= acc.getUsername().substring(0,1).toUpperCase()%></div>
            <div>
                <div class="account-name"><%= acc.getUsername()%></div>
                <div style="margin-top:6px;"><span class="badge badge-green">● Active</span></div>
            </div>
        </div>
        <div class="account-stats">
            <div class="stat-box"><div class="stat-label">Member Since</div><div class="stat-value">01/01/2025</div></div>
            <div class="stat-box"><div class="stat-label">Last Login</div><div class="stat-value"><%= (acc.getLastLogin() != null) ? acc.getLastLogin() : "N/A" %></div></div>
        </div>
    </section>

    <!-- MARKET -->
    <section id="market" class="section-card">
        <div class="section-header">
            <div class="section-title"><span class="icon">📊</span> Market Assets</div>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Symbol</th><th>Name</th><th>Exchange</th>
                        <th class="right">Price</th>
                        <th class="right">Change</th>
                        <th class="right">Change %</th>
                        <th class="right">Open</th>
                        <th class="right">High</th>
                        <th class="right">Low</th>
                        <th class="right">Prev Close</th>
                        <th class="center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (assets != null) {
                        for (Asset a : assets) {
                            AssetQuote q = quotes != null ? quotes.get(a.getAssetId()) : null;
                            boolean up   = q != null && q.getChange() >= 0;
                            String cls   = up ? "text-green" : "text-red";
                            String arrow = up ? "▲" : "▼";
                %>
                <tr>
                    <td class="bold"><span class="ticker-tag"><%= a.getSymbol()%></span></td>
                    <td class="muted"><%= a.getName()%></td>
                    <td><span class="exchange-tag"><%= a.getExchange()%></span></td>
                    <td class="right">
                        <span class="price-cell"><%= q != null && q.getCurrentPrice() > 0 ? String.format("$%.2f", q.getCurrentPrice()) : "N/A"%></span>
                    </td>
                    <td class="right">
                        <% if (q != null && q.getCurrentPrice() > 0) { %>
                            <span class="<%= cls%>"><%= arrow%> $<%= String.format("%.2f", Math.abs(q.getChange()))%></span>
                        <% } else { %>—<% } %>
                    </td>
                    <td class="right">
                        <% if (q != null && q.getCurrentPrice() > 0) { %>
                            <span class="change-badge <%= up ? "badge-up" : "badge-down"%>">
                                <%= arrow%> <%= String.format("%.2f", Math.abs(q.getChangePercent()))%>%
                            </span>
                        <% } else { %>—<% } %>
                    </td>
                    <td class="right mono"><%= q != null && q.getOpen()      > 0 ? String.format("$%.2f", q.getOpen())      : "—"%></td>
                    <td class="right mono text-green"><%= q != null && q.getDayHigh()   > 0 ? String.format("$%.2f", q.getDayHigh())   : "—"%></td>
                    <td class="right mono text-red">  <%= q != null && q.getDayLow()    > 0 ? String.format("$%.2f", q.getDayLow())    : "—"%></td>
                    <td class="right mono muted">     <%= q != null && q.getPrevClose() > 0 ? String.format("$%.2f", q.getPrevClose()) : "—"%></td>
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
                                <input type="number" name="qty"     step="0.0001" placeholder="Qty"  class="input-dark sm" required>
                                <input type="number" name="avgCost" step="0.01"   placeholder="Cost" class="input-dark sm" required>
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

    <!-- PORTFOLIO -->
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
        <div class="portfolio-card" id="portfolio-card-<%= p.getPortfolioId()%>">
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
                    <form action="PortfolioController" method="post" style="display:inline"
                          onsubmit="return confirm('Delete portfolio <%= p.getName()%>?')">
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
        <p style="color:var(--text-muted);font-size:13px;text-align:center;padding:24px 0;">
            No portfolios yet. Create one to get started!
        </p>
        <% } %>
        </div>
    </section>

    <!-- HOLDINGS PANEL -->
    <% if (holdings != null && openPortfolioId != null) { %>
    <div class="holdings-panel section-card">
        <div class="holdings-header">
            <span>📋 Portfolio Details</span>
            <span class="holdings-count"><%= holdings.size()%> holdings</span>
        </div>
        <% if (holdings.isEmpty()) { %>
        <p class="empty-hint">No holdings in this portfolio yet.</p>
        <% } else { %>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Symbol</th><th>Name</th><th>Exchange</th>
                        <th class="right">Qty</th><th class="right">Avg Cost</th>
                        <th class="right">Current Price</th><th class="right">Market Value</th>
                        <th class="right">P&L ($)</th><th class="right">P&L (%)</th>
                        <th class="center">Remove</th>
                    </tr>
                </thead>
                <tbody>
                <% for (PortfolioHolding h : holdings) { boolean isProfit = h.getPnl() >= 0; %>
                <tr>
                    <td><span class="ticker-tag"><%= h.getSymbol()%></span></td>
                    <td class="muted"><%= h.getName()%></td>
                    <td><span class="exchange-tag"><%= h.getExchange()%></span></td>
                    <td class="right bold"><%= String.format("%.4f", h.getQty())%></td>
                    <td class="right price-cell">$<%= String.format("%.2f", h.getAvgCost())%></td>
                    <td class="right price-cell">$<%= String.format("%.2f", h.getCurrentPrice())%></td>
                    <td class="right bold">$<%= String.format("%.2f", h.getMarketValue())%></td>
                    <td class="right">
                        <span class="<%= isProfit ? "text-green" : "text-red"%>">
                            <%= isProfit ? "▲ +$" : "▼ -$"%><%= String.format("%.2f", Math.abs(h.getPnl()))%>
                        </span>
                    </td>
                    <td class="right">
                        <span class="<%= isProfit ? "text-green" : "text-red"%>">
                            <%= isProfit ? "+" : ""%><%= String.format("%.2f", h.getPnlPercent())%>%
                        </span>
                    </td>
                    <td class="center">
                        <form action="PortfolioController" method="post">
                            <input type="hidden" name="portfolioAction" value="removeAsset">
                            <input type="hidden" name="portfolioId" value="<%= openPortfolioId%>">
                            <input type="hidden" name="assetId" value="<%= h.getAssetId()%>">
                            <button type="submit" class="btn btn-danger btn-sm">✕</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- WATCHLIST -->
    <section id="watchlist" class="section-card">
        <div class="section-header">
            <div class="section-title"><span class="icon">👁️</span> WatchList</div>
            <a href="MainController?action=watch-list" class="btn btn-dark">Manage WatchList</a>
        </div>
        <div class="watchlist-grid">
            <div class="watchlist-card">
                <div class="watchlist-card-header">
                    <div><div class="ticker-symbol">NVDA</div><div class="ticker-name">NVIDIA Corp.</div></div>
                    <button class="btn-remove">✕</button>
                </div>
                <div class="ticker-price">$875.40</div>
                <div class="ticker-change text-green">▲ +2.1% today</div>
                <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Add to Portfolio</button>
            </div>
            <div class="watchlist-card">
                <div class="watchlist-card-header">
                    <div><div class="ticker-symbol">META</div><div class="ticker-name">Meta Platforms</div></div>
                    <button class="btn-remove">✕</button>
                </div>
                <div class="ticker-price">$512.10</div>
                <div class="ticker-change text-green">▲ +0.9% today</div>
                <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Add to Portfolio</button>
            </div>
            <div class="watchlist-card">
                <div class="watchlist-card-header">
                    <div><div class="ticker-symbol">VNM</div><div class="ticker-name">Vinamilk</div></div>
                    <button class="btn-remove">✕</button>
                </div>
                <div class="ticker-price">68,500₫</div>
                <div class="ticker-change text-red">▼ -0.7% today</div>
                <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Add to Portfolio</button>
            </div>
        </div>
    </section>

    <!-- ALERTS -->
    <section id="alerts" class="section-card">
        <div class="section-header">
            <div class="section-title">
                <span class="icon">🔔</span> Alerts
                <% if (unreadCount > 0) { %><span class="badge-count"><%= unreadCount %> new</span><% } %>
            </div>
        </div>
        <div class="alert-list">
        <% if (alerts != null && !alerts.isEmpty()) {
               for (Alert a : alerts) {
                   String sev = "HIGH".equalsIgnoreCase(a.getSeverity()) ? "danger" : "warn";
                   String icon = "HIGH".equalsIgnoreCase(a.getSeverity()) ? "📉" : "⚠️";
        %>
        <div class="alert-item <%= sev%>">
            <div class="alert-body">
                <span class="alert-icon"><%= icon%></span>
                <div>
                    <div class="alert-title"><%= a.getMessage()%></div>
                    <div class="alert-desc">Asset ID: <%= a.getAssetId()%></div>
                </div>
            </div>
            <div class="alert-meta">
                <span class="alert-time"><%= a.getTimestamp()%></span>
                <button class="btn btn-outline btn-sm">View</button>
            </div>
        </div>
        <% } } else { %>
        <p style="color:var(--text-muted);font-size:13px;text-align:center;padding:24px 0;">No alerts found.</p>
        <% } %>
        </div>
    </section>

    <!-- CARE NOTE -->
    <section id="carenote" class="section-card">
        <div class="section-header">
            <div class="section-title"><span class="icon">📝</span> Care Note</div>
            <a href="MainController?action=care-note-list" class="btn btn-dark">+ Add Note</a>
        </div>
        <div class="note-grid">
            <div class="note-card blue">
                <div class="note-header">
                    <div class="note-title blue">📌 This week's strategy</div>
                    <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                </div>
                <div class="note-body">Monitor AAPL before Q1 earnings report. Hold MSFT long-term. Consider rebalancing end of month.</div>
                <div class="note-date">24/02/2026</div>
            </div>
            <div class="note-card purple">
                <div class="note-header">
                    <div class="note-title purple">💡 Reminder</div>
                    <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                </div>
                <div class="note-body">Consider cutting TSLA if it continues below $175. Set stop-loss at $170.</div>
                <div class="note-date">25/02/2026</div>
            </div>
            <div class="note-card orange">
                <div class="note-header">
                    <div class="note-title orange">🎯 March Target</div>
                    <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                </div>
                <div class="note-body">Reach total assets of $30,000. Open more NVDA position if price drops to $850.</div>
                <div class="note-date">20/02/2026</div>
            </div>
            <div class="note-card empty">
                <a href="MainController?action=care-note-list" style="text-decoration:none;color:inherit;">+ Add new note</a>
            </div>
        </div>
    </section>

</div><!-- /.content -->

<script>
(function () {
    const navbar  = document.querySelector('.navbar');
    const navTabs = document.querySelector('.nav-tabs');
    function getOffset() {
        return (navbar  ? navbar.offsetHeight  : 64)
             + (navTabs ? navTabs.offsetHeight : 48) + 8;
    }
    document.querySelectorAll('.nav-tabs .tab-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.getElementById(this.getAttribute('href').replace('#',''));
            if (!target) return;
            window.scrollTo({ top: target.getBoundingClientRect().top + window.scrollY - getOffset(), behavior: 'smooth' });
            document.querySelectorAll('.nav-tabs .tab-link').forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
    const sections = Array.from(document.querySelectorAll('section[id]'));
    const tabLinks  = Array.from(document.querySelectorAll('.nav-tabs .tab-link'));
    function onScroll() {
        const offset = getOffset() + 16;
        let current = sections[0];
        for (const sec of sections) { if (sec.getBoundingClientRect().top <= offset) current = sec; }
        tabLinks.forEach(l => l.classList.toggle('active', l.getAttribute('href') === '#' + current.id));
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
})();
</script>

</body>
</html>
