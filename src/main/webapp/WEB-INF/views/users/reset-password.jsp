<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="重置密码 - 网上村委会"/>
<c:set var="activePage" value="users"/>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重置密码 - 网上村委会</title>
    <link href="<c:url value='/static/css/main.css'/>" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-light">
    <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

    <div class="container mt-5 pt-4">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value="/"/>">首页</a></li>
                <li class="breadcrumb-item"><a href="<c:url value="/users"/>">用户管理</a></li>
                <li class="breadcrumb-item"><a href="<c:url value="/users/${user.id}"/>">${user.username}</a></li>
                <li class="breadcrumb-item active">重置密码</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-white">
                        <h4 class="mb-0">
                            <i class="fas fa-key me-2"></i>重置密码
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            即将为用户 <strong>${user.username}</strong>（${user.nickname}）重置密码
                        </div>
                        <form method="post" action="<c:url value="/users/${user.id}/reset-password"/>">
                            <input type="hidden" name="_csrf" value="${_csrf}"/>
                            <div class="mb-3">
                                <label class="form-label fw-bold">新密码 <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" name="newPassword"
                                       required minlength="6" placeholder="请输入新密码（至少6位）">
                            </div>
                            <hr>
                            <div class="d-flex justify-content-end gap-2">
                                <a href="<c:url value="/users/${user.id}"/>" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>取消
                                </a>
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-key me-1"></i>确认重置
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
