<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Edit Care Note — InvestorCare</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #0a0e27; color: #e8f0fc; min-height: 100vh; }
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; height: 64px; display: flex; align-items: center; justify-content: space-between; background: rgba(7,13,26,.98); border-bottom: 1px solid #162038; padding: 0 32px; }
        .navbar-brand { font-size: 18px; font-weight: 700; color: #e8f0fc; display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .navbar-brand-icon { width: 32px; height: 32px; background: linear-gradient(135deg, #00e5a0, #00bcd4); border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        .navbar-right { display: flex; align-items: center; gap: 16px; }
        .navbar-greeting { font-size: 13px; color: #7a94b8; }
        .navbar-avatar { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #00e5a0, #00bcd4); display: flex; align-items: center; justify-content: center; font-weight: 700; color: #070d1a; }
        .page-wrapper { display: flex; justify-content: center; padding: 100px 20px 40px; }
        .edit-container { width: 100%; max-width: 700px; background: #111d30; border-radius: 16px; border: 1px solid #1e3050; box-shadow: 0 8px 32px rgba(0,0,0,.45); }
        .edit-header { background: #0d1526; padding: 32px 40px; border-bottom: 1px solid #1e3050; border-radius: 16px 16px 0 0; }
        .edit-header h2 { font-size: 24px; font-weight: 600; color: #e8f0fc; margin-bottom: 6px; }
        .edit-header p { font-size: 14px; color: #7a94b8; }
        form { padding: 40px; }
        .form-group { margin-bottom: 24px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; color: #7a94b8; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px 14px; border: 1px solid #1e3050; border-radius: 8px; font-size: 14px; background: #0d1526; color: #e8f0fc; transition: .2s; font-family: inherit; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #00e5a0; box-shadow: 0 0 0 3px rgba(0,229,160,.1); }
        .form-actions { display: flex; gap: 12px; margin-top: 36px; padding-top: 24px; border-top: 1px solid #1e3050; }
        .btn { padding: 12px 24px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 14px; transition: .2s; flex: 1; text-align: center; text-decoration: none; }
        .btn-primary { background: #00e5a0; color: #070d1a; }
        .btn-primary:hover { background: #00c98c; transform: translateY(-1px); }
        .btn-secondary { background: #162038; color: #7a94b8; border: 1px solid #1e3050; }
        .btn-secondary:hover { background: #1e3050; color: #e8f0fc; }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="MainController?action=care-note-list" class="navbar-brand">
        <div class="navbar-brand-icon">📈</div> InvestorCare
    </a>
    <div class="navbar-right">
        <span class="navbar-greeting">Welcome, <strong><%= acc.getUsername() %></strong></span>
        <div class="navbar-avatar"><%= acc.getUsername().substring(0,1).toUpperCase() %></div>
    </div>
</nav>

<div class="page-wrapper">
    <div class="edit-container">
        <div class="edit-header">
            <h2>✏️ Edit Care Note</h2>
            <p>Update your investment strategy and analysis</p>
        </div>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="edit-care-note">
            <input type="hidden" name="noteId" value="${CARE_NOTE.noteId}">

            <div class="form-group">
                <label>Asset Symbol (Ticker)</label>
                <select name="assetId" required>
                    <c:forEach var="asset" items="${LIST_ASSET}">
                        <option value="${asset.assetId}" <c:if test="${asset.assetId == CARE_NOTE.assetId}">selected</c:if>>
                            [${asset.symbol}] - ${asset.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Title</label>
                <input type="text" name="title" value="${CARE_NOTE.title}" required>
            </div>

            <div class="form-group">
                <label>Content</label>
                <textarea name="content" rows="6" required>${CARE_NOTE.content}</textarea>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">🔄 Update Note</button>
                <a href="MainController?action=care-note-list" class="btn btn-secondary">❌ Cancel</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
