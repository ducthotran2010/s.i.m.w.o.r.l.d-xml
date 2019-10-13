<%--
  Created by IntelliJ IDEA.
  User: thotd
  Date: 10/12/19
  Time: 8:52 PM
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tra cứu số điện thoại | Thế Giới Thẻ SIM</title>
        <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
        <link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <%@include file="components/navbar.jspf" %>
        <%@include file="components/look-up-section.jspf" %>
        <script>document.getElementById('nav-look-up').classList.add('active');</script>
        Tra cứu đơn hàng, đoán tên người gọi!

        <c:set var="document" value="${requestScope.Result}"/>
        <c:if test="${not empty document}">
            <c:import var="xsl" url="assests/configs/xsl/look-up.xsl" charEncoding="UTF-8"/>
            <x:transform doc="${document}" xslt="${xsl}"/>
        </c:if>

    </body>
</html>
