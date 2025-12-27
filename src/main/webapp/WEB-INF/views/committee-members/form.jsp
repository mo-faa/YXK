<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode eq 'edit' ? '编辑村委会成员' : '新增村委会成员'} - 网上村委会"/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user-tie me-2"></i>${mode eq 'edit' ? '编辑村委会成员' : '新增村委会成员'}
                </h1>
                <div class="page-hero-subtitle">${mode eq 'edit' ? '修改成员信息' : '添加新的村委会成员'}</div>
            </div>

            <div class="text-md-end d-flex gap-2 flex-wrap justify-content-md-end">
                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="row g-4">
        <div class="col-lg-8" data-animate="fade-up">
            <div class="card soft">
                <div class="card-header bg-gradient-primary text-white">
                    <h3 class="card-title mb-0">
                        <i class="fa-solid fa-user-pen me-2"></i>基本信息
                    </h3>
                </div>
                <div class="card-body">
                    <form action="<c:url value='${mode eq \'edit\' ? \'/committee-members/\' : \'/committee-members\'}${mode eq \'edit\' ? member.id : \'\'}'/>" 
                          method="post" id="memberForm">
                        <c:if test="${mode eq 'edit'}">
                            <input type="hidden" name="_method" value="PUT">
                        </c:if>
                        <input type="hidden" name="_csrf" value="${_csrf}">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label fw-bold">姓名 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${member.name}" required maxlength="50">
                            </div>

                            <div class="col-md-6">
                                <label for="position" class="form-label fw-bold">职务 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="position" name="position" 
                                       value="${member.position}" required maxlength="50">
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-bold">联系电话 <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${member.phone}" required maxlength="20" pattern="1[3-9][0-9]{9}">
                                <div class="form-text">请输入11位手机号码</div>
                            </div>

                            <div class="col-md-6">
                                <label for="joinTime" class="form-label fw-bold">任职时间 <span class="text-danger">*</span></label>
                                <input type="datetime-local" class="form-control" id="joinTime" name="joinTime" 
                                       value="<fmt:formatDate value='${member.joinTime}' pattern='yyyy-MM-dd\'T\'HH:mm'/>" required>
                                <div class="form-text">选择成员的任职时间</div>
                            </div>

                            <div class="col-12">
                                <label for="duties" class="form-label fw-bold">职责描述</label>
                                <textarea class="form-control" id="duties" name="duties" rows="4" maxlength="500">${member.duties}</textarea>
                                <div class="form-text">描述该成员的主要职责和工作内容</div>
                            </div>

                            <div class="col-12">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                           ${member.isActive ? 'checked' : ''}>
                                    <label class="form-check-label fw-bold" for="isActive">
                                        在职状态
                                    </label>
                                    <div class="form-text">勾选表示该成员目前在职</div>
                                </div>
                            </div>

                            <div class="col-12 mt-4">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fa-solid fa-save me-2"></i>${mode eq 'edit' ? '保存修改' : '创建成员'}
                                    </button>
                                    <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                                        <i class="fa-solid fa-times me-2"></i>取消
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-4" data-animate="fade-up" data-delay="100">
            <div class="card soft mb-4">
                <div class="card-header bg-gradient-info text-white">
                    <h5 class="card-title mb-0">
                        <i class="fa-solid fa-circle-info me-2"></i>填写说明
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info d-flex align-items-start" role="alert">
                        <i class="fa-solid fa-lightbulb me-2 mt-1"></i>
                        <div>
                            <p class="mb-2">请认真填写以下信息：</p>
                            <ul class="mb-0">
                                <li>标有红色星号的为必填项</li>
                                <li>联系电话必须为有效的11位手机号码</li>
                                <li>任职时间精确到小时和分钟</li>
                                <li>职责描述应简明扼要，突出重点</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${mode eq 'edit'}">
                <div class="card soft">
                    <div class="card-header bg-gradient-secondary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fa-solid fa-clock-rotate-left me-2"></i>操作记录
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-marker bg-primary"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">创建记录</h6>
                                    <p class="text-muted mb-0">
                                        <fmt:formatDate value="${member.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </p>
                                </div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-marker bg-info"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">任职时间</h6>
                                    <p class="text-muted mb-0">
                                        <fmt:formatDate value="${member.joinTime}" pattern="yyyy-MM-dd HH:mm"/>
                                    </p>
                                </div>
                            </div>
                            <c:if test="${not empty member.updatedAt}">
                                <div class="timeline-item">
                                    <div class="timeline-marker bg-warning"></div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1">最后更新</h6>
                                        <p class="text-muted mb-0">
                                            <fmt:formatDate value="${member.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<style>
/* 时间线样式 */
.timeline {
    position: relative;
    padding-left: 25px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 8px;
    top: 0;
    height: 100%;
    width: 2px;
    background: var(--border-color);
}

.timeline-item {
    position: relative;
    margin-bottom: 1.5rem;
}

.timeline-item:last-child {
    margin-bottom: 0;
}

