<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>网上村委会业务办理系统（最小版）</title>
</head>
<body>
<h1>网上村委会业务办理系统（SSM 最小可运行版）</h1>

<p>${message}</p>

<ul>
    <li><a href="<c:url value='/db/ping'/>">测试数据库链路：/db/ping</a></li>
    <li><a href="<c:url value='/residents'/>">村民信息管理（JSP CRUD）</a></li>
    <li><a href="<c:url value='/api/residents'/>">村民信息 API（JSON）</a></li>
</ul>

</body>
</html>
