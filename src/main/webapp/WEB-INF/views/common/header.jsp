<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN" data-theme="light" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#2d5a3d">

    <script>
        (function () {
            try {
                var saved = localStorage.getItem('yxk-theme');
                var theme = saved ? saved : ((window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light');
                document.documentElement.setAttribute('data-theme', theme);
                document.documentElement.setAttribute('data-bs-theme', theme);
            } catch (e) { }
        })();
    </script>

    <title>
        <c:out value="${empty pageTitle ? '网上村委会业务办理系统' : pageTitle}"/>
    </title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="<c:url value='/static/css/main.css?v=20260510_01'/>" rel="stylesheet">

    <script>
        window.__CTX = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
<c:set var="_active" value="${empty activePage ? '' : activePage}" />

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="navbar-inner" style="display:flex;align-items:center;justify-content:space-between;width:100%;max-width:1800px;margin:0 auto;padding:0 1.5rem;height:100%;">
        <a class="navbar-brand" href="<c:url value="/"/>">
            <span class="brand-mark">村</span>网上村委会
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link ${_active == 'home' ? 'active' : ''}" href="<c:url value="/"/>">
                        首页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'announcements' ? 'active' : ''}" href="<c:url value="/announcements"/>">
                        公告
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'residents' ? 'active' : ''}" href="<c:url value="/residents"/>">
                        村民管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == "committee-members" ? "active" : ""}" href="<c:url value="/committee-members"/>">
                        村委会成员
                    </a>
                </li>
                <c:if test="${not empty sessionScope.isAdmin and sessionScope.isAdmin}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle ${_active == "system" || _active == "dashboard" || _active == "users" || _active == "logs" ? "active" : ""}"
                           href="#" id="systemDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-cogs me-1"></i>系统管理
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="systemDropdown">
                            <li><a class="dropdown-item" href="<c:url value="/system/dashboard"/>"><i class="fas fa-gauge-high me-2"></i>系统监控</a></li>
                            <li><a class="dropdown-item" href="<c:url value="/users"/>"><i class="fas fa-users-cog me-2"></i>用户管理</a></li>
                            <li><a class="dropdown-item" href="<c:url value="/logs"/>"><i class="fas fa-clipboard-list me-2"></i>操作日志</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<c:url value="/system/backup"/>"><i class="fas fa-database me-2"></i>数据备份</a></li>
                            <li><a class="dropdown-item" href="<c:url value="/system/config"/>"><i class="fas fa-sliders-h me-2"></i>系统配置</a></li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${not empty sessionScope.userId}">
                    <li class="nav-item ms-lg-3 mt-2 mt-lg-0 position-relative">
                        <a class="nav-link" href="<c:url value="/notifications"/>" title="消息通知">
                            <i class="fas fa-bell"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                                  id="unreadBadge" style="display: none;">
                                0
                            </span>
                        </a>
                    </li>

                    <li class="nav-item dropdown ms-lg-2 mt-2 mt-lg-0">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-1"></i>${sessionScope.username}
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>个人中心</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-key me-2"></i>修改密码</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <form method="post" action="<c:url value="/logout"/>" style="display:inline;">
                                    <input type="hidden" name="_csrf" value="${_csrf}"/>
                                    <button type="submit" class="dropdown-item text-danger">
                                        <i class="fas fa-sign-out-alt me-2"></i>退出登录
                                    </button>
                                </form>
                            </li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${empty sessionScope.userId}">
                    <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                        <a class="btn btn-outline-primary btn-sm" href="<c:url value="/login"/>">
                            <i class="fas fa-sign-in-alt me-1"></i>登录
                        </a>
                    </li>
                </c:if>

                <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                    <button type="button" id="themeToggle" class="btn btn-sm" title="切换主题">
                        <i class="fa-solid fa-moon"></i>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>
