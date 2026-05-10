<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode == 'edit' ? '编辑公告' : '发布新公告'} - 网上村委会"/>
<c:set var="activePage" value="announcements"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>${mode == 'edit' ? '编辑公告' : '发布新公告'}</h1>
                <p>${mode == 'edit' ? '修改公告内容与发布设置' : '填写公告信息并发布'}</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/announcements'/>" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="card soft" data-animate="fade-up">
        <div class="card-body p-4 p-md-5">
            <form id="announcementForm" method="post"
                  action="${pageContext.request.contextPath}/announcements<c:if test='${mode == "edit"}'>/${announcement.id}</c:if>"
                  novalidate>

                <input type="hidden" name="_csrf" value="${_csrf}"/>

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="mb-4">
                            <label class="form-label" for="title">公告标题 <span style="color:var(--c-err);">*</span></label>
                            <input type="text" class="form-control form-control-lg" id="title" name="title"
                                   value="${announcement.title}" required maxlength="100"
                                   placeholder="请输入公告标题（简洁明了）">
                            <div class="invalid-feedback">请输入标题（1-100个字符）</div>
                            <div class="d-flex justify-content-between" style="font-size:var(--text-xs);">
                                <span style="color:var(--c-ink-faint);">标题将显示在公告列表中</span>
                                <span class="char-counter"><span id="titleCount">0</span>/100</span>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label" for="content">公告内容 <span style="color:var(--c-err);">*</span></label>
                            <textarea class="form-control" id="content" name="content"
                                      rows="12" required maxlength="10000"
                                      placeholder="请输入公告的详细内容...">${announcement.content}</textarea>
                            <div class="invalid-feedback">请输入内容（1-10000个字符）</div>
                            <div class="d-flex justify-content-between" style="font-size:var(--text-xs);">
                                <span style="color:var(--c-ink-faint);">支持换行，内容将原样显示</span>
                                <span class="char-counter"><span id="contentCount">0</span>/10000</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="card soft mb-4">
                            <div class="card-header pb-0" style="border-bottom:1px solid var(--c-stroke-light);">
                                <h6 class="mb-0 fw-bold" style="font-family:var(--font-serif);">发布设置</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label" for="publisher">发布人 <span style="color:var(--c-err);">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                        <input type="text" class="form-control" id="publisher" name="publisher"
                                               value="${announcement.publisher}" required maxlength="50"
                                               placeholder="发布人姓名">
                                    </div>
                                    <div class="invalid-feedback">请输入发布人（1-50个字符）</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="publishTime">发布时间</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-calendar"></i></span>
                                        <input type="datetime-local" class="form-control" id="publishTime" name="publishTime"
                                               value="${not empty announcement.publishTime ? fn:substring(announcement.publishTime, 0, 16) : ''}">
                                    </div>
                                    <div style="font-size:var(--text-xs);color:var(--c-ink-faint);">留空则使用当前时间</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="status">发布状态</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="1" ${announcement.status == 1 ? 'selected' : ''}>立即发布</option>
                                        <option value="0" ${announcement.status == 0 ? 'selected' : ''}>保存为草稿</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <div class="form-check form-switch">
                                        <input type="checkbox" class="form-check-input" id="isTop" name="isTop" value="true"
                                               ${announcement.isTop ? 'checked' : ''}>
                                        <label class="form-check-label fw-bold" for="isTop">
                                            <i class="fa-solid fa-thumbtack me-1"></i>置顶显示
                                        </label>
                                    </div>
                                    <div style="font-size:var(--text-xs);color:var(--c-ink-faint);">置顶公告将显示在列表最前面</div>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info border-0">
                            <h6 class="alert-heading mb-2" style="font-size:var(--text-sm);">
                                <i class="fa-solid fa-lightbulb me-2"></i>温馨提示
                            </h6>
                            <ul class="mb-0 ps-3" style="font-size:var(--text-sm);">
                                <li>标题应简洁明了，便于村民快速了解内容</li>
                                <li>重要公告建议开启置顶功能</li>
                                <li>草稿状态的公告不会在前台显示</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <hr style="border-color:var(--c-stroke-light);" class="my-4">

                <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                            <span class="spinner-border spinner-border-sm d-none me-2" id="spinner"></span>
                            <i class="fa-solid fa-paper-plane me-2" id="submitIcon"></i>
                            ${mode == 'edit' ? '保存修改' : '确认发布'}
                        </button>
                        <button type="button" class="btn btn-outline-secondary btn-lg" id="previewBtn">
                            <i class="fa-solid fa-eye me-1"></i>预览
                        </button>
                    </div>
                    <a href="${pageContext.request.contextPath}/announcements" class="btn btn-light btn-lg">
                        取消
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0" style="background:var(--c-paper-warm);">
                <h5 class="modal-title"><i class="fa-solid fa-eye me-2"></i>公告预览</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <span class="badge bg-success me-2" id="previewStatus">已发布</span>
                    <span class="badge bg-warning text-dark d-none" id="previewTop">
                        <i class="fa-solid fa-thumbtack me-1"></i>置顶
                    </span>
                </div>
                <h3 id="previewTitle" class="fw-bold mb-3" style="font-family:var(--font-serif);"></h3>
                <div style="color:var(--c-ink-muted);margin-bottom:var(--space-4);" class="d-flex gap-3 flex-wrap; font-size:var(--text-sm);">
                    <span><i class="fa-solid fa-user me-1"></i><span id="previewPublisher"></span></span>
                    <span><i class="fa-solid fa-clock me-1"></i><span id="previewTime"></span></span>
                </div>
                <hr style="border-color:var(--c-stroke-light);">
                <div id="previewContent" class="article-content" style="white-space: pre-wrap; min-height: 200px;"></div>
            </div>
            <div class="modal-footer border-0" style="background:var(--c-paper-warm);">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<style>
