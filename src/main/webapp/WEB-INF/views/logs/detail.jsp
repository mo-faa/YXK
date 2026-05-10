<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="日志详情 - 网上村委会"/>
<c:set var="activePage" value="logs"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>日志详情</h1>
                <p>操作日志 #${log.id}</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/logs'/>" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">操作人</div>
                        <div class="info-value fw-bold">${log.operator}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">操作类型</div>
                        <div class="info-value">
                            <span class="badge
                                <c:choose>
                                    <c:when test="${log.operationType == 'CREATE'}">bg-success</c:when>
                                    <c:when test="${log.operationType == 'UPDATE'}">bg-primary</c:when>
                                    <c:when test="${log.operationType == 'DELETE'}">bg-danger</c:when>
                                    <c:otherwise>bg-info</c:otherwise>
                                </c:choose>
                            ">${log.operationType}</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">目标类型</div>
                        <div class="info-value">${log.targetType}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">目标ID</div>
                        <div class="info-value">${log.targetId}</div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="info-item">
                        <div class="info-label">描述</div>
                        <div class="info-value">${log.description}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">IP地址</div>
                        <div class="info-value"><code>${log.ipAddress}</code></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-item">
                        <div class="info-label">操作时间</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty log.createdAt}">
                                    ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 19)}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="info-item">
                        <div class="info-label">User-Agent</div>
                        <div class="info-value" style="font-size:var(--text-xs);color:var(--c-ink-muted);word-break:break-all;">${log.userAgent}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
