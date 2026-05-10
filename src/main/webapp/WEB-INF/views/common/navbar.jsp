<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="_active" value="${empty activePage ? '' : activePage}" />

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="<c:url value="/"/>">
            <i class="fas fa-landmark me-2"></i>网上村委会
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link ${_active == 'home' ? 'active' : ''}" href="<c:url value="/"/>">
                        <i class="fas fa-home me-1"></i>首页
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'announcements' ? 'active' : ''}" href="<c:url value="/announcements"/>">
                        <i class="fas fa-bullhorn me-1"></i>公告
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == 'residents' ? 'active' : ''}" href="<c:url value="/residents"/>">
                        <i class="fas fa-users me-1"></i>村民管理
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == "committee-members" ? "active" : ""}" href="<c:url value="/committee-members"/>">
                        <i class="fas fa-user-tie me-1"></i>村委会成员
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == "logs" ? "active" : ""}" href="<c:url value="/logs"/>">
                        <i class="fas fa-clipboard-list me-1"></i>操作日志
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${_active == "dashboard" ? "active" : ""}" href="<c:url value="/system/dashboard"/>">
                        <i class="fas fa-gauge-high me-1"></i>系统监控
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
