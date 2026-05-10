<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode == 'edit' ? '编辑村民' : '新增村民'} - 网上村委会"/>
<c:set var="activePage" value="residents"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>${mode == 'edit' ? '编辑村民信息' : '新增村民'}</h1>
                <p>${mode == 'edit' ? '修改村民的基本信息' : '录入新村民的基本信息'}</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/residents'/>" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="content-grid cols-2-1" data-animate="fade-up">
        <div class="card soft">
            <div class="card-body p-4 p-md-5">
                <form id="residentForm" method="post"
                      action="${pageContext.request.contextPath}/residents${mode == 'edit' ? '/' += resident.id : ''}"
                      novalidate>

                    <input type="hidden" name="_csrf" value="${_csrf}"/>

                    <div class="mb-4">
                        <label class="form-label" for="name">姓名 <span style="color:var(--c-err);">*</span></label>
                        <input type="text" class="form-control form-control-lg" id="name" name="name"
                               value="${resident.name}" required maxlength="50"
                               placeholder="请输入村民姓名">
                        <div class="invalid-feedback">请输入有效的姓名（1-50个字符）</div>
                        <div class="d-flex justify-content-between" style="font-size:var(--text-xs);">
                            <span style="color:var(--c-ink-faint);">请输入真实姓名</span>
                            <span class="char-counter"><span id="nameCount">0</span>/50</span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="idCard">身份证号</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-fingerprint"></i></span>
                            <input type="text" class="form-control" id="idCard" name="idCard"
                                   value="${resident.idCard}" maxlength="18"
                                   placeholder="18位身份证号码（选填）">
                        </div>
                        <div class="invalid-feedback" id="idCardError">身份证号格式不正确</div>
                        <div style="font-size:var(--text-xs);color:var(--c-ink-faint);">18位有效身份证号码，系统将自动校验</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="phone">联系电话</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-mobile-screen"></i></span>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   value="${resident.phone}" maxlength="20"
                                   placeholder="手机号或座机号（选填）">
                        </div>
                        <div class="invalid-feedback" id="phoneError">电话号码格式不正确</div>
                        <div style="font-size:var(--text-xs);color:var(--c-ink-faint);">支持11位手机号或座机号</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="address">住址</label>
                        <textarea class="form-control" id="address" name="address"
                                  rows="3" maxlength="255"
                                  placeholder="详细住址（选填）">${resident.address}</textarea>
                        <div class="d-flex justify-content-between" style="font-size:var(--text-xs);">
                            <span style="color:var(--c-ink-faint);">请填写详细地址，便于联系</span>
                            <span class="char-counter"><span id="addressCount">0</span>/255</span>
                        </div>
                    </div>

                    <hr style="border-color:var(--c-stroke-light);" class="my-4">

                    <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                <span class="spinner-border spinner-border-sm d-none me-2" id="spinner"></span>
                                <i class="fa-solid fa-check me-2" id="submitIcon"></i>
                                ${mode == 'edit' ? '保存修改' : '确认新增'}
                            </button>
                            <button type="reset" class="btn btn-outline-secondary btn-lg">
                                <i class="fa-solid fa-rotate-left me-1"></i>重置
                            </button>
                        </div>
                        <a href="${pageContext.request.contextPath}/residents" class="btn btn-light btn-lg">
                            取消
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <div>
            <div class="card soft mb-4">
                <div class="card-header pb-0" style="border-bottom:1px solid var(--c-stroke-light);">
                    <h6 class="mb-0 fw-bold" style="font-family:var(--font-serif);">填写说明</h6>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled mb-0" style="font-size:var(--text-sm);">
                        <li class="mb-2"><strong><span style="color:var(--c-err);">*</span> 姓名</strong><br><span style="color:var(--c-ink-muted);">村民的真实姓名，最多50个字符</span></li>
                        <li class="mb-2"><strong>身份证号</strong><br><span style="color:var(--c-ink-muted);">18位有效身份证，系统自动校验格式及校验码</span></li>
                        <li class="mb-2"><strong>联系电话</strong><br><span style="color:var(--c-ink-muted);">手机号或座机号，便于日常联系</span></li>
                        <li><strong>住址</strong><br><span style="color:var(--c-ink-muted);">详细的居住地址</span></li>
                    </ul>
                </div>
            </div>

            <div class="alert alert-warning border-0 mb-4">
                <h6 class="alert-heading mb-2" style="font-size:var(--text-sm);">
                    <i class="fa-solid fa-shield-halved me-2"></i>数据安全提示
                </h6>
                <p class="mb-0" style="font-size:var(--text-sm);">
                    村民信息属于敏感数据，请确保信息准确性。
                </p>
            </div>

            <c:if test="${mode == 'edit'}">
                <div class="d-grid gap-2">
                    <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                        <i class="fa-solid fa-trash me-1"></i>删除此村民
                    </button>
                </div>
            </c:if>
        </div>
    </div>
</div>

