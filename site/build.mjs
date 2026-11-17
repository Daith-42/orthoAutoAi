#!/usr/bin/env node
// Static site generator for the OrthoAutoAI website. No dependencies.
//
//   node site/build.mjs            build into site/dist/
//   node site/build.mjs --serve    build, then serve site/dist on http://localhost:4321
//
// Each language gets its own static page (/, /fr/, /es/ ...) so search engines index all of them.

import { createHash } from 'node:crypto';
import { cp, mkdir, readFile, readdir, rm, writeFile } from 'node:fs/promises';
import { createServer } from 'node:http';
import { dirname, extname, join, normalize } from 'node:path';
import { fileURLToPath } from 'node:url';

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

/** Public URL of the site, with a trailing slash. Change this if a custom domain is set up. */
const SITE_URL = 'https://daith-42.github.io/orthoAutoAi/';

/** First language is the default one, served at the site root. */
const LANGS = ['en', 'fr', 'es', 'de', 'it', 'pt', 'ro'];

const LINKS = {
  repo: 'https://github.com/Daith-42/orthoAutoAi',
  releases: 'https://github.com/Daith-42/orthoAutoAi/releases',
  issues: 'https://github.com/Daith-42/orthoAutoAi/issues/new',
  exe: 'https://github.com/Daith-42/orthoAutoAi/releases/latest/download/OrthoAutoAI.exe',
  linux: 'https://github.com/AbelQ11/orthoAutoAi-linux',
  daith: 'https://github.com/Daith-42',
  kiliotsu: 'https://github.com/AbelQ11',
};

// ---------------------------------------------------------------------------

const HERE = dirname(fileURLToPath(import.meta.url));
const SRC = join(HERE, 'src');
const DIST = join(HERE, 'dist');
const BASE_PATH = new URL(SITE_URL).pathname; // e.g. "/orthoAutoAi/"

const pagePath = (lang) => (lang === LANGS[0] ? '' : `${lang}/`);
const absUrl = (lang) => SITE_URL + pagePath(lang);
const hreflangCode = (lang, dict) => (lang === 'pt' && dict.locale === 'pt_BR' ? 'pt-BR' : lang);

const escapeHtml = (s) =>
  String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

const stripTags = (s) => String(s).replace(/<[^>]+>/g, '');

const hash = (buf) => createHash('sha256').update(buf).digest('hex').slice(0, 10);

/** "[Their|They're] going" -> markup with the wrong and the right version of each fix. */
function renderDemo(sentence) {
  const out = escapeHtml(sentence).replace(/\[([^|\]]+)\|([^\]]+)\]/g, (_, wrong, right) => {
    if (wrong === right) throw new Error(`Demo fix with identical sides: "${wrong}"`);
    return `<span class="fix"><span class="fix__old">${wrong}</span><span class="fix__new">${right}</span></span>`;
  });
  return `<span class="demo__sel">${out}</span>`;
}

/** Replace {{key}} (escaped) and {{{key}}} (raw HTML). Unknown keys fail the build. */
function render(template, vars, file) {
  return template
    .replace(/\{\{\{\s*([\w]+)\s*\}\}\}/g, (_, k) => {
      if (!(k in vars)) throw new Error(`${file}: unknown key {{{${k}}}}`);
      return vars[k];
    })
    .replace(/\{\{\s*([\w]+)\s*\}\}/g, (_, k) => {
      if (!(k in vars)) throw new Error(`${file}: unknown key {{${k}}}`);
      return escapeHtml(vars[k]);
    });
}

function jsonLd(lang, t) {
  const url = absUrl(lang);
  const faq = [1, 2, 3, 4, 5, 6].map((i) => ({
    '@type': 'Question',
    name: t[`faq${i}_q`],
    acceptedAnswer: { '@type': 'Answer', text: stripTags(t[`faq${i}_a`] ?? t[`faq${i}_a_html`]) },
  }));
  const graph = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'WebSite',
        '@id': `${SITE_URL}#website`,
        url: SITE_URL,
        name: 'OrthoAutoAI',
        inLanguage: LANGS,
      },
      {
        '@type': 'SoftwareApplication',
        '@id': `${SITE_URL}#app`,
        name: 'OrthoAutoAI',
        url,
        description: t.meta_description,
        applicationCategory: 'UtilitiesApplication',
        applicationSubCategory: 'Spelling and grammar checker',
        operatingSystem: 'Windows, Linux',
        downloadUrl: [LINKS.exe, LINKS.linux],
        installUrl: LINKS.releases,
        softwareRequirements: 'Google Gemini API key',
        image: `${SITE_URL}assets/icon-512.png`,
        screenshot: `${SITE_URL}assets/og-${lang}.png`,
        inLanguage: LANGS,
        isAccessibleForFree: true,
        offers: { '@type': 'Offer', price: '0', priceCurrency: 'EUR' },
        author: { '@type': 'Person', name: 'Daith_42', url: LINKS.daith },
        contributor: { '@type': 'Person', name: 'Kiliotsu', url: LINKS.kiliotsu },
        codeRepository: LINKS.repo,
      },
      {
        '@type': 'FAQPage',
        '@id': `${url}#faq`,
        inLanguage: lang,
        mainEntity: faq,
      },
    ],
  };
  // Prevent "</script>" from closing the tag early.
  return JSON.stringify(graph).replace(/</g, '\\u003c');
}

