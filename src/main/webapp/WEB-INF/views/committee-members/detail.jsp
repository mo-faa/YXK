<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="村委会成员详情 - 网上村委会"/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user-tie me-2"></i>村委会成员详情
                </h1>
                <div class="page-hero-subtitle">查看成员详细信息</div>
            </div>

            <div class="text-md-end d-flex gap-2 flex-wrap justify-content-md-end">
                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
                <a href="<c:url value='/committee-members/${member.id}/edit'/>" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-pen-to-square me-2"></i>编辑
                </a>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- 成员基本信息卡片 -->
        <div class="col-lg-8" data-animate="fade-up" data-delay="100">
            <div class="card soft h-100">
                <div class="card-header bg-gradient-primary text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-user me-2"></i>基本信息
                    </h3>
                </div>
                <div class="card-body">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center mb-3">
                                <div class="avatar-lg me-3">
                                    <div class="avatar-initial rounded-circle bg-primary text-white fs-2">
                                        ${fn:substring(member.name, 0, 1)}
                                    </div>
                                </div>
                                <div>
                                    <h4 class="mb-1">${member.name}</h4>
                                    <div class="badge ${member.isActiveMember ? 'bg-success' : 'bg-secondary'} fs-6">
                                        ${member.isActiveMember ? '在职' : '离职'}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <div class="mb-2">
                                <span class="text-muted">ID:</span>
                                <span class="ms-2 fw-bold">#${member.id}</span>
                            </div>
                            <div class="mb-2">
                                <span class="text-muted">性别:</span>
                                <span class="ms-2">${member.gender}</span>
                            </div>
                            <div>
                                <span class="text-muted">身份证号:</span>
                                <span class="ms-2">${member.idCard}</span>
                            </div>
                        </div>
                        <div class="col-12">
                            <hr>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fa-solid fa-phone me-2"></i>联系电话
                                </div>
                                <div class="info-value">${member.phone}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fa-solid fa-briefcase me-2"></i>职务
                                </div>
                                <div class="info-value">${member.position}</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-label">
                                    <i class="fa-solid fa-calendar-check me-2"></i>任职时间
                                </div>
                                <div class="info-value">
                                    <fmt:formatDate value="${member.joinTime}" pattern="yyyy-MM-dd HH:mm"/>
                                </div>
                            </div>
                        </div>
                        <c:if test="${not empty member.leaveTime}">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fa-solid fa-calendar-xmark me-2"></i>离职时间
                                    </div>
                                    <div class="info-value">
                                        <fmt:formatDate value="${member.leaveTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty member.responsibilities}">
                            <div class="col-12 mt-3">
                                <div class="info-item">
                                    <div class="info-label">
                                        <i class="fa-solid fa-clipboard-list me-2"></i>职责描述
                                    </div>
                                    <div class="info-value">${member.responsibilities}</div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- 附加信息卡片 -->
        <div class="col-lg-4" data-animate="fade-up" data-delay="200">
            <!-- 状态信息 -->
            <div class="card soft mb-4">
                <div class="card-header bg-gradient-info text-white">
                    <h5 class="card-title mb-0">
                        <i class="fa-solid fa-chart-line me-2"></i>状态信息
                    </h5>
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
                            <div>
                                该成员目前在职，正常履行职责
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not member.isActiveMember}">
                        <div class="alert alert-warning d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>
                            <div>
                                该成员已离职，不再履行职责
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- 操作记录 -->
            <div class="card soft">
                <div class="card-header bg-gradient-secondary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fa-solid fa-clock-rotate-left me-2"></i>操作记录
                    </h5>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-marker bg-primary"></div>
                            <div class="timeline-content">
                                <h6 class="mb-1">创建记录</h6>
                                <p class="text-muted mb-0">
                                    <fmt:formatDate value="${member.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </p>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-info"></div>
                            <div class="timeline-content">
                                <h6 class="mb-1">任职时间</h6>
                                <p class="text-muted mb-0">
                                    <fmt:formatDate value="${member.joinTime}" pattern="yyyy-MM-dd HH:mm"/>
                                </p>
                            </div>
                        </div>
                        <c:if test="${not empty member.updatedAt}">
                            <div class="timeline-item">
                                <div class="timeline-marker bg-warning"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">最后更新</h6>
                                    <p class="text-muted mb-0">
                                        <fmt:formatDate value="${member.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </p>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty member.leaveTime}">
                            <div class="timeline-item">
                                <div class="timeline-marker bg-danger"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">离职时间</h6>
                                    <p class="text-muted mb-0">
                                        <fmt:formatDate value="${member.leaveTime}" pattern="yyyy-MM-dd HH:mm"/>
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

<style>
/* 详情页样式 */
.avatar-lg {
    width: 80px;
    height: 80px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.avatar-initial {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}

.info-item {
    margin-bottom: 1.5rem;
}

.info-label {
    font-weight: 600;
    color: var(--text-muted);
    margin-bottom: 0.5rem;
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.info-value {
    font-size: 1.1rem;
    font-weight: 500;
}

/* 时间线样式 */
.timeline {
    position: relative;
    padding-left: 25px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 8px;
    top: 0;
    height: 100%;
    width: 2px;
    background: var(--border-color);
}

.timeline-item {
    position: relative;
    margin-bottom: 1.5rem;
}

.timeline-item:last-child {
    margin-bottom: 0;
}

.timeline-marker {
    position: absolute;
    left: -17px;
    top: 5px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    border: 2px solid var(--card-bg);
}

.timeline-content h6 {
    font-size: 0.9rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
}

.timeline-content p {
    font-size: 0.85rem;
}

/* 渐变背景 */
.bg-gradient-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-info {
    background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
}

.bg-gradient-secondary {
    background: linear-gradient(135deg, #434343 0%, #000000 100%);
}
</style>
