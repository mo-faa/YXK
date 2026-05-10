<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="村委会成员详情 - 网上村委会"/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>村委会成员详情</h1>
                <p>查看成员详细信息</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>返回列表
                </a>
                <a href="<c:url value='/committee-members/${member.id}/edit'/>" class="btn btn-primary btn-sm">
                    <i class="fa-solid fa-pen-to-square me-1"></i>编辑
                </a>
            </div>
        </div>
    </div>

    <div class="content-grid cols-2-1" data-animate="fade-up">
        <div class="card soft">
            <div class="card-header" style="background:var(--c-forest);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">基本信息</h3>
            </div>
            <div class="card-body">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center mb-3">
                            <div class="avatar-lg me-3">
                                <div class="avatar-initial rounded-circle" style="background:var(--c-forest);color:#fff;">
                                    ${fn:substring(member.name, 0, 1)}
                                </div>
                            </div>
                            <div>
                                <h4 class="mb-1">${member.name}</h4>
                                <div class="badge ${member.isActiveMember ? 'bg-success' : 'bg-secondary'}">
                                    ${member.isActiveMember ? '在职' : '离职'}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <div class="mb-2"><span class="info-label">ID:</span> <strong>#${member.id}</strong></div>
                        <div class="mb-2"><span class="info-label">状态:</span> ${member.statusText}</div>
                        <div><span class="info-label">电话:</span> ${member.phone}</div>
                    </div>
                    <div class="col-12"><hr style="border-color:var(--c-stroke-light);"></div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">联系电话</div>
                            <div class="info-value">${member.phone}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">职务</div>
                            <div class="info-value">${member.position}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">任职时间</div>
                            <div class="info-value">
                                ${fn:substring(fn:replace(member.joinTime, 'T', ' '), 0, 16)}
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-item">
                            <div class="info-label">职责描述</div>
                            <div class="info-value">${member.duties}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div>
            <div class="card soft mb-4">
                <div class="card-header" style="background:var(--c-teal);color:#fff;">
                    <h5 class="card-title mb-0" style="color:#fff;">状态信息</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>当前状态</span>
                            <span class="badge ${member.isActiveMember ? 'bg-success' : 'bg-secondary'}">
                                ${member.isActiveMember ? '在职' : '离职'}
                            </span>
                        </div>
                        <div class="progress" style="height: 8px;">
                            <div class="progress-bar ${member.isActiveMember ? 'bg-success' : 'bg-secondary'}"
                                 style="width: ${member.isActiveMember ? '100' : '0'}%"></div>
                        </div>
                    </div>
                    <c:if test="${member.isActiveMember}">
                        <div class="alert alert-success d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i>
                            <div>该成员目前在职，正常履行职责</div>
                        </div>
                    </c:if>
                    <c:if test="${not member.isActiveMember}">
                        <div class="alert alert-warning d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>
                            <div>该成员已离职，不再履行职责</div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="card soft">
                <div class="card-header" style="background:var(--c-ink-soft);color:#fff;">
                    <h5 class="card-title mb-0" style="color:#fff;">操作记录</h5>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-marker" style="background:var(--c-forest);"></div>
                            <div class="timeline-content">
                                <h6 class="mb-1">创建记录</h6>
                                <p class="mb-0" style="color:var(--c-ink-muted);">
                                    ${fn:substring(fn:replace(member.createdAt, 'T', ' '), 0, 16)}
                                </p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker" style="background:var(--c-teal);"></div>
                            <div class="timeline-content">
                                <h6 class="mb-1">任职时间</h6>
                                <p class="mb-0" style="color:var(--c-ink-muted);">
                                    ${fn:substring(fn:replace(member.joinTime, 'T', ' '), 0, 16)}
                                </p>
                            </div>
                        </div>
                        <c:if test="${not empty member.updatedAt}">
                            <div class="timeline-item">
                                <div class="timeline-marker" style="background:var(--c-gold);"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">最后更新</h6>
                                    <p class="mb-0" style="color:var(--c-ink-muted);">
                                        ${fn:substring(fn:replace(member.updatedAt, 'T', ' '), 0, 16)}
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
