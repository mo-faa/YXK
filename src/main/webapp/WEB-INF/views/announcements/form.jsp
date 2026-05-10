<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode == 'edit' ? '编辑公告' : '发布新公告'} - 网上村委会"/>
<c:set var="activePage" value="announcements"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <!-- Hero区域 -->
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-bullhorn me-2"></i>${mode == 'edit' ? '编辑公告' : '发布新公告'}
                </h1>
                <div class="page-hero-subtitle">
                    ${mode == 'edit' ? '修改公告内容与发布设置' : '填写公告信息并发布'}
                </div>
            </div>
            <div class="text-md-end">
                <a href="<c:url value='/announcements'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <!-- 表单卡片 -->
    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <form id="announcementForm" method="post"
                  action="${pageContext.request.contextPath}/announcements<c:if test='${mode == "edit"}'>/${announcement.id}</c:if>"
                  novalidate>

                <%-- CSRF Token --%>
                <input type="hidden" name="_csrf" value="${_csrf}"/>

                <div class="row">
                    <!-- 左侧主要内容 -->
                    <div class="col-lg-8">
                        <%-- 标题 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="title">
                                <i class="fa-solid fa-heading me-2 text-primary"></i>公告标题 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control form-control-lg" id="title" name="title"
                                   value="${announcement.title}" required maxlength="100"
                                   placeholder="请输入公告标题（简洁明了）">
                            <div class="invalid-feedback">请输入标题（1-100个字符）</div>
                            <div class="form-text d-flex justify-content-between">
                                <span>标题将显示在公告列表中</span>
                                <span class="char-counter"><span id="titleCount">0</span>/100</span>
                            </div>
                        </div>

                        <%-- 内容 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="content">
                                <i class="fa-solid fa-file-lines me-2 text-primary"></i>公告内容 
                                <span class="text-danger">*</span>
                            </label>
                            <textarea class="form-control" id="content" name="content"
                                      rows="12" required maxlength="10000"
                                      placeholder="请输入公告的详细内容...">${announcement.content}</textarea>
                            <div class="invalid-feedback">请输入内容（1-10000个字符）</div>
                            <div class="form-text d-flex justify-content-between">
                                <span>支持换行，内容将原样显示</span>
                                <span class="char-counter"><span id="contentCount">0</span>/10000</span>
                            </div>
                        </div>
                    </div>

                    <!-- 右侧设置面板 -->
                    <div class="col-lg-4">
                        <div class="card bg-light border-0 mb-4">
                            <div class="card-header bg-transparent border-0 pb-0">
                                <h6 class="mb-0 fw-bold">
                                    <i class="fa-solid fa-sliders me-2"></i>发布设置
                                </h6>
                            </div>
                            <div class="card-body">
                                <%-- 发布人 --%>
                                <div class="mb-3">
                                    <label class="form-label fw-bold" for="publisher">
                                        发布人 <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa-solid fa-user"></i>
                                        </span>
                                        <input type="text" class="form-control" id="publisher" name="publisher"
                                               value="${announcement.publisher}" required maxlength="50"
                                               placeholder="发布人姓名">
                                    </div>
                                    <div class="invalid-feedback">请输入发布人（1-50个字符）</div>
                                </div>

                                <%-- 发布时间 --%>
                                <div class="mb-3">
                                    <label class="form-label fw-bold" for="publishTime">发布时间</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fa-solid fa-calendar"></i>
                                        </span>
                                        <input type="datetime-local" class="form-control" id="publishTime" name="publishTime"
                                               value="${not empty announcement.publishTime ? fn:substring(announcement.publishTime, 0, 16) : ''}">
                                    </div>
                                    <div class="form-text">留空则使用当前时间</div>
                                </div>

                                <%-- 状态 --%>
                                <div class="mb-3">
                                    <label class="form-label fw-bold" for="status">发布状态</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="1" ${announcement.status == 1 ? 'selected' : ''}>
                                            ✅ 立即发布
                                        </option>
                                        <option value="0" ${announcement.status == 0 ? 'selected' : ''}>
                                            📝 保存为草稿
                                        </option>
                                    </select>
                                </div>

                                <%-- 置顶 --%>
                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <input type="checkbox" class="form-check-input" id="isTop" name="isTop" value="true"
                                               ${announcement.isTop ? 'checked' : ''}>
                                        <label class="form-check-label fw-bold" for="isTop">
                                            <i class="fa-solid fa-thumbtack me-1"></i>置顶显示
                                        </label>
                                    </div>
                                    <div class="form-text">置顶公告将显示在列表最前面</div>
                                </div>
                            </div>
                        </div>

                        <!-- 操作提示 -->
                        <div class="alert alert-info border-0 shadow-sm">
                            <h6 class="alert-heading mb-2">
                                <i class="fa-solid fa-lightbulb me-2"></i>温馨提示
                            </h6>
                            <ul class="mb-0 ps-3 small">
                                <li>标题应简洁明了，便于村民快速了解内容</li>
                                <li>重要公告建议开启置顶功能</li>
                                <li>草稿状态的公告不会在前台显示</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <%-- 操作按钮 --%>
                <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-gradient btn-lg" id="submitBtn">
                            <span class="spinner-border spinner-border-sm d-none me-2" id="spinner"></span>
                            <i class="fa-solid fa-paper-plane me-2" id="submitIcon"></i>
                            ${mode == 'edit' ? '保存修改' : '确认发布'}
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-lg" id="previewBtn">
                            <i class="fa-solid fa-eye me-2"></i>预览
                        </button>
                    </div>
                    <a href="${pageContext.request.contextPath}/announcements" class="btn btn-light btn-lg">
                        <i class="fa-solid fa-xmark me-2"></i>取消
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 预览模态框 --%>
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 bg-light">
                <h5 class="modal-title">
                    <i class="fa-solid fa-eye me-2"></i>公告预览
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <span class="badge bg-primary me-2" id="previewStatus">已发布</span>
                    <span class="badge bg-warning text-dark d-none" id="previewTop">
                        <i class="fa-solid fa-thumbtack me-1"></i>置顶
                    </span>
                </div>
                <h3 id="previewTitle" class="fw-bold mb-3"></h3>
                <div class="text-muted mb-4 d-flex gap-3 flex-wrap">
                    <span><i class="fa-solid fa-user me-1"></i><span id="previewPublisher"></span></span>
                    <span><i class="fa-solid fa-clock me-1"></i><span id="previewTime"></span></span>
                </div>
                <hr>
                <div id="previewContent" class="article-content" style="white-space: pre-wrap; min-height: 200px;"></div>
            </div>
            <div class="modal-footer border-0 bg-light">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fa-solid fa-xmark me-2"></i>关闭
                </button>
            </div>
        </div>
    </div>
