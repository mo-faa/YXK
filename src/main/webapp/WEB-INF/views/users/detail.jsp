<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户详情 - 网上村委会</title>
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
                <li class="breadcrumb-item active">${user.username}</li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm border-0 rounded-3 text-center">
                    <div class="card-body p-4">
                        <div class="mb-3">
                            <c:if test="${not empty user.avatar}">
                                <img src="${user.avatar}" alt="${user.nickname}"
                                     class="rounded-circle img-fluid" style="width: 120px; height: 120px; object-fit: cover;">
                            </c:if>
                            <c:if test="${empty user.avatar}">
                                <div class="rounded-circle bg-primary d-inline-flex align-items-center justify-content-center"
                                     style="width: 120px; height: 120px;">
                                    <i class="fas fa-user fa-3x text-white"></i>
                                </div>
                            </c:if>
                        </div>
                        <h4 class="mb-1">${user.nickname}</h4>
                        <p class="text-muted mb-3">@${user.username}</p>
                        <span class="badge ${user.enabled ? 'bg-success' : 'bg-secondary'} fs-6">
                            ${user.enabled ? '已启用' : '已禁用'}
                        </span>
                    </div>
                </div>

                <div class="card shadow-sm border-0 rounded-3 mt-3">
                    <div class="card-header bg-white">
                        <h6 class="mb-0"><i class="fas fa-shield-alt me-2"></i>角色权限</h6>
                    </div>
                    <div class="card-body">
                        <c:forEach items="${roles}" var="role">
                            <span class="badge bg-primary me-1 mb-1">${role.name}</span>
                        </c:forEach>
                        <hr>
                        <small class="text-muted">拥有权限：</small>
                        <div class="mt-2">
                            <c:forEach items="${permissions}" var="perm">
                                <span class="badge bg-light text-dark border me-1 mb-1">${perm}</span>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-user-circle me-2"></i>基本信息</h5>
                        <div>
                            <a href="<c:url value="/users/${user.id}/edit"/>"
                               class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-edit me-1"></i>编辑
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">用户名</label>
                            <div class="col-sm-9">
                                <p class="form-control-static">${user.username}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">昵称</label>
                            <div class="col-sm-9">
                                <p class="form-control-static">${user.nickname}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">真实姓名</label>
                            <div class="col-sm-9">
                                <p class="form-control-static">${user.realName}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">手机号</label>
                            <div class="col-sm-9">
                                <p class="form-control-static">${user.phone}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">邮箱</label>
                            <div class="col-sm-9">
                                <p class="form-control-static">${user.email}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">注册时间</label>
                            <div class="col-sm-9">
                                <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">最后登录</label>
                            <div class="col-sm-9">
                                <c:if test="${user.lastLoginAt != null}">
                                    <fmt:formatDate value="${user.lastLoginAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </c:if>
                            </div>
                        </div>
                        <hr>
                        <div class="row mb-3">
                            <label class="col-sm-3 col-form-label fw-bold">登录次数</label>
                            <div class="col-sm-9">
                                <span class="badge bg-info fs-6">${user.loginCount} 次</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
