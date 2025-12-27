/**
 * 网上村委会 - 主脚本
 * 作者：于翔堃
 */

(function () {
    'use strict';

    // ==================== 返回顶部按钮 ====================
    const backToTopBtn = document.getElementById('backToTop');
    
    if (backToTopBtn) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 300) {
                backToTopBtn.classList.add('show');
            } else {
                backToTopBtn.classList.remove('show');
            }
        });

        backToTopBtn.addEventListener('click', function () {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }

    // ==================== 滚动动画 ====================
    const animateElements = document.querySelectorAll('[data-animate]');
    
    if (animateElements.length > 0) {
        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animated');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.1
        });

        animateElements.forEach(function (el) {
            observer.observe(el);
        });
    }

    // ==================== Alert 自动关闭 ====================
    const alerts = document.querySelectorAll('.alert-dismissible');
    
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) {
                bsAlert.close();
            }
        }, 5000);
    });

    // ==================== 二维码功能（悬浮 + 点击Modal） ====================
    (function initQrCode() {
        const socialBtns = document.querySelectorAll('.social-icon-btn');
        const qrModal = document.getElementById('qrModal');
        const qrModalImg = document.getElementById('qrModalImg');
        const qrModalTitle = document.getElementById('qrModalTitle');
        const qrModalHint = document.getElementById('qrModalHint');

        if (!qrModal || socialBtns.length === 0) return;

        let modalInstance = null;
        
        // 延迟初始化Modal，确保Bootstrap已加载
        function getModalInstance() {
            if (!modalInstance) {
                modalInstance = new bootstrap.Modal(qrModal);
            }
            return modalInstance;
        }

        // 配置
        const config = {
            weixin: {
                title: '微信二维码',
                hint: '微信扫码添加好友'
            },
            qq: {
                title: 'QQ二维码',
                hint: 'QQ扫码添加好友'
            }
        };

        socialBtns.forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                
                const contactType = this.getAttribute('data-contact');
                const wrapper = this.closest('.social-icon-wrapper');
                const popupBox = wrapper ? wrapper.querySelector('.qr-popup-box') : null;
                const popupImg = popupBox ? popupBox.querySelector('img') : null;
                
                if (popupImg && qrModalImg) {
                    const cfg = config[contactType] || { title: '二维码', hint: '扫码添加' };
                    
                    qrModalImg.src = popupImg.src;
                    if (qrModalTitle) qrModalTitle.textContent = cfg.title;
                    if (qrModalHint) qrModalHint.textContent = cfg.hint;
                    
                    // 点击图标：统一弹出二维码（满足“点击图标应显示二维码”的需求）
                    // PC 端仍保留悬浮提示框，移动端因 hover 不可靠主要依赖此 Modal。
                    getModalInstance().show();
                }
            });
        });
    })();

    // ==================== 导航栏当前页面高亮 ====================
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');

    navLinks.forEach(function (link) {
        const href = link.getAttribute('href');
        if (href && currentPath.includes(href) && href !== '/' && href.length > 1) {
            link.classList.add('active');
        }
    });

    // ==================== 表格行点击效果 ====================
    const tableRows = document.querySelectorAll('.table-hover tbody tr');
    
    tableRows.forEach(function (row) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function (e) {
            // 如果点击的是按钮或链接，不处理
            if (e.target.closest('a, button, .btn')) {
                return;
            }
            
            // 查找该行的详情链接
            const detailLink = this.querySelector('a[href*="detail"], a[href*="view"]');
            if (detailLink) {
                window.location.href = detailLink.href;
            }
        });
    });

    // ==================== 确认删除对话框 ====================
    // ==================== 确认删除对话框 ====================
    const deleteButtons = document.querySelectorAll('[data-confirm]');
    
    deleteButtons.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            const message = this.getAttribute('data-confirm') || '确定要执行此操作吗？';
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });

    // ==================== 工具提示初始化 ====================
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // ==================== 主题切换 ====================
    const themeToggleBtn = document.getElementById('themeToggle');
    
    if (themeToggleBtn) {
        // 更新按钮图标
        function updateThemeIcon(theme) {
            const icon = themeToggleBtn.querySelector('i');
            if (icon) {
                if (theme === 'dark') {
                    icon.className = 'fa-solid fa-sun';
                } else {
                    icon.className = 'fa-solid fa-moon';
                }
            }
        }
        
        // 初始化图标
        const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
        updateThemeIcon(currentTheme);
        
        // 点击切换主题
        themeToggleBtn.addEventListener('click', function () {
            const html = document.documentElement;
            const current = html.getAttribute('data-theme') || 'light';
            const next = current === 'dark' ? 'light' : 'dark';
            
            html.setAttribute('data-theme', next);
            html.setAttribute('data-bs-theme', next);
            
            // 保存到 localStorage
            try {
                localStorage.setItem('yxk-theme', next);
            } catch (e) {
                // ignore
            }
            
            updateThemeIcon(next);
        });
    }

})();
