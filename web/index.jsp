<%--
    Document   : index
    Created on : Sep 28, 2019, 11:02:49 PM
    Author     : Duc Tho Tran
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Trang chủ | Thế Giới Thẻ SIM</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assests/image/logo.png"/>
    <link href="${pageContext.request.contextPath}/assests/css/global.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/assests/css/home.css" rel="stylesheet" type="text/css"/>
</head>

<%@include file="components/navbar.jspf" %>
<div class="home_main view">
    <%@include file="components/search-section.jspf" %>

    <div id="loader" class="transition p-20">
        Loading...
    </div>

    <div class="home_main home_main--right">
        <div id="result-view" class="hidden">
            <p id="result-message"></p>
            <div id="result-detail"></div>

            <div id="pagination-container">
                <div>
                    <button id="pagination-left">Trái</button>
                    <div>
                        <form id="pagination-form" style="display: inline-block">

                            <input id="pagination-input" type="number" min="1"/>
                        </form>
                        <span id="pagination-infor"></span>
                    </div>
                    <button id="pagination-right">Phải</button>
                </div>
            </div>

        </div>
    </div>
</div>

<script>document.getElementById('nav-home').classList.add('active');</script>
<script src="${pageContext.request.contextPath}/assests/js/constants.js"></script>
<script src="${pageContext.request.contextPath}/assests/js/utils/param.js"></script>
<script src="${pageContext.request.contextPath}/assests/js/utils/query.js"></script>
<script src="${pageContext.request.contextPath}/assests/js/MVOjs/home.js"></script>
</body>
</html>
