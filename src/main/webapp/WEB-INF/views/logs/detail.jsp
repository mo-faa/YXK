<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="日志详情 - 网上村委会"/>
<c:set var="activePage" value="logs"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-clipboard-list me-2"></i>日志详情
                </h1>
                <div class="page-hero-subtitle">操作日志 #${log.id}</div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/logs'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <div class="row g-4">
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">操作人</h6>
                    <p class="fs-5 fw-bold">${log.operator}</p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">操作类型</h6>
                    <p>
                        <span class="badge fs-6
                            <c:choose>
                                <c:when test="${log.operationType == 'CREATE'}">bg-success</c:when>
                                <c:when test="${log.operationType == 'UPDATE'}">bg-primary</c:when>
                                <c:when test="${log.operationType == 'DELETE'}">bg-danger</c:when>
                                <c:otherwise>bg-info</c:otherwise>
                            </c:choose>
                        ">${log.operationType}</span>
                    </p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">目标类型</h6>
                    <p class="fs-5">${log.targetType}</p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">目标ID</h6>
                    <p class="fs-5">${log.targetId}</p>
                </div>
                <div class="col-12">
                    <h6 class="text-muted mb-1">描述</h6>
                    <p class="fs-5">${log.description}</p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">IP地址</h6>
                    <p><code>${log.ipAddress}</code></p>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-1">操作时间</h6>
                    <p>
                        <c:choose>
                            <c:when test="${not empty log.createdAt}">
                                ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 19)}
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="col-12">
                    <h6 class="text-muted mb-1">User-Agent</h6>
                    <p class="text-break small text-muted">${log.userAgent}</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

