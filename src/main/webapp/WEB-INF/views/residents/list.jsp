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

<form method="get" action="<c:url value='/residents'/>" style="margin: 12px 0;">
    <label>搜索：</label>
    <input type="text" name="q" value="${q}" placeholder="姓名/身份证/电话/地址" style="width: 280px;" />
    <label>每页：</label>
    <input type="number" name="size" value="${page.size}" min="1" max="100" style="width: 80px;" />
    <button type="submit">查询</button>

    <c:url var="exportUrl" value="/residents/export.csv">
        <c:param name="q" value="${q}" />
    </c:url>
    <a href="${exportUrl}">导出CSV</a>
</form>

<p style="color:#666;">
    共 ${page.total} 条，当前第 ${page.page} 页 / 共 ${page.totalPages} 页
</p>

<c:if test="${page.totalPages > 1}">
    <p>
        <c:if test="${page.hasPrev}">
            <c:url var="prevUrl" value="/residents">
                <c:param name="q" value="${q}" />
                <c:param name="page" value="${page.page - 1}" />
                <c:param name="size" value="${page.size}" />
            </c:url>
            <a href="${prevUrl}">上一页</a>
        </c:if>

        <c:if test="${page.hasNext}">
            <c:url var="nextUrl" value="/residents">
                <c:param name="q" value="${q}" />
                <c:param name="page" value="${page.page + 1}" />
                <c:param name="size" value="${page.size}" />
            </c:url>
            <a href="${nextUrl}">下一页</a>
        </c:if>
    </p>
</c:if>

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
    <c:forEach var="r" items="${page.items}">
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
                    <input type="hidden" name="_csrf" value="${_csrf}" />
                    <button type="submit">删除</button>
                </form>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty page.items}">
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
    <li><a href="<c:url value='/api/residents/page'/>">GET /api/residents/page</a></li>
</ul>

<p style="color:#666;">RequestId: ${requestId}</p>

</body>
</html>
