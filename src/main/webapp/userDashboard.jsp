<%@page import="com.investorcare.model.AssetQuote"%>
<%@page import="com.investorcare.model.PortfolioHolding"%>
<%@page import="com.investorcare.model.Portfolio"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="com.investorcare.model.Alert"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lấy thông tin user từ session (sử dụng key "LOGIN_USER" theo logic Controller của bạn)
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy dữ liệu từ Request Attribute (được đổ từ DashboardController)
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
        <title>Dashboard - TrustStock</title>
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
                <% if (unreadCount > 0) { %><span class="badge-count"><%= unreadCount %></span><% } %>
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
                        <div style="margin-top:6px;"><span class="badge-status badge-green">● Active</span></div>
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
                                <th class="right">Price</th><th class="right">Change %</th>
                                <th class="center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (assets != null) {
                                for (Asset a : assets) {
                                    AssetQuote q = (quotes != null) ? quotes.get(a.getAssetId()) : null;
                            %>
                            <tr>
                                <td class="bold"><span class="ticker-tag"><%= a.getSymbol()%></span></td>
                                <td class="muted"><%= a.getName()%></td>
                                <td><span class="exchange-tag"><%= a.getExchange()%></span></td>
                                <td class="right"><%= (q != null) ? "$" + q.getCurrentPrice() : "N/A" %></td>
                                <td class="right">
                                    <% if (q != null) { %>
                                        <span class="<%= q.getChangePercent() >= 0 ? "text-green" : "text-red" %>">
                                            <%= String.format("%.2f", q.getChangePercent()) %>%
                                        </span>
                                    <% } else { %> — <% } %>
                                </td>
                                <td class="center">
                                    <button class="btn btn-dark btn-sm">+ Add</button>
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
                </div>
                <div class="portfolio-list">
                    <% if (portfolios != null && !portfolios.isEmpty()) {
                        for (Portfolio p : portfolios) { %>
                        <div class="portfolio-card">
                            <div class="portfolio-name">💼 <%= p.getName() %></div>
                            <div class="portfolio-actions">
                                <button class="btn btn-light btn-sm">📂 Open</button>
                            </div>
                        </div>
                    <% } } else { %>
                        <p class="empty-msg">No portfolios yet.</p>
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
                        <p class="empty-msg">No alerts found.</p>
                    <% } %>
                </div>
            </section>

            <section id="carenote" class="section-card">
                <div class="section-header">
                    <div class="section-title"><span class="icon">📝</span> Care Note</div>
                    <button class="btn btn-dark">+ Add Note</button>
                </div>
                <div class="note-grid">
                    <div class="note-card blue">
                        <div class="note-header">📌 Strategy</div>
                        <div class="note-body">Monitor market volatility.</div>
                        <div class="note-date">24/02/2026</div>
                    </div>
                </div>
            </section>

        </div> <script>
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
                        document.querySelectorAll('.nav-tabs .tab-link').forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
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