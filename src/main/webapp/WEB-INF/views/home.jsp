<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>网上村委会业务办理系统</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Animate.css -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --info-color: #17a2b8;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            padding-top: 76px;
        }

        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 120px 0 80px;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://picsum.photos/seed/village/1920/800.jpg') center/cover;
            opacity: 0.1;
            z-index: -1;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero-subtitle {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .service-card {
            transition: all 0.3s ease;
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            height: 100%;
        }
        
        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }
        
        .service-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .announcement-card {
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s ease;
        }
        
        .announcement-card:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        .nav-link {
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .nav-link:hover {
            color: var(--primary-color) !important;
        }
        
        .btn-gradient {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-gradient:hover {
            background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            color: white;
        }
        
        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 3rem;
            text-align: center;
            position: relative;
        }
        
        .section-title::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }
        
        .footer {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 3rem 0 1rem;
        }
        
        .table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .table thead th {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
        }
        
        .table tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem !important;
            }
            
            .hero-subtitle {
                font-size: 1.2rem !important;
            }
            
            .section-title {
                font-size: 2rem !important;
            }
            
            .stats-number {
                font-size: 2rem !important;
            }
        }
        
        .animate__animated {
            animation-duration: 0.8s;
            animation-fill-mode: both;
        }
        
        .animate__fadeInUp {
            animation-name: fadeInUp;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translate3d(0, 30px, 0);
            }
            to {
                opacity: 1;
                transform: translate3d(0, 0, 0);
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/'/>">
                <i class="fas fa-home me-2"></i>网上村委会
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/'/>">
                            <i class="fas fa-home me-1"></i>首页
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/announcements'/>">
                            <i class="fas fa-bullhorn me-1"></i>公告
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/residents'/>">
                            <i class="fas fa-users me-1"></i>村民管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/api/health'/>" target="_blank">
                            <i class="fas fa-heartbeat me-1"></i>系统状态
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <div class="animate__animated animate__fadeInUp">
                <h1 class="hero-title">网上村委会业务办理系统</h1>
                <p class="hero-subtitle">数字化服务 • 智慧化治理 • 便民利民</p>
                <div class="mt-4">
                    <a href="<c:url value='/residents'/>" class="btn btn-light btn-lg me-3">
                        <i class="fas fa-users me-2"></i>村民管理
                    </a>
                    <a href="<c:url value='/announcements'/>" class="btn btn-outline-light btn-lg">
                        <i class="fas fa-bullhorn me-2"></i>查看公告
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- 统计数据 -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="stats-card text-center animate__animated animate__fadeInUp">
                        <div class="stats-number">1,284</div>
                        <p class="text-muted mb-0">注册村民</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card text-center animate__animated animate__fadeInUp">
                        <div class="stats-number">48</div>
                        <p class="text-muted mb-0">公告数量</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card text-center animate__animated animate__fadeInUp">
                        <div class="stats-number">326</div>
                        <p class="text-muted mb-0">本月办理</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card text-center animate__animated animate__fadeInUp">
                        <div class="stats-number">98%</div>
                        <p class="text-muted mb-0">满意度</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 服务项目 -->
    <section class="py-5">
        <div class="container">
            <h2 class="section-title">服务项目</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card service-card animate__animated animate__fadeInUp">
                        <div class="card-body text-center p-4">
                            <div class="service-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <h5 class="card-title">证明开具</h5>
                            <p class="card-text">在线申请各类证明文件，包括居住证明、收入证明等</p>
                            <a href="#" class="btn btn-gradient">立即办理</a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card service-card animate__animated animate__fadeInUp">
                        <div class="card-body text-center p-4">
                            <div class="service-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h5 class="card-title">户籍管理</h5>
                            <p class="card-text">办理户籍相关业务，包括出生登记、户口迁移等</p>
                            <a href="<c:url value='/residents'/>" class="btn btn-gradient">立即办理</a>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card service-card animate__animated animate__fadeInUp">
                        <div class="card-body text-center p-4">
                            <div class="service-icon">
                                <i class="fas fa-hand-holding-usd"></i>
                            </div>
                            <h5 class="card-title">补贴申请</h5>
                            <p class="card-text">在线申请各类政府补贴，包括农业补贴、社保补贴等</p>
                            <a href="#" class="btn btn-gradient">立即办理</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 最新公告 -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="section-title">最新公告</h2>
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <c:if test="${not empty announcements}">
                        <c:forEach var="announcement" items="${announcements}" end="4">
                            <div class="card announcement-card mb-3 animate__animated animate__fadeInUp">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h5 class="card-title mb-2">${announcement.title}</h5>
                                            <p class="card-text text-muted mb-2">
                                                <c:choose>
                                                    <c:when test="${announcement.content.length() > 100}">
                                                        ${announcement.content.substring(0, 100)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${announcement.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            <small class="text-muted">
                                                <i class="fas fa-user me-1"></i> ${announcement.publisher}
                                                <i class="fas fa-calendar ms-3 me-1"></i> 
                                                <fmt:formatDate value="${announcement.publishTime}" pattern="yyyy-MM-dd HH:mm"/>
                                            </small>
                                        </div>
                                        <div class="ms-3">
                                            <a href="<c:url value='/announcements/${announcement.id}'/>" class="btn btn-sm btn-outline-primary">
                                                查看详情
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                    
                    <div class="text-center mt-4">
                        <a href="<c:url value='/announcements'/>" class="btn btn-gradient">
                            查看全部公告 <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 系统状态 -->
    <section class="py-5">
        <div class="container">
            <h2 class="section-title">系统状态</h2>
            <div class="row">
                <div class="col-md-6 mx-auto">
                    <div class="card">
                        <div class="card-body text-center">
                            <div id="system-status" class="mb-3">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                            <p class="text-muted">正在检查系统状态...</p>
                            <button onclick="checkSystemStatus()" class="btn btn-gradient">
                                <i class="fas fa-sync-alt me-2"></i>刷新状态
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <h5 class="mb-3">
                        <i class="fas fa-landmark me-2"></i>网上村委会
                    </h5>
                    <p class="text-light">为村民提供便捷、高效的在线服务，推进乡村治理现代化。</p>
                    <div class="mt-3">
                        <a href="#" class="text-light me-3"><i class="fab fa-weixin fa-lg"></i></a>
                        <a href="#" class="text-light me-3"><i class="fab fa-weibo fa-lg"></i></a>
                        <a href="#" class="text-light"><i class="fab fa-qq fa-lg"></i></a>
                    </div>
                </div>
                <div class="col-lg-4 mb-4">
                    <h5 class="mb-3">快速链接</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="<c:url value='/'/>" class="text-light text-decoration-none">首页</a></li>
                        <li class="mb-2"><a href="<c:url value='/announcements'/>" class="text-light text-decoration-none">公告通知</a></li>
                        <li class="mb-2"><a href="<c:url value='/residents'/>" class="text-light text-decoration-none">村民管理</a></li>
                        <li class="mb-2"><a href="<c:url value='/api/health'/>" class="text-light text-decoration-none">系统状态</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 mb-4">
                    <h5 class="mb-3">联系我们</h5>
                    <p class="text-light mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>村委会办公室
                    </p>
                    <p class="text-light mb-2">
                        <i class="fas fa-phone me-2"></i>123-456-7890
                    </p>
                    <p class="text-light mb-2">
                        <i class="fas fa-envelope me-2"></i>info@village.gov.cn
                    </p>
                </div>
            </div>
            <hr class="bg-light">
            <div class="text-center">
                <p class="mb-0">&copy; 2025 网上村委会业务办理系统. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    // 检查系统状态
    function checkSystemStatus() {
        const statusDiv = document.getElementById('system-status');
        statusDiv.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>';
        
        fetch('/YXK/api/health')
            .then(response => response.json())
            .then(data => {
                const dbStatus = data.db === 'UP' ? 
                    '<span class="badge bg-success">数据库正常</span>' : 
                    '<span class="badge bg-danger">数据库异常</span>';
                
                statusDiv.innerHTML = 
                    '<div class="alert ' + (data.db === 'UP' ? 'alert-success' : 'alert-danger') + '">' +
                    '<h5 class="alert-heading">' +
                    '<i class="fas fa-server me-2"></i>系统状态' +
                    '</h5>' +
                    '<p class="mb-2">' +
                    '<strong>应用状态：</strong> ' +
                    '<span class="badge bg-success">运行正常</span>' +
                    '</p>' +
                    '<p class="mb-0">' +
                    '<strong>数据库状态：</strong> ' + dbStatus +
                    '</p>' +
                    '<hr>' +
                    '<small class="text-muted">检查时间：' + new Date().toLocaleString() + '</small>' +
                    '</div>';
            })
            .catch(error => {
                statusDiv.innerHTML = 
                    '<div class="alert alert-danger">' +
                    '<h5 class="alert-heading">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>检查失败' +
                    '</h5>' +
                    '<p class="mb-0">无法获取系统状态信息</p>' +
                    '</div>';
            });
    }

    // 页面加载时自动检查状态
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(checkSystemStatus, 1000);
        
        // 添加滚动动画
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate__fadeInUp');
                }
            });
        }, observerOptions);
        
        document.querySelectorAll('.service-card, .stats-card, .announcement-card').forEach(el => {
            observer.observe(el);
        });
    });
    </script>
</body>
</html>