<c:if test="${mode == 'edit'}">
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="modal-header border-0" style="background:var(--c-err);color:#fff;">
                <h5 class="modal-title" style="color:#fff;">确认删除</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center p-4">
                <h5>确定要删除村民 "${resident.name}" 吗？</h5>
                <p style="color:var(--c-ink-muted);" class="mb-0">此操作不可恢复。</p>
            </div>
            <div class="modal-footer border-0 justify-content-center" style="background:var(--c-paper-warm);">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <form action="${pageContext.request.contextPath}/residents/${resident.id}/delete" method="post" class="d-inline">
                    <input type="hidden" name="_csrf" value="${_csrf}"/>
                    <button type="submit" class="btn btn-danger">确认删除</button>
                </form>
            </div>
        </div>
    </div>
</div>
</c:if>

<style>
.char-counter { font-size: var(--text-xs); color: var(--c-ink-faint); font-weight: 500; }
.char-counter.warning { color: var(--c-warn); }
.char-counter.danger { color: var(--c-err); }

.form-control:focus, .form-select:focus {
    border-color: var(--c-forest);
    box-shadow: 0 0 0 2px rgba(45, 90, 61, 0.1);
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('residentForm');
    if (!form) return;

    const nameInput = document.getElementById('name');
    const idCardInput = document.getElementById('idCard');
    const phoneInput = document.getElementById('phone');
    const addressInput = document.getElementById('address');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');
    const submitIcon = document.getElementById('submitIcon');

    function updateCounter(input, counterId, max) {
        const counter = document.getElementById(counterId);
        if (!counter) return;
        counter.textContent = input.value.length;
        const wrapper = counter.parentElement;
        wrapper.classList.remove('warning', 'danger');
        if (input.value.length > max * 0.9) wrapper.classList.add('danger');
        else if (input.value.length > max * 0.7) wrapper.classList.add('warning');
    }

    nameInput.addEventListener('input', function() { updateCounter(this, 'nameCount', 50); });
    addressInput.addEventListener('input', function() { updateCounter(this, 'addressCount', 255); });
    updateCounter(nameInput, 'nameCount', 50);
    updateCounter(addressInput, 'addressCount', 255);

    function setInvalid(input, msg) { input.classList.add('is-invalid'); input.classList.remove('is-valid'); }
    function setValid(input) { input.classList.remove('is-invalid'); input.classList.add('is-valid'); }
    function clearState(input) { input.classList.remove('is-invalid', 'is-valid'); }

    function validateIdCard(idCard) {
        if (!idCard || idCard.length === 0) return { valid: true };
        if (!/^\d{17}[\dXx]$/.test(idCard)) return { valid: false, message: '身份证号必须是18位数字' };
        const weights = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];
        const checkCodes = ['1','0','X','9','8','7','6','5','4','3','2'];
        let sum = 0;
        for (let i = 0; i < 17; i++) sum += parseInt(idCard.charAt(i)) * weights[i];
        if (idCard.charAt(17).toUpperCase() !== checkCodes[sum % 11]) return { valid: false, message: '校验码不正确' };
        return { valid: true };
    }

    function validatePhone(phone) {
        if (!phone || phone.length === 0) return { valid: true };
        if (/^1[3-9]\d{9}$/.test(phone) || /^0\d{2,3}-?\d{7,8}$/.test(phone)) return { valid: true };
        return { valid: false, message: '请输入有效的手机号或座机号' };
    }

    nameInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0) setInvalid(this);
        else if (val.length > 50) setInvalid(this);
        else setValid(this);
    });
    nameInput.addEventListener('input', function() { if (this.value.trim().length > 0) clearState(this); });

    idCardInput.addEventListener('blur', function() {
        const r = validateIdCard(this.value.trim());
        if (!r.valid && this.value.trim()) setInvalid(this, r.message);
        else if (this.value.trim()) setValid(this);
        else clearState(this);
    });

    phoneInput.addEventListener('blur', function() {
        const r = validatePhone(this.value.trim());
        if (!r.valid && this.value.trim()) setInvalid(this, r.message);
        else if (this.value.trim()) setValid(this);
        else clearState(this);
    });

    form.addEventListener('submit', function(e) {
        let isValid = true;
        if (nameInput.value.trim().length === 0 || nameInput.value.trim().length > 50) { setInvalid(nameInput); isValid = false; }
        const idR = validateIdCard(idCardInput.value.trim()); if (!idR.valid) { setInvalid(idCardInput, idR.message); isValid = false; }
        const phR = validatePhone(phoneInput.value.trim()); if (!phR.valid) { setInvalid(phoneInput, phR.message); isValid = false; }
        if (!isValid) { e.preventDefault(); const firstErr = form.querySelector('.is-invalid'); if (firstErr) { firstErr.scrollIntoView({ behavior:'smooth', block:'center' }); firstErr.focus(); } return; }
        submitBtn.disabled = true;
        spinner.classList.remove('d-none');
        submitIcon.classList.add('d-none');
    });

    form.addEventListener('reset', function() {
        setTimeout(function() { form.querySelectorAll('.is-valid,.is-invalid').forEach(function(el){ el.classList.remove('is-valid','is-invalid'); }); }, 10);
    });

    let formChanged = false;
    form.querySelectorAll('input, textarea').forEach(function(el) { el.addEventListener('change', function() { formChanged = true; }); });
    window.addEventListener('beforeunload', function(e) { if (formChanged) { e.preventDefault(); e.returnValue = ''; } });
    form.addEventListener('submit', function() { formChanged = false; });
});
</script>

<%@ include file="../common/footer.jsp" %>
