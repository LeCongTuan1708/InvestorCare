<%-- 
    Document   : error
    Created on : Mar 3, 2026, 1:20:17 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%String error = (String) request.getAttribute("ERROR");%>
        <h1><%= error%></h1>
        <button>
            <a href="MainController?action=add-asset">Quay lại</a>
        </button>
    </body>
</html>
