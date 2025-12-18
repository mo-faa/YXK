<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>村民信息管理</title>
</head>
<body>
<h1>村民信息管理</h1>

<c:if test="${not empty flash}">
    <p style="color: #0a7;">${flash}</p>
</c:if>

<p>
    <a href="<c:url value='/'/>">返回首页</a>
    |
    <a href="<c:url value='/residents/new'/>">新增村民</a>
</p>

<table border="1" cellpadding="6" cellspacing="0">
    <thead>
    <tr>
        <th>ID</th>
        <th>姓名</th>
        <th>身份证号</th>
        <th>电话</th>
        <th>地址</th>
        <th>创建时间</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="r" items="${residents}">
        <tr>
            <td>${r.id}</td>
            <td>${r.name}</td>
            <td>${r.idCard}</td>
            <td>${r.phone}</td>
            <td>${r.address}</td>
            <td>${r.createdAt}</td>
            <td>
                <a href="<c:url value='/residents/${r.id}/edit'/>">编辑</a>

                <form action="<c:url value='/residents/${r.id}/delete'/>" method="post" style="display:inline;"
                      onsubmit="return confirm('确认删除 ID=${r.id} 吗？');">
                    <button type="submit">删除</button>
                </form>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty residents}">
        <tr>
            <td colspan="7">暂无数据</td>
        </tr>
    </c:if>
    </tbody>
</table>

<hr/>
<h3>JSON API 快速测试</h3>
<ul>
    <li><a href="<c:url value='/api/residents'/>">GET /api/residents</a></li>
</ul>

</body>
</html>
