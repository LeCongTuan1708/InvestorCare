<%@page import="com.investorcare.model.PortfolioHolding"%>
<%@page import="com.investorcare.model.Portfolio"%>
<%@page import="com.investorcare.model.User"%>
<%@page import="java.util.*"%>
<%@page import="com.investorcare.model.Asset"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TrustStock — Dashboard</title>
        <link rel="stylesheet" href="style_dashboard.css">
    </head>
    <body>
        <%
            User acc = (User) session.getAttribute("LOGIN_USER");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            List<Portfolio> portfolios = (List<Portfolio>) request.getAttribute("portfolios");
        %>

        <!-- ===== NAVBAR ===== -->
        <nav class="navbar">
            <div class="navbar-brand">
                <div class="navbar-brand-icon">📈</div>
                TrustStock
            </div>
            <div class="navbar-right">
                <span class="navbar-greeting">Xin chào, <strong><%= acc.getUsername()%></strong></span>
                <div class="navbar-avatar"><%= acc.getUsername().substring(0, 1).toUpperCase()%></div>
                <a href="MainController?action=logout" class="navbar-logout">Đăng xuất</a>
            </div>
        </nav>

        <!-- ===== NAVIGATION TABS ===== -->
        <div class="nav-tabs">
            <a href="#account" class="tab-link active"><span class="icon">👤</span> Account</a>
            <a href="#market"    class="tab-link"><span class="icon">📊</span> Market</a>
            <a href="#portfolio" class="tab-link"><span class="icon">💼</span> Portfolio</a>
            <a href="#watchlist" class="tab-link"><span class="icon">👁️</span> WatchList</a>
            <a href="#alerts"    class="tab-link"><span class="icon">🔔</span> Alerts</a>
            <a href="#carenote"  class="tab-link"><span class="icon">📝</span> Care Note</a>
        </div>

        <!-- ===== MAIN CONTENT ===== -->
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
                    <div class="account-avatar"><%= acc.getUsername().substring(0, 1).toUpperCase()%></div>
                    <div>
                        <div class="account-name"><%= acc.getUsername()%></div>
                        <div style="margin-top:6px;"><span class="badge badge-green">● Active</span></div>
                    </div>
                </div>
                <div class="account-stats">
                    <div class="stat-box">
                        <div class="stat-label">Tham gia từ</div>
                        <div class="stat-value">01/01/2025</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">Đăng nhập cuối</div>
                        <div class="stat-value">26/02/2026</div>
                    </div>
                </div>
            </section>

            <!-- MARKET ASSETS -->
            <%
                List<Asset> assets = (List<Asset>) request.getAttribute("assets");
                Map<Integer, Double> prices = (Map<Integer, Double>) request.getAttribute("prices");
            %>
            <section id="market" class="section-card">
                <div class="section-header">
                    <div class="section-title"><span class="icon">📊</span> Market Assets</div>
                </div>
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã</th><th>Tên</th><th>Sàn</th>
                                <th class="right">Giá hiện tại</th>
                                <th class="center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (assets != null) {
                                    for (Asset a : assets) {
                                        Double price = prices != null ? prices.get(a.getAssetId()) : null;
                            %>
                            <tr>
                                <td class="bold"><span class="ticker-tag"><%= a.getSymbol()%></span></td>
                                <td class="muted"><%= a.getName()%></td>
                                <td><span class="exchange-tag"><%= a.getExchange()%></span></td>
                                <td class="right"><span class="price-cell"><%= price != null ? "$" + price : "N/A"%></span></td>
                                <td class="center">
                                    <div class="td-actions">
                                        <form action="PortfolioController" method="post">
                                            <input type="hidden" name="portfolioAction" value="addAsset">
                                            <input type="hidden" name="assetId" value="<%= a.getAssetId()%>">
                                            <select name="portfolioId" class="input-dark" required>
                                                <option value="">-- Chọn portfolio --</option>
                                                <% if (portfolios != null) {
                                            for (Portfolio pOpt : portfolios) {%>
                                                <option value="<%= pOpt.getPortfolioId()%>"><%= pOpt.getName()%></option>
                                                <% }
                                        } %>
                                            </select>
                                            <input type="number" name="qty" step="0.0001" placeholder="SL" class="input-dark sm" required>
                                            <input type="number" name="avgCost" step="0.01" placeholder="Giá vốn" class="input-dark sm" required>
                                            <button type="submit" class="btn btn-dark btn-sm">+ Thêm</button>
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
                        <input class="input-dark" name="portfolioName" placeholder="Tên portfolio mới..." required>
                        <button class="btn btn-dark">+ Tạo mới</button>
                    </form>
                </div>
                <div class="portfolio-list">
                    <%
                        if (portfolios != null && !portfolios.isEmpty()) {
                            for (Portfolio p : portfolios) {
                    %>
                    <div class="portfolio-card">
                        <input type="checkbox" id="rename-toggle-<%= p.getPortfolioId()%>" class="rename-toggle">
                        <div class="portfolio-main">
                            <div class="portfolio-name">💼 <%= p.getName()%></div>
                            <div class="portfolio-actions">
                                <form action="PortfolioController" method="post">
                                    <input type="hidden" name="portfolioAction" value="open">
                                    <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                                    <button type="submit" class="btn btn-light btn-sm">📂 Mở</button>
                                </form>
                                <label for="rename-toggle-<%= p.getPortfolioId()%>" class="btn btn-light btn-sm">✏️ Đổi tên</label>
                                <form action="PortfolioController" method="post"
                                      onsubmit="return confirm('Xoá portfolio <%= p.getName()%>?')">
                                    <input type="hidden" name="portfolioAction" value="delete">
                                    <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                                    <button type="submit" class="btn btn-danger btn-sm">🗑 Xoá</button>
                                </form>
                            </div>
                        </div>
                        <form action="PortfolioController" method="post" class="rename-form">
                            <input type="hidden" name="portfolioAction" value="rename">
                            <input type="hidden" name="portfolioId" value="<%= p.getPortfolioId()%>">
                            <input class="input-dark" name="portfolioName" value="<%= p.getName()%>" required>
                            <button type="submit" class="btn btn-dark btn-sm">✔ Lưu</button>
                            <label for="rename-toggle-<%= p.getPortfolioId()%>" class="btn btn-outline btn-sm">Huỷ</label>
                        </form>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <p style="color:var(--text-muted);font-size:13px;text-align:center;padding:24px 0;">
                        Chưa có portfolio nào. Hãy tạo mới!
                    </p>
                    <% } %>
                </div>
            </section>

            <!-- HOLDINGS PANEL -->
            <%
                List<PortfolioHolding> holdings = (List<PortfolioHolding>) request.getAttribute("holdings");
                Integer openPortfolioId = (Integer) request.getAttribute("openPortfolioId");
                if (holdings != null && openPortfolioId != null) {
            %>
            <div class="holdings-panel section-card">
                <div class="holdings-header">
                    <span>📋 Chi tiết Portfolio</span>
                    <span class="holdings-count"><%= holdings.size()%> cổ phiếu</span>
                </div>
                <% if (holdings.isEmpty()) { %>
                <p class="empty-hint">Chưa có cổ phiếu nào trong portfolio này.</p>
                <% } else { %>
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã</th><th>Tên</th><th>Sàn</th>
                                <th class="right">SL</th><th class="right">Giá vốn</th>
                                <th class="right">Giá hiện tại</th><th class="right">Giá trị</th>
                                <th class="right">Lãi/Lỗ ($)</th><th class="right">Lãi/Lỗ (%)</th>
                                <th class="center">Xoá</th>
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
            <section id="watchlist" class="section-card">
                <div class="section-header">
                    <div class="section-title"><span class="icon">👁️</span> WatchList</div>
                    <a href="MainController?action=watch-list" class="btn btn-dark">Quản lý WatchList</a>
                </div>
                <div class="watchlist-grid">
                    <div class="watchlist-card">
                        <div class="watchlist-card-header">
                            <div><div class="ticker-symbol">NVDA</div><div class="ticker-name">NVIDIA Corp.</div></div>
                            <button class="btn-remove">✕</button>
                        </div>
                        <div class="ticker-price">$875.40</div>
                        <div class="ticker-change text-green">▲ +2.1% hôm nay</div>
                        <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Thêm vào Portfolio</button>
                    </div>
                    <div class="watchlist-card">
                        <div class="watchlist-card-header">
                            <div><div class="ticker-symbol">META</div><div class="ticker-name">Meta Platforms</div></div>
                            <button class="btn-remove">✕</button>
                        </div>
                        <div class="ticker-price">$512.10</div>
                        <div class="ticker-change text-green">▲ +0.9% hôm nay</div>
                        <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Thêm vào Portfolio</button>
                    </div>
                    <div class="watchlist-card">
                        <div class="watchlist-card-header">
                            <div><div class="ticker-symbol">VNM</div><div class="ticker-name">Vinamilk</div></div>
                            <button class="btn-remove">✕</button>
                        </div>
                        <div class="ticker-price">68,500₫</div>
                        <div class="ticker-change text-red">▼ -0.7% hôm nay</div>
                        <button class="btn btn-light btn-sm" style="width:100%;margin-top:8px;">Thêm vào Portfolio</button>
                    </div>
                </div>
            </section>

            <!-- ALERTS -->
            <%
                List<com.investorcare.model.Alert> alerts
                        = (List<com.investorcare.model.Alert>) request.getAttribute("alerts");

                Integer unreadCount
                        = (Integer) request.getAttribute("unreadCount");

                if (unreadCount == null)
                    unreadCount = 0;
            %>

            <section id="alerts" class="section-card">
                <div class="section-header">
                    <div class="section-title">
                        <span class="icon">🔔</span>
                        Alerts
                        <span class="badge-count"><%= unreadCount%> mới</span>
                    </div>
                </div>

                <div class="alert-list">

                    <%
                        if (alerts != null && !alerts.isEmpty()) {
                            for (com.investorcare.model.Alert a : alerts) {
                                String cssClass = "warn";

                                if ("HIGH".equalsIgnoreCase(a.getSeverity()))
                                    cssClass = "danger";
                    %>

                    <div class="alert-item <%= cssClass%>">
                        <div class="alert-body">
                            <span class="alert-icon">⚠️</span>
                            <div>
                                <div class="alert-title"><%= a.getMessage()%></div>
                                <div class="alert-desc">
                                    Asset ID: <%= a.getAssetId()%>
                                </div>
                            </div>
                        </div>
                        <div class="alert-meta">
                            <span class="alert-time">
                                <%= a.getTimestamp()%>
                            </span>
                        </div>
                    </div>

                    <%
                        }
                    } else {
                    %>
                    <p style="color:gray;">Không có cảnh báo nào.</p>
                    <%
                        }
                    %>

                </div>
            </section>

            <!-- CARE NOTE -->
            <section id="carenote" class="section-card">
                <div class="section-header">
                    <div class="section-title"><span class="icon">📝</span> Care Note</div>
                    <a href="MainController?action=care-note-list" class="btn btn-dark">+ Thêm ghi chú</a>
                </div>
                <div class="note-grid">
                    <div class="note-card blue">
                        <div class="note-header">
                            <div class="note-title blue">📌 Chiến lược tuần này</div>
                            <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                        </div>
                        <div class="note-body">Theo dõi AAPL trước báo cáo thu nhập Q1. Hold MSFT dài hạn. Cân nhắc rebalance cuối tháng.</div>
                        <div class="note-date">24/02/2026</div>
                    </div>
                    <div class="note-card purple">
                        <div class="note-header">
                            <div class="note-title purple">💡 Nhắc nhở</div>
                            <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                        </div>
                        <div class="note-body">Xem xét cắt giảm TSLA nếu tiếp tục giảm dưới $175. Đặt stop-loss tại $170.</div>
                        <div class="note-date">25/02/2026</div>
                    </div>
                    <div class="note-card orange">
                        <div class="note-header">
                            <div class="note-title orange">🎯 Mục tiêu tháng 3</div>
                            <div class="note-actions"><button class="btn-icon">✏️</button><button class="btn-icon">🗑️</button></div>
                        </div>
                        <div class="note-body">Đạt tổng tài sản $30,000. Mở thêm vị thế NVDA nếu giá về $850.</div>
                        <div class="note-date">20/02/2026</div>
                    </div>
                    <div class="note-card empty">
                        <a href="MainController?action=care-note-list" style="text-decoration:none;color:inherit;">+ Thêm ghi chú mới</a>
                    </div>
                </div>
            </section>

        </div><!-- /.content -->

        <script>
            const OFFSET = 112 + 20; // navbar(64) + nav-tabs(48) + gap

            // ── 1. Click tab → smooth scroll đến đúng section ──
            document.querySelectorAll('.nav-tabs .tab-link').forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (!target)
                        return;
                    const top = target.getBoundingClientRect().top + window.scrollY - OFFSET;
                    window.scrollTo({top: top, behavior: 'smooth'});
                });
            });

            // ── 2. Scroll → tự highlight tab tương ứng ──
            const sections = Array.from(document.querySelectorAll('section[id]'));
            const tabLinks = Array.from(document.querySelectorAll('.nav-tabs .tab-link'));

            function onScroll() {
                // Tìm section đang hiển thị gần top nhất (sau offset)
                let current = sections[0];
                for (const sec of sections) {
                    const rect = sec.getBoundingClientRect();
                    if (rect.top <= OFFSET + 10) {
                        current = sec;
                    }
                }
                tabLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === '#' + current.id) {
                        link.classList.add('active');
                    }
                });
            }

            window.addEventListener('scroll', onScroll, {passive: true});
            onScroll(); // chạy lần đầu khi load
        </script>

    </body>
</html>
