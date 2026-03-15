<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.investorcare.model.User"%>
<%
    User acc = (User) session.getAttribute("LOGIN_USER");
    if (acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create New Watchlist — InvestorCare</title>
        <style>
            /* ===== SYSTEM CSS ===== */
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
            .navbar-brand-icon { width: 32px; height: 32px; background: linear-gradient(135deg, #00e5a0, #00bcd4); border-radius: 8px; display: flex; align-items: center; justify-content: center; }

            /* ===== MAIN CONTAINER ===== */
            .page-wrapper {
                flex: 1; display: flex; align-items: center; justify-content: center; padding: 80px 20px;
            }

            .add-card {
                background: #111d30; border: 1px solid #1e3050; border-radius: 20px;
                width: 100%; max-width: 450px; padding: 40px; position: relative;
                box-shadow: 0 20px 50px rgba(0,0,0,0.3); animation: fadeIn .4s ease-out;
            }
            .add-card::before {
                content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px;
                background: linear-gradient(90deg, #00e5a0, #00bcd4); border-radius: 20px 20px 0 0;
            }

            .card-header { text-align: center; margin-bottom: 32px; }
            .card-header h2 { font-size: 24px; font-weight: 700; color: #e8f0fc; margin-bottom: 8px; }
            .card-header p { font-size: 14px; color: #7a94b8; }

            .form-group { margin-bottom: 24px; }
            .form-group label { display: block; font-size: 13px; font-weight: 600; color: #7a94b8; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px; }

            .input-control {
                width: 100%; padding: 14px 18px; background: #070d1a; border: 1px solid #1e3050;
                border-radius: 12px; color: #e8f0fc; font-size: 15px; transition: all .2s;
            }
            .input-control:focus { outline: none; border-color: #00e5a0; box-shadow: 0 0 0 4px rgba(0,229,160,0.1); }

            .btn-submit {
                width: 100%; padding: 14px; background: linear-gradient(135deg, #00e5a0, #00bcd4);
                color: #070d1a; font-weight: 700; font-size: 15px; border: none; border-radius: 12px;
                cursor: pointer; transition: transform .2s, box-shadow .2s; margin-bottom: 16px;
            }
            .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0,229,160,0.3); }

            .btn-back { display: block; text-align: center; color: #7a94b8; text-decoration: none; font-size: 14px; font-weight: 500; transition: color .2s; }
            .btn-back:hover { color: #e8f0fc; }

            @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <a href="MainController?action=user-dash-board" class="navbar-brand">
                <div class="navbar-brand-icon">📈</div>
                InvestorCare
            </a>
            <div style="font-size: 12px; color: #7a94b8;">
                User: <strong><%= acc.getUsername()%></strong>
            </div>
        </nav>

        <div class="page-wrapper">
            <div class="add-card">
                <div class="card-header">
                    <h2>🆕 Create New Watchlist</h2>
                    <p>Build your personalized asset tracking list</p>
                </div>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="add-watchlist">

                    <div class="form-group">
                        <label>Watchlist Name</label>
                        <input type="text" class="input-control" name="txtWatchListName"
                               placeholder="Enter a name (e.g., AI Stocks...)"
                               required="required" autofocus>
                    </div>

                    <button type="submit" class="btn-submit">Save Watchlist</button>

                    <a href="MainController?action=watch-list" class="btn-back">
                        ← Back to list
                    </a>
                </form>
            </div>
        </div>

    </body>
</html>
