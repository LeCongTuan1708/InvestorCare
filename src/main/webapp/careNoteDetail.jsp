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
    <title>Journal Detail — InvestorCare</title>
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

        .content-body { padding: 40px; }
        .form-group { margin-bottom: 24px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; color: #7a94b8; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; }

        .read-only-box { width: 100%; padding: 16px; border: 1px solid #1e3050; border-radius: 8px; font-size: 14.5px; background: #0d1526; color: #00e5a0; font-weight: 500; line-height: 1.6; }
        .read-only-text { color: #e8f0fc; white-space: pre-wrap; font-weight: 400; }

        .form-actions { display: flex; gap: 12px; margin-top: 36px; padding-top: 24px; border-top: 1px solid #1e3050; }
        .btn { padding: 12px 24px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 14px; transition: .2s; flex: 1; text-align: center; text-decoration: none; display: inline-block; }
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
            <h2>📄 Journal Detail</h2>
            <p>Review your notes and market analysis</p>
        </div>

        <div class="content-body">
            <div class="form-group">
                <label>Asset Ticker</label>
                <div class="read-only-box">
                    <c:forEach var="asset" items="${LIST_ASSET}">
                        <c:if test="${asset.assetId == CARE_NOTE.assetId}">
                            [${asset.symbol}] - ${asset.name}
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <div class="form-group">
                <label>Title</label>
                <div class="read-only-box read-only-text">${CARE_NOTE.title}</div>
            </div>

            <div class="form-group">
                <label>Detailed Content</label>
                <div class="read-only-box read-only-text">${CARE_NOTE.content}</div>
            </div>

            <div class="form-actions">
                <a href="MainController?action=show-edit-care-note&noteId=${CARE_NOTE.noteId}" class="btn btn-primary">✏️ Edit</a>
                <a href="MainController?action=care-note-list" class="btn btn-secondary">🔙 Back</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
