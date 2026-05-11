<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="_active" value="system"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div data-animate="fade-up">
        <h2 style="font-family:var(--font-serif);" class="mb-4"><i class="fa-solid fa-sliders-h me-2"></i>系统配置</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success border-0 mb-4">${successMessage}</div>
        </c:if>

        <div class="card soft">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>配置键</th>
                            <th>配置值</th>
                            <th>分组</th>
                            <th>描述</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${configs}" var="config">
                            <tr>
                                <td><code>${config.configKey}</code></td>
                                <td><input type="text" id="value-${config.id}" value="${config.configValue}" class="form-control form-control-sm"/></td>
                                <td><span class="badge bg-secondary">${config.configGroup}</span></td>
                                <td>${config.description}</td>
                                <td>
                                    <button type="button"
                                            onclick="updateConfig(${config.id}, '${config.configKey}')"
                                            class="btn btn-sm btn-primary">
                                        <i class="fa-solid fa-save"></i> 保存
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
function updateConfig(id, key) {
    const value = document.getElementById('value-' + id).value;
    window.location.href = '<c:url value="/system/config/update"/>?configKey=' + encodeURIComponent(key) + '&configValue=' + encodeURIComponent(value);
}
</script>

<%@ include file="../common/footer.jsp" %>
