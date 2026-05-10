<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="操作日志 - 网上村委会"/>
<c:set var="activePage" value="logs"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">

    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-clipboard-list me-2"></i>操作日志
                </h1>
                <div class="page-hero-subtitle">查看系统所有操作记录</div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回首页
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <!-- 搜索表单 -->
    <div class="card soft mb-4" data-animate="fade-up">
        <div class="card-body">
            <form method="get" action="<c:url value='/logs'/>">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-bold">关键词搜索</label>
                        <input type="text" name="q" value="${q}"
                               class="form-control"
                               placeholder="操作人 / 描述">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">操作类型</label>
                        <select name="operationType" class="form-select">
                            <option value="">全部</option>
                            <c:forEach var="type" items="${operationTypes}">
                                <option value="${type}" ${operationType == type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">目标类型</label>
                        <select name="targetType" class="form-select">
                            <option value="">全部</option>
                            <c:forEach var="type" items="${targetTypes}">
                                <option value="${type}" ${targetType == type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
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
                <c:if test="${not empty q}">
                    <span class="badge rounded-pill badge-soft">关键词：${q}</span>
                </c:if>
                <c:if test="${not empty operationType}">
                    <span class="badge rounded-pill badge-soft">操作：${operationType}</span>
                </c:if>
                <c:if test="${not empty targetType}">
                    <span class="badge rounded-pill badge-soft">目标：${targetType}</span>
                </c:if>
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
                            <th style="width: 80px;">ID</th>
                            <th style="width: 100px;">操作人</th>
                            <th style="width: 100px;">操作类型</th>
                            <th style="width: 100px;">目标类型</th>
                            <th style="width: 80px;">目标ID</th>
                            <th>描述</th>
                            <th style="width: 130px;">IP地址</th>
                            <th style="width: 160px;">操作时间</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="log" items="${page.items}">
                            <tr>
                                <td class="fw-bold">#${log.id}</td>
                                <td>
                                    <span class="badge bg-secondary">${log.operator}</span>
                                </td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${log.operationType == 'CREATE'}">bg-success</c:when>
                                            <c:when test="${log.operationType == 'UPDATE'}">bg-primary</c:when>
                                            <c:when test="${log.operationType == 'DELETE'}">bg-danger</c:when>
                                            <c:otherwise>bg-info</c:otherwise>
                                        </c:choose>
                                    ">${log.operationType}</span>
                                </td>
                                <td>
                                    <span class="badge bg-outline-secondary border">${log.targetType}</span>
                                </td>
                                <td>${log.targetId}</td>
                                <td>
                                    <span class="text-truncate d-inline-block" style="max-width: 300px;" 
                                          title="${log.description}">
                                        ${log.description}
                                    </span>
                                </td>
                                <td>
                                    <code class="small">${log.ipAddress}</code>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.createdAt}">
                                            ${fn:substring(fn:replace(log.createdAt, 'T', ' '), 0, 19)}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 分页导航 -->
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

                    <nav class="p-3" aria-label="日志分页">
                        <ul class="pagination justify-content-center mb-0">

                            <c:if test="${page.hasPrev}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${page.page - 1}&size=${page.size}&q=${q}&operationType=${operationType}&targetType=${targetType}">
                                        <i class="fa-solid fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <!-- 首页 -->
                            <c:if test="${start > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=1&size=${page.size}&q=${q}&operationType=${operationType}&targetType=${targetType}">1</a>
                                </li>
                                <c:if test="${start > 2}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:if>
                            </c:if>

                            <!-- 窗口 -->
                            <c:forEach begin="${start}" end="${end}" var="i">
                                <li class="page-item ${page.page == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&size=${page.size}&q=${q}&operationType=${operationType}&targetType=${targetType}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- 末页 -->
                            <c:if test="${end < totalPages}">
                                <c:if test="${end < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">…</span></li>
                                </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${totalPages}&size=${page.size}&q=${q}&operationType=${operationType}&targetType=${targetType}">
                                        ${totalPages}
                                    </a>
                                </li>
                            </c:if>

                            <c:if test="${page.hasNext}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${page.page + 1}&size=${page.size}&q=${q}&operationType=${operationType}&targetType=${targetType}">
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
                    <i class="fa-solid fa-clipboard-list"></i>
                    <div class="mt-2">暂无操作日志</div>
                </div>
            </c:if>

        </div>
    </div>

</div>

<%@ include file="../common/footer.jsp" %>
