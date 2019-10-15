<%--
  Created by IntelliJ IDEA.
  User: thotd
  Date: 10/12/19
  Time: 8:52 PM
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xem phong thuỷ | Thế Giới Thẻ SIM</title>
        <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
        <link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assests/css/look-up.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <%@include file="components/navbar.jspf" %>
        <%@include file="components/phongthuy-section.jspf" %>
        <script>document.getElementById('nav-phongthuy').classList.add('active');</script>
        <table id="result" class="home_table"></table>

        <script src="${pageContext.request.contextPath}/assests/js/constants.js"></script>
        <script src="${pageContext.request.contextPath}/assests/js/utils/param.js"></script>
        <script src="${pageContext.request.contextPath}/assests/js/utils/query.js"></script>
        <script src="${pageContext.request.contextPath}/assests/js/MVOjs/phongthuy.js"></script>
    </body>
</html>