.char-counter { font-size: var(--text-xs); color: var(--c-ink-faint); font-weight: 500; }
.char-counter.warning { color: var(--c-warn); }
.char-counter.danger { color: var(--c-err); }

.form-control:focus, .form-select:focus {
    border-color: var(--c-forest);
    box-shadow: 0 0 0 2px rgba(45, 90, 61, 0.1);
}

textarea.form-control { min-height: 250px; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('announcementForm');
    if (!form) return;

    const titleInput = document.getElementById('title');
    const contentInput = document.getElementById('content');
    const publisherInput = document.getElementById('publisher');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');
    const submitIcon = document.getElementById('submitIcon');

    function updateCounter(input, counterId, max) {
        const counter = document.getElementById(counterId);
        if (!counter) return;
        const count = input.value.length;
        counter.textContent = count;
        const wrapper = counter.parentElement;
        wrapper.classList.remove('warning', 'danger');
        if (count > max * 0.9) wrapper.classList.add('danger');
        else if (count > max * 0.7) wrapper.classList.add('warning');
    }

    titleInput.addEventListener('input', function() { updateCounter(this, 'titleCount', 100); });
    contentInput.addEventListener('input', function() { updateCounter(this, 'contentCount', 10000); });
    updateCounter(titleInput, 'titleCount', 100);
    updateCounter(contentInput, 'contentCount', 10000);

    function setInvalid(input) { input.classList.add('is-invalid'); input.classList.remove('is-valid'); }
    function setValid(input) { input.classList.remove('is-invalid'); input.classList.add('is-valid'); }
    function clearState(input) { input.classList.remove('is-invalid', 'is-valid'); }

    titleInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0 || val.length > 100) setInvalid(this);
        else setValid(this);
    });
    titleInput.addEventListener('input', function() { if (this.value.trim().length > 0) clearState(this); });

    contentInput.addEventListener('blur', function() {
        if (this.value.trim().length === 0) setInvalid(this);
        else setValid(this);
    });
    contentInput.addEventListener('input', function() { if (this.value.trim().length > 0) clearState(this); });

    publisherInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0 || val.length > 50) setInvalid(this);
        else setValid(this);
    });
    publisherInput.addEventListener('input', function() { if (this.value.trim().length > 0) clearState(this); });

    form.addEventListener('submit', function(e) {
        let isValid = true;
        if (titleInput.value.trim().length === 0 || titleInput.value.trim().length > 100) { setInvalid(titleInput); isValid = false; }
        if (contentInput.value.trim().length === 0) { setInvalid(contentInput); isValid = false; }
        if (publisherInput.value.trim().length === 0 || publisherInput.value.trim().length > 50) { setInvalid(publisherInput); isValid = false; }
        if (!isValid) {
            e.preventDefault();
            const firstError = form.querySelector('.is-invalid');
            if (firstError) { firstError.scrollIntoView({ behavior: 'smooth', block: 'center' }); firstError.focus(); }
            return false;
        }
        submitBtn.disabled = true;
        spinner.classList.remove('d-none');
        submitIcon.classList.add('d-none');
    });

    let previewModal = null;
    document.getElementById('previewBtn').addEventListener('click', function() {
        if (!previewModal && typeof bootstrap !== 'undefined') {
            previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
        }
        if (!previewModal) return;

        document.getElementById('previewTitle').textContent = titleInput.value || '（无标题）';
        document.getElementById('previewPublisher').textContent = publisherInput.value || '（未填写）';
        const timeVal = document.getElementById('publishTime').value
            ? new Date(document.getElementById('publishTime').value).toLocaleString('zh-CN')
            : new Date().toLocaleString('zh-CN');
        document.getElementById('previewTime').textContent = timeVal;
        document.getElementById('previewContent').textContent = contentInput.value || '（无内容）';

        const statusSelect = document.getElementById('status');
        const previewStatus = document.getElementById('previewStatus');
        if (statusSelect.value === '1') { previewStatus.textContent = '已发布'; previewStatus.className = 'badge bg-success me-2'; }
        else { previewStatus.textContent = '草稿'; previewStatus.className = 'badge bg-secondary me-2'; }

        const isTopCheck = document.getElementById('isTop');
        const previewTop = document.getElementById('previewTop');
        if (isTopCheck.checked) previewTop.classList.remove('d-none');
        else previewTop.classList.add('d-none');

        previewModal.show();
    });

    let formChanged = false;
    form.querySelectorAll('input, textarea, select').forEach(function(el) {
        el.addEventListener('change', function() { formChanged = true; });
    });
    window.addEventListener('beforeunload', function(e) { if (formChanged) { e.preventDefault(); e.returnValue = ''; } });
    form.addEventListener('submit', function() { formChanged = false; });
});
</script>

<%@ include file="../common/footer.jsp" %>
