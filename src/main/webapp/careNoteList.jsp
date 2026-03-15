<%-- 
    Document   : careNoteList
    Redesigned : Mar 5, 2026
--%>

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
    <title>Investment Journal — InvestorCare</title>
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
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px; gap: 16px; flex-wrap: wrap; }
        .page-header-left h1 { font-size: 26px; font-weight: 700; color: #e8f0fc; display: flex; align-items: center; gap: 10px; }
        .page-header-left p { font-size: 14px; color: #7a94b8; margin-top: 6px; }

        .btn-add { display: inline-flex; align-items: center; gap: 8px; padding: 10px 22px; background: linear-gradient(135deg, #00e5a0, #00bcd4); color: #070d1a; font-weight: 700; font-size: 13px; border-radius: 10px; text-decoration: none; border: none; cursor: pointer; box-shadow: 0 4px 16px rgba(0,229,160,.25); transition: .2s; }
        .btn-add:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,229,160,.35); }

        /* ===== STATS BAR ===== */
        .stats-bar { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: #111d30; border: 1px solid #1e3050; border-radius: 12px; padding: 18px 20px; }
        .stat-card .label { font-size: 11px; color: #7a94b8; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .stat-card .value { font-size: 22px; font-weight: 700; color: #e8f0fc; }
        .stat-card .value.accent { color: #00e5a0; }

        /* ===== SEARCH / FILTER ===== */
        .toolbar { display: flex; gap: 12px; align-items: center; margin-bottom: 20px; flex-wrap: wrap; }
        .search-wrap { position: relative; flex: 1; min-width: 200px; }
        .search-wrap input { width: 100%; padding: 9px 14px 9px 38px; background: #111d30; border: 1px solid #1e3050; border-radius: 8px; color: #e8f0fc; font-size: 13px; transition: .2s; }
        .search-wrap input:focus { outline: none; border-color: #00e5a0; }
        .search-wrap::before { content: "🔍"; position: absolute; left: 12px; top: 50%; transform: translateY(-50%); font-size: 13px; pointer-events: none; }

        /* ===== NOTE GRID ===== */
        .note-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 18px; }
        .note-card { background: #111d30; border: 1px solid #1e3050; border-radius: 14px; padding: 22px; transition: transform .2s, box-shadow .2s, border-color .2s; position: relative; overflow: hidden; animation: fadeIn .35s ease-out both; }
        .note-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
        .note-card.color-teal::before   { background: linear-gradient(90deg, #00e5a0, #00bcd4); }
        .note-card.color-blue::before   { background: linear-gradient(90deg, #3b82f6, #6366f1); }
        .note-card.color-amber::before  { background: linear-gradient(90deg, #f59e0b, #ef4444); }
        .note-card.color-purple::before { background: linear-gradient(90deg, #a855f7, #ec4899); }
        .note-card.color-rose::before   { background: linear-gradient(90deg, #f43f5e, #f97316); }
        .note-card:hover { transform: translateY(-3px); box-shadow: 0 8px 28px rgba(0,0,0,.4); border-color: #2a4070; }

        .note-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .note-ticker { display: inline-flex; align-items: center; gap: 6px; background: rgba(0,229,160,.1); border: 1px solid rgba(0,229,160,.25); color: #00e5a0; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; letter-spacing: 0.5px; }
        .note-actions { display: flex; gap: 6px; }
        .note-actions a { width: 30px; height: 30px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 13px; text-decoration: none; transition: .15s; border: 1px solid transparent; }
        .note-actions a.edit { color: #7a94b8; border-color: #1e3050; }
        .note-actions a.edit:hover { background: #162038; color: #e8f0fc; }
        .note-actions a.delete { color: #f43f5e; border-color: rgba(244,63,94,.2); }
        .note-actions a.delete:hover { background: rgba(244,63,94,.12); }

        .note-title { font-size: 15px; font-weight: 600; color: #e8f0fc; margin-bottom: 10px; line-height: 1.4; }
        .note-content { font-size: 13px; color: #7a94b8; line-height: 1.65; display: -webkit-box; -webkit-line-clamp: 4; -webkit-box-orient: vertical; overflow: hidden; }
        .note-footer { display: flex; align-items: center; justify-content: space-between; margin-top: 16px; padding-top: 14px; border-top: 1px solid #1e3050; }
        .note-date { font-size: 11px; color: #3d5270; }
        .note-read-more { font-size: 11px; color: #00e5a0; text-decoration: none; font-weight: 600; }
        .note-read-more:hover { text-decoration: underline; }

        /* ===== EMPTY STATE ===== */
        .empty-state { grid-column: 1 / -1; padding: 64px 24px; text-align: center; }
        .empty-icon { font-size: 52px; margin-bottom: 16px; filter: grayscale(0.3); }
        .empty-state h3 { font-size: 18px; color: #e8f0fc; margin-bottom: 8px; }
        .empty-state p  { font-size: 14px; color: #7a94b8; margin-bottom: 24px; }

        /* ===== SCROLLBAR & ANIMATION ===== */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #070d1a; }
        ::-webkit-scrollbar-thumb { background: #1e3050; border-radius: 4px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
        .note-card:nth-child(1) { animation-delay: .05s; }
        .note-card:nth-child(2) { animation-delay: .10s; }
        .note-card:nth-child(3) { animation-delay: .15s; }
        .note-card:nth-child(4) { animation-delay: .20s; }
        .note-card:nth-child(5) { animation-delay: .25s; }

        @media (max-width: 768px) {
            .navbar { padding: 0 16px; }
            .page-wrapper { padding: 80px 16px 32px; }
            .note-grid { grid-template-columns: 1fr; }
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
            <h1>📝 Investment Journal</h1>
            <p>Record your strategies, insights, and analysis for each asset</p>
        </div>
        <a href="MainController?action=show-add-care-note" class="btn-add">
            <span>＋</span> Write New Entry
        </a>
    </div>

    <div class="stats-bar">
        <div class="stat-card">
            <div class="label">Total Entries</div>
            <div class="value accent">
                <c:choose>
                    <c:when test="${empty LIST_CARENOTE}">0</c:when>
                    <c:otherwise><c:out value="${fn:length(LIST_CARENOTE)}" default="0"/></c:otherwise>
                </c:choose>
            </div>
        </div>

        <%
            java.util.List<com.investorcare.model.CareNote> listCN = (java.util.List<com.investorcare.model.CareNote>) request.getAttribute("LIST_CARENOTE");
            int thisMonthCount = 0;
            int uniqueAssetsCount = 0;

            if (listCN != null && !listCN.isEmpty()) {
                java.util.Set<String> uniqueSymbols = new java.util.HashSet<>();

                java.util.Calendar cal = java.util.Calendar.getInstance();
                int currentMonth = cal.get(java.util.Calendar.MONTH);
                int currentYear = cal.get(java.util.Calendar.YEAR);

                for (com.investorcare.model.CareNote note : listCN) {
                    if (note.getAsset() != null && note.getAsset().getSymbol() != null) {
                        uniqueSymbols.add(note.getAsset().getSymbol());
                    }

                    if (note.getCreatedAt() != null) {
                        cal.setTime(note.getCreatedAt());
                        if (cal.get(java.util.Calendar.MONTH) == currentMonth &&
                            cal.get(java.util.Calendar.YEAR) == currentYear) {
                            thisMonthCount++;
                        }
                    }
                }
                uniqueAssetsCount = uniqueSymbols.size();
            }
            request.setAttribute("NOTES_THIS_MONTH", thisMonthCount);
            request.setAttribute("UNIQUE_ASSETS", uniqueAssetsCount);
        %>

        <div class="stat-card">
            <div class="label">This Month</div>
            <div class="value">${NOTES_THIS_MONTH}</div>
        </div>
        <div class="stat-card">
            <div class="label">Assets Tracked</div>
            <div class="value">${UNIQUE_ASSETS}</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-wrap">
            <input type="text" id="searchInput" placeholder="Search by title, content, or asset ticker..." oninput="filterNotes()">
        </div>
    </div>

    <div class="note-grid" id="noteGrid">

        <c:choose>
            <c:when test="${empty LIST_CARENOTE}">
                <div class="empty-state">
                    <div class="empty-icon">📔</div>
                    <h3>No journal entries yet</h3>
                    <p>Start documenting your investment journey today!</p>
                    <a href="MainController?action=show-add-care-note" class="btn-add">
                        ＋ Write First Entry
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${LIST_CARENOTE}" varStatus="status">
                    <c:choose>
                        <c:when test="${status.index % 5 == 0}"><c:set var="colorClass" value="color-teal"/></c:when>
                        <c:when test="${status.index % 5 == 1}"><c:set var="colorClass" value="color-blue"/></c:when>
                        <c:when test="${status.index % 5 == 2}"><c:set var="colorClass" value="color-amber"/></c:when>
                        <c:when test="${status.index % 5 == 3}"><c:set var="colorClass" value="color-purple"/></c:when>
                        <c:otherwise><c:set var="colorClass" value="color-rose"/></c:otherwise>
                    </c:choose>

                    <div class="note-card ${colorClass}"
                         data-title="${item.title}"
                         data-content="${item.content}"
                         data-symbol="${item.asset.symbol}">
                        <div class="note-top">
                            <span class="note-ticker">📌 ${item.asset.symbol}</span>
                            <div class="note-actions">
                                <a href="MainController?action=show-edit-care-note&noteId=${item.noteId}"
                                   class="edit" title="Edit">✏️</a>
                                <a href="MainController?action=remove-care-note&noteId=${item.noteId}"
                                   class="delete" title="Delete"
                                   onclick="return confirm('Are you sure you want to delete this journal entry?')">🗑</a>
                            </div>
                        </div>
                        <div class="note-title">${item.title}</div>
                        <div class="note-content">${item.content}</div>
                        <div class="note-footer">
                            <span class="note-date">🗓 ${item.createdAt}</span>
                            <a href="MainController?action=view-care-note&noteId=${item.noteId}"
                               class="note-read-more">View details →</a>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script>
function filterNotes() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('#noteGrid .note-card').forEach(card => {
        const text = (card.dataset.title + ' ' + card.dataset.content + ' ' + card.dataset.symbol).toLowerCase();
        card.style.display = text.includes(q) ? '' : 'none';
    });
}
</script>

</body>
</html>
