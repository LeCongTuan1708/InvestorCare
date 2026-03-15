<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Watchlists — InvestorCare</title>
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

        /* ===== PAGE ===== */
        .page-wrapper { padding: 96px 32px 40px; max-width: 1200px; margin: 0 auto; }

        /* ===== PAGE HEADER ===== */
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px; gap: 16px; }
        .page-header-left h1 { font-size: 26px; font-weight: 700; color: #e8f0fc; display: flex; align-items: center; gap: 10px; }
        .page-header-left p { font-size: 14px; color: #7a94b8; margin-top: 6px; }

        .btn-add { display: inline-flex; align-items: center; gap: 8px; padding: 10px 22px; background: linear-gradient(135deg, #00e5a0, #00bcd4); color: #070d1a; font-weight: 700; font-size: 13px; border-radius: 10px; text-decoration: none; border: none; cursor: pointer; box-shadow: 0 4px 16px rgba(0,229,160,.25); transition: .2s; }
        .btn-add:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,229,160,.35); }

        /* ===== GRID LAYOUT ===== */
        .wl-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; }
        .wl-card { background: #111d30; border: 1px solid #1e3050; border-radius: 14px; padding: 24px; transition: all .25s ease; position: relative; overflow: hidden; animation: fadeIn .35s ease-out both; }
        .wl-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }

        .color-teal::before   { background: linear-gradient(90deg, #00e5a0, #00bcd4); }
        .color-blue::before   { background: linear-gradient(90deg, #3b82f6, #6366f1); }
        .color-amber::before  { background: linear-gradient(90deg, #f59e0b, #ef4444); }
        .color-purple::before { background: linear-gradient(90deg, #a855f7, #ec4899); }
        .color-rose::before   { background: linear-gradient(90deg, #f43f5e, #f97316); }

        .wl-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,.4); border-color: #2a4070; }

        .wl-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .wl-icon { width: 42px; height: 42px; background: rgba(255,255,255,0.03); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }

        .wl-name { font-size: 18px; font-weight: 700; color: #e8f0fc; margin-bottom: 4px; }
        .wl-meta { font-size: 12px; color: #7a94b8; margin-bottom: 20px; }

        .wl-actions { display: flex; gap: 8px; border-top: 1px solid #1e3050; padding-top: 16px; }
        .wl-btn { flex: 1; text-align: center; padding: 8px 0; border-radius: 8px; font-size: 12px; font-weight: 600; text-decoration: none; transition: .2s; }
        .wl-btn.view { background: rgba(0,229,160,.1); color: #00e5a0; border: 1px solid rgba(0,229,160,.2); }
        .wl-btn.view:hover { background: #00e5a0; color: #070d1a; }
        .wl-btn.edit { background: rgba(255,255,255,0.05); color: #e8f0fc; border: 1px solid #1e3050; }
        .wl-btn.edit:hover { background: #1e3050; }
        .wl-btn.delete { color: #f43f5e; border: 1px solid rgba(244,63,94,.2); }
        .wl-btn.delete:hover { background: rgba(244,63,94,.1); border-color: #f43f5e; }

        .empty-state { grid-column: 1 / -1; padding: 80px 24px; text-align: center; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 768px) {
            .page-wrapper { padding: 80px 16px 32px; }
            .wl-grid { grid-template-columns: 1fr; }
        }
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
        <a href="MainController?action=dashboard" class="navbar-back">← Dashboard</a>
        <a href="MainController?action=logout" class="navbar-logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">

    <div class="page-header">
        <div class="page-header-left">
            <h1>👁️ Watchlists</h1>
            <p>Manage your asset tracking folders</p>
        </div>
        <a href="MainController?action=show-add-watchlist" class="btn-add">
            <span>＋</span> Create New Watchlist
        </a>
    </div>

    <div class="wl-grid">
        <c:choose>
            <c:when test="${empty LIST_WATCHLIST}">
                <div class="empty-state">
                    <div style="font-size: 52px; margin-bottom: 16px;">📁</div>
                    <h3 style="color: #e8f0fc;">No watchlists yet</h3>
                    <p style="color: #7a94b8; margin-top: 8px;">Create a watchlist to start tracking your assets!</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${LIST_WATCHLIST}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.index % 5 == 0}"><c:set var="color" value="color-teal"/></c:when>
                        <c:when test="${status.index % 5 == 1}"><c:set var="color" value="color-blue"/></c:when>
                        <c:when test="${status.index % 5 == 2}"><c:set var="color" value="color-amber"/></c:when>
                        <c:when test="${status.index % 5 == 3}"><c:set var="color" value="color-purple"/></c:when>
                        <c:otherwise><c:set var="color" value="color-rose"/></c:otherwise>
                    </c:choose>

                    <div class="wl-card ${color}">
                        <div class="wl-top">
                            <div class="wl-icon">📂</div>
                            <div style="color: #3d5270; font-size: 11px; font-weight: 700;">#${item.watchListId}</div>
                        </div>
                        <div class="wl-name">${item.name}</div>
                        <div class="wl-meta">📅 Created: ${item.createAt}</div>

                        <div class="wl-actions">
                            <a href="MainController?action=watchlist-item&selectedId=${item.watchListId}" class="wl-btn view">Details</a>
                            <a href="MainController?action=show-edit-watchlist&id=${item.watchListId}&oldName=${item.name}" class="wl-btn edit">Edit</a>
                            <a href="MainController?action=remove-watchlist&watchListId=${item.watchListId}"
                               class="wl-btn delete"
                               onclick="return confirm('Warning: Deleting this watchlist will remove all assets inside. Are you sure?');">Delete</a>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>
