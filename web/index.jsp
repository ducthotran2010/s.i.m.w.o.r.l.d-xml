<%-- 
    Document   : index
    Created on : Sep 28, 2019, 11:02:49 PM
    Author     : Duc Tho Tran
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Trang chủ | Thế Giới Thẻ SIM</title>
	<link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
	<link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
</head>
	<body>
		<%@include file="components/navbar.jspf" %>
		<script>document.getElementById('nav-home').classList.add('active');</script>


		<%@include file="components/search-section.jspf" %>
		<script src="${pageContext.request.contextPath}/assests/js/constants.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/utils/param.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/utils/query.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/MVOjs/home.js"></script>
	</body>
</html>
