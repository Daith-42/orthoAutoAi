# OrthoAutoAI website

Source of https://daith-42.github.io/orthoAutoAi/ — a static, dark-only page generated in 7 languages
(one real HTML page per language, so search engines index all of them).

## Work on it

Requires Node.js 18+ and nothing else (no `npm install`).

```bash
node site/build.mjs --serve   # build, then open http://localhost:4321/orthoAutoAi/
node site/build.mjs           # build only, output in site/dist/
```

Re-run the command after each change. Pushing to `main` deploys automatically
(`.github/workflows/pages.yml`).

## Layout

```text
site/
  build.mjs           generator + local server (SITE_URL, languages and links are at the top)
  src/
    index.html        page template: {{key}} = escaped text, {{{key}}} = raw HTML
    404.html          error page template
    i18n/<lang>.json  all texts, one file per language (every file must have the same keys)
    css/style.css     styles
    js/main.js        small enhancements (demo animation, copy buttons, tabs, language hint)
    assets/           generated images (icons, social previews)
  tools/
    make-images.py    regenerates src/assets/ from ../assets/icon_orthoAutoAI.png (needs Pillow)
  dist/               build output, not committed
```

## Common tasks

- **Change a text**: edit `src/i18n/*.json` in every language. The build fails if a key is missing.
- **Keys ending in `_html`** may contain markup (`<kbd>`, `<a>`, `<code>`); other keys are plain text.
- **Demo sentence** (`demo_sentence`): write each fix as `[wrong|right]`.
- **Add a language**: copy `en.json` to `xx.json`, translate it, add `'xx'` to `LANGS` in `build.mjs`,
  then run `python site/tools/make-images.py` for its social preview image.
- **Custom domain**: change `SITE_URL` in `build.mjs` (canonical URLs, sitemap, Open Graph), and set the
  domain in the repository's Pages settings.
