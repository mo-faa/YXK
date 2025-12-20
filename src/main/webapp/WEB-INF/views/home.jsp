<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="首页 - 网上村委会业务办理系统"/>
<c:set var="activePage" value="home"/>

<%@ include file="common/header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container text-center">
        <div data-animate="fade-up" class="is-visible">
            <h1 class="hero-title">网上村委会业务办理系统</h1>
            <p class="hero-subtitle">数字化服务 · 智慧治理 · 便民利民</p>
            <div class="mt-4">
                <a href="<c:url value='/residents'/>" class="btn btn-light btn-lg me-2 me-md-3">
                    <i class="fas fa-users me-2"></i>村民管理
                </a>
                <a href="<c:url value='/announcements'/>" class="btn btn-outline-light btn-lg">
                    <i class="fas fa-bullhorn me-2"></i>查看公告
                </a>
            </div>
        </div>
    </div>
</section>

<!-- 统计数据（改为动态：从 Controller 传入 residentTotal / announcementTotal） -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-3" data-animate="fade-up">
                <div class="stats-card text-center">
                    <div class="stats-number">${residentTotal}</div>
                    <p class="text-muted mb-0">注册村民</p>
                </div>
            </div>
            <div class="col-md-3" data-animate="fade-up">
                <div class="stats-card text-center">
                    <div class="stats-number">${announcementTotal}</div>
                    <p class="text-muted mb-0">公告数量</p>
                </div>
            </div>
            <div class="col-md-3" data-animate="fade-up">
                <div class="stats-card text-center">
                    <div class="stats-number">100%</div>
                    <p class="text-muted mb-0">在线可办理</p>
                </div>
            </div>
            <div class="col-md-3" data-animate="fade-up">
                <div class="stats-card text-center">
                    <div class="stats-number">24/7</div>
                    <p class="text-muted mb-0">随时可访问</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 服务项目 -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-4">
            <h2 class="fw-bold">服务项目</h2>
            <div class="text-muted">一站式办理常见村务事项</div>
        </div>

        <div class="row g-4">
            <div class="col-md-4" data-animate="fade-up">
                <div class="card service-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="service-icon"><i class="fas fa-file-alt"></i></div>
                        <h5 class="card-title fw-bold">证明开具</h5>
                        <p class="card-text text-muted">在线申请居住证明、收入证明等材料</p>
                        <a href="#" class="btn btn-gradient btn-glow">立即办理</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-animate="fade-up">
                <div class="card service-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="service-icon"><i class="fas fa-users"></i></div>
                        <h5 class="card-title fw-bold">户籍管理</h5>
                        <p class="card-text text-muted">村民信息管理、登记维护、导出等</p>
                        <a href="<c:url value='/residents'/>" class="btn btn-gradient btn-glow">立即办理</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4" data-animate="fade-up">
                <div class="card service-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="service-icon"><i class="fas fa-hand-holding-usd"></i></div>
                        <h5 class="card-title fw-bold">补贴申请</h5>
                        <p class="card-text text-muted">农业补贴、社保补贴等在线申报入口</p>
                        <a href="#" class="btn btn-gradient btn-glow">立即办理</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 最新公告（首页只显示 latest 5 条，不再全表查） -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-4">
            <h2 class="fw-bold">最新公告</h2>
            <div class="text-muted">及时了解通知与政策</div>
        </div>

        <div class="row">
            <div class="col-lg-9 mx-auto">
                <c:if test="${not empty announcements}">
                    <c:forEach var="a" items="${announcements}">
                        <div class="card soft mb-3" data-animate="fade-up">
                            <div class="card-body">
                                <div class="d-flex flex-column flex-md-row gap-3 justify-content-between">
                                    <div class="flex-grow-1">
                                        <h5 class="fw-bold mb-2">${a.title}</h5>
                                        <p class="text-muted mb-2">
                                            <c:choose>
                                                <c:when test="${not empty a.content and a.content.length() > 100}">
                                                    ${fn:substring(a.content, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>${a.content}</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <div class="d-flex flex-wrap gap-2">
                                            <span class="badge rounded-pill badge-soft">
                                                <i class="fa-solid fa-user me-1"></i>${a.publisher}
                                            </span>
                                            <span class="badge rounded-pill badge-soft">
                                                <i class="fa-solid fa-clock me-1"></i>
                                                ${fn:substring(fn:replace(a.publishTime, 'T', ' '), 0, 16)}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="text-md-end">
                                        <a class="btn btn-outline-primary" href="<c:url value='/announcements/${a.id}'/>">
                                            查看详情 <i class="fa-solid fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>

                <c:if test="${empty announcements}">
                    <div class="empty-state" data-animate="fade-up">
                        <i class="fa-solid fa-inbox"></i>
                        <div class="mt-2">暂无公告</div>
                    </div>
                </c:if>

                <div class="text-center mt-4" data-animate="fade-up">
                    <a href="<c:url value='/announcements'/>" class="btn btn-gradient">
                        查看全部公告 <i class="fa-solid fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 系统状态（统一为 data-health 组件，main.js 自动刷新） -->
<section class="py-5">
    <div class="container">
        <div class="text-center mb-4">
            <h2 class="fw-bold">系统状态</h2>
            <div class="text-muted">实时检查服务与数据库连通性</div>
        </div>

        <div class="row">
            <div class="col-lg-7 mx-auto" data-animate="fade-up">
                <div class="card soft p-4 text-center" data-health>
                    <div class="mb-3" data-health-icon>
                        <i class="fa-solid fa-spinner fa-spin fa-2x"></i>
                    </div>
                    <div class="h5 fw-bold mb-1" data-health-title>系统状态检查中...</div>
                    <div class="text-muted mb-3" data-health-desc>正在连接服务与数据库</div>

                    <div class="d-flex justify-content-center gap-2 flex-wrap">
                        <span class="badge rounded-pill badge-soft" data-health-app>应用：--</span>
                        <span class="badge rounded-pill badge-soft" data-health-db>数据库：--</span>
                    </div>

                    <div class="small text-muted mt-3" data-health-time>--</div>

                    <button type="button" class="btn btn-gradient mt-3" data-health-refresh>
                        <i class="fa-solid fa-rotate me-2"></i>刷新
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="common/footer.jsp" %>
