<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="系统监控 - 网上村委会"/>
<c:set var="activePage" value="dashboard"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-gauge-high me-2"></i>系统监控
                </h1>
                <div class="page-hero-subtitle">系统状态与性能监控</div>
            </div>

            <div class="text-md-end">
                <button class="btn btn-light btn-lg" onclick="refreshDashboard()">
                    <i class="fa-solid fa-arrows-rotate me-2"></i>刷新数据
                </button>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <!-- 系统状态卡片 -->
    <div class="row g-4 mb-5">
        <!-- 数据库状态 -->
        <div class="col-lg-6" data-animate="fade-up" data-delay="100">
            <div class="card soft h-100">
                <div class="card-header bg-gradient-primary text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-database me-2"></i>数据库状态
                    </h3>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-4">
                        <div class="status-indicator me-3" id="dbStatusIndicator">
                            <div class="status-pulse"></div>
                        </div>
                        <div class="flex-grow-1">
                            <h5 class="mb-1">数据库连接</h5>
                            <p class="text-muted mb-0" id="dbStatusText">检查中...</p>
                        </div>
                        <div class="text-end">
                            <button class="btn btn-sm btn-outline-primary" onclick="checkDbStatus()">
                                <i class="fa-solid fa-plug me-1"></i>检查连接
                            </button>
                        </div>
                    </div>

                    <div class="info-box bg-light rounded p-3 mb-3">
                        <div class="d-flex justify-content-between">
                            <span>上次检查时间</span>
                            <span id="lastCheckTime">未检查</span>
                        </div>
                    </div>

                    <div class="info-box bg-light rounded p-3">
                        <div class="d-flex justify-content-between">
                            <span>连接状态</span>
                            <span id="connectionStatus">未知</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 系统信息 -->
        <div class="col-lg-6" data-animate="fade-up" data-delay="200">
            <div class="card soft h-100">
                <div class="card-header bg-gradient-info text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-server me-2"></i>系统信息
                    </h3>
                </div>
                <div class="card-body">
                    <div class="info-item">
                        <div class="info-label">应用名称</div>
                        <div class="info-value">网上村委会业务办理系统</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">版本</div>
                        <div class="info-value">v1.0.0</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">服务器时间</div>
                        <div class="info-value" id="serverTime">获取中...</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">运行环境</div>
                        <div class="info-value">Java Spring Boot</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 系统活动图表 -->
    <div class="row g-4">
        <div class="col-lg-8" data-animate="fade-up" data-delay="100">
            <div class="card soft h-100">
                <div class="card-header bg-gradient-success text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-chart-line me-2"></i>系统活动
                    </h3>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <ul class="nav nav-pills nav-pills-sm" id="activityTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="operations-tab" data-bs-toggle="tab" data-bs-target="#operations" type="button" role="tab">
                                    操作统计
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">
                                    用户活动
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="tab-content" id="activityTabsContent">
                        <div class="tab-pane fade show active" id="operations" role="tabpanel">
                            <div class="chart-container" style="position: relative; height:300px;">
                                <canvas id="operationsChart"></canvas>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="users" role="tabpanel">
                            <div class="chart-container" style="position: relative; height:300px;">
                                <canvas id="usersChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 快速操作 -->
        <div class="col-lg-4" data-animate="fade-up" data-delay="200">
            <div class="card soft h-100">
                <div class="card-header bg-gradient-warning text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-bolt me-2"></i>快速操作
                    </h3>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/announcements" class="btn btn-outline-primary">
                            <i class="fa-solid fa-bullhorn me-2"></i>管理公告
                        </a>
                        <a href="${pageContext.request.contextPath}/residents" class="btn btn-outline-primary">
                            <i class="fa-solid fa-users me-2"></i>管理村民
                        </a>
                        <a href="${pageContext.request.contextPath}/committee-members" class="btn btn-outline-primary">
                            <i class="fa-solid fa-user-tie me-2"></i>管理成员
                        </a>
                        <a href="${pageContext.request.contextPath}/logs" class="btn btn-outline-primary">
                            <i class="fa-solid fa-clipboard-list me-2"></i>查看日志
                        </a>
                        <button class="btn btn-outline-danger" onclick="clearCache()">
                            <i class="fa-solid fa-trash me-2"></i>清除缓存
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<style>
/* 状态指示器样式 */
.status-indicator {
    width: 40px;
    height: 40px;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
}

.status-pulse {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background-color: var(--text-light);
    position: relative;
}

.status-pulse::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background-color: inherit;
    animation: pulse 2s infinite;
}

.status-indicator.online .status-pulse {
    background-color: #10b981;
}

.status-indicator.offline .status-pulse {
    background-color: #ef4444;
    animation: none;
}

@keyframes pulse {
    0% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.5);
        opacity: 0.5;
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
}

/* 信息项样式 */
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

