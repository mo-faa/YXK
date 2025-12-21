<%-- FILE: src/main/webapp/WEB-INF/views/announcements/form.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mode == 'edit' ? '编辑' : '新增'}公告 - 村委会管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .char-counter {
            font-size: 12px;
            color: #6c757d;
            text-align: right;
        }
        .char-counter.warning { color: #ffc107; }
        .char-counter.danger { color: #dc3545; }
    </style>
</head>
<body>
<div class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">首页</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/announcements">公告管理</a></li>
            <li class="breadcrumb-item active">${mode == 'edit' ? '编辑' : '新增'}</li>
        </ol>
    </nav>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">${mode == 'edit' ? '编辑公告' : '新增公告'}</h5>
        </div>
        <div class="card-body">
            <c:if test="${not empty flash}">
                <div class="alert alert-${flashType != null ? flashType : 'info'} alert-dismissible fade show">
                    ${flash}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form id="announcementForm" method="post"
                  action="${pageContext.request.contextPath}/announcements<c:if test='${mode == "edit"}'>/${announcement.id}</c:if>"
                  novalidate>

                <%-- CSRF Token --%>
                <input type="hidden" name="_csrf" value="${_csrf}"/>

                <%-- 标题 --%>
                <div class="mb-3">
                    <label class="form-label" for="title">标题 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title"
                           value="${announcement.title}" required maxlength="100"
                           placeholder="请输入公告标题">
                    <div class="invalid-feedback">请输入标题（1-100个字符）</div>
                    <div class="char-counter"><span id="titleCount">0</span>/100</div>
                </div>

                <%-- 内容 --%>
                <div class="mb-3">
                    <label class="form-label" for="content">内容 <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="content" name="content"
                              rows="10" required maxlength="10000"
                              placeholder="请输入公告内容">${announcement.content}</textarea>
                    <div class="invalid-feedback">请输入内容（1-10000个字符）</div>
                    <div class="char-counter"><span id="contentCount">0</span>/10000</div>
                </div>

                <%-- 发布人 --%>
                <div class="mb-3">
                    <label class="form-label" for="publisher">发布人 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="publisher" name="publisher"
                           value="${announcement.publisher}" required maxlength="50"
                           placeholder="请输入发布人姓名">
                    <div class="invalid-feedback">请输入发布人（1-50个字符）</div>
                </div>

                <div class="row">
                    <%-- 发布时间 --%>
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="publishTime">发布时间</label>
                        <%--
                          ✅ 修复点：
                          - announcement.publishTime 是 LocalDateTime
                          - datetime-local 需要格式 yyyy-MM-ddTHH:mm
                          - LocalDateTime.toString() 为 yyyy-MM-ddTHH:mm:ss...
                          - 截取前16位即可
                        --%>
                        <input type="datetime-local" class="form-control" id="publishTime" name="publishTime"
                               value="${not empty announcement.publishTime ? fn:substring(announcement.publishTime, 0, 16) : ''}">
                        <div class="form-text">留空则使用当前时间</div>
                    </div>

                    <%-- 状态 --%>
                    <div class="col-md-3 mb-3">
                        <label class="form-label" for="status">状态</label>
                        <select class="form-select" id="status" name="status">
                            <option value="1" ${announcement.status == 1 ? 'selected' : ''}>发布</option>
                            <option value="0" ${announcement.status == 0 ? 'selected' : ''}>草稿</option>
                        </select>
                    </div>

                    <%-- 置顶 --%>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="form-check mt-2">
                            <input type="checkbox" class="form-check-input" id="isTop" name="isTop" value="true"
                                   ${announcement.isTop ? 'checked' : ''}>
                            <label class="form-check-label" for="isTop">置顶显示</label>
                        </div>
                    </div>
                </div>

                <%-- 按钮 --%>
                <div class="d-flex gap-2 mt-4">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <span class="spinner-border spinner-border-sm d-none" id="spinner"></span>
                        ${mode == 'edit' ? '保存修改' : '确认发布'}
                    </button>
                    <button type="button" class="btn btn-outline-secondary" id="previewBtn">
                        预览
                    </button>
                    <a href="${pageContext.request.contextPath}/announcements" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 预览模态框 --%>
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">公告预览</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h4 id="previewTitle" class="mb-3"></h4>
                <div class="text-muted mb-3">
                    <small>
                        <span id="previewPublisher"></span> |
                        <span id="previewTime"></span>
                    </small>
                </div>
                <hr>
                <div id="previewContent" style="white-space: pre-wrap;"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    'use strict';

    const form = document.getElementById('announcementForm');
    const titleInput = document.getElementById('title');
    const contentInput = document.getElementById('content');
    const publisherInput = document.getElementById('publisher');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');

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

    updateCounter(titleInput, 'titleCount', 100);
    updateCounter(contentInput, 'contentCount', 10000);

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
    });

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
        previewModal.show();
    });

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
</body>
</html>
