<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="村委会成员管理 - 网上村委会"/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>村委会成员管理</h1>
                <p>管理村委会成员信息，包括添加、编辑和删除</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/committee-members/new'/>" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-user-plus me-1"></i>新增成员
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="card soft mb-4" data-animate="fade-up">
        <div class="card-body">
            <form method="get" action="<c:url value='/committee-members'/>">
                <div class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label">搜索</label>
                        <input type="text" name="q" value="${q}" class="form-control" placeholder="姓名 / 职务 / 联系电话">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">在职状态</label>
                        <select name="isActive" class="form-select">
                            <option value="">全部</option>
                            <option value="true" <c:if test="${isActive eq true}">selected</c:if>>在职</option>
                            <option value="false" <c:if test="${isActive eq false}">selected</c:if>>离职</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">每页条数</label>
                        <input type="number" name="size" value="${page.size}" min="1" max="100" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fa-solid fa-magnifying-glass me-1"></i>查询
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty page.items}">
        <div class="card soft mb-3" data-animate="fade-up">
            <div class="card-body d-flex flex-wrap gap-2 align-items-center justify-content-between" style="padding:var(--space-3) var(--space-4);">
                <div style="font-size:var(--text-sm);">
                    共 <strong>${page.total}</strong> 条，第 <strong>${page.page}</strong> / <strong>${page.totalPages}</strong> 页
                </div>
                <div class="d-flex gap-2">
                    <span class="badge badge-soft">q：${empty q ? '（无）' : q}</span>
                    <span class="badge badge-soft">状态：${isActive eq null ? '全部' : (isActive ? '在职' : '离职')}</span>
                </div>
            </div>
        </div>

        <div class="card soft" data-animate="fade-up">
            <div class="card-body p-0">
                <div class="table-wrap table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th style="width: 90px;">ID</th>
                            <th style="width: 140px;">姓名</th>
                            <th>职务</th>
                            <th style="width: 160px;">联系电话</th>
                            <th style="width: 140px;">任职时间</th>
                            <th style="width: 100px;">状态</th>
                            <th style="width: 180px;">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="member" items="${page.items}">
                            <tr>
                                <td class="fw-bold">#${member.id}</td>
                                <td class="fw-bold">${member.name}</td>
                                <td>${member.position}</td>
                                <td>${member.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty member.joinTime}">
                                            ${fn:substring(fn:replace(member.joinTime, 'T', ' '), 0, 10)}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${member.isActiveMember}">
                                        <span class="badge bg-success">在职</span>
                                    </c:if>
                                    <c:if test="${!member.isActiveMember}">
                                        <span class="badge bg-secondary">离职</span>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <a href="<c:url value='/committee-members/${member.id}'/>" class="btn btn-sm btn-outline-info" title="查看详情">
                                            <i class="fa-solid fa-eye"></i>
                                        </a>
                                        <a href="<c:url value='/committee-members/${member.id}/edit'/>" class="btn btn-sm btn-outline-primary" title="编辑">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <form action="<c:url value='/committee-members/${member.id}/delete'/>" method="post" style="display:inline;"
                                              onsubmit="return confirm('确定要删除成员 ${member.name} 吗？');">
                                            <input type="hidden" name="_csrf" value="${_csrf}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="删除">
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
                <c:if test="${page.totalPages > 1}">
                    <%@ include file="../common/pagination.jsp" %>
                </c:if>
            </div>
        </div>
    </c:if>

    <c:if test="${empty page.items}">
        <div class="card soft" data-animate="fade-up">
            <div class="card-body">
                <div class="empty-state">
                    <i class="fa-solid fa-user-tie"></i>
                    <div class="mt-2">暂无村委会成员数据</div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
