<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.investorcare.model.User"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Watchlist Detail — InvestorCare</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #0a0e27;
            min-height: 100vh;
            color: #e8f0fc;
        }

        /* ===== NAVBAR ===== */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0;
            z-index: 1000; height: 64px;
            display: flex; align-items: center; justify-content: space-between;
            background: rgba(7,13,26,.98); backdrop-filter: blur(20px);
            border-bottom: 1px solid #162038; padding: 0 32px;
        }
        .navbar-brand { font-size: 18px; font-weight: 700; color: #e8f0fc; display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .navbar-brand-icon { width: 32px; height: 32px; background: linear-gradient(135deg, #00e5a0, #00bcd4); border-radius: 8px; display: flex; align-items: center; justify-content: center; box-shadow: 0 0 16px rgba(0,229,160,.25); }
        .navbar-right { display: flex; align-items: center; gap: 16px; }
        .navbar-greeting { font-size: 13px; color: #7a94b8; }
        .navbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #00e5a0, #00bcd4); display: flex; align-items: center; justify-content: center; font-weight: 700; color: #070d1a; font-size: 15px; }
        .navbar-logout { padding: 6px 16px; border-radius: 8px; border: 1px solid rgba(244,63,94,.4); color: #f43f5e; text-decoration: none; font-size: 12px; font-weight: 600; transition: .2s; }
        .navbar-logout:hover { background: rgba(244,63,94,.12); }
        .navbar-back { display: flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 8px; border: 1px solid #1e3050; color: #7a94b8; text-decoration: none; font-size: 12px; font-weight: 600; transition: .2s; }
        .navbar-back:hover { background: #162038; color: #e8f0fc; }

        /* ===== PAGE WRAPPER ===== */
        .page-wrapper { padding: 96px 32px 40px; max-width: 1200px; margin: 0 auto; }

        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 32px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #e8f0fc; }
        .page-header p { font-size: 14px; color: #7a94b8; margin-top: 6px; }

        .btn-add { display: inline-flex; align-items: center; gap: 8px; padding: 10px 22px; background: linear-gradient(135deg, #00e5a0, #00bcd4); color: #070d1a; font-weight: 700; font-size: 13px; border-radius: 10px; text-decoration: none; transition: .2s; box-shadow: 0 4px 16px rgba(0,229,160,.25); }
        .btn-add:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,229,160,.35); }

        /* ===== MODERN TABLE ===== */
        .table-card { background: #111d30; border: 1px solid #1e3050; border-radius: 16px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background: #162038; padding: 16px 24px; font-size: 12px; font-weight: 700; color: #7a94b8; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid #1e3050; }
        td { padding: 18px 24px; border-bottom: 1px solid #1e3050; font-size: 14px; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(255,255,255,0.02); }

        /* ===== ASSET STYLES ===== */
        .ticker-tag { display: inline-flex; align-items: center; background: rgba(0,229,160,.1); border: 1px solid rgba(0,229,160,.25); color: #00e5a0; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 13px; }
        .asset-type { font-size: 11px; text-transform: uppercase; color: #3d5270; font-weight: 700; }
        .asset-name { font-weight: 500; color: #e8f0fc; }
        .price-value { font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 15px; }

        /* ===== POSITIVE / NEGATIVE ===== */
        .badge-up { background: rgba(0,229,160,.1); color: #00e5a0; padding: 4px 8px; border-radius: 6px; font-weight: 700; font-size: 12px; }
        .badge-down { background: rgba(244,63,94,.1); color: #f43f5e; padding: 4px 8px; border-radius: 6px; font-weight: 700; font-size: 12px; }

        .btn-delete { color: #f43f5e; text-decoration: none; font-size: 13px; font-weight: 600; padding: 6px 12px; border-radius: 8px; border: 1px solid rgba(244,63,94,0.2); transition: 0.2s; }
        .btn-delete:hover { background: rgba(244,63,94,0.1); border-color: #f43f5e; }

        .empty-state { padding: 80px 24px; text-align: center; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: 0.5; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="MainController?action=dashboard" class="navbar-brand">
        <div class="navbar-brand-icon">📈</div>
        InvestorCare
    </a>
    <div class="navbar-right">
        <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername() %></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase() %></div>
        <a href="MainController?action=watch-list" class="navbar-back">← Watchlists</a>
        <a href="MainController?action=logout" class="navbar-logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <h1>📂 Folder: ${not empty WATCHLIST_NAME ? WATCHLIST_NAME : 'Loading...'}</h1>
            <p>Manage and monitor price movements of assets in this watchlist</p>
        </div>
        <a href="MainController?action=show-add-item&watchListId=${CURRENT_WATCHLIST_ID}" class="btn-add">
            <span>＋</span> Add Asset
        </a>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Type</th>
                    <th>Symbol</th>
                    <th>Asset Name</th>
                    <th style="text-align: right;">Current Price</th>
                    <th style="text-align: center;">Change</th>
                    <th style="text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty LIST_WATCHLIST_ITEM}">
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <div class="empty-icon">📊</div>
                                    <h3 style="color: #7a94b8;">This watchlist is empty</h3>
                                    <p style="color: #3d5270; font-size: 14px; margin-top: 8px;">Add assets to start tracking their price movements.</p>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${LIST_WATCHLIST_ITEM}">
                            <c:set var="aId" value="${item.asset.assetId}" />
                            <c:set var="priceBar" value="${LATEST_PRICES[aId]}" />

                            <tr>
                                <td><span class="asset-type">${item.asset.type}</span></td>
                                <td><span class="ticker-tag">${item.asset.symbol}</span></td>
                                <td><div class="asset-name">${item.asset.name}</div></td>

                                <td style="text-align: right;">
                                    <c:choose>
                                        <c:when test="${not empty priceBar}">
                                            <span class="price-value">$<fmt:formatNumber value="${priceBar.close}" type="number" maxFractionDigits="2"/></span>
                                        </c:when>
                                        <c:otherwise><span style="color: #3d5270;">--</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${not empty priceBar}">
                                            <c:set var="change" value="${priceBar.close - priceBar.open}" />
                                            <c:set var="percent" value="${priceBar.open > 0 ? (change / priceBar.open) * 100 : 0}" />

                                            <c:choose>
                                                <c:when test="${change > 0}">
                                                    <span class="badge-up">▲ +<fmt:formatNumber value="${percent}" maxFractionDigits="2"/>%</span>
                                                </c:when>
                                                <c:when test="${change < 0}">
                                                    <span class="badge-down">▼ <fmt:formatNumber value="${percent}" maxFractionDigits="2"/>%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #7a94b8; font-size: 12px;">● 0.00%</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise><span style="color: #3d5270;">N/A</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td style="text-align: right;">
                                    <a href="MainController?action=remove-item&itemId=${item.itemId}&watchListId=${CURRENT_WATCHLIST_ID}"
                                       class="btn-delete"
                                       onclick="return confirm('Remove this asset from your watchlist?');">
                                        ✕ Remove
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
