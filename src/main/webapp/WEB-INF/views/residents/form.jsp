<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode == 'edit' ? '编辑村民' : '新增村民'} - 网上村委会"/>
<c:set var="activePage" value="residents"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <!-- Hero区域 -->
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user-plus me-2"></i>${mode == 'edit' ? '编辑村民信息' : '新增村民'}
                </h1>
                <div class="page-hero-subtitle">
                    ${mode == 'edit' ? '修改村民的基本信息' : '录入新村民的基本信息'}
                </div>
            </div>
            <div class="text-md-end">
                <a href="<c:url value='/residents'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="row">
        <!-- 表单卡片 -->
        <div class="col-lg-8" data-animate="fade-up">
            <div class="card soft">
                <div class="card-body p-4 p-md-5">
                    <form id="residentForm" method="post"
                          action="${pageContext.request.contextPath}/residents${mode == 'edit' ? '/' += resident.id : ''}"
                          novalidate>

                        <%-- CSRF Token --%>
                        <input type="hidden" name="_csrf" value="${_csrf}"/>

                        <%-- 姓名 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="name">
                                <i class="fa-solid fa-user me-2 text-primary"></i>姓名 
                                <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control form-control-lg" id="name" name="name"
                                   value="${resident.name}" required maxlength="50"
                                   placeholder="请输入村民姓名">
                            <div class="invalid-feedback">请输入有效的姓名（1-50个字符）</div>
                            <div class="form-text d-flex justify-content-between">
                                <span>请输入真实姓名</span>
                                <span class="char-counter"><span id="nameCount">0</span>/50</span>
                            </div>
                        </div>

                        <%-- 身份证号 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="idCard">
                                <i class="fa-solid fa-id-card me-2 text-primary"></i>身份证号
                            </label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text">
                                    <i class="fa-solid fa-fingerprint"></i>
                                </span>
                                <input type="text" class="form-control" id="idCard" name="idCard"
                                       value="${resident.idCard}" maxlength="18"
                                       placeholder="18位身份证号码（选填）">
                            </div>
                            <div class="invalid-feedback" id="idCardError">身份证号格式不正确</div>
                            <div class="form-text">
                                <i class="fa-solid fa-circle-info me-1"></i>
                                18位有效身份证号码，系统将自动校验
                            </div>
                        </div>

                        <%-- 电话 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="phone">
                                <i class="fa-solid fa-phone me-2 text-primary"></i>联系电话
                            </label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text">
                                    <i class="fa-solid fa-mobile-screen"></i>
                                </span>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       value="${resident.phone}" maxlength="20"
                                       placeholder="手机号或座机号（选填）">
                            </div>
                            <div class="invalid-feedback" id="phoneError">电话号码格式不正确</div>
                            <div class="form-text">
                                <i class="fa-solid fa-circle-info me-1"></i>
                                支持11位手机号或座机号（如 010-12345678）
                            </div>
                        </div>

                        <%-- 地址 --%>
                        <div class="mb-4">
                            <label class="form-label fw-bold" for="address">
                                <i class="fa-solid fa-location-dot me-2 text-primary"></i>住址
                            </label>
                            <textarea class="form-control" id="address" name="address"
                                      rows="3" maxlength="255"
                                      placeholder="详细住址（选填）">${resident.address}</textarea>
                            <div class="form-text d-flex justify-content-between">
                                <span>请填写详细地址，便于联系</span>
                                <span class="char-counter"><span id="addressCount">0</span>/255</span>
                            </div>
                        </div>

                        <hr class="my-4">

                        <%-- 操作按钮 --%>
                        <div class="d-flex flex-wrap gap-3 justify-content-between align-items-center">
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-gradient btn-lg" id="submitBtn">
                                    <span class="spinner-border spinner-border-sm d-none me-2" id="spinner"></span>
                                    <i class="fa-solid fa-check me-2" id="submitIcon"></i>
                                    ${mode == 'edit' ? '保存修改' : '确认新增'}
                                </button>
                                <button type="reset" class="btn btn-outline-secondary btn-lg">
                                    <i class="fa-solid fa-rotate-left me-2"></i>重置
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/residents" class="btn btn-light btn-lg">
                                <i class="fa-solid fa-xmark me-2"></i>取消
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- 右侧提示面板 -->
        <div class="col-lg-4 mt-4 mt-lg-0" data-animate="fade-up" data-delay="100">
            <!-- 填写说明 -->
            <div class="card soft mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fa-solid fa-circle-info me-2"></i>填写说明
                    </h5>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled mb-0">
                        <li class="mb-3 d-flex">
                            <span class="badge bg-danger rounded-pill me-2" style="height: fit-content;">必填</span>
                            <div>
                                <strong>姓名</strong><br>
                                <small class="text-muted">村民的真实姓名，最多50个字符</small>
                            </div>
                        </li>
                        <li class="mb-3 d-flex">
                            <span class="badge bg-secondary rounded-pill me-2" style="height: fit-content;">选填</span>
                            <div>
                                <strong>身份证号</strong><br>
                                <small class="text-muted">18位有效身份证，系统自动校验格式及校验码</small>
                            </div>
                        </li>
                        <li class="mb-3 d-flex">
                            <span class="badge bg-secondary rounded-pill me-2" style="height: fit-content;">选填</span>
                            <div>
                                <strong>联系电话</strong><br>
                                <small class="text-muted">手机号或座机号，便于日常联系</small>
                            </div>
                        </li>
                        <li class="d-flex">
                            <span class="badge bg-secondary rounded-pill me-2" style="height: fit-content;">选填</span>
                            <div>
                                <strong>住址</strong><br>
                                <small class="text-muted">详细的居住地址</small>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 数据安全提示 -->
            <div class="alert alert-warning border-0 shadow-sm">
                <h6 class="alert-heading mb-2">
                    <i class="fa-solid fa-shield-halved me-2"></i>数据安全提示
                </h6>
                <p class="mb-0 small">
                    村民信息属于敏感数据，请确保信息准确性，系统将对数据进行加密存储和访问控制。
                </p>
            </div>

            <!-- 快速操作 -->
            <div class="card soft">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fa-solid fa-bolt me-2"></i>快速操作
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/residents" class="btn btn-outline-primary">
                            <i class="fa-solid fa-list me-2"></i>查看村民列表
                        </a>
                        <c:if test="${mode == 'edit'}">
                            <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                <i class="fa-solid fa-trash me-2"></i>删除此村民
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- 删除确认模态框（仅编辑模式） --%>
<c:if test="${mode == 'edit'}">
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>确认删除
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center p-4">
                <div class="mb-3">
                    <i class="fa-solid fa-user-xmark fa-4x text-danger"></i>
                </div>
                <h5>确定要删除村民 "${resident.name}" 吗？</h5>
                <p class="text-muted mb-0">此操作不可恢复，请谨慎操作。</p>
            </div>
            <div class="modal-footer border-0 justify-content-center">
                <button type="button" class="btn btn-secondary btn-lg" data-bs-dismiss="modal">
                    <i class="fa-solid fa-xmark me-2"></i>取消
                </button>
                <form action="${pageContext.request.contextPath}/residents/${resident.id}/delete" method="post" class="d-inline">
                    <input type="hidden" name="_csrf" value="${_csrf}"/>
                    <button type="submit" class="btn btn-danger btn-lg">
                        <i class="fa-solid fa-trash me-2"></i>确认删除
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
</c:if>

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

