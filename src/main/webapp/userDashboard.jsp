<%@page import="com.investorcare.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>TrustStock - Dashboard</title>
    <link rel="stylesheet" href="style_dashboard.css">
</head>

<body>
<%
    
    User acc =(User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String error = (String) session.getAttribute("Login_Error");
    
%>
<!-- TOP NAVBAR -->
<div class="navbar">
    <div class="navbar-brand">📈 TrustStock</div>
    <div class="navbar-right">
        <span class="navbar-greeting">Welcome <strong><%= acc.getUsername() %></strong></span>
        <div class="navbar-avatar">J</div>
        <a href="login.jsp" class="navbar-logout">Đăng xuất</a>
    </div>
</div>

<!-- MAIN LAYOUT -->
<div class="main-layout">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-label">Menu</div>
        <a href="#account" class="active"><span>👤</span> Account</a>
        <a href="#portfolio"><span>💼</span> Portfolio</a>
        <a href="#watchlist"><span>👁️</span> WatchList</a>
        <a href="#alerts"><span>🔔</span> Alerts</a>
        <a href="#carenote"><span>📝</span> Care Note</a>
    </div>

    <!-- CONTENT -->
    <div class="content">

        <!-- ===== ACCOUNT ===== -->
        <div id="account" class="section-card">
            <div class="section-header">
                <div class="section-title">👤 Account</div>
            </div>
            <div class="account-info">
                <div class="account-avatar">J</div>
                <div>
                    <div class="account-name"><%= acc.getUsername() %></div>
                    <div class="account-status">
                        <span class="badge badge-green">● Active</span>
                    </div>
                </div>
                <div style="margin-left:auto;">
                    <button class="btn btn-dark">Chỉnh sửa hồ sơ</button>
                </div>
            </div>
            <div class="account-stats">
                <div class="stat-box">
                    <div class="stat-label">Tham gia từ</div>
                    <div class="stat-value">01/01/2025</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Gói dịch vụ</div>
                    <div class="stat-value">Premium</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Đăng nhập cuối</div>
                    <div class="stat-value">26/02/2026</div>
                </div>
            </div>
        </div>

        <!-- ===== PORTFOLIO ===== -->
        <div id="portfolio" class="section-card">
            <div class="section-header">
                <div class="section-title">💼 Portfolio</div>
                <div class="portfolio-meta">
                    <div class="meta-tag green">Tổng tài sản: <strong>$24,500.00</strong></div>
                    <div class="meta-tag yellow">Lãi/Lỗ: <strong>+$358.30</strong></div>
                    <button class="btn btn-dark">+ Thêm lệnh</button>
                </div>
            </div>
            <div style="overflow-x:auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Mã CP</th>
                            <th>Tên công ty</th>
                            <th class="right">Số lượng</th>
                            <th class="right">Giá vốn</th>
                            <th class="right">Giá hiện tại</th>
                            <th class="right">Lãi / Lỗ</th>
                            <th class="center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="bold">AAPL</td>
                            <td class="muted">Apple Inc.</td>
                            <td class="right">10</td>
                            <td class="right">$195.00</td>
                            <td class="right bold">$213.49</td>
                            <td class="right text-green">+$184.90</td>
                            <td class="center">
                                <button class="btn btn-light btn-sm" style="margin-right:4px;">Mua thêm</button>
                                <button class="btn btn-danger btn-sm">Bán</button>
                            </td>
                        </tr>
                        <tr>
                            <td class="bold">TSLA</td>
                            <td class="muted">Tesla Inc.</td>
                            <td class="right">5</td>
                            <td class="right">$200.00</td>
                            <td class="right bold">$178.20</td>
                            <td class="right text-red">-$109.00</td>
                            <td class="center">
                                <button class="btn btn-light btn-sm" style="margin-right:4px;">Mua thêm</button>
                                <button class="btn btn-danger btn-sm">Bán</button>
                            </td>
                        </tr>
                        <tr>
                            <td class="bold">MSFT</td>
                            <td class="muted">Microsoft Corp.</td>
                            <td class="right">8</td>
                            <td class="right">$380.00</td>
                            <td class="right bold">$415.30</td>
                            <td class="right text-green">+$282.40</td>
                            <td class="center">
                                <button class="btn btn-light btn-sm" style="margin-right:4px;">Mua thêm</button>
                                <button class="btn btn-danger btn-sm">Bán</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ===== WATCHLIST ===== -->
        <div id="watchlist" class="section-card">
            <div class="section-header">
                <div class="section-title">👁️ WatchList</div>
                <button class="btn btn-dark">+ Thêm ticker</button>
            </div>
            <div class="watchlist-grid">

                <div class="watchlist-card">
                    <div class="watchlist-card-header">
                        <div>
                            <div class="ticker-symbol">NVDA</div>
                            <div class="ticker-name">NVIDIA Corp.</div>
                        </div>
                        <button class="btn-remove">✕</button>
                    </div>
                    <div class="ticker-price">$875.40</div>
                    <div class="ticker-change text-green">▲ +2.1% hôm nay</div>
                    <button class="btn btn-light" style="margin-top:12px; width:100%; padding:7px;">Thêm vào Portfolio</button>
                </div>

                <div class="watchlist-card">
                    <div class="watchlist-card-header">
                        <div>
                            <div class="ticker-symbol">META</div>
                            <div class="ticker-name">Meta Platforms</div>
                        </div>
                        <button class="btn-remove">✕</button>
                    </div>
                    <div class="ticker-price">$512.10</div>
                    <div class="ticker-change text-green">▲ +0.9% hôm nay</div>
                    <button class="btn btn-light" style="margin-top:12px; width:100%; padding:7px;">Thêm vào Portfolio</button>
                </div>

                <div class="watchlist-card">
                    <div class="watchlist-card-header">
                        <div>
                            <div class="ticker-symbol">VNM</div>
                            <div class="ticker-name">Vinamilk</div>
                        </div>
                        <button class="btn-remove">✕</button>
                    </div>
                    <div class="ticker-price">68,500₫</div>
                    <div class="ticker-change text-red">▼ -0.7% hôm nay</div>
                    <button class="btn btn-light" style="margin-top:12px; width:100%; padding:7px;">Thêm vào Portfolio</button>
                </div>

            </div>
        </div>

        <!-- ===== ALERTS ===== -->
        <div id="alerts" class="section-card">
            <div class="section-header">
                <div class="section-title">
                    🔔 Alerts
                    <span class="badge-count">3 mới</span>
                </div>
                <button class="btn btn-dark">+ Tạo Alert</button>
            </div>
            <div class="alert-list">

                <div class="alert-item warn">
                    <div class="alert-body">
                        <span class="alert-icon">⚠️</span>
                        <div>
                            <div class="alert-title">TSLA giảm dưới ngưỡng cảnh báo</div>
                            <div class="alert-desc">Giá hiện tại $178.20 — thấp hơn ngưỡng $180 bạn đặt</div>
                        </div>
                    </div>
                    <div class="alert-meta">
                        <span class="alert-time">10 phút trước</span>
                        <button class="btn btn-outline btn-sm">Xem</button>
                    </div>
                </div>

                <div class="alert-item success">
                    <div class="alert-body">
                        <span class="alert-icon">✅</span>
                        <div>
                            <div class="alert-title">AAPL đạt mục tiêu giá</div>
                            <div class="alert-desc">Giá hiện tại $213.49 — đã vượt mục tiêu $210</div>
                        </div>
                    </div>
                    <div class="alert-meta">
                        <span class="alert-time">1 giờ trước</span>
                        <button class="btn btn-outline btn-sm">Xem</button>
                    </div>
                </div>

                <div class="alert-item danger">
                    <div class="alert-body">
                        <span class="alert-icon">📉</span>
                        <div>
                            <div class="alert-title">ACB giảm mạnh hôm nay</div>
                            <div class="alert-desc">Giảm 1.1% — theo dõi sát diễn biến</div>
                        </div>
                    </div>
                    <div class="alert-meta">
                        <span class="alert-time">3 giờ trước</span>
                        <button class="btn btn-outline btn-sm">Xem</button>
                    </div>
                </div>

            </div>
        </div>

        <!-- ===== CARE NOTE ===== -->
        <div id="carenote" class="section-card">
            <div class="section-header">
                <div class="section-title">📝 Care Note</div>
                <button class="btn btn-dark">+ Thêm ghi chú</button>
            </div>
            <div class="note-grid">

                <div class="note-card blue">
                    <div class="note-header">
                        <div class="note-title blue">📌 Chiến lược tuần này</div>
                        <div class="note-actions">
                            <button>✏️</button>
                            <button>🗑️</button>
                        </div>
                    </div>
                    <div class="note-body">Theo dõi AAPL trước báo cáo thu nhập Q1. Hold MSFT dài hạn. Cân nhắc rebalance cuối tháng.</div>
                    <div class="note-date">24/02/2026</div>
                </div>

                <div class="note-card purple">
                    <div class="note-header">
                        <div class="note-title purple">💡 Nhắc nhở</div>
                        <div class="note-actions">
                            <button>✏️</button>
                            <button>🗑️</button>
                        </div>
                    </div>
                    <div class="note-body">Xem xét cắt giảm TSLA nếu tiếp tục giảm dưới $175. Đặt stop-loss tại $170.</div>
                    <div class="note-date">25/02/2026</div>
                </div>

                <div class="note-card orange">
                    <div class="note-header">
                        <div class="note-title orange">🎯 Mục tiêu tháng 3</div>
                        <div class="note-actions">
                            <button>✏️</button>
                            <button>🗑️</button>
                        </div>
                    </div>
                    <div class="note-body">Đạt tổng tài sản $30,000. Mở thêm vị thế NVDA nếu giá về $850.</div>
                    <div class="note-date">20/02/2026</div>
                </div>

                <div class="note-card empty">+ Thêm ghi chú mới</div>

            </div>
        </div>

    </div>
</div>

</body>
</html>