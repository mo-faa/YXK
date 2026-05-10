<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="村民详情 - 网上村委会"/>
<c:set var="activePage" value="residents"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user me-2"></i>村民详情
                </h1>
                <div class="page-hero-subtitle">查看村民完整信息</div>
            </div>
            <div class="text-md-end d-flex gap-2 flex-wrap justify-content-md-end">
                <a href="<c:url value='/residents'/>" class="btn btn-outline-secondary btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
                <a href="<c:url value='/residents/${resident.id}/edit'/>" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-pen-to-square me-2"></i>编辑
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8" data-animate="fade-up">
            <div class="card soft">
                <div class="card-header">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-id-card me-2"></i>基本信息
                    </h3>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">姓名</div>
                                <div class="info-value fw-bold fs-5">${resident.name}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">身份证号</div>
                                <div class="info-value">${resident.idCard}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">联系电话</div>
                                <div class="info-value">${resident.phone}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">住址</div>
                                <div class="info-value">${empty resident.address ? '-' : resident.address}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">创建时间</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty resident.createdAt}">
                                            ${fn:substring(fn:replace(resident.createdAt, 'T', ' '), 0, 19)}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">记录ID</div>
                                <div class="info-value">#${resident.id}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" data-animate="fade-up" data-delay="100">
            <div class="card soft">
                <div class="card-header">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-bolt me-2"></i>快速操作
                    </h3>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="<c:url value='/residents/${resident.id}/edit'/>" class="btn btn-outline-primary">
                            <i class="fa-solid fa-pen-to-square me-2"></i>编辑信息
                        </a>
                        <form action="<c:url value='/residents/${resident.id}/delete'/>" method="post"
                              onsubmit="return confirm('确定要删除村民 ${resident.name} 吗？');">
                            <input type="hidden" name="_csrf" value="${_csrf}"/>
                            <button type="submit" class="btn btn-outline-danger w-100">
                                <i class="fa-solid fa-trash me-2"></i>删除村民
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
