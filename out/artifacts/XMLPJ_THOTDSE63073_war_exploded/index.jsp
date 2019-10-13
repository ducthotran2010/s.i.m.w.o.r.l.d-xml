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
		<%@include file="components/search-section.jspf" %>
		<div id="loader" class="transition hidden">
			Loading...
		</div>
		<div id="result-view" class="hidden">
            <p id="result-message"></p>

			<div id="result-detail"></div>

			<div id="pagination-container" class="">
				<button id="pagination-left">left</button>
				<form id="pagination-form">
					<input id="pagination-input" type="number" min="1"/>
				</form>
				<span id="pagination-infor"></span>
				<button id="pagination-right">right</button>
		</div>
		</div>

		<script>document.getElementById('nav-home').classList.add('active');</script>
		<script src="${pageContext.request.contextPath}/assests/js/constants.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/utils/param.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/utils/query.js"></script>
		<script src="${pageContext.request.contextPath}/assests/js/MVOjs/home.js"></script>
	</body>
</html>
