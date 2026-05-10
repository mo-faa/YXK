<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="${mode eq 'edit' ? '编辑村委会成员' : '新增村委会成员'} - 网上村委会"/>
<c:set var="activePage" value="committee-members"/>

<%@ include file="../common/header.jsp" %>

<div class="site-container">
    <div class="page-intro" data-animate="fade-up">
        <div class="page-intro-row">
            <div>
                <h1>${mode eq 'edit' ? '编辑村委会成员' : '新增村委会成员'}</h1>
                <p>${mode eq 'edit' ? '修改成员信息' : '添加新的村委会成员'}</p>
            </div>
            <div class="page-intro-actions">
                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i>返回列表
                </a>
            </div>
        </div>
    </div>

    <%@ include file="../common/flash.jsp" %>

    <div class="content-grid cols-2-1" data-animate="fade-up">
        <div class="card soft">
            <div class="card-header" style="background:var(--c-forest);color:#fff;">
                <h3 class="card-title mb-0" style="color:#fff;">基本信息</h3>
            </div>
            <div class="card-body">
                <form action="<c:url value='${mode eq \'edit\' ? \'/committee-members/\' : \'/committee-members\'}${mode eq \'edit\' ? member.id : \'\'}'/>"
                      method="post" id="memberForm">
                    <c:if test="${mode eq 'edit'}">
                        <input type="hidden" name="_method" value="PUT">
                    </c:if>
                    <input type="hidden" name="_csrf" value="${_csrf}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label for="name" class="form-label">姓名 <span style="color:var(--c-err);">*</span></label>
                            <input type="text" class="form-control form-control-lg" id="name" name="name"
                                   value="${member.name}" required maxlength="50"
                                   placeholder="请输入姓名">
                            <div class="invalid-feedback">姓名只能包含中文和间隔号</div>
                        </div>

                        <div class="col-md-6">
                            <label for="position" class="form-label">职务 <span style="color:var(--c-err);">*</span></label>
                            <input type="text" class="form-control form-control-lg" id="position" name="position"
                                   value="${member.position}" required maxlength="50"
                                   placeholder="如：村主任、会计等">
                            <div class="invalid-feedback">职位只能是中文或英文</div>
                        </div>

                        <div class="col-md-6">
                            <label for="phone" class="form-label">联系电话 <span style="color:var(--c-err);">*</span></label>
                            <input type="tel" class="form-control form-control-lg" id="phone" name="phone"
                                   value="${member.phone}" required maxlength="20"
                                   placeholder="11位手机号码">
                            <div class="invalid-feedback">请输入有效的11位手机号码</div>
                        </div>

                        <div class="col-md-6">
                            <label for="joinTime" class="form-label">任职时间 <span style="color:var(--c-err);">*</span></label>
                            <input type="datetime-local" class="form-control form-control-lg" id="joinTime" name="joinTime"
                                   value="${fn:substring(fn:replace(member.joinTime, 'T', ' '), 0, 16)}" required>
                        </div>

                        <div class="col-12">
                            <label for="duties" class="form-label">职责描述</label>
                            <textarea class="form-control" id="duties" name="duties" rows="3" maxlength="500"
                                      placeholder="描述该成员的主要职责和工作内容">${member.duties}</textarea>
                        </div>

                        <div class="col-12 mt-2">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive"
                                       ${member.isActive ? 'checked' : ''}>
                                <label class="form-check-label fw-bold" for="isActive">在职状态</label>
                            </div>
                            <div style="font-size:var(--text-xs);color:var(--c-ink-faint);">勾选表示该成员目前在职</div>
                        </div>

                        <div class="col-12 mt-4 pt-3" style="border-top:1px solid var(--c-stroke-light);">
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fa-solid fa-save me-2"></i>${mode eq 'edit' ? '保存修改' : '创建成员'}
                                </button>
                                <a href="<c:url value='/committee-members'/>" class="btn btn-light btn-lg">
                                    取消
                                </a>
                            </div>
                        </div>
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
                    <ul class="mb-0 ps-3" style="font-size:var(--text-sm);">
                        <li class="mb-2"><strong><span style="color:var(--c-err);">*</span> 必填项</strong> - 姓名、职务、电话、任职时间</li>
                        <li class="mb-2"><strong>联系电话</strong> - 必须为有效的11位手机号码</li>
                        <li class="mb-2"><strong>任职时间</strong> - 精确到小时和分钟</li>
                        <li><strong>职责描述</strong> - 简明扼要，突出重点</li>
                    </ul>
                </div>
            </div>

            <c:if test="${mode eq 'edit'}">
                <div class="card soft mb-4">
                    <div class="card-header" style="background:var(--c-teal);color:#fff;">
                        <h5 class="card-title mb-0" style="color:#fff;">操作记录</h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-marker" style="background:var(--c-forest);"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">创建记录</h6>
                                    <p style="color:var(--c-ink-muted);" class="mb-0">${fn:substring(fn:replace(member.createdAt, 'T', ' '), 0, 16)}</p>
                                </div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-marker" style="background:var(--c-teal);"></div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">任职时间</h6>
                                    <p style="color:var(--c-ink-muted);" class="mb-0">${fn:substring(fn:replace(member.joinTime, 'T', ' '), 0, 16)}</p>
                                </div>
                            </div>
                            <c:if test="${not empty member.updatedAt}">
                                <div class="timeline-item">
                                    <div class="timeline-marker" style="background:var(--c-gold);"></div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1">最后更新</h6>
                                        <p style="color:var(--c-ink-muted);" class="mb-0">${fn:substring(fn:replace(member.updatedAt, 'T', ' '), 0, 16)}</p>
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

<style>
.form-control:focus { border-color: var(--c-forest); box-shadow: 0 0 0 2px rgba(45,90,61,0.1); }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('memberForm');
    if (!form) return;
    
    const phoneInput = document.getElementById('phone');
    const nameInput = document.getElementById('name');
    const positionInput = document.getElementById('position');

    nameInput.addEventListener('input', function() {
        if (this.value && !/^[\u4e00-\u9fa5·]+$/.test(this.value)) this.classList.add('is-invalid');
        else this.classList.remove('is-invalid');
    });

    positionInput.addEventListener('input', function() {
        if (this.value && !/^[\u4e00-\u9fa5a-zA-Z\s]+$/.test(this.value)) this.classList.add('is-invalid');
        else this.classList.remove('is-invalid');
    });

    phoneInput.addEventListener('input', function() {
        if (this.value && !/^1[3-9][0-9]{9}$/.test(this.value)) this.classList.add('is-invalid');
        else this.classList.remove('is-invalid');
    });

    form.addEventListener('submit', function(e) {
        if (nameInput.value && !/^[\u4e00-\u9fa5·]+$/.test(nameInput.value)) { e.preventDefault(); nameInput.classList.add('is-invalid'); nameInput.focus(); return; }
        if (positionInput.value && !/^[\u4e00-\u9fa5a-zA-Z\s]+$/.test(positionInput.value)) { e.preventDefault(); positionInput.classList.add('is-invalid'); positionInput.focus(); return; }
        if (phoneInput.value && !/^1[3-9][0-9]{9}$/.test(phoneInput.value)) { e.preventDefault; phoneInput.classList.add('is-invalid'); return false; }
    });
});
</script>

<%@ include file="../common/footer.jsp" %>
