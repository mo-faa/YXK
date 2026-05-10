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
                <div class="mt-3 footer-social">
                    <!-- 微信 -->
                    <div class="social-icon-wrapper">
                        <a href="javascript:void(0)" class="social-icon-btn" 
                           data-contact="weixin" title="微信二维码">
                            <i class="fa-brands fa-weixin fa-lg"></i>
                        </a>
                        <div class="qr-popup-box">
                            <img src="<c:url value='/static/css/img/WeiXin.jpg'/>" alt="微信二维码" />
                            <span class="qr-tip">微信扫码添加</span>
                        </div>
                    </div>
                    <!-- QQ -->
                    <div class="social-icon-wrapper">
                        <a href="javascript:void(0)" class="social-icon-btn"
                           data-contact="qq" title="QQ二维码">
                            <i class="fa-brands fa-qq fa-lg"></i>
                        </a>
                        <div class="qr-popup-box">
                            <img src="<c:url value='/static/css/img/QQ.jpg'/>" alt="QQ二维码" />
                            <span class="qr-tip">QQ扫码添加</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <h6 class="text-uppercase text-light mb-3">快速链接</h6>
                        <ul class="list-unstyled footer-links">
                            <li><a href="<c:url value='/'/>">首页</a></li>
                            <li><a href="<c:url value='/residents'/>">村民管理</a></li>
                            <li><a href="<c:url value='/announcements'/>">公告管理</a></li>
                            <li><a href="<c:url value='/logs'/>">操作日志</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6 mb-4">
                        <h6 class="text-uppercase text-light mb-3">联系信息</h6>
                        <ul class="list-unstyled footer-links">
                            <li><i class="fa-solid fa-location-dot me-2"></i>中国 · 天津静海</li>
                            <li><i class="fa-solid fa-envelope me-2"></i>3062949899@qq.com</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom text-center mt-4 pt-3">
            <span>© <script>document.write(new Date().getFullYear())</script> 网上村委会 · 作者：于翔堃</span>
        </div>
    </div>
</footer>

<!-- 二维码Modal（移动端点击使用） -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="qrModalTitle">联系我们</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <div class="modal-body text-center pb-4">
                <img id="qrModalImg" class="qr-modal-img" src="" alt="二维码" />
                <p class="mt-3 mb-0 text-muted" id="qrModalHint">扫码添加好友</p>
            </div>
        </div>
    </div>
</div>

<!-- 返回顶部按钮 -->
<button type="button" class="back-to-top" id="backToTop" aria-label="Back to top">
    <i class="fa-solid fa-arrow-up"></i>
</button>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- 全站自定义 JS -->
<script src="<c:url value='/static/js/main.js?v=20251221_01'/>"></script>

</body>
</html>
