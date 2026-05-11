/* ============================================================
   BioTwine Manufacturing — theme.js
   ============================================================ */

document.addEventListener('DOMContentLoaded', function () {

  // ── Sticky Nav scroll class ──────────────────────────────
  const nav = document.querySelector('.site-nav');
  if (nav) {
    const handleScroll = () => {
      nav.classList.toggle('scrolled', window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    handleScroll();
  }

  // ── Mobile hamburger menu ────────────────────────────────
  const hamburger = document.querySelector('.nav-hamburger');
  const navLinksWrap = document.querySelector('.nav-links-wrap');
  if (hamburger && navLinksWrap) {
    hamburger.addEventListener('click', function () {
      const isOpen = navLinksWrap.classList.toggle('open');
      this.setAttribute('aria-expanded', isOpen);
      // Animate hamburger spans to X
      this.classList.toggle('active', isOpen);
    });
    // Close menu when a nav link is clicked
    navLinksWrap.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        navLinksWrap.classList.remove('open');
        hamburger.classList.remove('active');
        hamburger.setAttribute('aria-expanded', false);
      });
    });
    // Close on outside click
    document.addEventListener('click', function (e) {
      if (!hamburger.contains(e.target) && !navLinksWrap.contains(e.target)) {
        navLinksWrap.classList.remove('open');
        hamburger.classList.remove('active');
        hamburger.setAttribute('aria-expanded', false);
      }
    });
  }

  // ── Alert dismiss ────────────────────────────────────────
  document.addEventListener('click', function (e) {
    if (e.target.matches('.btn-close') || e.target.closest('.btn-close')) {
      const alert = e.target.closest('.alert');
      if (alert) {
        alert.style.opacity = '0';
        alert.style.transition = 'opacity 200ms';
        setTimeout(() => alert.remove(), 200);
      }
    }
  });

  // ── Fade-in on scroll (Intersection Observer) ────────────
  const fadeEls = document.querySelectorAll('[data-fade]');
  if (fadeEls.length) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry, i) => {
        if (entry.isIntersecting) {
          const delay = entry.target.dataset.fadeDelay || 0;
          setTimeout(() => {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
          }, delay);
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    fadeEls.forEach(el => {
      el.style.opacity = '0';
      el.style.transform = 'translateY(24px)';
      el.style.transition = 'opacity 600ms ease, transform 600ms ease';
      observer.observe(el);
    });
  }

  // ── Active nav link highlight ────────────────────────────
  const currentPath = window.location.pathname.split('/').pop() || 'index.cfm';
  document.querySelectorAll('.nav-links a').forEach(link => {
    const href = link.getAttribute('href') || '';
    if (href && currentPath && href.includes(currentPath)) {
      link.classList.add('active');
    }
  });

  // ── Admin sidebar mobile toggle ──────────────────────────
  const adminToggle = document.querySelector('.admin-menu-toggle');
  const adminSidebar = document.querySelector('.admin-sidebar');
  if (adminToggle && adminSidebar) {
    adminToggle.addEventListener('click', () => {
      adminSidebar.classList.toggle('open');
    });
  }

});