.timeline-marker {
    position: absolute;
    left: -17px;
    top: 5px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    border: 2px solid var(--card-bg);
}

.timeline-content h6 {
    font-size: 0.9rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
}

.timeline-content p {
    font-size: 0.85rem;
}

/* 渐变背景 */
.bg-gradient-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-info {
    background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
}

.bg-gradient-secondary {
    background: linear-gradient(135deg, #434343 0%, #000000 100%);
}

/* 表单验证样式 */
.is-invalid {
    border-color: #dc3545;
}

.invalid-feedback {
    display: block;
    width: 100%;
    margin-top: 0.25rem;
    font-size: 0.875em;
    color: #dc3545;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 表单验证
    const form = document.getElementById('memberForm');
    const phoneInput = document.getElementById('phone');
    const nameInput = document.getElementById('name');
    const positionInput = document.getElementById('position');

    // 姓名验证
    nameInput.addEventListener('input', function() {
        const namePattern = /^[\u4e00-\u9fa5·]+$/;
        if (this.value && !namePattern.test(this.value)) {
            this.classList.add('is-invalid');
            if (!this.nextElementSibling || !this.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = '姓名只能包含中文和间隔号';
                this.parentNode.insertBefore(feedback, this.nextSibling);
            }
        } else {
            this.classList.remove('is-invalid');
            const feedback = this.nextElementSibling;
            if (feedback && feedback.classList.contains('invalid-feedback')) {
                feedback.remove();
            }
        }
    });

    // 职位验证
    positionInput.addEventListener('input', function() {
        const positionPattern = /^[\u4e00-\u9fa5a-zA-Z\s]+$/;
        if (this.value && !positionPattern.test(this.value)) {
            this.classList.add('is-invalid');
            if (!this.nextElementSibling || !this.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = '职位只能是中文或英文';
                this.parentNode.insertBefore(feedback, this.nextSibling);
            }
        } else {
            this.classList.remove('is-invalid');
            const feedback = this.nextElementSibling;
            if (feedback && feedback.classList.contains('invalid-feedback')) {
                feedback.remove();
            }
        }
    });

    // 手机号验证
    phoneInput.addEventListener('input', function() {
        const phonePattern = /^1[3-9][0-9]{9}$/;
        if (this.value && !phonePattern.test(this.value)) {
            this.classList.add('is-invalid');
            if (!this.nextElementSibling || !this.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.classList.add('invalid-feedback');
                feedback.textContent = '请输入有效的11位手机号码';
                this.parentNode.insertBefore(feedback, this.nextSibling);
            }
        } else {
            this.classList.remove('is-invalid');
            const feedback = this.nextElementSibling;
            if (feedback && feedback.classList.contains('invalid-feedback')) {
                feedback.remove();
            }
        }
    });

    // 表单提交前验证
    form.addEventListener('submit', function(e) {
        // 姓名验证
        const namePattern = /^[\u4e00-\u9fa5·]+$/;
        if (nameInput.value && !namePattern.test(nameInput.value)) {
            e.preventDefault();
            nameInput.classList.add('is-invalid');
            if (!nameInput.nextElementSibling || !nameInput.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = '姓名只能包含中文和间隔号';
                nameInput.parentNode.insertBefore(feedback, nameInput.nextSibling);
            }
            nameInput.focus();
            return;
        }
        
        // 职位验证
        const positionPattern = /^[\u4e00-\u9fa5a-zA-Z\s]+$/;
        if (positionInput.value && !positionPattern.test(positionInput.value)) {
            e.preventDefault();
            positionInput.classList.add('is-invalid');
            if (!positionInput.nextElementSibling || !positionInput.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                feedback.textContent = '职位只能是中文或英文';
                positionInput.parentNode.insertBefore(feedback, positionInput.nextSibling);
            }
            positionInput.focus();
            return;
        }
        
        // 手机号验证
        const phonePattern = /^1[3-9][0-9]{9}$/;
        if (phoneInput.value && !phonePattern.test(phoneInput.value)) {
            e.preventDefault();
            phoneInput.classList.add('is-invalid');
            if (!phoneInput.nextElementSibling || !phoneInput.nextElementSibling.classList.contains('invalid-feedback')) {
                const feedback = document.createElement('div');
                feedback.classList.add('invalid-feedback');
                feedback.textContent = '请输入有效的11位手机号码';
                phoneInput.parentNode.insertBefore(feedback, phoneInput.nextSibling);
            }
            return false;
        }
    });
    
    // 清除验证状态
    form.querySelectorAll('input, textarea').forEach(field => {
        field.addEventListener('focus', function() {
            this.classList.remove('is-invalid');
            // 查找并移除所有可能的错误提示元素
            let nextElement = this.nextElementSibling;
            while (nextElement) {
                if (nextElement.classList && nextElement.classList.contains('invalid-feedback')) {
                    nextElement.remove();
                    break;
                }
                nextElement = nextElement.nextElementSibling;
            }
        });
    });
});
</script>