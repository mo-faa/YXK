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

    <!-- 统计卡片（已移除“投诉/统计”模块） -->
    <div class="row g-4 mb-5">
        <div class="col-md-6" data-animate="fade-up" data-delay="100">
            <div class="stat-card stat-card--glow">
                <div class="stat-card-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fa-solid fa-people-group"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">居民总数</div>
                    <div class="stat-card-value">${residentTotal}</div>
                    <div class="stat-card-meta">户籍与常住居民</div>
                </div>
            </div>
        </div>

        <div class="col-md-6" data-animate="fade-up" data-delay="200">
            <div class="stat-card stat-card--glow">
                <div class="stat-card-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fa-solid fa-bullhorn"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">公告总数</div>
                    <div class="stat-card-value">${announcementTotal}</div>
                    <div class="stat-card-meta">已发布与草稿</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 最新动态 -->
    <div class="row g-4">
        <!-- 最近公告 -->
        <div class="col-lg-6" data-animate="fade-up" data-delay="100">
            <div class="card soft h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-bullhorn me-2"></i>最近公告
                    </h3>
                    <a href="${pageContext.request.contextPath}/announcements" class="btn btn-sm btn-outline-primary">
                        查看全部 <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:if test="${not empty recentAnnouncements}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${recentAnnouncements}" var="ann">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-4 py-3">
                                    <div>
                                        <div class="fw-semibold">
                                            <a href="${pageContext.request.contextPath}/announcements/view?id=${ann.id}" class="text-decoration-none">
                                                ${ann.title}
                                            </a>
                                        </div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty ann.publishTime}">
                                                    ${fn:substring(fn:replace(ann.publishTime, 'T', ' '), 0, 10)}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${ann.published}">bg-success</c:when>
                                            <c:when test="${empty ann.status || ann.status == 0}">bg-warning text-dark</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>
                                    ">${ann.statusText}</span>
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
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-clock-rotate-left me-2"></i>最近操作
                    </h3>
                    <a href="${pageContext.request.contextPath}/logs" class="btn btn-sm btn-outline-primary">
                        查看日志 <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="card-body p-0">
                    <c:if test="${not empty recentLogs}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${recentLogs}" var="log">
                                <li class="list-group-item px-4 py-3">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <div class="fw-semibold">
                                                <c:choose>
                                                    <c:when test="${not empty log.description}">
                                                        ${log.description}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <small class="text-muted">
                                                <c:choose>
                                                    <c:when test="${not empty log.operator}">
                                                        ${log.operator}
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty log.createdAt}">
                                                    ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 16)}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </small>
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
