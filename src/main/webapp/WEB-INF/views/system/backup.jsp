<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="_active" value="system"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div data-animate="fade-up">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 style="font-family:var(--font-serif);"><i class="fa-solid fa-database me-2"></i>数据备份管理</h2>
            <form method="post" action="<c:url value="/system/backup/create"/>" class="d-inline">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-plus me-2"></i>创建备份
                </button>
            </form>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success border-0 mb-4">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger border-0 mb-4">${errorMessage}</div>
        </c:if>

        <div class="card soft">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>文件名</th>
                            <th>类型</th>
                            <th>状态</th>
                            <th>大小</th>
                            <th>操作人</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${records}" var="record">
                            <tr>
                                <td>${record.id}</td>
                                <td><code>${record.fileName}</code></td>
                                <td>
                                    <span class="badge ${record.type == 'full' ? 'bg-primary' : 'bg-info'}">
                                        ${record.type == 'full' ? '完整备份' : '增量备份'}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${record.status == 'success' ? 'bg-success' : record.status == 'failed' ? 'bg-danger' : 'bg-warning'}">
                                        ${record.status == 'success' ? '成功' : record.status == 'failed' ? '失败' : '进行中'}
                                    </span>
                                </td>
                                <td>${record.fileSizeFormatted}</td>
                                <td>${record.operator}</td>
                                <td>${record.createdAtFormatted}</td>
                                <td>
                                    <form method="post" action="<c:url value="/system/backup/${record.id}/delete"/>" style="display:inline;">
                                        <button type="submit"
                                                class="btn btn-sm btn-outline-danger"
                                                onclick="return confirm('确认删除此备份记录？')"
                                                title="删除">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty records}">
                            <tr>
                                <td colspan="8" class="text-center py-5 text-muted">
                                    <i class="fa-solid fa-inbox fa-3x d-block mb-3 opacity-50"></i>
                                    暂无备份记录
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
