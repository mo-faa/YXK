// FILE: src/main/webapp/static/js/main.js
// 全站公共交互：主题切换 + 动画 + 回到顶部
(function () {
  'use strict';

  var STORAGE_KEY = 'yxk-theme';

  function getSavedTheme() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }

  function getSystemTheme() {
    try {
      return (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ? 'dark' : 'light';
    } catch (e) {
      return 'light';
    }
  }

  function setTheme(theme) {
    var t = (theme === 'dark') ? 'dark' : 'light';

    // 你项目的主题开关（自定义）
    document.documentElement.setAttribute('data-theme', t);

    // 启用 Bootstrap 5.3 内置暗色模式变量（关键：表格/表单/分页等会跟随）
    document.documentElement.setAttribute('data-bs-theme', t);

    try { localStorage.setItem(STORAGE_KEY, t); } catch (e) { /* ignore */ }

    // 更新按钮图标
    var btn = document.getElementById('themeToggle');
    if (btn) {
      btn.setAttribute('aria-label', t === 'dark' ? '切换亮色模式' : '切换暗色模式');
      btn.setAttribute('title', t === 'dark' ? '切换亮色模式' : '切换暗色模式');

      var icon = btn.querySelector('i');
      if (icon) {
        icon.classList.remove('fa-moon', 'fa-sun');
        icon.classList.add(t === 'dark' ? 'fa-sun' : 'fa-moon');
      }
    }
  }

  function initTheme() {
    var saved = getSavedTheme();
    setTheme(saved || getSystemTheme());
  }

  // 动画：给带 data-animate 的元素做一次入场动画
  function initAnimations() {
    var els = document.querySelectorAll('[data-animate]');
    if (!els || els.length === 0) return;

    var map = {
      'fade-up': 'animate__fadeInUp',
      'fade-down': 'animate__fadeInDown',
      'fade-left': 'animate__fadeInLeft',
      'fade-right': 'animate__fadeInRight',
      'fade-in': 'animate__fadeIn'
    };

    function animate(el) {
      var key = el.getAttribute('data-animate') || 'fade-up';
      var cls = map[key] || map['fade-up'];
      var delay = parseInt(el.getAttribute('data-delay') || '0', 10);

      el.style.opacity = '0';
      if (delay > 0) el.style.animationDelay = delay + 'ms';

      // animate.css
      el.classList.add('animate__animated', cls);

      // 触发显示
      requestAnimationFrame(function () {
        el.style.opacity = '';
      });
    }

    if ('IntersectionObserver' in window) {
      var io = new IntersectionObserver(function (entries, obs) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            animate(entry.target);
            obs.unobserve(entry.target);
          }
        });
      }, { threshold: 0.12 });

      els.forEach(function (el) { io.observe(el); });
    } else {
      // 兼容：直接全部动画
      els.forEach(animate);
    }
  }

  // 回到顶部
  function initBackToTop() {
    var btn = document.getElementById('backToTop');
    if (!btn) return;

    function toggle() {
      if (window.scrollY > 300) btn.classList.add('show');
      else btn.classList.remove('show');
    }

    window.addEventListener('scroll', toggle, { passive: true });
    toggle();

    btn.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  function initThemeToggle() {
    var btn = document.getElementById('themeToggle');
    if (!btn) return;

    btn.addEventListener('click', function () {
      var current = document.documentElement.getAttribute('data-theme') || 'light';
      setTheme(current === 'dark' ? 'light' : 'dark');
    });
  }

  // DOM Ready
  document.addEventListener('DOMContentLoaded', function () {
    initTheme();         // 确保 DOM Ready 时也会对齐一次（与 header.jsp 的“提前设置”互补）
    initThemeToggle();
    initAnimations();
    initBackToTop();
  });
})();