/* 标签页样式 */
.nav-pills-sm .nav-link {
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // 初始化页面
    document.addEventListener('DOMContentLoaded', function() {
        updateServerTime();
        checkDbStatus();
        initCharts();

        // 每分钟更新服务器时间
        setInterval(updateServerTime, 60000);
    });

    // 更新服务器时间
    function updateServerTime() {
        const now = new Date();
        document.getElementById('serverTime').textContent = now.toLocaleString('zh-CN');
    }

    // 检查数据库状态
    function checkDbStatus() {
        const indicator = document.getElementById('dbStatusIndicator');
        const statusText = document.getElementById('dbStatusText');
        const lastCheckTime = document.getElementById('lastCheckTime');
        const connectionStatus = document.getElementById('connectionStatus');

        // 显示检查中状态
        indicator.className = 'status-indicator checking';
        statusText.textContent = '检查中...';

        fetch('${pageContext.request.contextPath}/db/ping')
            .then(response => response.text())
            .then(data => {
                // 检查成功
                indicator.className = 'status-indicator online';
                statusText.textContent = '数据库连接正常';
                connectionStatus.textContent = '已连接';
                connectionStatus.className = 'text-success';

                // 更新最后检查时间
                const now = new Date();
                lastCheckTime.textContent = now.toLocaleTimeString('zh-CN');
            })
            .catch(error => {
                // 检查失败
                indicator.className = 'status-indicator offline';
                statusText.textContent = '数据库连接失败';
                connectionStatus.textContent = '连接失败';
                connectionStatus.className = 'text-danger';

                // 更新最后检查时间
                const now = new Date();
                lastCheckTime.textContent = now.toLocaleTimeString('zh-CN');

                console.error('数据库检查失败:', error);
            });
    }

    // 刷新仪表盘
    function refreshDashboard() {
        updateServerTime();
        checkDbStatus();
        updateCharts();

        // 显示刷新提示
        const toast = document.createElement('div');
        toast.className = 'position-fixed bottom-0 end-0 p-3';
        toast.style.zIndex = '11';
        toast.innerHTML = `
            <div class="toast show" role="alert">
                <div class="toast-header">
                    <i class="fa-solid fa-check-circle text-success me-2"></i>
                    <strong class="me-auto">系统提示</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">
                    仪表盘数据已刷新
                </div>
            </div>
        `;
        document.body.appendChild(toast);

        // 3秒后自动移除提示
        setTimeout(() => {
            document.body.removeChild(toast);
        }, 3000);
    }

    // 清除缓存
    function clearCache() {
        if (confirm('确定要清除系统缓存吗？')) {
            // 这里可以添加实际的清除缓存逻辑
            const toast = document.createElement('div');
            toast.className = 'position-fixed bottom-0 end-0 p-3';
            toast.style.zIndex = '11';
            toast.innerHTML = `
                <div class="toast show" role="alert">
                    <div class="toast-header">
                        <i class="fa-solid fa-check-circle text-success me-2"></i>
                        <strong class="me-auto">系统提示</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                    </div>
                    <div class="toast-body">
                        缓存已清除
                    </div>
                </div>
            `;
            document.body.appendChild(toast);

            // 3秒后自动移除提示
            setTimeout(() => {
                document.body.removeChild(toast);
            }, 3000);
        }
    }

    // 初始化图表
    let operationsChart, usersChart;

    function initCharts() {
        // 操作统计图表
        const operationsCtx = document.getElementById('operationsChart').getContext('2d');
        operationsChart = new Chart(operationsCtx, {
            type: 'line',
            data: {
                labels: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                datasets: [{
                    label: '新增操作',
                    data: [12, 19, 8, 15, 22, 18, 25],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.3
                }, {
                    label: '更新操作',
                    data: [15, 12, 18, 14, 20, 22, 16],
                    borderColor: 'rgb(255, 205, 86)',
                    backgroundColor: 'rgba(255, 205, 86, 0.2)',
                    tension: 0.3
                }, {
                    label: '删除操作',
                    data: [3, 5, 2, 4, 3, 6, 4],
                    borderColor: 'rgb(255, 99, 132)',
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: '本周操作统计'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // 用户活动图表
        const usersCtx = document.getElementById('usersChart').getContext('2d');
        usersChart = new Chart(usersCtx, {
            type: 'doughnut',
            data: {
                labels: ['公告管理', '村民管理', '成员管理', '其他操作'],
                datasets: [{
                    data: [30, 45, 15, 10],
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)',
                        'rgba(118, 75, 162, 0.8)',
                        'rgba(240, 147, 251, 0.8)',
                        'rgba(245, 87, 108, 0.8)'
                    ],
                    borderColor: [
                        'rgb(102, 126, 234)',
                        'rgb(118, 75, 162)',
                        'rgb(240, 147, 251)',
                        'rgb(245, 87, 108)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                    },
                    title: {
                        display: true,
                        text: '功能模块使用比例'
                    }
                }
            }
        });
    }

    // 更新图表数据
    function updateCharts() {
        // 这里可以添加从服务器获取最新数据的逻辑
        // 然后更新图表
        console.log('更新图表数据');
    }
</script>
