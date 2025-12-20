<%-- FILE: src/main/webapp/WEB-INF/views/residents/form.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mode == 'edit' ? '编辑' : '新增'}村民 - 村委会管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-control.is-invalid + .invalid-feedback { display: block; }
        .validation-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
        }
        .form-group { position: relative; }
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
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/residents">村民管理</a></li>
            <li class="breadcrumb-item active">${mode == 'edit' ? '编辑' : '新增'}</li>
        </ol>
    </nav>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">${mode == 'edit' ? '编辑村民' : '新增村民'}</h5>
        </div>
        <div class="card-body">
            <%-- 错误提示 --%>
            <c:if test="${not empty flash}">
                <div class="alert alert-${flashType != null ? flashType : 'info'} alert-dismissible fade show">
                    ${flash}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form id="residentForm" method="post"
                  action="${pageContext.request.contextPath}/residents${mode == 'edit' ? '/' += resident.id : ''}"
                  novalidate>

                <%-- 姓名 --%>
                <div class="mb-3 form-group">
                    <label class="form-label" for="name">姓名 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="name" name="name"
                           value="${resident.name}" required maxlength="50"
                           placeholder="请输入姓名">
                    <div class="invalid-feedback">请输入有效的姓名（1-50个字符）</div>
                    <div class="char-counter"><span id="nameCount">0</span>/50</div>
                </div>

                <%-- 身份证号 --%>
                <div class="mb-3 form-group">
                    <label class="form-label" for="idCard">身份证号</label>
                    <input type="text" class="form-control" id="idCard" name="idCard"
                           value="${resident.idCard}" maxlength="18"
                           placeholder="18位身份证号码（选填）">
                    <div class="invalid-feedback" id="idCardError">身份证号格式不正确</div>
                    <div class="form-text">18位有效身份证号码，留空表示不填写</div>
                </div>

                <%-- 电话 --%>
                <div class="mb-3 form-group">
                    <label class="form-label" for="phone">联系电话</label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           value="${resident.phone}" maxlength="20"
                           placeholder="手机号或座机号（选填）">
                    <div class="invalid-feedback" id="phoneError">电话号码格式不正确</div>
                    <div class="form-text">支持11位手机号或座机号（如 010-12345678）</div>
                </div>

                <%-- 地址 --%>
                <div class="mb-3 form-group">
                    <label class="form-label" for="address">住址</label>
                    <textarea class="form-control" id="address" name="address"
                              rows="3" maxlength="255"
                              placeholder="详细住址（选填）">${resident.address}</textarea>
                    <div class="char-counter"><span id="addressCount">0</span>/255</div>
                </div>

                <%-- 按钮 --%>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <span class="spinner-border spinner-border-sm d-none" id="spinner"></span>
                        ${mode == 'edit' ? '保存修改' : '确认新增'}
                    </button>
                    <a href="${pageContext.request.contextPath}/residents" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    'use strict';

    // ==================== 身份证验证 ====================

    const ID_CARD_WEIGHTS = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    const ID_CARD_CHECK_CODES = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    function validateIdCard(idCard) {
        if (!idCard || idCard.trim() === '') {
            return { valid: true, message: '' };
        }

        const id = idCard.trim().toUpperCase();

        if (id.length !== 18) {
            return { valid: false, message: '身份证号必须为18位' };
        }

        const pattern = /^[1-9]\d{5}(19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[0-9X]$/;
        if (!pattern.test(id)) {
            const year = parseInt(id.substring(6, 10));
            const month = parseInt(id.substring(10, 12));
            const day = parseInt(id.substring(12, 14));

            if (year < 1900 || year > 2100) {
                return { valid: false, message: '出生年份无效' };
            }
            if (month < 1 || month > 12) {
                return { valid: false, message: '出生月份无效' };
            }
            if (day < 1 || day > 31) {
                return { valid: false, message: '出生日期无效' };
            }

            return { valid: false, message: '身份证号格式不正确' };
        }

        let sum = 0;
        for (let i = 0; i < 17; i++) {
            sum += parseInt(id.charAt(i)) * ID_CARD_WEIGHTS[i];
        }
        const expectedCode = ID_CARD_CHECK_CODES[sum % 11];
        const actualCode = id.charAt(17);

        if (expectedCode !== actualCode) {
            return { valid: false, message: '身份证号校验码错误（末位应为 ' + expectedCode + '）' };
        }

        return { valid: true, message: '' };
    }

    // ==================== 手机号验证 ====================

    function validatePhone(phone) {
        if (!phone || phone.trim() === '') {
            return { valid: true, message: '' };
        }

        const p = phone.trim().replace(/[\s-]/g, '');

        if (p.length < 7) {
            return { valid: false, message: '电话号码太短' };
        }

        if (p.length > 12) {
            return { valid: false, message: '电话号码太长' };
        }

        const mobilePattern = /^1[3-9]\d{9}$/;
        const landlinePattern = /^(0\d{2,3}-?)?\d{7,8}$/;

        if (p.length === 11) {
            if (!p.startsWith('1')) {
                return { valid: false, message: '手机号必须以1开头' };
            }
            if (!mobilePattern.test(p)) {
                return { valid: false, message: '手机号格式不正确' };
            }
        } else if (!landlinePattern.test(p)) {
            return { valid: false, message: '电话号码格式不正确' };
        }

        return { valid: true, message: '' };
    }

    // ==================== 表单元素 ====================

    const form = document.getElementById('residentForm');
    const nameInput = document.getElementById('name');
    const idCardInput = document.getElementById('idCard');
    const phoneInput = document.getElementById('phone');
    const addressInput = document.getElementById('address');
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');

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

    nameInput.addEventListener('input', function() {
        updateCounter(nameInput, 'nameCount', 50);
    });

    addressInput.addEventListener('input', function() {
        updateCounter(addressInput, 'addressCount', 255);
    });

    // 初始化计数
    updateCounter(nameInput, 'nameCount', 50);
    updateCounter(addressInput, 'addressCount', 255);

    // ==================== 实时验证 ====================

    function setFieldState(input, isValid, errorId, message) {
        if (isValid) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
        } else {
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
            if (errorId && message) {
                document.getElementById(errorId).textContent = message;
            }
        }
    }

    function clearFieldState(input) {
        input.classList.remove('is-valid', 'is-invalid');
    }

    // 姓名验证
    nameInput.addEventListener('blur', function() {
        const value = this.value.trim();
        if (value.length === 0) {
            setFieldState(this, false, null, '');
        } else if (value.length > 50) {
            setFieldState(this, false, null, '');
        } else {
            setFieldState(this, true, null, '');
        }
    });

    nameInput.addEventListener('input', function() {
        if (this.value.trim().length > 0) {
            clearFieldState(this);
        }
    });

    // 身份证验证
    idCardInput.addEventListener('blur', function() {
        const result = validateIdCard(this.value);
        if (this.value.trim() === '') {
            clearFieldState(this);
        } else {
            setFieldState(this, result.valid, 'idCardError', result.message);
        }
    });

    idCardInput.addEventListener('input', function() {
        const pos = this.selectionStart;
        this.value = this.value.toUpperCase().replace(/[^0-9X]/gi, '');
        this.setSelectionRange(pos, pos);

        if (this.value.length === 18) {
            const result = validateIdCard(this.value);
            setFieldState(this, result.valid, 'idCardError', result.message);
        } else {
            clearFieldState(this);
        }
    });

    // 电话验证
    phoneInput.addEventListener('blur', function() {
        const result = validatePhone(this.value);
        if (this.value.trim() === '') {
            clearFieldState(this);
        } else {
            setFieldState(this, result.valid, 'phoneError', result.message);
        }
    });

    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9-]/g, '');
        clearFieldState(this);
    });

    // ==================== 表单提交 ====================

    form.addEventListener('submit', function(e) {
        let isValid = true;

        // 姓名必填
        const name = nameInput.value.trim();
        if (name.length === 0 || name.length > 50) {
            setFieldState(nameInput, false, null, '');
            isValid = false;
        }

        // 身份证（选填，但填了要正确）
        const idCardResult = validateIdCard(idCardInput.value);
        if (!idCardResult.valid) {
            setFieldState(idCardInput, false, 'idCardError', idCardResult.message);
            isValid = false;
        }

        // 电话（选填，但填了要正确）
        const phoneResult = validatePhone(phoneInput.value);
        if (!phoneResult.valid) {
            setFieldState(phoneInput, false, 'phoneError', phoneResult.message);
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault();
            // 滚动到第一个错误字段
            const firstError = form.querySelector('.is-invalid');
            if (firstError) {
                firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstError.focus();
            }
            return false;
        }

        // 防止重复提交
        submitBtn.disabled = true;
        spinner.classList.remove('d-none');
    });

    // 页面离开前提示（如果有修改）
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

})();
</script>
</body>
</html>
