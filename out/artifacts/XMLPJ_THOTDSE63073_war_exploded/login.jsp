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
	<title>Login | Thế Giới Thẻ SIM</title>
	<link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
	<link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
</head>
	<body>

	<form method="post" action="AdminController">
		<input name="username" type="text" autofocus />
		<input name="password" type="password" />
		<input name="btnAction" value="Login" type="submit" />
	</form>

	</body>
</html>
