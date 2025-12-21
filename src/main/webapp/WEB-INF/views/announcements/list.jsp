<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="公告管理 - 网上村委会"/>
<c:set var="activePage" value="announcements"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-bullhorn me-2"></i>公告管理
                </h1>
                <div class="page-hero-subtitle">发布、编辑与管理通知公告</div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/announcements/new'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-plus me-2"></i>发布公告
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-0">
            <c:if test="${not empty announcements}">
                <div class="table-wrap table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th>标题</th>
                            <th style="width: 160px;">发布人</th>
                            <th style="width: 180px;">发布时间</th>
                            <th style="width: 160px;">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${announcements}">
                            <tr>
                                <td class="fw-bold">#${a.id}</td>
                                <td>
                                    <a href="<c:url value='/announcements/${a.id}'/>" class="fw-bold">
                                        ${a.title}
                                    </a>
                                </td>
                                <td>${a.publisher}</td>
                                <td>
                                    ${fn:substring(fn:replace(a.publishTime, 'T', ' '), 0, 16)}
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="<c:url value='/announcements/${a.id}'/>"
                                           class="btn btn-sm btn-outline-secondary">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>

                                        <a href="<c:url value='/announcements/${a.id}/edit'/>"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>

                                        <form action="<c:url value='/announcements/${a.id}/delete'/>"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirm('确定要删除这条公告吗？');">
                                            <input type="hidden" name="_csrf" value="${_csrf}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty announcements}">
                <div class="empty-state">
                    <i class="fa-solid fa-inbox"></i>
                    <div class="mt-2">暂无公告</div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>


