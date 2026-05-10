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
        <div class="card-header p-4">
            <form method="get" action="<c:url value='/announcements'/>">
                <div class="row g-2 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label">搜索</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="q" class="form-control" placeholder="输入公告标题关键词..." value="${q}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">状态</label>
                        <select name="status" class="form-select">
                            <option value="">全部状态</option>
                            <option value="0" <c:if test="${status eq 0}">selected</c:if>>📝 草稿</option>
                            <option value="1" <c:if test="${status eq 1}">selected</c:if>>✅ 已发布</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">置顶</label>
                        <select name="isTop" class="form-select">
                            <option value="">全部</option>
                            <option value="true" <c:if test="${isTop eq 'true'}">selected</c:if>>⭐ 已置顶</option>
                            <option value="false" <c:if test="${isTop eq 'false'}">selected</c:if>>未置顶</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-gradient w-100">
                            <i class="fa-solid fa-filter me-1"></i>筛选
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div class="card-body p-0">
            <c:if test="${not empty announcements}">
                <div class="table-wrap table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th>标题</th>
                            <th style="width: 120px;">状态</th>
                            <th style="width: 80px;">置顶</th>
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
                                <td>
                                    <span class="badge <c:if test='${a.status eq 1}'>bg-success</c:if><c:if test='${a.status eq 0}'>bg-secondary</c:if>">
                                        ${a.statusText}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${a.isTop}">
                                        <i class="fa-solid fa-star text-warning"></i>
                                    </c:if>
                                    <c:if test="${not a.isTop}">
                                        <i class="fa-regular fa-star"></i>
                                    </c:if>
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


