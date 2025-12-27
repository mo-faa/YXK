<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value='${mode eq "create" ? "新增村委会成员" : "编辑村委会成员"} - 网上村委会'/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="container py-4">
    <div class="page-hero mb-4" data-animate="fade-up">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-3">
            <div>
                <h1 class="page-hero-title">
                    <i class="fa-solid fa-user-tie me-2"></i>${mode eq "create" ? "新增村委会成员" : "编辑村委会成员"}
                </h1>
                <div class="page-hero-subtitle">
                    ${mode eq "create" ? "添加新的村委会成员信息" : "修改现有村委会成员信息"}
                </div>
            </div>

            <div class="text-md-end">
                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                    <i class="fa-solid fa-arrow-left me-2"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="card soft" data-animate="fade-up">
                <div class="card-body p-4 p-md-5">
                    <form action="<c:url value='${mode eq "create" ? "/committee-members" : "/committee-members/${member.id}"}'/>"
                          method="post" class="needs-validation" novalidate>

                        <c:if test="${mode eq 'edit'}">
                            <input type="hidden" name="_method" value="put">
                        </c:if>

                        <div class="row g-4">
                            <!-- 基本信息 -->
                            <div class="col-12">
                                <h5 class="mb-3 pb-2 border-bottom">
                                    <i class="fa-solid fa-user me-2 text-primary"></i>基本信息
                                </h5>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">姓名 <span class="text-danger">*</span></label>
                                <input type="text" name="name" value="${member.name}"
                                       class="form-control form-control-lg" required>
                                <div class="invalid-feedback">请输入姓名</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">性别 <span class="text-danger">*</span></label>
                                <select name="gender" class="form-select form-select-lg" required>
                                    <option value="">请选择</option>
                                    <option value="男" ${member.gender eq '男' ? 'selected' : ''}>男</option>
                                    <option value="女" ${member.gender eq '女' ? 'selected' : ''}>女</option>
                                </select>
                                <div class="invalid-feedback">请选择性别</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">身份证号 <span class="text-danger">*</span></label>
                                <input type="text" name="idCard" value="${member.idCard}"
                                       class="form-control form-control-lg" required maxlength="18">
                                <div class="invalid-feedback">请输入身份证号</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">联系电话 <span class="text-danger">*</span></label>
                                <input type="tel" name="phone" value="${member.phone}"
                                       class="form-control form-control-lg" required>
                                <div class="invalid-feedback">请输入联系电话</div>
                            </div>

                            <!-- 职务信息 -->
                            <div class="col-12 mt-4">
                                <h5 class="mb-3 pb-2 border-bottom">
                                    <i class="fa-solid fa-briefcase me-2 text-primary"></i>职务信息
                                </h5>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">职务 <span class="text-danger">*</span></label>
                                <input type="text" name="position" value="${member.position}"
                                       class="form-control form-control-lg" required>
                                <div class="invalid-feedback">请输入职务</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">任职时间 <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="joinTime"
                                       value="<fmt:formatDate value="${member.joinTime}" pattern="yyyy-MM-dd'T'HH:mm"/>"
                                       class="form-control form-control-lg" required>
                                <div class="invalid-feedback">请选择任职时间</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold">职责描述</label>
                                <textarea name="responsibilities" rows="4"
                                          class="form-control form-control-lg">${member.responsibilities}</textarea>
                            </div>

                            <!-- 状态信息 -->
                            <div class="col-12 mt-4">
                                <h5 class="mb-3 pb-2 border-bottom">
                                    <i class="fa-solid fa-toggle-on me-2 text-primary"></i>状态信息
                                </h5>
                            </div>

                            <div class="col-md-6">
                                <div class="form-check form-switch form-check-lg">
                                    <input class="form-check-input" type="checkbox" name="isActiveMember"
                                           id="isActiveMember" ${member.isActiveMember ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActiveMember">
                                        在职状态
                                    </label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">离职时间</label>
                                <input type="datetime-local" name="leaveTime"
                                       value="<fmt:formatDate value="${member.leaveTime}" pattern="yyyy-MM-dd'T'HH:mm"/>"
                                       class="form-control form-control-lg">
                            </div>

                            <!-- 提交按钮 -->
                            <div class="col-12 mt-5">
                                <div class="d-flex gap-3 justify-content-end">
                                    <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                                        <i class="fa-solid fa-times me-2"></i>取消
                                    </a>
                                    <button type="submit" class="btn btn-gradient btn-lg">
                                        <i class="fa-solid fa-save me-2"></i>${mode eq "create" ? "保存" : "更新"}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    // 表单验证
    (function() {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');

        Array.from(forms).forEach(function(form) {
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                form.classList.add('was-validated');
            }, false);
        });
    })();

    // 在职状态切换
    const isActiveMember = document.getElementById('isActiveMember');
    const leaveTimeField = document.querySelector('input[name="leaveTime"]');

    function toggleLeaveTimeField() {
        if (isActiveMember.checked) {
            leaveTimeField.disabled = true;
            leaveTimeField.value = '';
        } else {
            leaveTimeField.disabled = false;
        }
    }

    if (isActiveMember && leaveTimeField) {
        isActiveMember.addEventListener('change', toggleLeaveTimeField);
        toggleLeaveTimeField(); // 初始化
    }
</script>
