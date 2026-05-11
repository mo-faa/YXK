<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 网上村委会</title>
    <link href="<c:url value='/static/css/main.css'/>" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-light">
    <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

    <div class="container mt-5 pt-4">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="fas fa-users-cog me-2"></i>用户管理</h2>
            </div>
            <div class="col-auto">
                <a href="<c:url value="/users/create"/>" class="btn btn-primary">
                    <i class="fas fa-plus me-1"></i>新建用户
                </a>
            </div>
        </div>

        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-4">
                <form method="get" action="<c:url value="/users"/>" class="mb-4">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-6">
                            <label for="keyword" class="form-label">搜索</label>
                            <input type="text" class="form-control" id="keyword" name="keyword"
                                   value="${keyword}" placeholder="用户名/昵称/真实姓名">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i>搜索
                            </button>
                        </div>
                        <div class="col-md-3">
                            <a href="<c:url value="/users"/>" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-redo me-1"></i>重置
                            </a>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover table-striped align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>昵称</th>
                            <th>真实姓名</th>
                            <th>手机号</th>
                            <th>状态</th>
                            <th>登录次数</th>
                            <th>最后登录</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>${user.id}</td>
                                <td><strong>${user.username}</strong></td>
                                <td>${user.nickname}</td>
                                <td>${user.realName}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <span class="badge ${user.enabledClass}">${user.statusText}</span>
                                </td>
                                <td>${user.loginCount}</td>
                                <td>${user.lastLoginAtFormatted}</td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="<c:url value="/users/${user.id}"/>"
                                           class="btn btn-outline-primary" title="查看详情">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="<c:url value="/users/${user.id}/edit"/>"
                                           class="btn btn-outline-warning" title="编辑">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<c:url value="/users/${user.id}/reset-password"/>"
                                           class="btn btn-outline-info" title="重置密码">
                                            <i class="fas fa-key"></i>
                                        </a>
                                        <form method="post" action="<c:url value="/users/${user.id}/toggle"/>"
                                              style="display:inline;">
                                            <button type="submit"
                                                    class="btn btn-outline-${user.enabled ? 'warning' : 'success'}"
                                                    title="${user.enabled ? '禁用' : '启用'}"
                                                    onclick="return confirm('确认${user.enabled ? "禁用" : "启用"}该用户？')">
                                                <i class="fas fa-${user.enabled ? 'ban' : 'check'}"></i>
                                            </button>
                                        </form>
                                        <form method="post" action="<c:url value="/users/${user.id}/delete"/>"
                                              style="display:inline;">
                                            <button type="submit" class="btn btn-outline-danger" title="删除"
                                                    onclick="return confirm('确认删除该用户？此操作不可恢复！')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:set var="activePage" value="users"/>
                <%@ include file="/WEB-INF/views/common/pagination.jsp" %>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
