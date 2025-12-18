<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>
        <c:choose>
            <c:when test="${mode == 'edit'}">编辑村民</c:when>
            <c:otherwise>新增村民</c:otherwise>
        </c:choose>
    </title>
</head>
<body>

<c:choose>
    <c:when test="${mode == 'edit'}">
        <h1>编辑村民（ID=${resident.id}）</h1>
        <c:set var="actionUrl" value="/residents/${resident.id}"/>
    </c:when>
    <c:otherwise>
        <h1>新增村民</h1>
        <c:set var="actionUrl" value="/residents"/>
    </c:otherwise>
</c:choose>

<p>
    <a href="<c:url value='/residents'/>">返回列表</a>
</p>

<form action="<c:url value='${actionUrl}'/>" method="post">
    <p>
        <label>姓名（必填）：</label>
        <input type="text" name="name" value="${resident.name}" maxlength="50" />
    </p>
    <p>
        <label>身份证号：</label>
        <input type="text" name="idCard" value="${resident.idCard}" maxlength="18" />
    </p>
    <p>
        <label>电话：</label>
        <input type="text" name="phone" value="${resident.phone}" maxlength="20" />
    </p>
    <p>
        <label>地址：</label>
        <input type="text" name="address" value="${resident.address}" maxlength="255" style="width: 420px;" />
    </p>

    <p>
        <button type="submit">
            <c:choose>
                <c:when test="${mode == 'edit'}">保存修改</c:when>
                <c:otherwise>确认新增</c:otherwise>
            </c:choose>
        </button>
    </p>
</form>

</body>
</html>
