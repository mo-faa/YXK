<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="村民信息管理 - 网上村委会"/>
<c:set var="activePage" value="residents"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">

    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-users me-2"></i>村民信息管理
                </h1>
                <div class="page-hero-subtitle">搜索、分页、编辑、导出一站式管理</div>
            </div>

            <div class="text-md-end d-flex gap-2 flex-wrap justify-content-md-end">
                <a href="<c:url value='/residents/new'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-user-plus me-2"></i>新增村民
                </a>

                <c:url var="exportUrl" value="/residents/export.csv">
                    <c:param name="q" value="${q}"/>
                </c:url>
                <a href="${exportUrl}" class="btn btn-outline-success btn-lg">
                    <i class="fa-solid fa-download me-2"></i>导出 CSV
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <!-- 搜索表单 -->
    <div class="card soft mb-4" data-animate="fade-up">
        <div class="card-body">
            <form method="get" action="<c:url value='/residents'/>">
                <div class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">搜索</label>
                        <input type="text" name="q" value="${q}"
                               class="form-control"
                               placeholder="姓名 / 身份证 / 电话 / 地址">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">每页条数</label>
                        <input type="number" name="size" value="${page.size}"
                               min="1" max="100" class="form-control">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-gradient w-100">
                            <i class="fa-solid fa-magnifying-glass me-2"></i>查询
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 分页信息 -->
    <div class="card soft mb-4" data-animate="fade-up">
        <div class="card-body d-flex flex-wrap gap-2 align-items-center justify-content-between">
            <div>
                <i class="fa-solid fa-circle-info me-2 text-primary"></i>
                共 <strong>${page.total}</strong> 条记录，
                当前第 <strong>${page.page}</strong> 页，
                共 <strong>${page.totalPages}</strong> 页
            </div>

            <div class="d-flex gap-2">
                <span class="badge rounded-pill badge-soft">q：${empty q ? '（无）' : q}</span>
                <span class="badge rounded-pill badge-soft">size：${page.size}</span>
            </div>
        </div>
    </div>

    <!-- 数据表格 -->
    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-0">

            <c:if test="${not empty page.items}">
                <div class="table-wrap table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th style="width: 140px;">姓名</th>
                            <th>身份证号</th>
                            <th style="width: 160px;">电话</th>
                            <th>地址</th>
                            <th style="width: 180px;">创建时间</th>
                            <th style="width: 160px;">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="r" items="${page.items}">
                            <tr>
                                <td class="fw-bold">#${r.id}</td>
                                <td class="fw-bold">${r.name}</td>
                                <td>${r.idCard}</td>
                                <td>${r.phone}</td>
                                <td>${r.address}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.createdAt}">
                                            ${fn:substring(fn:replace(r.createdAt, 'T', ' '), 0, 16)}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="<c:url value='/residents/${r.id}/edit'/>"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>

                                        <form action="<c:url value='/residents/${r.id}/delete'/>"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirm('确定要删除村民 ${r.name} 吗？');">
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

                <!-- 分页导航（窗口化渲染） -->
                <c:if test="${page.totalPages > 1}">
                    <c:set var="current" value="${page.page}"/>
                    <c:set var="totalPages" value="${page.totalPages}"/>
                    <c:set var="start" value="${current - 2}"/>
                    <c:set var="end" value="${current + 2}"/>

                    <c:if test="${start < 1}">
                        <c:set var="start" value="1"/>
                    </c:if>
                    <c:if test="${end > totalPages}">
                        <c:set var="end" value="${totalPages}"/>
                    </c:if>

                    <nav class="p-3" aria-label="村民分页">
                        <ul class="pagination justify-content-center mb-0">

                            <c:if test="${page.hasPrev}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${page.page - 1}&size=${page.size}&q=${q}">
                                        <i class="fa-solid fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <!-- 首页 -->
                            <c:if test="${start > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=1&size=${page.size}&q=${q}">1</a>
                                </li>
                                <c:if test="${start > 2}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:if>
                            </c:if>

                            <!-- 窗口 -->
                            <c:forEach begin="${start}" end="${end}" var="i">
                                <li class="page-item ${page.page == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&size=${page.size}&q=${q}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- 末页 -->
                            <c:if test="${end < totalPages}">
                                <c:if test="${end < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${totalPages}&size=${page.size}&q=${q}">
                                        ${totalPages}
                                    </a>
                                </li>
                            </c:if>

                            <c:if test="${page.hasNext}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${page.page + 1}&size=${page.size}&q=${q}">
                                        <i class="fa-solid fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:if>

            <c:if test="${empty page.items}">
                <div class="empty-state">
                    <i class="fa-solid fa-users"></i>
                    <div class="mt-2">暂无村民数据</div>
                </div>
            </c:if>

        </div>
    </div>

</div>

<%@ include file="../common/footer.jsp" %>
