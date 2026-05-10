<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="首页 - 网上村委会"/>
<c:set var="activePage" value="home"/>

<%@ include file="common/header.jsp" %>

<div class="container py-4">

    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-house-chimney me-2"></i>${message}
                </h1>
                <div class="page-hero-subtitle">高效便捷的村务管理平台</div>
            </div>
            <div class="mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/announcements/new" class="btn btn-light btn-sm me-2">
                    <i class="fa-solid fa-plus me-1"></i>发布公告
                </a>
                <a href="${pageContext.request.contextPath}/residents/new" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-user-plus me-1"></i>新增村民
                </a>
            </div>
        </div>
    </div>

    <%@ include file="common/flash.jsp" %>

    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3" data-animate="fade-up" data-delay="50">
            <div class="stat-card">
                <div class="stat-card-icon bg-gradient-primary">
                    <i class="fa-solid fa-people-group"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">居民总数</div>
                    <div class="stat-card-value">${residentTotal}</div>
                    <div class="stat-card-meta">户籍与常住居民</div>
                </div>
            </div>
        </div>

        <div class="col-6 col-lg-3" data-animate="fade-up" data-delay="100">
            <div class="stat-card">
                <div class="stat-card-icon bg-gradient-info">
                    <i class="fa-solid fa-bullhorn"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">公告总数</div>
                    <div class="stat-card-value">${announcementTotal}</div>
                    <div class="stat-card-meta">已发布与草稿</div>
                </div>
            </div>
        </div>

        <div class="col-6 col-lg-3" data-animate="fade-up" data-delay="150">
            <div class="stat-card">
                <div class="stat-card-icon bg-gradient-success">
                    <i class="fa-solid fa-user-tie"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">村委会成员</div>
                    <div class="stat-card-value">${memberTotal}</div>
                    <div class="stat-card-meta">在职成员</div>
                </div>
            </div>
        </div>

        <div class="col-6 col-lg-3" data-animate="fade-up" data-delay="200">
            <div class="stat-card">
                <div class="stat-card-icon bg-gradient-warning">
                    <i class="fa-solid fa-clipboard-list"></i>
                </div>
                <div class="stat-card-content">
                    <div class="stat-card-title">操作日志</div>
                    <div class="stat-card-value">${logTotal}</div>
                    <div class="stat-card-meta">系统操作记录</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-8" data-animate="fade-up" data-delay="100">
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
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="stat-card-icon bg-gradient-info" style="width:40px;min-width:40px;height:40px;font-size:1rem;border-radius:10px;">
                                            <i class="fa-solid fa-file-lines"></i>
                                        </div>
                                        <div>
                                            <div class="fw-semibold">
                                                <a href="${pageContext.request.contextPath}/announcements/${ann.id}" class="text-decoration-none">
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

        <div class="col-lg-4" data-animate="fade-up" data-delay="200">
            <div class="card soft h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-clock-rotate-left me-2"></i>最近操作
                    </h3>
                    <a href="${pageContext.request.contextPath}/logs" class="btn btn-sm btn-outline-primary">
                        查看日志 <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
                <div class="card-body">
                    <c:if test="${not empty recentLogs}">
                        <div class="timeline">
                            <c:forEach items="${recentLogs}" var="log">
                                <div class="timeline-item">
                                    <div class="timeline-marker bg-gradient-primary"></div>
                                    <div class="timeline-content">
                                        <h6>
                                            <c:choose>
                                                <c:when test="${not empty log.description}">
                                                    ${log.description}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </h6>
                                        <p class="mb-0">
                                            <c:choose>
                                                <c:when test="${not empty log.operator}">
                                                    ${log.operator}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty log.createdAt}">
                                                &middot; ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 16)}
                                            </c:if>
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
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

    <div class="row g-4" data-animate="fade-up" data-delay="300">
        <div class="col-12">
            <div class="card soft">
                <div class="card-header">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-bolt me-2"></i>快捷操作
                    </h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/announcements/new" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none" style="background: var(--surface-1); transition: all 0.2s ease; border: 1px solid var(--border-light);">
                                <div class="stat-card-icon bg-gradient-info" style="width:44px;min-width:44px;height:44px;font-size:1.1rem;border-radius:12px;">
                                    <i class="fa-solid fa-plus"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold" style="color: var(--text-primary); font-size: 0.9rem;">发布公告</div>
                                    <div style="color: var(--text-tertiary); font-size: 0.8rem;">创建新公告</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/residents/new" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none" style="background: var(--surface-1); transition: all 0.2s ease; border: 1px solid var(--border-light);">
                                <div class="stat-card-icon bg-gradient-success" style="width:44px;min-width:44px;height:44px;font-size:1.1rem;border-radius:12px;">
                                    <i class="fa-solid fa-user-plus"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold" style="color: var(--text-primary); font-size: 0.9rem;">新增村民</div>
                                    <div style="color: var(--text-tertiary); font-size: 0.8rem;">登记居民信息</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/committee-members/new" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none" style="background: var(--surface-1); transition: all 0.2s ease; border: 1px solid var(--border-light);">
                                <div class="stat-card-icon bg-gradient-primary" style="width:44px;min-width:44px;height:44px;font-size:1.1rem;border-radius:12px;">
                                    <i class="fa-solid fa-user-tie"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold" style="color: var(--text-primary); font-size: 0.9rem;">添加成员</div>
                                    <div style="color: var(--text-tertiary); font-size: 0.8rem;">村委会成员</div>
                                </div>
                            </a>
                        </div>
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/system/dashboard" class="d-flex align-items-center gap-3 p-3 rounded-3 text-decoration-none" style="background: var(--surface-1); transition: all 0.2s ease; border: 1px solid var(--border-light);">
                                <div class="stat-card-icon bg-gradient-warning" style="width:44px;min-width:44px;height:44px;font-size:1.1rem;border-radius:12px;">
                                    <i class="fa-solid fa-gauge-high"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold" style="color: var(--text-primary); font-size: 0.9rem;">系统监控</div>
                                    <div style="color: var(--text-tertiary); font-size: 0.8rem;">查看仪表盘</div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<%@ include file="common/footer.jsp" %>
