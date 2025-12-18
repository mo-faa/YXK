<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>错误 ${status}</title>
</head>
<body>
<h1>发生错误（HTTP ${status}）</h1>

<p><b>错误：</b> ${error}</p>
<p><b>消息：</b> ${message}</p>
<p><b>路径：</b> ${path}</p>
<p><b>RequestId：</b> ${requestId}</p>

<p>
    <a href="<c:url value='/'/>">返回首页</a>
</p>
</body>
</html>
