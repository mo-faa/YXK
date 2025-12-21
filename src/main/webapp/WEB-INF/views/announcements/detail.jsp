<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="公告详情 - 网上村委会"/>
<c:set var="activePage" value="announcements"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-bullhorn me-2"></i>公告详情
                </h1>
                <div class="page-hero-subtitle">查看公告内容与发布信息</div>

                <div class="article-meta">
                    <span class="badge rounded-pill badge-soft">
                        <i class="fa-solid fa-user me-1"></i>${announcement.publisher}
                    </span>
                    <span class="badge rounded-pill badge-soft">
                        <i class="fa-solid fa-clock me-1"></i>
                        ${fn:substring(fn:replace(announcement.publishTime, 'T', ' '), 0, 16)}
                    </span>
                    <span class="badge rounded-pill badge-soft">
                        <i class="fa-solid fa-hashtag me-1"></i>ID：${announcement.id}
                    </span>
                </div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/announcements'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <h2 class="fw-bold mb-3">${announcement.title}</h2>
            <div class="article-content"><c:out value="${announcement.content}"/></div>

            <hr class="my-4">

            <div class="d-flex flex-wrap gap-2">
                <a href="<c:url value='/announcements/${announcement.id}/edit'/>" class="btn btn-outline-primary">
                    <i class="fa-solid fa-pen-to-square me-2"></i>编辑
                </a>

                <form action="<c:url value='/announcements/${announcement.id}/delete'/>" method="post"
                      onsubmit="return confirm('确定要删除这条公告吗？');" style="display:inline;">
                    <input type="hidden" name="_csrf" value="${_csrf}"/>
                    <button type="submit" class="btn btn-outline-danger">
                        <i class="fa-solid fa-trash me-2"></i>删除
                    </button>
                </form>

                <a href="<c:url value='/announcements/new'/>" class="btn btn-gradient">
                    <i class="fa-solid fa-plus me-2"></i>发布新公告
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>


