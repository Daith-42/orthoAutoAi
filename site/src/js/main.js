/* OrthoAutoAI — progressive enhancements. The page is fully usable without this file. */
(function () {
  'use strict';

  var data = {};
  try {
    data = JSON.parse(document.getElementById('i18n-data').textContent);
  } catch (e) { /* no data, keep defaults */ }

  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- Demo: select → Alt+C → corrected, on a loop ---------- */
  var demo = document.querySelector('.demo');
  if (demo) {
    if (reduceMotion) {
      demo.classList.add('is-fixed');
    } else {
      var timers = [];
      var later = function (fn, ms) { timers.push(setTimeout(fn, ms)); };
      var cycle = function () {
        demo.classList.remove('is-selected', 'is-pressing', 'is-fixed');
        later(function () { demo.classList.add('is-selected'); }, 1400);
        later(function () { demo.classList.add('is-pressing'); }, 2300);
        later(function () {
          demo.classList.remove('is-pressing', 'is-selected');
          demo.classList.add('is-fixed');
        }, 2700);
        later(cycle, 6800);
      };
      var running = false;
      var start = function () { if (!running) { running = true; cycle(); } };
      var stop = function () {
        running = false;
        timers.forEach(clearTimeout);
        timers = [];
      };
      // Only animate while visible.
      if ('IntersectionObserver' in window) {
        new IntersectionObserver(function (entries) {
          entries.forEach(function (e) { e.isIntersecting ? start() : stop(); });
        }).observe(demo);
      } else {
        start();
      }
      document.addEventListener('visibilitychange', function () {
        if (document.hidden) stop();
      });
    }
  }

  /* ---------- Copy buttons ---------- */
  document.querySelectorAll('[data-copy]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var lines = btn.parentElement.querySelectorAll('.code__line');
      var text = Array.prototype.map.call(lines, function (l) { return l.textContent; }).join('\n');
      var done = function () {
        btn.textContent = data.copied || 'Copied';
        btn.classList.add('is-done');
        setTimeout(function () {
          btn.textContent = data.copy || 'Copy';
          btn.classList.remove('is-done');
        }, 1800);
      };
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(done, function () {});
      } else {
        var ta = document.createElement('textarea');
        ta.value = text;
        ta.setAttribute('readonly', '');
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy'); done(); } catch (e) { /* ignore */ }
        document.body.removeChild(ta);
      }
    });
  });

  /* ---------- Tabs (distribution picker) ---------- */
  document.querySelectorAll('[data-tabs]').forEach(function (root) {
    var tabs = Array.prototype.slice.call(root.querySelectorAll('[role="tab"]'));
    var select = function (tab, focus) {
      tabs.forEach(function (t) {
        var on = t === tab;
        t.setAttribute('aria-selected', on ? 'true' : 'false');
        t.tabIndex = on ? 0 : -1;
        document.getElementById(t.getAttribute('aria-controls')).classList.toggle('is-active', on);
      });
      if (focus) tab.focus();
    };
    tabs.forEach(function (tab, i) {
      tab.addEventListener('click', function () { select(tab); });
      tab.addEventListener('keydown', function (e) {
        var next = null;
        if (e.key === 'ArrowRight') next = tabs[(i + 1) % tabs.length];
        if (e.key === 'ArrowLeft') next = tabs[(i - 1 + tabs.length) % tabs.length];
        if (e.key === 'Home') next = tabs[0];
        if (e.key === 'End') next = tabs[tabs.length - 1];
        if (next) { e.preventDefault(); select(next, true); }
      });
    });
    // Pre-select the user's distribution when we can guess it.
    var ua = navigator.userAgent.toLowerCase();
    var guess = /fedora/.test(ua) ? 'tab-fedora' : /ubuntu|debian|mint/.test(ua) ? 'tab-debian' : null;
    if (guess) {
      var t = root.querySelector('#' + guess);
      if (t) select(t);
    }
  });

  /* ---------- Language menu: close on outside click / Escape ---------- */
  var langMenu = document.querySelector('.lang-menu');
  if (langMenu) {
    document.addEventListener('click', function (e) {
      if (langMenu.open && !langMenu.contains(e.target)) langMenu.open = false;
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && langMenu.open) {
        langMenu.open = false;
        langMenu.querySelector('summary').focus();
      }
    });
    langMenu.querySelectorAll('a[hreflang]').forEach(function (a) {
      a.addEventListener('click', function () { remember(a.getAttribute('hreflang')); });
    });
  }
  document.querySelectorAll('.site-footer__langs a[hreflang]').forEach(function (a) {
    a.addEventListener('click', function () { remember(a.getAttribute('hreflang')); });
  });

  function remember(lang) {
    try { localStorage.setItem('oa-lang', lang); } catch (e) { /* storage unavailable */ }
  }

  /* ---------- Suggest the visitor's language (no automatic redirect) ---------- */
  (function suggest() {
    var bar = document.getElementById('lang-suggest');
    if (!bar || !data.langs) return;
    var current = document.documentElement.lang;
    var stored = null;
    try { stored = localStorage.getItem('oa-lang'); } catch (e) { /* ignore */ }
    if (stored) return; // the visitor already picked a language
    var wanted = (navigator.languages || [navigator.language || ''])
      .map(function (l) { return String(l).slice(0, 2).toLowerCase(); })
      .filter(function (l) { return data.langs[l]; })[0];
    if (!wanted || wanted === current) return;
    var target = data.langs[wanted];
    document.getElementById('lang-suggest-text').textContent = target.text;
    var go = document.getElementById('lang-suggest-go');
    go.textContent = target.go;
    go.href = target.href + location.hash;
    go.setAttribute('hreflang', wanted);
    go.addEventListener('click', function () { remember(wanted); });
    document.getElementById('lang-suggest-close').addEventListener('click', function () {
      bar.hidden = true;
      remember(current);
    });
    bar.hidden = false;
  })();
})();
