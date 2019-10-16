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
	<link href="${pageContext.request.contextPath}/assests/css/login.css" rel="stylesheet" type="text/css"/>
</head>
	<body>
		<div class="shadow p-40 rounded border container">
			<h2 class="text-center ls-10 pb-20">thegioithesim</h2>

			<form method="post" action="AdminController" class="login_form">
				<input name="username" placeholder="Tên tài khoản" type="text" autofocus />
				<input name="password" placeholder="Mật khẩu" type="password" />
				<input name="btnAction" class="button" value="Login" type="submit" />
			</form>
		</div>
	</body>
</html>
