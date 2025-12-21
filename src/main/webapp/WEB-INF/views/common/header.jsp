<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN" data-theme="light" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#667eea">

    <script>
        // 主题初始化：尽可能早设置，避免闪烁（依赖 localStorage）
        (function () {
            try {
                var saved = localStorage.getItem('yxk-theme');
                var theme = saved ? saved : ((window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light');
                document.documentElement.setAttribute('data-theme', theme);
                document.documentElement.setAttribute('data-bs-theme', theme); // 启用 Bootstrap 5.3 内置暗色变量
            } catch (e) { /* ignore */ }
        })();
    </script>

    <title>
        <c:out value="${empty pageTitle ? '网上村委会业务办理系统' : pageTitle}"/>
    </title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Animate.css（可选，但你项目里已在用） -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

    <!-- 全站自定义主题（新） -->
    <link href="<c:url value='/static/css/main.css'/>" rel="stylesheet">
    <!-- 暗色模式补丁：只在 data-theme='dark' 时生效，修复文本/背景未切换的问题 -->
    <link href="<c:url value='/static/css/dark-fix.css'/>" rel="stylesheet">

    <script>
        // 给 main.js 使用（避免写死 /YXK）
        window.__CTX = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
<c:set var="_active" value="${empty activePage ? '' : activePage}" />

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
            <i class="fas fa-landmark me-2"></i>网上村委会
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link ${_active == 'home' ? 'active' : ''}" href="<c:url value='/'/>">
                        <i class="fas fa-home me-1"></i>首页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'announcements' ? 'active' : ''}" href="<c:url value='/announcements'/>">
                        <i class="fas fa-bullhorn me-1"></i>公告
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'residents' ? 'active' : ''}" href="<c:url value='/residents'/>">
                        <i class="fas fa-users me-1"></i>村民管理
                    </a>
                </li>

                <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                    <button type="button" id="themeToggle" class="btn btn-sm btn-outline-light">
                        <i class="fa-solid fa-moon"></i>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>
