<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="错误 ${status} - 网上村委会"/>
<c:set var="activePage" value=""/>

<%@ include file="common/header.jsp" %>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8" data-animate="fade-up">
            <div class="page-hero mb-4">
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>发生错误（HTTP ${status}）
                </h1>
                <div class="page-hero-subtitle">请检查请求路径或稍后重试</div>
            </div>

            <div class="card soft">
                <div class="card-body p-4 p-md-5">
                    <div class="alert alert-danger border-0 shadow-sm">
                        <div class="fw-bold mb-2"><i class="fa-solid fa-bug me-2"></i>错误信息</div>
                        <div class="mb-1"><strong>error：</strong> ${error}</div>
                        <div class="mb-1"><strong>message：</strong> ${message}</div>
                        <div class="mb-1"><strong>path：</strong> ${path}</div>
                        <div class="mb-0"><strong>requestId：</strong> ${requestId}</div>
                    </div>

                    <div class="d-flex flex-wrap gap-2">
                        <a href="<c:url value='/'/>" class="btn btn-gradient btn-lg">
                            <i class="fa-solid fa-house me-2"></i>返回首页
                        </a>
                        <a href="javascript:history.back();" class="btn btn-outline-secondary btn-lg">
                            <i class="fa-solid fa-arrow-left me-2"></i>返回上一页
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>


