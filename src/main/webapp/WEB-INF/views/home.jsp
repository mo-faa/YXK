<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="首页 - 网上村委会"/>
<c:set var="activePage" value="home"/>

<%@ include file="common/header.jsp" %>

<div class="site-container">

    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>${message}</h1>
                <p>高效便捷的村务管理平台</p>
            </div>
            <div class="page-intro-actions">
                <a href="${pageContext.request.contextPath}/announcements/new" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-plus me-1"></i>发布公告
                </a>
                <a href="${pageContext.request.contextPath}/residents/new" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-user-plus me-1"></i>新增村民
                </a>
            </div>
        </div>
    </div>

    <%@ include file="common/flash.jsp" %>

    <div class="stat-grid mb-5" data-animate="fade-up" data-delay="50">
        <div class="stat-block">
            <div class="stat-block-accent" style="background: var(--c-forest);"></div>
            <div class="stat-block-label">居民总数</div>
            <div class="stat-block-value">${residentTotal}</div>
            <div class="stat-block-meta">户籍与常住居民</div>
        </div>
        <div class="stat-block">
            <div class="stat-block-accent" style="background: var(--c-teal);"></div>
            <div class="stat-block-label">公告总数</div>
            <div class="stat-block-value">${announcementTotal}</div>
            <div class="stat-block-meta">已发布与草稿</div>
        </div>
        <div class="stat-block">
            <div class="stat-block-accent" style="background: var(--c-gold);"></div>
            <div class="stat-block-label">村委会成员</div>
            <div class="stat-block-value">${memberTotal}</div>
            <div class="stat-block-meta">在职成员</div>
        </div>
        <div class="stat-block">
            <div class="stat-block-accent" style="background: var(--c-terracotta);"></div>
            <div class="stat-block-label">操作日志</div>
            <div class="stat-block-value">${logTotal}</div>
            <div class="stat-block-meta">系统操作记录</div>
        </div>
    </div>

    <div class="content-grid cols-2-1 mb-5" data-animate="fade-up" data-delay="100">
        <div class="card soft">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">最近公告</h3>
                <a href="${pageContext.request.contextPath}/announcements" class="btn btn-sm btn-outline-primary">
                    查看全部 <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>
            <div class="card-body p-0">
                <c:if test="${not empty recentAnnouncements}">
                    <c:forEach items="${recentAnnouncements}" var="ann">
                        <div class="announcement-item px-4">
                            <div style="flex:1;min-width:0;">
                                <a href="${pageContext.request.contextPath}/announcements/${ann.id}" class="announcement-item-title">
                                    ${ann.title}
                                </a>
                                <div class="announcement-item-time">
                                    <c:choose>
                                        <c:when test="${not empty ann.publishTime}">
                                            ${fn:substring(fn:replace(ann.publishTime, 'T', ' '), 0, 10)}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <span class="badge
                                <c:choose>
                                    <c:when test="${ann.published}">bg-success</c:when>
                                    <c:when test="${empty ann.status || ann.status == 0}">bg-warning text-dark</c:when>
                                    <c:otherwise>bg-secondary</c:otherwise>
                                </c:choose>
                            ">${ann.statusText}</span>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty recentAnnouncements}">
                    <div class="empty-state py-5">
                        <i class="fa-solid fa-bullhorn"></i>
                        <div class="mt-2">暂无公告</div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card soft">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3 class="card-title mb-0">最近操作</h3>
                <a href="${pageContext.request.contextPath}/logs" class="btn btn-sm btn-outline-primary">
                    查看日志 <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>
            <div class="card-body">
                <c:if test="${not empty recentLogs}">
                    <div class="timeline">
                        <c:forEach items="${recentLogs}" var="log">
                            <div class="timeline-item">
                                <div class="timeline-marker" style="background: var(--c-forest);"></div>
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

    <div data-animate="fade-up" data-delay="200">
        <h2 class="section-label">快捷操作</h2>
        <div class="quick-actions mb-5">
            <a href="${pageContext.request.contextPath}/announcements/new" class="quick-action-item">
                <i class="fa-solid fa-plus"></i>发布公告
            </a>
            <a href="${pageContext.request.contextPath}/residents/new" class="quick-action-item">
                <i class="fa-solid fa-user-plus"></i>新增村民
            </a>
            <a href="${pageContext.request.contextPath}/committee-members/new" class="quick-action-item">
                <i class="fa-solid fa-user-tie"></i>添加成员
            </a>
            <a href="${pageContext.request.contextPath}/system/dashboard" class="quick-action-item">
                <i class="fa-solid fa-gauge-high"></i>系统监控
            </a>
        </div>
    </div>

</div>

<%@ include file="common/footer.jsp" %>