</div>

<style>
.char-counter {
    font-size: 0.8rem;
    color: var(--bs-secondary);
    font-weight: 500;
}
.char-counter.warning { color: var(--bs-warning); }
.char-counter.danger { color: var(--bs-danger); }

.form-control:focus, .form-select:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
}

.form-control.is-valid {
    border-color: var(--bs-success);
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='M2.3 6.73.6 4.53c-.4-1.04.46-1.4 1.1-.8l1.1 1.4 3.4-3.8c.6-.63 1.6-.27 1.2.7l-4 4.6c-.43.5-.8.4-1.1.1z'/%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right calc(0.375em + 0.1875rem) center;
    background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
}

.form-control.is-invalid {
    border-color: var(--bs-danger);
}

textarea.form-control {
    min-height: 250px;
}

[data-theme="dark"] .card.bg-light {
    background-color: rgba(255, 255, 255, 0.05) !important;
}

[data-theme="dark"] .modal-header.bg-light,
[data-theme="dark"] .modal-footer.bg-light {
    background-color: rgba(255, 255, 255, 0.05) !important;
}
</style>

<script>
(function() {
    'use strict';

    const form = document.getElementById('announcementForm');
    const titleInput = document.getElementById('title');
    const contentInput = document.getElementById('content');
    const publisherInput = document.getElementById('publisher');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');
    const submitIcon = document.getElementById('submitIcon');

    // ==================== 字符计数器 ====================
    function updateCounter(input, counterId, max) {
        const counter = document.getElementById(counterId);
        const count = input.value.length;
        counter.textContent = count;

        const wrapper = counter.parentElement;
        wrapper.classList.remove('warning', 'danger');
        if (count > max * 0.9) {
            wrapper.classList.add('danger');
        } else if (count > max * 0.7) {
            wrapper.classList.add('warning');
        }
    }

    titleInput.addEventListener('input', function() {
        updateCounter(this, 'titleCount', 100);
    });

    contentInput.addEventListener('input', function() {
        updateCounter(this, 'contentCount', 10000);
    });

    // 初始化计数
    updateCounter(titleInput, 'titleCount', 100);
    updateCounter(contentInput, 'contentCount', 10000);

    // ==================== 验证状态 ====================
    function setInvalid(input) {
        input.classList.add('is-invalid');
        input.classList.remove('is-valid');
    }

    function setValid(input) {
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
    }

    function clearState(input) {
        input.classList.remove('is-invalid', 'is-valid');
    }

    titleInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0 || val.length > 100) setInvalid(this);
        else setValid(this);
    });

    titleInput.addEventListener('input', function() {
        if (this.value.trim().length > 0) clearState(this);
    });

    contentInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0) setInvalid(this);
        else setValid(this);
    });

    contentInput.addEventListener('input', function() {
        if (this.value.trim().length > 0) clearState(this);
    });

    publisherInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0 || val.length > 50) setInvalid(this);
        else setValid(this);
    });

    publisherInput.addEventListener('input', function() {
        if (this.value.trim().length > 0) clearState(this);
    });

    // ==================== 表单提交 ====================
    form.addEventListener('submit', function(e) {
        let isValid = true;

        if (titleInput.value.trim().length === 0 || titleInput.value.trim().length > 100) {
            setInvalid(titleInput);
            isValid = false;
        }
        if (contentInput.value.trim().length === 0) {
            setInvalid(contentInput);
            isValid = false;
        }
        if (publisherInput.value.trim().length === 0 || publisherInput.value.trim().length > 50) {
            setInvalid(publisherInput);
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            const firstError = form.querySelector('.is-invalid');
            if (firstError) {
                firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstError.focus();
            }
            return false;
        }

        submitBtn.disabled = true;
        spinner.classList.remove('d-none');
        submitIcon.classList.add('d-none');
    });

    // ==================== 预览功能 ====================
    const previewModal = new bootstrap.Modal(document.getElementById('previewModal'));

    document.getElementById('previewBtn').addEventListener('click', function() {
        document.getElementById('previewTitle').textContent = titleInput.value || '（无标题）';
        document.getElementById('previewPublisher').textContent = publisherInput.value || '（未填写）';

        const timeInput = document.getElementById('publishTime');
        const timeVal = timeInput.value
            ? new Date(timeInput.value).toLocaleString('zh-CN')
            : new Date().toLocaleString('zh-CN');
        document.getElementById('previewTime').textContent = timeVal;

        document.getElementById('previewContent').textContent = contentInput.value || '（无内容）';

        // 状态显示
        const statusSelect = document.getElementById('status');
        const previewStatus = document.getElementById('previewStatus');
        if (statusSelect.value === '1') {
            previewStatus.textContent = '已发布';
            previewStatus.className = 'badge bg-success me-2';
        } else {
            previewStatus.textContent = '草稿';
            previewStatus.className = 'badge bg-secondary me-2';
        }

        // 置顶显示
        const isTopCheck = document.getElementById('isTop');
        const previewTop = document.getElementById('previewTop');
        if (isTopCheck.checked) {
            previewTop.classList.remove('d-none');
        } else {
            previewTop.classList.add('d-none');
        }

        previewModal.show();
    });

    // ==================== 离开提示 ====================
    let formChanged = false;

    form.querySelectorAll('input, textarea, select').forEach(function(el) {
        el.addEventListener('change', function() {
            formChanged = true;
        });
    });

    window.addEventListener('beforeunload', function(e) {
        if (formChanged) {
            e.preventDefault();
            e.returnValue = '';
        }
    });

    form.addEventListener('submit', function() {
        formChanged = false;
    });

})();
</script>

<%@ include file="../common/footer.jsp" %>
