<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="首页 - 网上村委会"/>
<c:set var="activePage" value="home"/>

<%@ include file="common/header.jsp" %>

<div class="container py-4">

    <!-- Hero区域 -->
    <div class="page-hero mb-5" data-animate="fade-up">
        <h1 class="page-hero-title">
            <i class="fa-solid fa-house-chimney me-2"></i>${message}
        </h1>
        <div class="page-hero-subtitle">高效便捷的村务管理平台</div>
    </div>

    <%@ include file="common/flash.jsp" %>

    <!-- 统计卡片 -->
    <div class="row g-4 mb-5">
        <div class="col-md-4" data-animate="fade-up" data-delay="100">
            <div class="stat-card">
                <div class="stat-card-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-value">${residentTotal}</div>
                    <div class="stat-card-label">居民总数</div>
                </div>
            </div>
        </div>
        <div class="col-md-4" data-animate="fade-up" data-delay="200">
            <div class="stat-card">
                <div class="stat-card-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fa-solid fa-bullhorn"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-value">${announcementTotal}</div>
                    <div class="stat-card-label">公告总数</div>
                </div>
            </div>
        </div>
        <div class="col-md-4" data-animate="fade-up" data-delay="300">
            <div class="stat-card">
                <div class="stat-card-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fa-solid fa-clipboard-list"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-value">${fn:length(recentLogs)}</div>
                    <div class="stat-card-label">最近操作</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 快捷入口 -->
    <div class="card soft mb-5" data-animate="fade-up">
        <div class="card-header">
            <i class="fa-solid fa-rocket me-2"></i>快捷入口
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-6 col-md-3">
                    <a href="<c:url value='/residents'/>" class="quick-link">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>居民管理</span>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="<c:url value='/announcements'/>" class="quick-link">
                        <i class="fa-solid fa-newspaper"></i>
                        <span>公告管理</span>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="<c:url value='/logs'/>" class="quick-link">
                        <i class="fa-solid fa-clipboard-list"></i>
                        <span>操作日志</span>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="<c:url value='/residents/new'/>" class="quick-link">
                        <i class="fa-solid fa-circle-plus"></i>
                        <span>新增居民</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- 最近公告 -->
        <div class="col-lg-6" data-animate="fade-up" data-delay="100">
            <div class="card soft h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-bullhorn me-2"></i>最近公告</span>
                    <a href="<c:url value='/announcements'/>" class="btn btn-sm btn-light">
                        查看全部 <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:if test="${not empty recentAnnouncements}">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="ann" items="${recentAnnouncements}">
                                <li class="list-group-item d-flex justify-content-between align-items-start">
                                    <div class="ms-2 me-auto">
                                        <div class="fw-bold">
                                            <a href="<c:url value='/announcements/${ann.id}'/>" class="text-decoration-none">
                                                ${ann.title}
                                            </a>
                                        </div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty ann.createdAt}">
                                                    ${fn:substring(fn:replace(ann.createdAt, 'T', ' '), 0, 10)}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${ann.status == 'PUBLISHED'}">bg-success</c:when>
                                            <c:when test="${ann.status == 'DRAFT'}">bg-warning text-dark</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>
                                    ">${ann.status}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                    <c:if test="${empty recentAnnouncements}">
                        <div class="empty-state py-5">
                            <i class="fa-solid fa-bullhorn"></i>
                            <div class="mt-2">暂无公告</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 最近操作 -->
        <div class="col-lg-6" data-animate="fade-up" data-delay="200">
            <div class="card soft h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-clock-rotate-left me-2"></i>最近操作</span>
                    <a href="<c:url value='/logs'/>" class="btn btn-sm btn-light">
                        查看全部 <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:if test="${not empty recentLogs}">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="log" items="${recentLogs}">
                                <li class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="ms-2 me-auto">
                                            <div class="d-flex align-items-center gap-2 mb-1">
                                                <span class="badge 
                                                    <c:choose>
                                                        <c:when test="${log.operationType == 'CREATE'}">bg-success</c:when>
                                                        <c:when test="${log.operationType == 'UPDATE'}">bg-primary</c:when>
                                                        <c:when test="${log.operationType == 'DELETE'}">bg-danger</c:when>
                                                        <c:otherwise>bg-info</c:otherwise>
                                                    </c:choose>
                                                ">${log.operationType}</span>
                                                <span class="badge bg-outline-secondary border">${log.targetType}</span>
                                            </div>
                                            <div class="small text-truncate" style="max-width: 280px;">
                                                ${log.description}
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <div class="small text-muted">${log.operator}</div>
                                            <div class="small text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty log.createdAt}">
                                                        ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 16)}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                    <c:if test="${empty recentLogs}">
                        <div class="empty-state py-5">
                            <i class="fa-solid fa-clipboard-list"></i>
                            <div class="mt-2">暂无操作记录</div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

</div>

<%@ include file="common/footer.jsp" %>
