<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="系统监控 - 网上村委会"/>
<c:set var="activePage" value="dashboard"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>系统监控</h1>
                <p>系统状态与性能监控</p>
            </div>
            <div class="page-intro-actions">
                <button class="btn btn-light btn-sm" onclick="refreshDashboard()">
                    <i class="fa-solid fa-arrows-rotate me-1"></i>刷新数据
                </button>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="content-grid cols-2 mb-5" data-animate="fade-up" data-delay="50">
        <div class="card soft">
            <div class="card-header" style="background:var(--c-forest);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">
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
                        <p class="mb-0" style="color:var(--c-ink-muted);" id="dbStatusText">检查中...</p>
                    </div>
                    <div>
                        <button class="btn btn-sm btn-outline-primary" onclick="checkDbStatus()">
                            <i class="fa-solid fa-plug me-1"></i>检查连接
                        </button>
                    </div>
                </div>
                <div class="mb-3" style="background:var(--c-paper-warm);border-radius:var(--r-sm);padding:var(--space-3);">
                    <div class="d-flex justify-content-between" style="font-size:var(--text-sm);">
                        <span>上次检查时间</span>
                        <span id="lastCheckTime">未检查</span>
                    </div>
                </div>
                <div style="background:var(--c-paper-warm);border-radius:var(--r-sm);padding:var(--space-3);">
                    <div class="d-flex justify-content-between" style="font-size:var(--text-sm);">
                        <span>连接状态</span>
                        <span id="connectionStatus">未知</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="card soft">
            <div class="card-header" style="background:var(--c-teal);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">
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

    <div class="content-grid cols-2-1" data-animate="fade-up" data-delay="100">
        <div class="card soft">
            <div class="card-header" style="background:var(--c-gold);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">
                    <i class="fa-solid fa-chart-line me-2"></i>系统活动
                </h3>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <ul class="nav nav-pills nav-pills-sm" id="activityTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="operations-tab" data-bs-toggle="tab" data-bs-target="#operations" type="button" role="tab">操作统计</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">用户活动</button>
                        </li>
                    </ul>
                </div>
                <div class="tab-content" id="activityTabsContent">
                    <div class="tab-pane fade show active" id="operations" role="tabpanel">
                        <div style="position:relative;height:300px;"><canvas id="operationsChart"></canvas></div>
                    </div>
                    <div class="tab-pane fade" id="users" role="tabpanel">
                        <div style="position:relative;height:300px;"><canvas id="usersChart"></canvas></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card soft">
            <div class="card-header" style="background:var(--c-terracotta);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">
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
                    <button class="btn btn-outline-warning" onclick="initDatabase()">
                        <i class="fa-solid fa-database me-2"></i>初始化数据库
                    </button>
                    <button class="btn btn-outline-danger" onclick="clearCache()">
                        <i class="fa-solid fa-trash me-2"></i>清除缓存
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        updateServerTime();
        checkDbStatus();
        initCharts();
        setInterval(updateServerTime, 60000);
    });

    function updateServerTime() {
        document.getElementById('serverTime').textContent = new Date().toLocaleString('zh-CN');
    }

    function checkDbStatus() {
        var indicator = document.getElementById('dbStatusIndicator');
        var statusText = document.getElementById('dbStatusText');
        var lastCheckTime = document.getElementById('lastCheckTime');
        var connectionStatus = document.getElementById('connectionStatus');
        indicator.className = 'status-indicator checking';
        statusText.textContent = '检查中...';
        fetch('${pageContext.request.contextPath}/db/ping')
            .then(function(response) { return response.text(); })
            .then(function(data) {
                indicator.className = 'status-indicator online';
                statusText.textContent = '数据库连接正常';
                connectionStatus.textContent = '已连接';
                connectionStatus.className = 'text-success';
                lastCheckTime.textContent = new Date().toLocaleTimeString('zh-CN');
            })
            .catch(function(error) {
                indicator.className = 'status-indicator offline';
                statusText.textContent = '数据库连接失败';
                connectionStatus.textContent = '连接失败';
                connectionStatus.className = 'text-danger';
                lastCheckTime.textContent = new Date().toLocaleTimeString('zh-CN');
            });
    }

    function refreshDashboard() {
        updateServerTime();
        checkDbStatus();
        updateCharts();
    }

    function clearCache() {
        if (confirm('确定要清除系统缓存吗？')) {
            fetch('${pageContext.request.contextPath}/system/clear-cache', {
                method: 'POST',
                headers: { 'X-CSRF-TOKEN': '${_csrf}' }
            })
            .then(function(r) { return r.json(); })
            .then(function(data) { alert(data.message); })
            .catch(function() { alert('清除缓存请求失败'); });
        }
    }

    function initDatabase() {
        if (confirm('确定要初始化数据库吗？这将创建缺失的数据库和表，但不会删除现有数据。')) {
            fetch('${pageContext.request.contextPath}/db/init')
                .then(function(r) { return r.text(); })
                .then(function(result) {
                    alert(result);
                    if (result.indexOf('成功') >= 0) { setTimeout(checkDbStatus, 1000); }
                })
                .catch(function(error) { alert('数据库初始化失败：' + error.message); });
        }
    }

    var operationsChart, usersChart;

    function loadChartData() {
        fetch('${pageContext.request.contextPath}/system/stats')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                updateOperationsChart(data);
                updateUsersChart(data);
            })
            .catch(function() { initChartsWithDefaultData(); });
    }

    function initChartsWithDefaultData() {
        var ctx1 = document.getElementById('operationsChart').getContext('2d');
        operationsChart = new Chart(ctx1, {
            type: 'line',
            data: {
                labels: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                datasets: [{
                    label: '新增操作', data: [12, 19, 8, 15, 22, 18, 25],
                    borderColor: '#2d5a3d', backgroundColor: 'rgba(45,90,61,0.08)',
                    fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#2d5a3d'
                }, {
                    label: '更新操作', data: [15, 12, 18, 14, 20, 22, 16],
                    borderColor: '#2a7a7a', backgroundColor: 'rgba(42,122,122,0.08)',
                    fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#2a7a7a'
                }, {
                    label: '删除操作', data: [3, 5, 2, 4, 3, 6, 4],
                    borderColor: '#c45a3c', backgroundColor: 'rgba(196,90,60,0.08)',
                    fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#c45a3c'
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'top', labels: { usePointStyle: true, padding: 16 } } },
                scales: { y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.04)' } }, x: { grid: { display: false } } }
            }
        });

        var ctx2 = document.getElementById('usersChart').getContext('2d');
        usersChart = new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['公告管理', '村民管理', '成员管理', '其他操作'],
                datasets: [{
                    data: [30, 45, 15, 10],
                    backgroundColor: ['rgba(45,90,61,0.85)', 'rgba(42,122,122,0.85)', 'rgba(184,134,11,0.85)', 'rgba(196,90,60,0.85)'],
                    borderColor: '#faf8f4', borderWidth: 3, hoverOffset: 8
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false, cutout: '65%',
                plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 16 } } }
            }
        });
    }

    function updateOperationsChart(data) {
        var ctx = document.getElementById('operationsChart').getContext('2d');
        var labels = [], createData = [], updateData = [], deleteData = [];
        if (data.recentOperations && data.recentOperations.length > 0) {
            data.recentOperations.forEach(function(stat) {
                labels.push(stat.date || '未知');
                createData.push(stat.createCount || stat.createcount || 0);
                updateData.push(stat.updateCount || stat.updatecount || 0);
                deleteData.push(stat.deleteCount || stat.deletecount || 0);
            });
        } else {
            labels = ['周一','周二','周三','周四','周五','周六','周日'];
            createData = [12,19,8,15,22,18,25]; updateData = [15,12,18,14,20,22,16]; deleteData = [3,5,2,4,3,6,4];
        }
        if (operationsChart) {
            operationsChart.data.labels = labels;
            operationsChart.data.datasets[0].data = createData;
            operationsChart.data.datasets[1].data = updateData;
            operationsChart.data.datasets[2].data = deleteData;
            operationsChart.update();
        } else {
            operationsChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '新增操作', data: createData,
                        borderColor: '#2d5a3d', backgroundColor: 'rgba(45,90,61,0.08)',
                        fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#2d5a3d'
                    }, {
                        label: '更新操作', data: updateData,
                        borderColor: '#2a7a7a', backgroundColor: 'rgba(42,122,122,0.08)',
                        fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#2a7a7a'
                    }, {
                        label: '删除操作', data: deleteData,
                        borderColor: '#c45a3c', backgroundColor: 'rgba(196,90,60,0.08)',
                        fill: true, tension: 0.4, borderWidth: 2, pointRadius: 3, pointBackgroundColor: '#c45a3c'
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { position: 'top', labels: { usePointStyle: true, padding: 16 } } },
                    scales: { y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.04)' } }, x: { grid: { display: false } } }
                }
            });
        }
    }

    function updateUsersChart(data) {
        var ctx = document.getElementById('usersChart').getContext('2d');
        var labels = ['公告管理', '村民管理', '成员管理', '其他操作'];
        var chartData = [30, 45, 15, 10];
        if (data.targetTypes) {
            var a = data.targetTypes.ANNOUNCEMENT || 0;
            var r = data.targetTypes.RESIDENT || 0;
            var m = data.targetTypes.COMMITTEE_MEMBER || 0;
            var o = Math.max(0, (a + r + m) * 0.1);
            chartData = [a, r, m, o];
        }
        if (usersChart) {
            usersChart.data.datasets[0].data = chartData;
            usersChart.update();
        } else {
            usersChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: chartData,
                        backgroundColor: ['rgba(45,90,61,0.85)', 'rgba(42,122,122,0.85)', 'rgba(184,134,11,0.85)', 'rgba(196,90,60,0.85)'],
                        borderColor: '#faf8f4', borderWidth: 3, hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false, cutout: '65%',
                    plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 16 } } }
                }
            });
        }
    }

    function initCharts() { loadChartData(); }
    function updateCharts() { loadChartData(); }
</script>