.input-group-text {
    background-color: var(--bs-light);
    border-color: var(--bs-border-color);
}

[data-theme="dark"] .input-group-text {
    background-color: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.2);
    color: var(--bs-body-color);
}

[data-theme="dark"] .modal-header.bg-danger {
    background-color: var(--bs-danger) !important;
}
</style>

<script>
(function() {
    'use strict';

    const form = document.getElementById('residentForm');
    const nameInput = document.getElementById('name');
    const idCardInput = document.getElementById('idCard');
    const phoneInput = document.getElementById('phone');
    const addressInput = document.getElementById('address');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');
    const submitIcon = document.getElementById('submitIcon');

    // ==================== 字符计数器 ====================
    function updateCounter(input, counterId, max) {
        const counter = document.getElementById(counterId);
        if (!counter) return;
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

    nameInput.addEventListener('input', function() {
        updateCounter(this, 'nameCount', 50);
    });

    addressInput.addEventListener('input', function() {
        updateCounter(this, 'addressCount', 255);
    });

    // 初始化计数
    updateCounter(nameInput, 'nameCount', 50);
    updateCounter(addressInput, 'addressCount', 255);

    // ==================== 验证函数 ====================
    function setInvalid(input, message) {
        input.classList.add('is-invalid');
        input.classList.remove('is-valid');
        const feedback = input.parentElement.querySelector('.invalid-feedback') 
                        || input.nextElementSibling;
        if (feedback && feedback.classList.contains('invalid-feedback') && message) {
            feedback.textContent = message;
        }
    }

    function setValid(input) {
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
    }

    function clearState(input) {
        input.classList.remove('is-invalid', 'is-valid');
    }

    // ==================== 身份证校验 ====================
    function validateIdCard(idCard) {
        if (!idCard || idCard.length === 0) return { valid: true }; // 选填，为空则有效

        if (!/^\d{17}[\dXx]$/.test(idCard)) {
            return { valid: false, message: '身份证号必须是18位数字（最后一位可为X）' };
        }

        // 校验码验证
        const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
        const checkCodes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];
        let sum = 0;
        for (let i = 0; i < 17; i++) {
            sum += parseInt(idCard.charAt(i)) * weights[i];
        }
        const checkCode = checkCodes[sum % 11];
        if (idCard.charAt(17).toUpperCase() !== checkCode) {
            return { valid: false, message: '身份证号校验码不正确' };
        }

        // 简单的出生日期验证
        const year = parseInt(idCard.substring(6, 10));
        const month = parseInt(idCard.substring(10, 12));
        const day = parseInt(idCard.substring(12, 14));
        const birthDate = new Date(year, month - 1, day);
        if (birthDate.getFullYear() !== year || 
            birthDate.getMonth() !== month - 1 || 
            birthDate.getDate() !== day) {
            return { valid: false, message: '身份证号中的出生日期无效' };
        }

        return { valid: true };
    }

    // ==================== 电话校验 ====================
    function validatePhone(phone) {
        if (!phone || phone.length === 0) return { valid: true }; // 选填

        // 手机号：11位数字，以1开头
        const mobilePattern = /^1[3-9]\d{9}$/;
        // 座机号：区号-号码
        const landlinePattern = /^0\d{2,3}-?\d{7,8}$/;

        if (mobilePattern.test(phone) || landlinePattern.test(phone)) {
            return { valid: true };
        }
        return { valid: false, message: '请输入有效的手机号或座机号' };
    }

    // ==================== 输入验证 ====================
    nameInput.addEventListener('blur', function() {
        const val = this.value.trim();
        if (val.length === 0) {
            setInvalid(this, '姓名不能为空');
        } else if (val.length > 50) {
            setInvalid(this, '姓名不能超过50个字符');
        } else {
            setValid(this);
        }
    });

    nameInput.addEventListener('input', function() {
        if (this.value.trim().length > 0) clearState(this);
    });

    idCardInput.addEventListener('blur', function() {
        const result = validateIdCard(this.value.trim());
        if (!result.valid) {
            setInvalid(this, result.message);
        } else if (this.value.trim().length > 0) {
            setValid(this);
        } else {
            clearState(this);
        }
    });

    idCardInput.addEventListener('input', function() {
        // 自动转换X为大写
        this.value = this.value.toUpperCase();
        if (this.value.length === 18) {
            const result = validateIdCard(this.value);
            if (result.valid) setValid(this);
            else setInvalid(this, result.message);
        } else {
            clearState(this);
        }
    });

    phoneInput.addEventListener('blur', function() {
        const result = validatePhone(this.value.trim());
        if (!result.valid) {
            setInvalid(this, result.message);
        } else if (this.value.trim().length > 0) {
            setValid(this);
        } else {
            clearState(this);
        }
    });

    phoneInput.addEventListener('input', function() {
        clearState(this);
    });

    // ==================== 表单提交 ====================
    form.addEventListener('submit', function(e) {
        let isValid = true;

        // 验证姓名（必填）
        const nameVal = nameInput.value.trim();
        if (nameVal.length === 0 || nameVal.length > 50) {
            setInvalid(nameInput, nameVal.length === 0 ? '姓名不能为空' : '姓名不能超过50个字符');
            isValid = false;
        }

        // 验证身份证（选填但格式需正确）
        const idCardResult = validateIdCard(idCardInput.value.trim());
        if (!idCardResult.valid) {
            setInvalid(idCardInput, idCardResult.message);
            isValid = false;
        }

        // 验证电话（选填但格式需正确）
        const phoneResult = validatePhone(phoneInput.value.trim());
        if (!phoneResult.valid) {
            setInvalid(phoneInput, phoneResult.message);
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

    // ==================== 重置表单 ====================
    form.addEventListener('reset', function() {
        setTimeout(function() {
            form.querySelectorAll('.is-valid, .is-invalid').forEach(function(el) {
                el.classList.remove('is-valid', 'is-invalid');
            });
            updateCounter(nameInput, 'nameCount', 50);
            updateCounter(addressInput, 'addressCount', 255);
        }, 10);
    });

    // ==================== 离开提示 ====================
    let formChanged = false;

    form.querySelectorAll('input, textarea').forEach(function(el) {
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

    form.addEventListener('reset', function() {
        formChanged = false;
    });

})();
</script>

<%@ include file="../common/footer.jsp" %>
