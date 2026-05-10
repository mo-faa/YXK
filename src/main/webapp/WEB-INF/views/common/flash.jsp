<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty flash}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert" data-animate="fade-up">
        <i class="fa-solid fa-circle-check me-2"></i>${flash}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>


