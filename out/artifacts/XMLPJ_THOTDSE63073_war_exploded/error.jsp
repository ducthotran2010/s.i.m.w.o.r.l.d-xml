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
    <title>Error</title>
</head>
<body>
    <h2>You got error</h2>

    <p><%= (request.getAttribute("Error") != null)
            ? request.getAttribute("Error")
            : "Your request URL is not found"%></p>
</body>
</html>
