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

    <h2 class="py-20 text-center ls-10 select-none banner shadow" style="font-size:24px">Admin Dashboard</h2>

    <div class="container">
        <p>${sessionScope.USER.fullName}, crawl thôi chờ chi!</p>
        <form method="post" action="AdminController" class="control-group">
            <input name="totalPage" placeholder="Số trang trên mỗi domain" autofocus type="number" min="1" max="10"/>
            <input name="btnAction" value="Crawl" type="hidden"/>
            <button class="button">Lấy dữ liệu Sim</button>
        </form>

        <form method="post" action="AdminController">
            <input name="btnAction" value="CrawlOrder" type="hidden"/>
            <button class="button">Lấy Đơn Hàng</button>
        </form>

        <form method="post" action="AdminController">
            <input name="btnAction" value="CrawlPhongThuy" type="hidden"/>
            <button class="button">Lấy dữ liệu Phong Thuỷ</button>
        </form>

        </form>
    </div>

</body>
</html>
