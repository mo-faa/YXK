<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>村民信息管理 - 网上村委会业务办理系统</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            padding-top: 76px;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
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
        
        .footer {
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: white;
            padding: 3rem 0 1rem;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            animation: slideIn 0.5s ease;
        }
        
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 3px;
            border: none;
            color: var(--primary-color);
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        }
        
        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
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
                        <a class="nav-link active" href="<c:url value='/residents'/>">
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

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>
                        <i class="fas fa-users me-2"></i>村民信息管理
                    </h2>
                    <div>
                        <a href="<c:url value='/residents/new'/>" class="btn btn-gradient me-2">
                            <i class="fas fa-user-plus me-2"></i>新增村民
                        </a>
                        <c:url var="exportUrl" value="/residents/export.csv">
                            <c:param name="q" value="${q}" />
                        </c:url>
                        <a href="${exportUrl}" class="btn btn-outline-success">
                            <i class="fas fa-download me-2"></i>导出CSV
                        </a>
                    </div>
                </div>
                
                <c:if test="${not empty flash}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${flash}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- 搜索表单 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="<c:url value='/residents'/>">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">搜索</label>
                                    <input type="text" name="q" value="${q}" 
                                           class="form-control" 
                                           placeholder="姓名/身份证/电话/地址">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">每页条数</label>
                                    <input type="number" name="size" value="${page.size}" 
                                           min="1" max="100" class="form-control">
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-search me-2"></i>查询
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- 分页信息 -->
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    共 <strong>${page.total}</strong> 条记录，
                    当前第 <strong>${page.page}</strong> 页，
                    共 <strong>${page.totalPages}</strong> 页
                </div>
                
                <!-- 数据表格 -->
                <div class="card">
                    <div class="card-body">
                        <c:if test="${not empty page.items}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>姓名</th>
                                            <th>身份证号</th>
                                            <th>电话</th>
                                            <th>地址</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="r" items="${page.items}">
                                            <tr>
                                                <td>${r.id}</td>
                                                <td><strong>${r.name}</strong></td>
                                                <td>${r.idCard}</td>
                                                <td>${r.phone}</td>
                                                <td>${r.address}</td>
                                                <td>
                                                    <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/residents/${r.id}/edit'/>" 
                                                       class="btn btn-sm btn-outline-primary me-2">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <form action="<c:url value='/residents/${r.id}/delete'/>" 
                                                          method="post" style="display:inline;"
                                                          onsubmit="return confirm('确定要删除村民 ${r.name} 吗？');">
                                                        <input type="hidden" name="_csrf" value="${_csrf}"/>
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- 分页导航 -->
                            <c:if test="${page.totalPages > 1}">
                                <nav aria-label="村民分页">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${page.hasPrev}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${page.page - 1}&size=${page.size}&q=${q}">
                                                    <i class="fas fa-chevron-left"></i> 上一页
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${page.totalPages}" var="i">
                                            <li class="page-item ${page.page == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${page.size}&q=${q}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <c:if test="${page.hasNext}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${page.page + 1}&size=${page.size}&q=${q}">
                                                    下一页 <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:if>
                        
                        <c:if test="${empty page.items}">
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <p class="text-muted">暂无村民数据</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
        <div class="container">
            <div class="text-center">
                <p class="mb-0">&copy; 2025 网上村委会业务办理系统. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
