<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- 页脚 -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4">
                <h5 class="mb-3">
                    <i class="fas fa-landmark me-2"></i>网上村委会
                </h5>
                <p class="text-light mb-2">为村民提供便捷、高效的在线服务，推进乡村治理现代化。</p>
                <div class="mt-3">
                    <a href="#" class="text-light me-3"><i class="fab fa-weixin fa-lg"></i></a>
                    <a href="#" class="text-light me-3"><i class="fab fa-weibo fa-lg"></i></a>
                    <a href="#" class="text-light"><i class="fab fa-qq fa-lg"></i></a>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <h5 class="mb-3">快速链接</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="<c:url value='/'/>" class="text-light">首页</a></li>
                    <li class="mb-2"><a href="<c:url value='/announcements'/>" class="text-light">公告通知</a></li>
                    <li class="mb-2"><a href="<c:url value='/residents'/>" class="text-light">村民管理</a></li>
                </ul>
            </div>
            <div class="col-lg-4 mb-4">
                <h5 class="mb-3">联系我们</h5>
                <p class="text-light mb-2"><i class="fas fa-map-marker-alt me-2"></i>村委会办公室</p>
                <p class="text-light mb-2"><i class="fas fa-phone me-2"></i>123-456-7890</p>
                <p class="text-light mb-2"><i class="fas fa-envelope me-2"></i>info@village.gov.cn</p>
            </div>
        </div>
        <hr class="bg-light">
        <div class="text-center">
            <p class="mb-0">&copy; 2025 网上村委会业务办理系统. All rights reserved.</p>
        </div>
    </div>
</footer>

<button type="button" class="back-to-top" id="backToTop" aria-label="Back to top">
    <i class="fa-solid fa-arrow-up"></i>
</button>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- 全站自定义 JS（新） -->
<script src="<c:url value='/static/js/main.js'/>"></script>

</body>
</html>