async function build() {
  const started = Date.now();
  // Empty dist/ rather than deleting it: on Windows a folder that is open in a shell can't be removed.
  await mkdir(DIST, { recursive: true });
  for (const entry of await readdir(DIST)) {
    await rm(join(DIST, entry), { recursive: true, force: true });
  }

  // Static files
  await cp(join(SRC, 'css'), join(DIST, 'css'), { recursive: true });
  await cp(join(SRC, 'js'), join(DIST, 'js'), { recursive: true });
  await cp(join(SRC, 'assets'), join(DIST, 'assets'), { recursive: true });
  await cp(join(SRC, 'assets', 'favicon.ico'), join(DIST, 'favicon.ico'));

  const cssHash = hash(await readFile(join(SRC, 'css', 'style.css')));
  const jsHash = hash(await readFile(join(SRC, 'js', 'main.js')));

  // Translations
  const dicts = {};
  for (const lang of LANGS) {
    dicts[lang] = JSON.parse(await readFile(join(SRC, 'i18n', `${lang}.json`), 'utf8'));
  }
  const refKeys = Object.keys(dicts[LANGS[0]]).sort().join('|');
  for (const lang of LANGS) {
    const keys = Object.keys(dicts[lang]).sort().join('|');
    if (keys !== refKeys) {
      const a = new Set(Object.keys(dicts[LANGS[0]]));
      const b = new Set(Object.keys(dicts[lang]));
      const missing = [...a].filter((k) => !b.has(k));
      const extra = [...b].filter((k) => !a.has(k));
      throw new Error(`i18n/${lang}.json keys differ. Missing: ${missing.join(', ') || '-'}; extra: ${extra.join(', ') || '-'}`);
    }
  }

  const indexTpl = await readFile(join(SRC, 'index.html'), 'utf8');
  const notFoundTpl = await readFile(join(SRC, '404.html'), 'utf8');

  for (const lang of LANGS) {
    const t = dicts[lang];
    const root = lang === LANGS[0] ? './' : '../';
    const href = (l) => root + pagePath(l);

    const hreflang = [
      ...LANGS.map((l) => `  <link rel="alternate" hreflang="${hreflangCode(l, dicts[l])}" href="${absUrl(l)}">`),
      `  <link rel="alternate" hreflang="x-default" href="${absUrl(LANGS[0])}">`,
    ].join('\n');

    const ogLocaleAlts = LANGS.filter((l) => l !== lang)
      .map((l) => `  <meta property="og:locale:alternate" content="${dicts[l].locale}">`)
      .join('\n');

    const langMenu = LANGS.map((l) => {
      const current = l === lang ? ' aria-current="page"' : '';
      return `            <li><a href="${href(l)}" hreflang="${l}" lang="${l}"${current}>${escapeHtml(dicts[l].lang_name)} <span>${l.toUpperCase()}</span></a></li>`;
    }).join('\n');

    const langLinks = LANGS.map((l) => {
      const current = l === lang ? ' aria-current="page"' : '';
      return `        <li><a href="${href(l)}" hreflang="${l}" lang="${l}"${current}>${escapeHtml(dicts[l].lang_name)}</a></li>`;
    }).join('\n');

    const clientData = {
      copy: t.copy,
      copied: t.copied,
      langs: Object.fromEntries(
        LANGS.map((l) => [l, { href: href(l), text: dicts[l].suggest_text, go: dicts[l].suggest_go }]),
      ),
    };

    const vars = {
      ...t,
      _lang: lang,
      _lang_upper: lang.toUpperCase(),
      _root: root,
      _home: root,
      _canonical: absUrl(lang),
      _hreflang: hreflang,
      _og_locale_alts: ogLocaleAlts,
      _og_image: `${SITE_URL}assets/og-${lang}.png`,
      _lang_menu: langMenu,
      _lang_links: langLinks,
      _demo: renderDemo(t.demo_sentence),
      _jsonld: jsonLd(lang, t),
      _client_data: JSON.stringify(clientData).replace(/</g, '\\u003c'),
      _css_hash: cssHash,
      _js_hash: jsHash,
      _year: String(new Date().getFullYear()),
      ...Object.fromEntries(Object.entries(LINKS).map(([k, v]) => [`_url_${k}`, v])),
    };

    const outDir = join(DIST, pagePath(lang));
    await mkdir(outDir, { recursive: true });
    await writeFile(join(outDir, 'index.html'), render(indexTpl, vars, 'index.html'));

    // GitHub Pages serves /404.html for any missing path, at any depth: use absolute paths.
    if (lang === LANGS[0]) {
      const abs = (l) => BASE_PATH + pagePath(l);
      const nfVars = {
        ...vars,
        _root: BASE_PATH,
        _home: BASE_PATH,
        _lang_links: LANGS.map(
          (l) => `      <li><a href="${abs(l)}" hreflang="${l}" lang="${l}">${escapeHtml(dicts[l].lang_name)}</a></li>`,
        ).join('\n'),
      };
      await writeFile(join(DIST, '404.html'), render(notFoundTpl, nfVars, '404.html'));
    }
  }

  // sitemap.xml with alternate languages
  const today = new Date().toISOString().slice(0, 10);
  const alternates = LANGS.map(
    (l) => `    <xhtml:link rel="alternate" hreflang="${hreflangCode(l, dicts[l])}" href="${absUrl(l)}"/>`,
  ).join('\n');
  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
${LANGS.map(
  (l) => `  <url>
    <loc>${absUrl(l)}</loc>
    <lastmod>${today}</lastmod>
${alternates}
    <xhtml:link rel="alternate" hreflang="x-default" href="${absUrl(LANGS[0])}"/>
  </url>`,
).join('\n')}
</urlset>
`;
  await writeFile(join(DIST, 'sitemap.xml'), sitemap);

  // robots.txt only applies at the domain root; on a project page (github.io/repo/) it is
  // ignored by crawlers, but it becomes effective as soon as a custom domain is used.
  await writeFile(join(DIST, 'robots.txt'), `User-agent: *\nAllow: /\n\nSitemap: ${SITE_URL}sitemap.xml\n`);

  const en = dicts[LANGS[0]];
  const manifest = {
    name: 'OrthoAutoAI',
    short_name: 'OrthoAutoAI',
    description: en.meta_description,
    start_url: BASE_PATH,
    scope: BASE_PATH,
    display: 'browser',
    background_color: '#0b0f15',
    theme_color: '#0b0f15',
    icons: [
      { src: 'assets/icon-192.png', sizes: '192x192', type: 'image/png' },
      { src: 'assets/icon-512.png', sizes: '512x512', type: 'image/png' },
    ],
  };
  await writeFile(join(DIST, 'site.webmanifest'), JSON.stringify(manifest, null, 2) + '\n');

  // Tell GitHub Pages not to run Jekyll on the output.
  await writeFile(join(DIST, '.nojekyll'), '');

  const files = await readdir(DIST, { recursive: true });
  console.log(`Built ${LANGS.length} languages, ${files.length} files in ${Date.now() - started} ms -> ${DIST}`);
}

function serve(port = 4321) {
  const types = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'text/javascript; charset=utf-8',
    '.json': 'application/json',
    '.webmanifest': 'application/manifest+json',
    '.xml': 'application/xml',
    '.txt': 'text/plain; charset=utf-8',
    '.png': 'image/png',
    '.ico': 'image/x-icon',
    '.svg': 'image/svg+xml',
  };
  // Mimic GitHub Pages: the site lives under BASE_PATH.
  createServer(async (req, res) => {
    let path = decodeURIComponent(new URL(req.url, 'http://x').pathname);
    if (path === '/') {
      res.writeHead(302, { Location: BASE_PATH });
      return res.end();
    }
    if (!path.startsWith(BASE_PATH)) path = '/__missing__';
    let rel = normalize(path.slice(BASE_PATH.length) || '/').replace(/^([/\\])+/, '');
    if (rel === '.') rel = '';
    if (rel.includes('..')) rel = '__missing__';
    if (rel === '' || rel.endsWith('/') || rel.endsWith('\\')) rel = join(rel, 'index.html');
    try {
      const body = await readFile(join(DIST, rel));
      res.writeHead(200, { 'Content-Type': types[extname(rel)] || 'application/octet-stream' });
      res.end(body);
    } catch {
      try {
        // "/fr" without trailing slash -> redirect like GitHub Pages does
        await readFile(join(DIST, rel, 'index.html'));
        res.writeHead(301, { Location: path + '/' });
        res.end();
      } catch {
        res.writeHead(404, { 'Content-Type': types['.html'] });
        res.end(await readFile(join(DIST, '404.html')));
      }
    }
  }).listen(port, () => console.log(`Serving on http://localhost:${port}${BASE_PATH}`));
}

await build();
if (process.argv.includes('--serve')) serve(Number(process.env.PORT) || 4321);
