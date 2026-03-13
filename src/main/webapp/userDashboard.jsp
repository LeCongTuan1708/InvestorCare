<%@page import="com.investorcare.model.AssetQuote"%>
<%@page import="com.investorcare.model.PortfolioHolding"%>
<%@page import="com.investorcare.model.Portfolio"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="com.investorcare.model.Alert"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) { response.sendRedirect("login.jsp"); return; }

    List<Portfolio> portfolios = (List<Portfolio>) request.getAttribute("portfolios");
    List<Asset> assets = (List<Asset>) request.getAttribute("assets");
    Map<Integer, AssetQuote> quotes = (Map<Integer, AssetQuote>) request.getAttribute("quotes");
    List<Alert> alerts = (List<Alert>) request.getAttribute("alerts");
    List<PortfolioHolding> holdings = (List<PortfolioHolding>) request.getAttribute("holdings");
    Integer openPortfolioId = (Integer) request.getAttribute("openPortfolioId");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null)
        unreadCount = 0;
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
            <div class="stat-box"><div class="stat-label">Member Since</div><div class="stat-value"><%= (acc.getCreated_at()!= null) ? acc.getCreated_at().substring(0, 10) : "N/A" %></div>
            </div>
            <div class="stat-box"><div class="stat-label">Last Login</div><div class="stat-value"><%= (acc.getLastLogin() != null) ? acc.getLastLogin() : "N/A" %></div></div>
        </div>
    </section>

        <!-- ===== NAV TABS ===== -->
        
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
                                        boolean up = q != null && q.getChange() >= 0;
                                        String cls = up ? "text-green" : "text-red";
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
                                    <% if (q != null && q.getCurrentPrice() > 0) {%>
                                    <span class="<%= cls%>"><%= arrow%> $<%= String.format("%.2f", Math.abs(q.getChange()))%></span>
                                    <% } else { %>—<% } %>
                                </td>
                                <td class="right">
                                    <% if (q != null && q.getCurrentPrice() > 0) {%>
                                    <span class="change-badge <%= up ? "badge-up" : "badge-down"%>">
                                        <%= arrow%> <%= String.format("%.2f", Math.abs(q.getChangePercent()))%>%
                                    </span>
                                    <% } else { %>—<% }%>
                                </td>
                                <td class="right mono"><%= q != null && q.getOpen() > 0 ? String.format("$%.2f", q.getOpen()) : "—"%></td>
                                <td class="right mono text-green"><%= q != null && q.getDayHigh() > 0 ? String.format("$%.2f", q.getDayHigh()) : "—"%></td>
                                <td class="right mono text-red">  <%= q != null && q.getDayLow() > 0 ? String.format("$%.2f", q.getDayLow()) : "—"%></td>
                                <td class="right mono muted">     <%= q != null && q.getPrevClose() > 0 ? String.format("$%.2f", q.getPrevClose()) : "—"%></td>
                                <td class="center">
                                    <div class="td-actions">
                                        <form action="PortfolioController" method="post">
                                            <input type="hidden" name="portfolioAction" value="addAsset">
                                            <input type="hidden" name="assetId" value="<%= a.getAssetId()%>">
                                            <select name="portfolioId" class="input-dark" required>
                                                <option value="">-- Select --</option>
                                                <% if (portfolios != null) {
                                                    for (Portfolio pOpt : portfolios) {%>
                                                <option value="<%= pOpt.getPortfolioId()%>"><%= pOpt.getName()%></option>
                                                <% }
                                                } %>
                                            </select>
                                            <input type="number" name="qty"     step="0.0001" placeholder="Qty"  class="input-dark sm" required>
                                            <input type="number" name="avgCost" step="0.01"   placeholder="Cost" class="input-dark sm" required>
                                            <button type="submit" class="btn btn-dark btn-sm">+ Add</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <% }
                            } %>
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
                        for (Portfolio p : portfolios) {%>
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
                    <% }
                    } else { %>
                    <p style="color:var(--text-muted);font-size:13px;text-align:center;padding:24px 0;">
                        No portfolios yet. Create one to get started!
                    </p>
                    <% } %>
                </div>
            </section>

            <!-- HOLDINGS PANEL -->
            <% if (holdings != null && openPortfolioId != null) {%>
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
                            <% for (PortfolioHolding h : holdings) {
                                boolean isProfit = h.getPnl() >= 0;%>
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
            <section id="watchlist" class="section-card" style="background: transparent; border: none; padding: 0; margin-bottom: 24px;">
                <div class="section-header" style="margin-bottom: 20px;">
                    <div class="section-title"><span class="icon">👁️</span> WatchList</div>
                    <a href="MainController?action=watch-list" class="btn btn-dark" style="text-decoration:none;">Manage WatchList</a>
                </div>

                <div class="watchlist-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px;">
                    <c:forEach items="${watchLists}" var="wl" varStatus="status">
                        <c:choose>
                            <c:when test="${status.index % 4 == 0}"><c:set var="wlColor" value="#00e5a0"/></c:when>
                            <c:when test="${status.index % 4 == 1}"><c:set var="wlColor" value="#3b82f6"/></c:when>
                            <c:when test="${status.index % 4 == 2}"><c:set var="wlColor" value="#a855f7"/></c:when>
                            <c:otherwise><c:set var="wlColor" value="#f59e0b"/></c:otherwise>
                        </c:choose>

                        <div class="watchlist-card"
                             style="background: #111d30; border: 1px solid #1e3050; border-radius: 12px; padding: 18px; cursor: pointer; display: flex; align-items: center; gap: 16px; transition: all 0.25s ease;"
                             onclick="window.location.href='MainController?action=watchlist-item&selectedId=${wl.watchListId}'"
                             onmouseover="this.style.transform='translateY(-3px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.4)'; this.style.borderColor='${wlColor}';"
                             onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'; this.style.borderColor='#1e3050';">

                            <div style="width: 48px; height: 48px; min-width: 48px; border-radius: 12px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; justify-content: center; font-size: 22px; color: ${wlColor};">
                                📂
                            </div>

                            <div style="flex: 1; overflow: hidden;">
                                <div class="ticker-symbol" style="font-size: 16px; font-weight: 600; color: #e8f0fc; margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                    ${wl.name}
                                </div>
                                <div class="ticker-name" style="font-size: 12px; color: #7a94b8; display: flex; align-items: center; gap: 4px;">
                                    <span>🗓</span> ${wl.createAt}
                                </div>
                            </div>

                            <div style="color: #3d5270; font-size: 16px; font-weight: bold; transition: color 0.2s;"
                                 onmouseover="this.style.color='${wlColor}'"
                                 onmouseout="this.style.color='#3d5270'">→</div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty watchLists}">
                        <div style="padding: 40px 20px; color: #7a94b8; grid-column: 1 / -1; text-align: center; background: #111d30; border-radius: 12px; border: 1px dashed #1e3050;">
                            <div style="font-size: 36px; margin-bottom: 12px; opacity: 0.5;">📁</div>
                            <div style="font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #e8f0fc;">Chưa có thư mục theo dõi</div>
                            <p style="font-size: 13px; margin-bottom: 16px;">Tạo danh sách để dễ dàng theo dõi các mã cổ phiếu tiềm năng.</p>
                            <a href="MainController?action=watch-list" class="btn btn-dark" style="text-decoration: none; padding: 8px 16px; font-size: 13px; border: 1px solid #1e3050; border-radius: 8px;">Thiết lập ngay</a>
                        </div>
                    </c:if>
                </div>
            </section>

            <!-- ALERTS -->
            <section id="alerts" class="section-card">
                <div class="section-header">
                    <div class="section-title">
                        <span class="icon">🔔</span> Alerts
                        <% if (unreadCount > 0) {%><span class="badge-count"><%= unreadCount%> new</span><% } %>
                    </div>
                    <a href="MainController?action=show-create-alert" class="btn btn-dark">+ Create Alert</a>
                </div>
                <div class="alert-list">
                    <% if (alerts != null && !alerts.isEmpty()) {
                        for (Alert a : alerts) {
                            String sev = "HIGH".equalsIgnoreCase(a.getSeverity()) ? "danger"
                                    : "MEDIUM".equalsIgnoreCase(a.getSeverity()) ? "warn" : "success";
                            String icon = "HIGH".equalsIgnoreCase(a.getSeverity()) ? "📉"
                                    : "MEDIUM".equalsIgnoreCase(a.getSeverity()) ? "⚠️" : "🔔";

                            String rawMsg = a.getMessage() != null ? a.getMessage() : "";
                            String condDesc = "";
                            String userMsg = rawMsg;
                            if (rawMsg.startsWith("[CONDITION:")) {
                                int end = rawMsg.indexOf("]");
                                if (end > 0) {
                                    String tag = rawMsg.substring(11, end);
                                    String[] parts = tag.split(":");
                                    if (parts.length == 2) {
                                        condDesc = parts[0].replace("_", " ") + " " + parts[1];
                                    }
                                    userMsg = rawMsg.substring(end + 1).trim();
                                }
                            }
                    %>
                    <div class="alert-item <%= sev%>">
                        <div class="alert-body">
                            <span class="alert-icon"><%= icon%></span>
                            <div>
                                <div class="alert-title"><%= userMsg.isEmpty() ? "(No message)" : userMsg%></div>
                                <div class="alert-desc" style="display:flex;gap:12px;margin-top:3px;">
                                    <% if (!condDesc.isEmpty()) {%>
                                    <span style="background:var(--bg-hover);padding:1px 8px;border-radius:4px;font-size:11px;">
                                        📌 <%= condDesc%>
                                    </span>
                                    <% }%>
                                    <span>Status: <strong style="color:var(--text-primary)"><%= a.getStatus()%></strong></span>
                                    <span>Severity: <strong style="color:var(--text-primary)"><%= a.getSeverity()%></strong></span>
                                </div>
                            </div>
                        </div>
                        <div class="alert-meta">
                            <span class="alert-time"><%= a.getTimestamp()%></span>
                            <a href="MainController?action=show-view-alert&alertId=<%= a.getAlertId()%>" class="btn btn-light btn-sm" title="View Alert">👁️</a>
                            <a href="MainController?action=show-edit-alert&alertId=<%= a.getAlertId()%>" class="btn btn-outline btn-sm" title="Edit Alert">✏️</a>
                            <form action="MainController" method="POST" style="display:inline">
                                <input type="hidden" name="action" value="delete-alert">
                                <input type="hidden" name="alertId" value="<%= a.getAlertId()%>">
                                <button type="submit" class="btn btn-danger btn-sm"
                                        onclick="return confirm('Delete this alert?')">🗑</button>
                            </form>
                        </div>
                    </div>
                    <% }
                    } else { %>
                    <p style="color:var(--text-muted);font-size:13px;text-align:center;padding:24px 0;">
                        No alerts yet. Create one to get notified!
                    </p>
                    <% }%>
                </div>
            </section>

            <!-- CARE NOTE -->
            <section id="carenote" class="section-card" style="background: transparent; border: none; padding: 0;">
                <div class="section-header" style="margin-bottom: 20px;">
                    <div class="section-title"><span class="icon">📝</span> Care Note</div>
                    <a href="MainController?action=care-note-list" class="btn btn-dark" style="text-decoration:none;">Manage Care Note</a>
                </div>

                <div class="note-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 16px;">
                    <c:forEach items="${careNotes}" var="note" varStatus="status">
                        <c:choose>
                            <c:when test="${status.index % 5 == 0}"><c:set var="colorClass" value="color-teal"/></c:when>
                            <c:when test="${status.index % 5 == 1}"><c:set var="colorClass" value="color-blue"/></c:when>
                            <c:when test="${status.index % 5 == 2}"><c:set var="colorClass" value="color-amber"/></c:when>
                            <c:when test="${status.index % 5 == 3}"><c:set var="colorClass" value="color-purple"/></c:when>
                            <c:otherwise><c:set var="colorClass" value="color-rose"/></c:otherwise>
                        </c:choose>

                        <div class="note-card ${colorClass}"
                             style="background: #111d30; border: 1px solid #1e3050; border-radius: 12px; padding: 20px; cursor: pointer; position: relative; overflow: hidden; transition: transform .2s, box-shadow .2s;"
                             onclick="window.location.href='MainController?action=show-edit-care-note&noteId=${note.noteId}'"
                             onmouseover="this.style.transform='translateY(-3px)'; this.style.boxShadow='0 8px 24px rgba(0,0,0,.4)';"
                             onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">

                            <div style="position: absolute; top: 0; left: 0; right: 0; height: 3px;
                                 ${status.index % 5 == 0 ? 'background: linear-gradient(90deg, #00e5a0, #00bcd4);' :
                                   status.index % 5 == 1 ? 'background: linear-gradient(90deg, #3b82f6, #6366f1);' :
                                   status.index % 5 == 2 ? 'background: linear-gradient(90deg, #f59e0b, #ef4444);' :
                                   status.index % 5 == 3 ? 'background: linear-gradient(90deg, #a855f7, #ec4899);' :
                                   'background: linear-gradient(90deg, #f43f5e, #f97316);'}">
                            </div>

                            <div class="note-top" style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                <span class="note-ticker" style="background: rgba(0,229,160,.1); border: 1px solid rgba(0,229,160,.25); color: #00e5a0; padding: 3px 8px; border-radius: 12px; font-size: 11px; font-weight: 700;">
                                    📌 ${note.asset.symbol != null ? note.asset.symbol : 'Ghi chú'}
                                </span>
                            </div>

                            <div class="note-title" style="font-size: 15px; font-weight: 600; color: #e8f0fc; margin-bottom: 8px; line-height: 1.4;">
                                ${note.title}
                            </div>

                            <div class="note-content" style="font-size: 13px; color: #7a94b8; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 14px;">
                                ${note.content}
                            </div>

                            <div class="note-footer" style="padding-top: 12px; border-top: 1px solid #1e3050; font-size: 11px; color: #3d5270;">
                                🗓 Cập nhật: ${note.updatedAt}
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty careNotes}">
                        <div style="padding: 30px; color: #7a94b8; grid-column: 1 / -1; text-align: center; background: #111d30; border-radius: 12px; border: 1px dashed #1e3050;">
                            Chưa có nhật ký nào. Bấm 'Manage Care Note' để bắt đầu ghi chép nhé!
                        </div>
                    </c:if>
                </div>
            </section>

        </div><!-- /.content -->

        <script>
            (function () {
                const navbar = document.querySelector('.navbar');
                const navTabs = document.querySelector('.nav-tabs');
                function getOffset() {
                    return (navbar ? navbar.offsetHeight : 64)
                            + (navTabs ? navTabs.offsetHeight : 48) + 8;
                }
                document.querySelectorAll('.nav-tabs .tab-link').forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        const target = document.getElementById(this.getAttribute('href').replace('#', ''));
                        if (!target) return;
                        window.scrollTo({top: target.getBoundingClientRect().top + window.scrollY - getOffset(), behavior: 'smooth'});
                        document.querySelectorAll('.nav-tabs .tab-link').forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    });
                });
                const sections = Array.from(document.querySelectorAll('section[id]'));
                const tabLinks = Array.from(document.querySelectorAll('.nav-tabs .tab-link'));
                function onScroll() {
                    const offset = getOffset() + 16;
                    let current = sections[0];
                    for (const sec of sections) {
                        if (sec.getBoundingClientRect().top <= offset) current = sec;
                    }
                    tabLinks.forEach(l => l.classList.toggle('active', l.getAttribute('href') === '#' + current.id));
                }
                window.addEventListener('scroll', onScroll, {passive: true});
                onScroll();
            })();
        </script>

    </body>
</html>
