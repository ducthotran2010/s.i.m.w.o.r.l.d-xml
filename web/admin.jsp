<%--
  Created by IntelliJ IDEA.
  User: thotd
  Date: 10/5/19
  Time: 9:56 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard | Thế Giới Thẻ SIM</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
    <link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
</head>
<body>
    <h2>Admin Dashboard</h2>

    <p>Hello ${sessionScope.USER.fullName}</p>
    <form method="post" action="AdminController">
        <label>Crawl dữ liệu sim</label>
        <input name="totalPage" value="2" type="number" min="1" max="10"/>
        <input name="btnAction" value="Crawl" type="submit"/>
    </form>

    <form method="post" action="AdminController">
        <input name="btnAction" value="CrawlOrder" type="submit"/>
    </form>

    <form method="post" action="AdminController">
        <input name="btnAction" value="CrawlPhongThuy" autofocus type="submit"/>
    </form>

</body>
</html>
