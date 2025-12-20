<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="activePage" value="residents"/>

<c:choose>
    <c:when test="${mode == 'edit'}">
        <c:set var="pageTitle" value="编辑村民 - 网上村委会"/>
        <c:set var="actionUrl" value="/residents/${resident.id}"/>
        <c:set var="modeText" value="编辑村民"/>
        <c:set var="subText" value="更新村民信息并保存"/>
    </c:when>
    <c:otherwise>
        <c:set var="pageTitle" value="新增村民 - 网上村委会"/>
        <c:set var="actionUrl" value="/residents"/>
        <c:set var="modeText" value="新增村民"/>
        <c:set var="subText" value="录入村民基础信息"/>
    </c:otherwise>
</c:choose>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user-gear me-2"></i>${modeText}
                    <c:if test="${mode == 'edit'}">
                        <span class="ms-2 fs-6 fw-bold opacity-75">（ID=${resident.id}）</span>
                    </c:if>
                </h1>
                <div class="page-hero-subtitle">${subText}</div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/residents'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回村民列表
                </a>
            </div>
        </div>
    </div>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <form action="<c:url value='${actionUrl}'/>" method="post">
                <input type="hidden" name="_csrf" value="${_csrf}"/>

                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">姓名（必填）</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                            <input type="text" name="name" value="${resident.name}"
                                   class="form-control" maxlength="50" required
                                   placeholder="请输入姓名">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">身份证号</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-id-card"></i></span>
                            <input type="text" name="idCard" value="${resident.idCard}"
                                   class="form-control" maxlength="18"
                                   placeholder="18 位身份证号（可选）">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">电话</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                            <input type="text" name="phone" value="${resident.phone}"
                                   class="form-control" maxlength="20"
                                   placeholder="手机号/座机（可选）">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold">地址</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-location-dot"></i></span>
                            <input type="text" name="address" value="${resident.address}"
                                   class="form-control" maxlength="255"
                                   placeholder="请输入详细地址（可选）">
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <div class="d-flex flex-wrap gap-2">
                    <button type="submit" class="btn btn-gradient btn-lg">
                        <i class="fa-solid fa-floppy-disk me-2"></i>
                        <c:choose>
                            <c:when test="${mode == 'edit'}">保存修改</c:when>
                            <c:otherwise>确认新增</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="<c:url value='/residents'/>" class="btn btn-outline-secondary btn-lg">取消</a>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
