<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="注册 - 网上村委会"/>
<c:set var="activePage" value="auth"/>

<%@ include file="../common/header.jsp" %>

<div style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - 60px);width:100%;padding:2rem 1rem;box-sizing:border-box;">
    <div style="width:100%;max-width:480px;" data-animate="fade-up">
        <div class="card soft">
            <div class="card-body p-5">
                <div class="text-center mb-4">
                    <div style="width:64px;height:64px;background:var(--c-teal);border-radius:var(--r-lg);display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--space-3);">
                        <i class="fa-solid fa-user-plus text-white fa-lg"></i>
                    </div>
                    <h2 class="fw-bold mt-2" style="font-family:var(--font-serif);">用户注册</h2>
                    <p style="color:var(--c-ink-muted);font-size:var(--text-sm);">创建您的网上村委会账号</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger border-0 mb-4">${error}</div>
                </c:if>

                <form method="post" action="<c:url value='/register'/>">
                    <input type="hidden" name="_csrf" value="${_csrf}"/>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" for="username">用户名 <span style="color:var(--c-err);">*</span></label>
                            <input type="text" class="form-control form-control-lg" id="username" name="username"
                                   required minlength="3" maxlength="50" placeholder="3-50个字符">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="realName">真实姓名</label>
                            <input type="text" class="form-control form-control-lg" id="realName" name="realName"
                                   maxlength="50" placeholder="选填">
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label class="form-label" for="password">密码 <span style="color:var(--c-err);">*</span></label>
                            <input type="password" class="form-control form-control-lg" id="password" name="password"
                                   required minlength="6" maxlength="100" placeholder="至少6位">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" for="confirmPassword">确认密码 <span style="color:var(--c-err);">*</span></label>
                            <input type="password" class="form-control form-control-lg" id="confirmPassword"
                                   name="confirmPassword" required placeholder="再次输入密码">
                        </div>
                    </div>

                    <div class="mb-4 mt-3">
                        <label class="form-label" for="nickname">昵称</label>
                        <input type="text" class="form-control form-control-lg" id="nickname" name="nickname"
                               maxlength="50" placeholder="选填，默认使用用户名">
                    </div>

                    <button type="submit" class="btn btn-primary w-100 btn-lg">
                        <i class="fa-solid fa-check me-2"></i>注 册
                    </button>
                </form>

                <hr style="border-color:var(--c-stroke-light);" class="my-4">

                <div class="text-center">
                    <p style="font-size:var(--text-sm);color:var(--c-ink-muted);">已有账号？</p>
                    <a href="<c:url value='/login'/>" class="btn btn-outline-primary w-100 mt-2">
                        返回登录
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>