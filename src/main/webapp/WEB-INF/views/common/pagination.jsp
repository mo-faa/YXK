<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:if test="${page.totalPages > 1}">
    <c:set var="current" value="${page.page}"/>
    <c:set var="totalPages" value="${page.totalPages}"/>
    <c:set var="start" value="${current - 2}"/>
    <c:set var="end" value="${current + 2}"/>

    <c:if test="${start < 1}">
        <c:set var="start" value="1"/>
    </c:if>
    <c:if test="${end > totalPages}">
        <c:set var="end" value="${totalPages}"/>
    </c:if>

    <nav class="p-3" aria-label="分页导航">
        <ul class="pagination justify-content-center mb-0">

            <c:if test="${page.hasPrev}">
                <li class="page-item">
                    <a class="page-link" href="?page=${page.page - 1}&size=${page.size}">
                        <i class="fa-solid fa-chevron-left"></i>
                    </a>
                </li>
            </c:if>

            <!-- 首页 -->
            <c:if test="${start > 1}">
                <li class="page-item">
                    <a class="page-link" href="?page=1&size=${page.size}">1</a>
                </li>
                <c:if test="${start > 2}">
                    <li class="page-item disabled"><span class="page-link">…</span></li>
                </c:if>
            </c:if>

            <!-- 窗口 -->
            <c:forEach begin="${start}" end="${end}" var="i">
                <li class="page-item ${page.page == i ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}&size=${page.size}">${i}</a>
                </li>
            </c:forEach>

            <!-- 末页 -->
            <c:if test="${end < totalPages}">
                <c:if test="${end < totalPages - 1}">
                    <li class="page-item disabled"><span class="page-link">…</span></li>
                </c:if>
                <li class="page-item">
                    <a class="page-link" href="?page=${totalPages}&size=${page.size}">
                        ${totalPages}
                    </a>
                </li>
            </c:if>

            <c:if test="${page.hasNext}">
                <li class="page-item">
                    <a class="page-link" href="?page=${page.page + 1}&size=${page.size}">
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>
</c:if>
