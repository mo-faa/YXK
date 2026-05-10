(function () {
    'use strict';

    var backToTopBtn = document.getElementById('backToTop');

    if (backToTopBtn) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 300) {
                backToTopBtn.classList.add('show');
            } else {
                backToTopBtn.classList.remove('show');
            }
        });

        backToTopBtn.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    var navbar = document.querySelector('.navbar');
    if (navbar) {
        var lastScroll = 0;
        window.addEventListener('scroll', function () {
            var currentScroll = window.scrollY;
            if (currentScroll > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
            lastScroll = currentScroll;
        });
    }

    var animateElements = document.querySelectorAll('[data-animate]');

    if (animateElements.length > 0) {
        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animated');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        animateElements.forEach(function (el) {
            observer.observe(el);
        });
    }

    var alerts = document.querySelectorAll('.alert-dismissible');

    alerts.forEach(function (alert) {
        setTimeout(function () {
            var bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) {
                bsAlert.close();
            }
        }, 5000);
    });

    (function initQrCode() {
        var socialBtns = document.querySelectorAll('.social-icon-btn');
        var qrModal = document.getElementById('qrModal');
        var qrModalImg = document.getElementById('qrModalImg');
        var qrModalTitle = document.getElementById('qrModalTitle');
        var qrModalHint = document.getElementById('qrModalHint');

        if (!qrModal || socialBtns.length === 0) return;

        var modalInstance = null;

        function getModalInstance() {
            if (!modalInstance) {
                modalInstance = new bootstrap.Modal(qrModal);
            }
            return modalInstance;
        }

        var config = {
            weixin: { title: '微信二维码', hint: '微信扫码添加好友' },
            qq: { title: 'QQ二维码', hint: 'QQ扫码添加好友' }
        };

        socialBtns.forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();

                var contactType = this.getAttribute('data-contact');
                var wrapper = this.closest('.social-icon-wrapper');
                var popupBox = wrapper ? wrapper.querySelector('.qr-popup-box') : null;
                var popupImg = popupBox ? popupBox.querySelector('img') : null;

                if (popupImg && qrModalImg) {
                    var cfg = config[contactType] || { title: '二维码', hint: '扫码添加' };

                    qrModalImg.src = popupImg.src;
                    if (qrModalTitle) qrModalTitle.textContent = cfg.title;
                    if (qrModalHint) qrModalHint.textContent = cfg.hint;

                    getModalInstance().show();
                }
            });
        });
    })();

    var currentPath = window.location.pathname;
    var navLinks = document.querySelectorAll('.navbar-nav .nav-link');

    navLinks.forEach(function (link) {
        var href = link.getAttribute('href');
        if (href && currentPath.includes(href) && href !== '/' && href.length > 1) {
            link.classList.add('active');
        }
    });

    var tableRows = document.querySelectorAll('.table-hover tbody tr');

    tableRows.forEach(function (row) {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function (e) {
            if (e.target.closest('a, button, .btn')) {
                return;
            }

            var detailLink = this.querySelector('a[href*="detail"], a[href*="view"]');
            if (detailLink) {
                window.location.href = detailLink.href;
            }
        });
    });

    var deleteButtons = document.querySelectorAll('[data-confirm]');

    deleteButtons.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            var message = this.getAttribute('data-confirm') || '确定要执行此操作吗？';
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });

    var tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltipTriggerList.forEach(function (tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });

    var themeToggleBtn = document.getElementById('themeToggle');

    if (themeToggleBtn) {
        function updateThemeIcon(theme) {
            var icon = themeToggleBtn.querySelector('i');
            if (icon) {
                if (theme === 'dark') {
                    icon.className = 'fa-solid fa-sun';
                } else {
                    icon.className = 'fa-solid fa-moon';
                }
            }
        }

        var currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
        updateThemeIcon(currentTheme);

        themeToggleBtn.addEventListener('click', function () {
            var html = document.documentElement;
            var current = html.getAttribute('data-theme') || 'light';
            var next = current === 'dark' ? 'light' : 'dark';

            html.setAttribute('data-theme', next);
            html.setAttribute('data-bs-theme', next);

            try {
                localStorage.setItem('yxk-theme', next);
            } catch (e) { }

            updateThemeIcon(next);
        });
    }

})();
