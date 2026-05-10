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
    <div class="container">
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
                <li class="nav-item">
                    <a class="nav-link ${_active == "logs" ? "active" : ""}" href="<c:url value="/logs"/>">
                        操作日志
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == "dashboard" ? "active" : ""}" href="<c:url value="/system/dashboard"/>">
                        系统监控
                    </a>
                </li>

                <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                    <button type="button" id="themeToggle" class="btn btn-sm" title="切换主题">
                        <i class="fa-solid fa-moon"></i>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>
