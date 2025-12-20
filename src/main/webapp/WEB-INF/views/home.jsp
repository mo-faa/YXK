<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="首页 - 网上村委会业务办理系统"/>
<c:set var="activePage" value="home"/>

<%@ include file="common/header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container text-center">
        <div data-animate="fade-up" class="is-visible">
            <h1 class="hero-title">网上村委会业务办理系统</h1>
            <p class="hero-subtitle">数字化服务 · 智慧治理 · 便民利民</p>
            <div class="mt-4">
                <a href="<c:url value='/residents'/>" class="btn btn-light btn-lg me-2 me-md-3">
                    <i class="fas fa-users me-2"></i>村民管理
                </a>
                <a href="<c:url value='/announcements'/>" class="btn btn-outline-light btn-lg">
                    <i class="fas fa-bullhorn me-2"></i>查看公告
                </a>
            </div>
        </div>
    </div>
</section>

<div class="container py-5">
    <div class="row g-4">
        <div class="col-lg-8">
            <!-- 此处省略：你原来的内容保持不变（项目代码.txt 里是什么这里就是什么） -->
        </div>

        <div class="col-lg-4">
            <!-- 此处省略：你原来的内容保持不变 -->
        </div>
    </div>

    <!-- 最近数据 -->
    <div class="row g-4 mt-2">
        <!-- 最近公告 -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="bi bi-megaphone text-success me-2"></i>最近公告</h6>
                    <a href="${pageContext.request.contextPath}/announcements" class="btn btn-sm btn-outline-success">
                        查看全部
                    </a>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <c:forEach items="${recentAnnouncements}" var="a" varStatus="st">
                            <c:if test="${st.index < 5}">
                                <a href="${pageContext.request.contextPath}/announcements/${a.id}/edit"
                                   class="list-group-item list-group-item-action recent-item py-3">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <c:if test="${a.isTop}">
                                                <span class="badge bg-danger me-1">置顶</span>
                                            </c:if>
                                            <span class="fw-medium">${a.title}</span>
                                        </div>
                                        <small class="text-muted">
                                            ${fn:substring(fn:replace(a.publishTime, 'T', ' '), 5, 16)}
                                        </small>
                                    </div>
                                    <small class="text-muted">${a.publisher}</small>
                                </a>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty recentAnnouncements}">
                            <div class="list-group-item text-center text-muted py-4">
                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                暂无公告
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- 最近操作 -->
        <div class="col-lg-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="bi bi-journal-text text-warning me-2"></i>最近操作</h6>
                    <a href="${pageContext.request.contextPath}/logs" class="btn btn-sm btn-outline-warning">
                        查看全部
                    </a>
                </div>
                <div class="card-body p-0">
                    <div class="list-group list-group-flush">
                        <c:forEach items="${recentLogs}" var="log" varStatus="st">
                            <c:if test="${st.index < 5}">
                                <div class="list-group-item recent-item py-3">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <span class="badge
                                                <c:choose>
                                                    <c:when test="${log.action == 'CREATE'}">bg-success</c:when>
                                                    <c:when test="${log.action == 'UPDATE'}">bg-primary</c:when>
                                                    <c:when test="${log.action == 'DELETE'}">bg-danger</c:when>
                                                    <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>
                                            ">${log.action}</span>
                                            <span class="ms-2">${log.detail}</span>
                                        </div>
                                        <small class="text-muted text-nowrap">
                                            ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 5, 16)}
                                        </small>
                                    </div>
                                    <small class="text-muted">
                                        <i class="bi bi-person me-1"></i>${log.username}
                                        <i class="bi bi-geo-alt ms-2 me-1"></i>${log.ip}
                                    </small>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty recentLogs}">
                            <div class="list-group-item text-center text-muted py-4">
                                <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                暂无操作记录
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>
