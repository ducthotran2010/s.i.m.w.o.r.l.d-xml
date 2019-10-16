<%--
  Created by IntelliJ IDEA.
  User: thotd
  Date: 10/5/19
  Time: 10:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Error | Thế Giới Thẻ SIM</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
    <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
    <link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }
    </style>
</head>
</head>
<body>
    <p class="p-8 upper-case transition text-14 text-bold text-gray">Oppppps, something went wrong!</p>

    <p><%= (request.getAttribute("Error") != null)
            ? request.getAttribute("Error")
            : "Your request URL is not found"%></p>
</body>
</html>
