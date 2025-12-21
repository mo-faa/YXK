<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="<c:url value='/admin/dashboard'/>">
                    <i class="fas fa-tachometer-alt me-2"></i>控制台
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value='/residents'/>">
                    <i class="fas fa-users me-2"></i>村民管理
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<c:url value='/announcements'/>">
                    <i class="fas fa-bullhorn me-2"></i>公告管理
                </a>
            </li>
        </ul>
    </div>
</div>
