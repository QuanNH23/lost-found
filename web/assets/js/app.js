/* ================================================================
   LOST & FOUND SYSTEM — Main Application JS
   ================================================================ */
(function () {
  'use strict';

  // ── Mobile Nav Toggle ────────────────────────────────────────
  const toggle = document.getElementById('navToggle');
  const nav    = document.getElementById('mainNav');
  if (toggle && nav) {
    toggle.addEventListener('click', () => {
      nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', nav.classList.contains('open'));
    });
    document.addEventListener('click', (e) => {
      if (!nav.contains(e.target) && !toggle.contains(e.target)) {
        nav.classList.remove('open');
      }
    });
  }

  // ── User menu dropdown (profile/logout) ───────────────────────
  const menus = document.querySelectorAll('[data-user-menu]');
  const closeAllMenus = () => menus.forEach(m => {
    m.classList.remove('open');
    const btn = m.querySelector('[data-user-menu-btn]');
    if (btn) btn.setAttribute('aria-expanded', 'false');
  });

  menus.forEach(menu => {
    const btn = menu.querySelector('[data-user-menu-btn]');
    const panel = menu.querySelector('[data-user-menu-panel]');
    if (!btn) return;
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const isOpen = menu.classList.contains('open');
      closeAllMenus();
      if (!isOpen) {
        menu.classList.add('open');
        btn.setAttribute('aria-expanded', 'true');
      }
    });

    if (panel) {
      panel.addEventListener('click', (e) => e.stopPropagation());
    }

    menu.querySelectorAll('[role="menuitem"]').forEach(item => {
      item.addEventListener('click', () => closeAllMenus());
    });
  });

  document.addEventListener('click', () => closeAllMenus());
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeAllMenus();
  });

  // ── Toast Notification System ────────────────────────────────
  window.LF = window.LF || {};

  window.LF.toast = function (msg, type = 'info', duration = 4000) {
    let container = document.getElementById('lf-toast-container');
    if (!container) {
      container = document.createElement('div');
      container.id = 'lf-toast-container';
      container.style.cssText = `
        position:fixed; bottom:24px; right:24px; z-index:9999;
        display:flex; flex-direction:column; gap:10px; pointer-events:none;
      `;
      document.body.appendChild(container);
    }

    const icons = { success: '✅', error: '❌', info: 'ℹ️', warn: '⚠️' };
    const toast = document.createElement('div');
    toast.className = `lf-alert lf-alert-${type === 'error' ? 'error' : type === 'success' ? 'success' : type === 'warn' ? 'warn' : 'info'}`;
    toast.style.cssText = `
      pointer-events:auto; min-width:280px; max-width:380px;
      box-shadow:0 8px 32px rgba(0,0,0,0.5);
      animation: toastIn 0.35s ease;
    `;
    toast.innerHTML = `<span class="lf-alert__icon">${icons[type] || 'ℹ️'}</span><span>${msg}</span>`;

    const style = document.createElement('style');
    style.textContent = `
      @keyframes toastIn  { from { opacity:0; transform:translateX(40px); } to { opacity:1; transform:translateX(0); } }
      @keyframes toastOut { from { opacity:1; transform:translateX(0); }   to { opacity:0; transform:translateX(40px); } }
    `;
    if (!document.getElementById('toast-styles')) {
      style.id = 'toast-styles';
      document.head.appendChild(style);
    }

    container.appendChild(toast);

    setTimeout(() => {
      toast.style.animation = 'toastOut 0.3s ease forwards';
      toast.addEventListener('animationend', () => toast.remove());
    }, duration);
  };

  // ── Replace old alert() calls with toast ────────────────────
  // (JSP pages use alert() for session messages — override it)
  const _origAlert = window.alert;
  window.alert = function (msg) {
    if (typeof msg === 'string' && msg.trim()) {
      window.LF.toast(msg, 'info');
    }
  };

  // ── Confirm dialogs: keep native but style-safe ──────────────
  // (We keep window.confirm native for now, it's functional)

  // ── Active nav link highlighting ─────────────────────────────
  const pathname = window.location.pathname;
  document.querySelectorAll('.lf-navbar__link, .lf-menu__item a').forEach(link => {
    const href = link.getAttribute('href') || '';
    if (href && pathname.endsWith(href.split('?')[0])) {
      link.classList.add('active');
    }
  });

  // ── Table row hover enhancement ───────────────────────────────
  document.querySelectorAll('.lf-table tbody tr').forEach(row => {
    row.style.cursor = 'default';
  });

  // ── Auto-close date time picker on change ─────────────────────
  document.querySelectorAll('input[type="datetime-local"]').forEach(input => {
    input.addEventListener('change', function () {
      if (this.value && this.value.length >= 16) {
         this.blur();
      }
    });
  });

  // ── Image preview for file inputs ───────────────────────────
  document.querySelectorAll('input[type="file"][accept*="image"]').forEach(input => {
    input.addEventListener('change', function () {
      const wrap = this.closest('.lf-file-wrap');
      if (!wrap) return;
      const icon = wrap.querySelector('.lf-file-icon');
      const text = wrap.querySelector('.lf-file-text');
      
      let previewDiv = wrap.querySelector('.lf-file-preview-grid');
      if (previewDiv) previewDiv.remove();

      if (this.files.length > 0) {
        const names = Array.from(this.files).map(f => f.name).join(', ');
        if (text) text.textContent = `Đã chọn: ${names}`;
        if (icon) icon.style.display = 'none';

        previewDiv = document.createElement('div');
        previewDiv.className = 'lf-file-preview-grid';
        previewDiv.style.cssText = 'display:flex; justify-content:center; gap:8px; margin-bottom:12px; flex-wrap:wrap;';

        Array.from(this.files).forEach(file => {
          const reader = new FileReader();
          reader.onload = function (e) {
            const img = document.createElement('img');
            img.src = e.target.result;
            img.style.cssText = 'width:64px; height:64px; object-fit:cover; border-radius:6px; border:1px solid #d1d5db;';
            previewDiv.appendChild(img);
          };
          reader.readAsDataURL(file);
        });

        wrap.insertBefore(previewDiv, text);
      } else {
        if (text) text.textContent = 'Nhấn để chọn ảnh';
        if (icon) icon.style.display = 'block';
      }
    });
  });

  // ── Smooth scroll-in for cards ───────────────────────────────
  if ('IntersectionObserver' in window) {
    const cards = document.querySelectorAll('.lf-card, .lf-stat, .lf-item-card, .lf-message, .lf-inbox-msg');
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });

    cards.forEach((el, i) => {
      el.style.opacity = '0';
      el.style.transform = 'translateY(20px)';
      el.style.transition = `opacity 0.4s ease ${i * 0.05}s, transform 0.4s ease ${i * 0.05}s`;
      observer.observe(el);
    });
  }

  // ── Force reload on back/forward history navigation ──────────
  window.addEventListener('pageshow', function (event) {
    const historyTraversal = event.persisted || 
                             (typeof window.performance !== 'undefined' && 
                              window.performance.navigation.type === 2);
    if (historyTraversal) {
      window.location.reload();
    }
  });

  console.log('%c🔍 Lost & Found System — UI loaded', 'color:#5b8dee;font-weight:700;font-size:14px;');
})();
