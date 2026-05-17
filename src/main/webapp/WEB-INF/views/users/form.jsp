<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="${empty user.id ? '新建用户' : '编辑用户'} - 网上村委会"/>
<c:set var="activePage" value="users"/>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty user.id ? '新建用户' : '编辑用户'} - 网上村委会</title>
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
                <li class="breadcrumb-item active">${empty user.id ? '新建用户' : '编辑用户'}</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-white">
                        <h4 class="mb-0">
                            <i class="fas fa-${empty user.id ? 'plus' : 'edit'} me-2"></i>
                            ${empty user.id ? '新建用户' : '编辑用户'}
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <c:choose>
                            <c:when test="${empty user.id}">
                                <form method="post" action="<c:url value='/users/create'/>">
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="<c:url value='/users/${user.id}/edit'/>">
                            </c:otherwise>
                        </c:choose>
                            <input type="hidden" name="_csrf" value="${_csrf}"/>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">用户名 <span class="text-danger">*</span></label>
                                <div class="col-sm-9">
                                    <c:choose>
                                        <c:when test="${empty user.id}">
                                            <input type="text" class="form-control" name="username"
                                                   value="${user.username}" required minlength="3" maxlength="50"
                                                   placeholder="请输入用户名（3-50个字符）">
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text" class="form-control" value="${user.username}" disabled>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <c:if test="${empty user.id}">
                                <div class="row mb-3">
                                    <label class="col-sm-3 col-form-label fw-bold">密码 <span class="text-danger">*</span></label>
                                    <div class="col-sm-9">
                                        <input type="password" class="form-control" name="passwordHash"
                                               required minlength="6" placeholder="请输入密码（至少6位）">
                                    </div>
                                </div>
                            </c:if>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">昵称</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" name="nickname"
                                           value="${user.nickname}" maxlength="50" placeholder="请输入昵称">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">真实姓名</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" name="realName"
                                           value="${user.realName}" maxlength="50" placeholder="请输入真实姓名">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">手机号</label>
                                <div class="col-sm-9">
                                    <input type="tel" class="form-control" name="phone"
                                           value="${user.phone}" maxlength="20" placeholder="请输入手机号">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">邮箱</label>
                                <div class="col-sm-9">
                                    <input type="email" class="form-control" name="email"
                                           value="${user.email}" maxlength="100" placeholder="请输入邮箱">
                                </div>
                            </div>

                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label fw-bold">角色分配</label>
                                <div class="col-sm-9">
                                    <c:forEach items="${roles}" var="role">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="checkbox" name="roleIds"
                                                   value="${role.id}" id="role_${role.id}"
                                                   <c:forEach items="${userRoles}" var="ur">
                                                       ${ur == role.id ? 'checked' : ''}
                                                   </c:forEach>>
                                            <label class="form-check-label" for="role_${role.id}">
                                                ${role.name} <small class="text-muted">(${role.code})</small>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <hr>
                            <div class="d-flex justify-content-end gap-2">
                                <a href="<c:url value="/users"/>" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>取消
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>${empty user.id ? '创建' : '保存'}
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
