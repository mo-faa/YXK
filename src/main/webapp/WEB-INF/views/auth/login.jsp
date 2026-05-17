<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="登录 - 网上村委会"/>
<c:set var="activePage" value="auth"/>

<%@ include file="../common/header.jsp" %>

<div style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - 60px);width:100%;padding:2rem 1rem;box-sizing:border-box;">
    <div style="width:100%;max-width:420px;" data-animate="fade-up">
        <div class="card soft">
            <div class="card-body p-5">
                <div class="text-center mb-4">
                    <div style="width:64px;height:64px;background:var(--c-forest);border-radius:var(--r-lg);display:inline-flex;align-items:center;justify-content:center;margin-bottom:var(--space-3);">
                        <i class="fa-solid fa-user-shield text-white fa-lg"></i>
                    </div>
                    <h2 class="fw-bold mt-2" style="font-family:var(--font-serif);">用户登录</h2>
                    <p style="color:var(--c-ink-muted);font-size:var(--text-sm);">网上村委会业务办理系统</p>
                </div>

                <c:if test="${not empty loginError}">
                    <div class="alert alert-danger border-0 mb-4">${loginError}</div>
                </c:if>
                <c:if test="${not empty registered}">
                    <div class="alert alert-success border-0 mb-4">注册成功！请使用新账号登录</div>
                </c:if>

                <form method="post" action="<c:url value='/login'/>">
                    <input type="hidden" name="_csrf" value="${_csrf}"/>

                    <div class="mb-3">
                        <label class="form-label" for="username">用户名</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                            <input type="text" class="form-control form-control-lg" id="username" name="username"
                                   required placeholder="请输入用户名" autofocus>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label" for="password">密码</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                            <input type="password" class="form-control form-control-lg" id="password" name="password"
                                   required placeholder="请输入密码">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 btn-lg">
                        <i class="fa-solid fa-right-to-bracket me-2"></i>登 录
                    </button>
                </form>

                <hr style="border-color:var(--c-stroke-light);" class="my-4">

                <div class="text-center">
                    <p style="font-size:var(--text-sm);color:var(--c-ink-muted);">还没有账号？</p>
                    <a href="<c:url value='/register'/>" class="btn btn-outline-primary w-100 mt-2">
                        注册新账号
                    </a>
                </div>
            </div>
        </div>

        <div class="text-center mt-4" style="font-size:var(--text-xs);color:var(--c-ink-faint);">
            &copy; <script>document.write(new Date().getFullYear())</script> 网上村委会
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>