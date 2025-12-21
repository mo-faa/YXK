<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>仪表盘 - 村委会管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .stat-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.875rem;
        }
        .stat-change {
            font-size: 0.75rem;
        }
        .chart-container {
            position: relative;
            height: 300px;
        }
        .recent-item {
            border-left: 3px solid transparent;
            transition: all 0.2s;
        }
        .recent-item:hover {
            background-color: #f8f9fa;
            border-left-color: #0d6efd;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 12px;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.15);
            color: white;
        }
        .sidebar .nav-link i {
            width: 24px;
        }
    </style>
</head>
<body>

<div class="d-flex">
    <%-- 侧边栏 --%>
    <nav class="sidebar d-flex flex-column p-3" style="width: 250px;">
        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center mb-4 text-white text-decoration-none">
            <i class="bi bi-building me-2 fs-4"></i>
            <span class="fs-5 fw-semibold">村委会管理系统</span>
        </a>
        <hr class="text-white-50">
        <ul class="nav nav-pills flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/" class="nav-link active">
                    <i class="bi bi-speedometer2 me-2"></i>仪表盘
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/residents" class="nav-link">
                    <i class="bi bi-people me-2"></i>村民管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/announcements" class="nav-link">
                    <i class="bi bi-megaphone me-2"></i>公告管理
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/logs" class="nav-link">
                    <i class="bi bi-journal-text me-2"></i>操作日志
                </a>
            </li>
        </ul>
        <hr class="text-white-50">
        <div class="text-white-50 small">
            <i class="bi bi-clock me-1"></i>
            <span id="currentTime"></span>
        </div>
    </nav>

    <%-- 主内容区 --%>
    <main class="flex-grow-1 p-4 bg-light">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="mb-1">仪表盘</h4>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item active">首页</li>
                    </ol>
                </nav>
            </div>
            <div>
                <button class="btn btn-outline-secondary btn-sm" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise me-1"></i>刷新
                </button>
            </div>
        </div>

        <%-- 统计卡片 --%>
        <div class="row g-4 mb-4">
            <%-- 村民总数 --%>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary me-3">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stat-value text-primary">${stats.residentCount}</div>
                                <div class="stat-label">村民总数</div>
                            </div>
                        </div>
                        <div class="mt-3 pt-3 border-top">
                            <span class="stat-change text-success">
                                <i class="bi bi-arrow-up"></i> ${stats.residentThisMonth}
                            </span>
                            <span class="text-muted small">本月新增</span>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 公告总数 --%>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-success bg-opacity-10 text-success me-3">
                                <i class="bi bi-megaphone-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stat-value text-success">${stats.announcementCount}</div>
                                <div class="stat-label">公告总数</div>
                            </div>
                        </div>
                        <div class="mt-3 pt-3 border-top">
                            <span class="stat-change text-success">
                                <i class="bi bi-arrow-up"></i> ${stats.announcementThisMonth}
                            </span>
                            <span class="text-muted small">本月发布</span>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 今日操作 --%>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning me-3">
                                <i class="bi bi-activity"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stat-value text-warning">${stats.todayOperations}</div>
                                <div class="stat-label">今日操作</div>
                            </div>
                        </div>
                        <div class="mt-3 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/logs" class="text-decoration-none small">
                                查看详情 <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 系统状态 --%>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stat-icon bg-info bg-opacity-10 text-info me-3">
                                <i class="bi bi-hdd-stack-fill"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stat-value text-info">
                                    <i class="bi bi-check-circle-fill fs-3"></i>
                                </div>
                                <div class="stat-label">系统运行正常</div>
                            </div>
                        </div>
                        <div class="mt-3 pt-3 border-top">
                            <span class="text-muted small">
                                <i class="bi bi-clock me-1"></i>运行时间: ${stats.uptime}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 图表和最近数据 --%>
        <div class="row g-4">
            <%-- 趋势图 --%>
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6 class="mb-0">数据趋势（近7天）</h6>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-outline-secondary active" data-chart="week">周</button>
                                <button type="button" class="btn btn-outline-secondary" data-chart="month">月</button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="trendChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 操作类型分布 --%>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0 py-3">
                        <h6 class="mb-0">操作类型分布</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="pieChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 最近数据 --%>
        <div class="row g-4 mt-2">
            <%-- 最近公告 --%>
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><i class="bi bi-megaphone text-success me-2"></i>最近公告</h6>
                        <a href="${pageContext.request.contextPath}/announcements" class="btn btn-sm btn-outline-success">
                            查看全部
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach items="${recentAnnouncements}" var="a" varStatus="st">
                                <c:if test="${st.index < 5}">
                                    <a href="${pageContext.request.contextPath}/announcements/${a.id}/edit" 
                                       class="list-group-item list-group-item-action recent-item py-3">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <c:if test="${a.isTop}">
                                                    <span class="badge bg-danger me-1">置顶</span>
                                                </c:if>
                                                <span class="fw-medium">${a.title}</span>
                                            </div>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${a.publishTime}" pattern="MM-dd HH:mm"/>
                                            </small>
                                        </div>
                                        <small class="text-muted">${a.publisher}</small>
                                    </a>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentAnnouncements}">
                                <div class="list-group-item text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    暂无公告
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 最近操作 --%>
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><i class="bi bi-journal-text text-warning me-2"></i>最近操作</h6>
                        <a href="${pageContext.request.contextPath}/logs" class="btn btn-sm btn-outline-warning">
                            查看全部
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:forEach items="${recentLogs}" var="log" varStatus="st">
                                <c:if test="${st.index < 5}">
                                    <div class="list-group-item recent-item py-3">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <span class="badge 
                                                    <c:choose>
                                                        <c:when test="${log.action == 'CREATE'}">bg-success</c:when>
                                                        <c:when test="${log.action == 'UPDATE'}">bg-primary</c:when>
                                                        <c:when test="${log.action == 'DELETE'}">bg-danger</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>
                                                ">${log.action}</span>
                                                <span class="ms-2">${log.detail}</span>
                                            </div>
                                            <small class="text-muted text-nowrap">
                                                <fmt:formatDate value="${log.createdAt}" pattern="MM-dd HH:mm"/>
                                            </small>
                                        </div>
                                        <small class="text-muted">
                                            <i class="bi bi-person me-1"></i>${log.username}
                                            <i class="bi bi-geo-alt ms-2 me-1"></i>${log.ip}
                                        </small>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty recentLogs}">
                                <div class="list-group-item text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    暂无操作记录
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 页脚 --%>
        <footer class="text-center text-muted mt-5 py-3">
            <small>&copy; 2024 村委会管理系统 | Version 1.0.0</small>
        </footer>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function() {
    'use strict';

    // ==================== 时间显示 ====================
    function updateTime() {
        const now = new Date();
        const options = { 
            year: 'numeric', 
            month: '2-digit', 
            day: '2-digit',
            hour: '2-digit', 
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        };
        document.getElementById('currentTime').textContent = now.toLocaleString('zh-CN', options);
    }
    updateTime();
    setInterval(updateTime, 1000);

    // ==================== 趋势图 ====================
    const trendCtx = document.getElementById('trendChart').getContext('2d');
    
    // 生成最近7天的日期标签
    function getLast7Days() {
        const days = [];
        for (let i = 6; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            days.push((d.getMonth() + 1) + '/' + d.getDate());
        }
        return days;
    }

    const trendChart = new Chart(trendCtx, {
        type: 'line',
        data: {
            labels: getLast7Days(),
            datasets: [
                {
                    label: '新增村民',
                    data: [${stats.residentTrend != null ? stats.residentTrend : '2, 5, 3, 8, 4, 6, 3'}],
                    borderColor: 'rgb(13, 110, 253)',
                    backgroundColor: 'rgba(13, 110, 253, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 6
                },
                {
                    label: '发布公告',
                    data: [${stats.announcementTrend != null ? stats.announcementTrend : '1, 2, 0, 3, 1, 2, 1'}],
                    borderColor: 'rgb(25, 135, 84)',
                    backgroundColor: 'rgba(25, 135, 84, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 6
                },
                {
                    label: '操作次数',
                    data: [${stats.operationTrend != null ? stats.operationTrend : '12, 19, 8, 15, 22, 18, 10'}],
                    borderColor: 'rgb(255, 193, 7)',
                    backgroundColor: 'rgba(255, 193, 7, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 6
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        padding: 20
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: { size: 14 },
                    bodyFont: { size: 13 }
                }
            },
            scales: {
                x: {
                    grid: {
                        display: false
                    }
                },
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 5
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                }
            }
        }
    });

    // ==================== 饼图 ====================
    const pieCtx = document.getElementById('pieChart').getContext('2d');
    
    const pieChart = new Chart(pieCtx, {
        type: 'doughnut',
        data: {
            labels: ['新增', '修改', '删除', '查询', '其他'],
            datasets: [{
                data: [
                    ${stats.createCount != null ? stats.createCount : 35},
                    ${stats.updateCount != null ? stats.updateCount : 25},
                    ${stats.deleteCount != null ? stats.deleteCount : 15},
                    ${stats.queryCount != null ? stats.queryCount : 20},
                    ${stats.otherCount != null ? stats.otherCount : 5}
                ],
                backgroundColor: [
                    'rgba(25, 135, 84, 0.8)',
                    'rgba(13, 110, 253, 0.8)',
                    'rgba(220, 53, 69, 0.8)',
                    'rgba(255, 193, 7, 0.8)',
                    'rgba(108, 117, 125, 0.8)'
                ],
                borderColor: [
                    'rgb(25, 135, 84)',
                    'rgb(13, 110, 253)',
                    'rgb(220, 53, 69)',
                    'rgb(255, 193, 7)',
                    'rgb(108, 117, 125)'
                ],
                borderWidth: 2,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        padding: 15
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    callbacks: {
                        label: function(context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const value = context.raw;
                            const percentage = Math.round((value / total) * 100);
                            return context.label + ': ' + value + ' (' + percentage + '%)';
                        }
                    }
                }
            }
        }
    });

    // ==================== 图表切换（周/月）====================
    document.querySelectorAll('[data-chart]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('[data-chart]').forEach(function(b) {
                b.classList.remove('active');
            });
            this.classList.add('active');
            
            // TODO: 根据选择加载不同时间范围的数据
            // 这里可以发起AJAX请求获取数据
            console.log('切换到:', this.dataset.chart);
        });
    });

})();
</script>
</body>
</html>
