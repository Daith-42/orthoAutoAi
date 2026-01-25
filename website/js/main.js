document.addEventListener('DOMContentLoaded', () => {
    const langSelect = document.getElementById('langSelect');

    // Detect user language or default to EN
    let currentLang = 'EN';
    const userLang = navigator.language || navigator.userLanguage;
    const supportedLangs = ['EN', 'FR', 'ES', 'DE', 'IT', 'PT', 'RO'];

    // Check if user's browser language starts with any of our supported codes
    const browserLangCode = userLang.substring(0, 2).toUpperCase();
    if (supportedLangs.includes(browserLangCode)) {
        currentLang = browserLangCode;
    }

    // Set dropdown to current language
    langSelect.value = currentLang;

    // Initial translation
    translatePage(currentLang);

    // Event listener for language change
    langSelect.addEventListener('change', (e) => {
        translatePage(e.target.value);
    });

    // Theme Toggle
    const themeBtn = document.getElementById('themeToggle');
    const storedTheme = localStorage.getItem('theme');

    // Check preference
    if (storedTheme === 'light' || (!storedTheme && window.matchMedia('(prefers-color-scheme: light)').matches)) {
        document.body.classList.add('light-theme');
        themeBtn.textContent = '🌙';
    } else {
        themeBtn.textContent = '☀️';
    }

    themeBtn.addEventListener('click', () => {
        document.body.classList.toggle('light-theme');
        const isLight = document.body.classList.contains('light-theme');
        themeBtn.textContent = isLight ? '🌙' : '☀️';
        localStorage.setItem('theme', isLight ? 'light' : 'dark');
    });
});

function translatePage(lang) {
    const elements = document.querySelectorAll('[data-i18n]');
    const t = translations[lang];

    elements.forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (t[key]) {
            el.textContent = t[key];
        }
    });

    // Determine the correct download filename based on context if needed, 
    // or just localization of the site is enough.
}
