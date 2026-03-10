<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.investorcare.model.User"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Tài Sản — InvestorCare</title>
    <style>
        /* ===== CSS ĐỒNG BỘ HÓA HỆ THỐNG ===== */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #0a0e27;
            min-height: 100vh;
            color: #e8f0fc;
            display: flex;
            flex-direction: column;
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

        /* ===== CONTAINER CHÍNH ===== */
        .page-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 20px;
        }

        .add-card {
            background: #111d30;
            border: 1px solid #1e3050;
            border-radius: 20px;
            width: 100%;
            max-width: 500px;
            padding: 40px;
            position: relative;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: fadeIn .4s ease-out;
        }
        /* Vạch màu gradient xanh đặc trưng */
        .add-card::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, #00e5a0, #00bcd4);
            border-radius: 20px 20px 0 0;
        }

        .card-header { text-align: center; margin-bottom: 32px; }
        .card-header h2 { font-size: 22px; font-weight: 700; color: #e8f0fc; margin-bottom: 8px; }
        .card-header p { font-size: 13px; color: #7a94b8; line-height: 1.5; }

        /* ===== FORM STYLES ===== */
        .form-group { margin-bottom: 28px; }
        .form-group label { display: block; font-size: 12px; font-weight: 700; color: #7a94b8; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 1px; }
        
        /* Style cho Select Dropdown */
        .select-control {
            width: 100%;
            padding: 14px 18px;
            background: #070d1a;
            border: 1px solid #1e3050;
            border-radius: 12px;
            color: #e8f0fc;
            font-size: 15px;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%237a94b8' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 18px;
            transition: all .2s;
        }
        .select-control:focus {
            outline: none;
            border-color: #00e5a0;
            box-shadow: 0 0 0 4px rgba(0,229,160,0.1);
        }
        .select-control option { background: #111d30; color: #e8f0fc; }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #00e5a0, #00bcd4);
            color: #070d1a;
            font-weight: 700;
            font-size: 15px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all .2s;
            margin-bottom: 16px;
            box-shadow: 0 4px 12px rgba(0,229,160,0.2);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,229,160,0.3);
        }

        .btn-back {
            display: block;
            text-align: center;
            color: #7a94b8;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: color .2s;
        }
        .btn-back:hover { color: #e8f0fc; text-decoration: underline; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="MainController?action=dashboard" class="navbar-brand">
        <div class="navbar-brand-icon">📈</div>
        InvestorCare
    </a>
    <div style="font-size: 12px; color: #7a94b8;">
        User: <strong><%= acc.getUsername() %></strong>
    </div>
</nav>

<div class="page-wrapper">
    <div class="add-card">
        <div class="card-header">
            <h2>➕ Thêm Vào Thư Mục</h2>
            <p>Chọn các mã cổ phiếu hoặc vàng tiềm năng để bắt đầu theo dõi trong danh sách của m</p>
        </div>

        <%-- HIỂN THỊ THÔNG BÁO LỖI NẾU BỊ TRÙNG Ở ĐÂY NÈ --%>
        <c:if test="${not empty ERROR_MSG}">
            <div style="background: rgba(244,63,94,.1); border: 1px solid rgba(244,63,94,.3); color: #f43f5e; padding: 12px 16px; border-radius: 12px; margin-bottom: 24px; font-size: 14px; font-weight: 600; text-align: center; animation: fadeIn 0.3s ease-out;">
                ⚠️ ${ERROR_MSG}
            </div>
        </c:if>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="add-item">
            <input type="hidden" name="watchListId" value="${CURRENT_WATCHLIST_ID}">

            <div class="form-group">
                <label>Chọn Mã Tài Sản (Asset)</label>
                <select name="assetId" class="select-control" required>
                    <option value="" disabled selected>-- Chọn một mã tài sản --</option>
                    <c:forEach var="asset" items="${LIST_ASSET}">
                        <option value="${asset.assetId}">
                            [${asset.symbol}] - ${asset.name} (${asset.type})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit" class="btn-submit">Xác Nhận Thêm</button>
            
            <a href="MainController?action=watchlist-item&selectedId=${CURRENT_WATCHLIST_ID}" class="btn-back">
                ← Quay lại chi tiết thư mục
            </a>
        </form>
    </div>
</div>

</body>
</html>