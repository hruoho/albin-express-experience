# Albin Express Experience — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a static Hugo website for a 1990 Albin Express sailing boat — charter/sale marketing, photo-rich logbook, and self-service documentation — hosted on GitHub Pages.

**Architecture:** Hugo static site with a custom theme (no external theme dependency). Three content sections (home, logbook, docs) with bilingual support via Hugo's built-in multilingual mode. GitHub Actions deploys to GitHub Pages on push to main.

**Tech Stack:** Hugo, HTML/CSS, minimal vanilla JS (language toggle only), Google Fonts, GitHub Pages, GitHub Actions.

---

### Task 1: Hugo Project Scaffold

**Files:**
- Create: `hugo.toml`
- Create: `.gitignore`
- Create: `layouts/_default/baseof.html`

**Step 1: Initialize Hugo project**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo new site . --force`

The `--force` flag is needed because the directory already exists (has docs/).

Expected: Hugo creates its directory structure in the existing folder.

**Step 2: Configure hugo.toml**

Replace the generated `hugo.toml` with:

```toml
baseURL = "https://hruoho.github.io/albin-express-experience/"
languageCode = "en"
title = "Albin Express Experience"

defaultContentLanguage = "en"

[languages]
  [languages.en]
    languageName = "EN"
    weight = 1
    [languages.en.menus]
      [[languages.en.menus.main]]
        name = "Home"
        pageRef = "/"
        weight = 1
      [[languages.en.menus.main]]
        name = "Logbook"
        pageRef = "/logbook"
        weight = 2
      [[languages.en.menus.main]]
        name = "Docs"
        pageRef = "/docs"
        weight = 3
  [languages.fi]
    languageName = "FI"
    weight = 2
    [languages.fi.menus]
      [[languages.fi.menus.main]]
        name = "Koti"
        pageRef = "/"
        weight = 1
      [[languages.fi.menus.main]]
        name = "Lokikirja"
        pageRef = "/logbook"
        weight = 2
      [[languages.fi.menus.main]]
        name = "Dokumentaatio"
        pageRef = "/docs"
        weight = 3

[params]
  description = "1990 Albin Express — Charter & Sale"
  contactEmail = "REPLACE_ME"
```

**Step 3: Create .gitignore**

```
public/
resources/_gen/
.hugo_build.lock
.DS_Store
```

**Step 4: Verify Hugo builds**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo`

Expected: Build succeeds (may warn about missing layouts, that's fine).

**Step 5: Commit**

```bash
git add hugo.toml .gitignore archetypes/ layouts/ content/ static/ assets/ themes/
git commit -m "feat: initialize Hugo project with bilingual config"
```

---

### Task 2: Base Layout & Navigation

**Files:**
- Create: `layouts/_default/baseof.html`
- Create: `layouts/partials/head.html`
- Create: `layouts/partials/header.html`
- Create: `layouts/partials/footer.html`

**Step 1: Create the base template**

Create `layouts/_default/baseof.html`:

```html
<!DOCTYPE html>
<html lang="{{ .Lang }}">
<head>
  {{- partial "head.html" . -}}
</head>
<body>
  {{- partial "header.html" . -}}
  <main>
    {{- block "main" . }}{{- end }}
  </main>
  {{- partial "footer.html" . -}}
</body>
</html>
```

**Step 2: Create head partial**

Create `layouts/partials/head.html`:

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} — {{ .Site.Title }}{{ end }}</title>
<meta name="description" content="{{ with .Description }}{{ . }}{{ else }}{{ .Site.Params.description }}{{ end }}">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&family=Source+Sans+3:wght@400;600&family=IBM+Plex+Mono:wght@400&display=swap" rel="stylesheet">
{{- $style := resources.Get "css/main.css" | minify | fingerprint }}
<link rel="stylesheet" href="{{ $style.RelPermalink }}">
```

**Step 3: Create header partial**

Create `layouts/partials/header.html`:

```html
<header class="site-header">
  <nav class="nav">
    <a href="{{ "/" | relLangURL }}" class="nav__logo">Albin Express</a>
    <ul class="nav__links">
      {{- range .Site.Menus.main }}
      <li><a href="{{ .URL }}" class="nav__link">{{ .Name }}</a></li>
      {{- end }}
    </ul>
    <div class="nav__lang">
      {{- range .Site.Languages }}
      <a href="{{ $.RelPermalink | absLangURL }}"
         class="nav__lang-link{{ if eq $.Lang .Lang }} nav__lang-link--active{{ end }}"
         hreflang="{{ .Lang }}">{{ .LanguageName }}</a>
      {{- end }}
    </div>
  </nav>
</header>
```

Note: Hugo's `absLangURL` handles the language switching — the link points to the same page in the other language. No JavaScript needed for the toggle.

**Step 4: Create footer partial**

Create `layouts/partials/footer.html`:

```html
<footer class="site-footer">
  <div class="footer__content">
    <p class="footer__title">Albin Express Experience</p>
    <p class="footer__sub">1990 Albin Express 26 — Designed by Per Brohäll</p>
    <p class="footer__contact">{{ .Site.Params.contactEmail }}</p>
  </div>
</footer>
```

**Step 5: Verify Hugo builds without errors**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo`

Expected: Build succeeds.

**Step 6: Commit**

```bash
git add layouts/
git commit -m "feat: add base layout with nav and footer partials"
```

---

### Task 3: CSS — Nautical 70s Theme

**Files:**
- Create: `assets/css/main.css`

**Step 1: Create the stylesheet**

Create `assets/css/main.css` with the full Nautical 70s theme. This is the core visual identity file.

```css
/* ============================================
   Albin Express Experience — Nautical 70s
   ============================================ */

:root {
  --color-bg: #F5F0E8;
  --color-text: #1B2838;
  --color-accent: #C4652A;
  --color-gold: #D4A843;
  --color-teal: #5B8A8A;
  --color-sand: #D9CFBD;

  --font-heading: 'Libre Baskerville', Georgia, serif;
  --font-body: 'Source Sans 3', 'Helvetica Neue', sans-serif;
  --font-mono: 'IBM Plex Mono', 'Courier New', monospace;

  --content-width: 650px;
  --wide-width: 960px;
}

/* --- Reset & Base --- */

*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html {
  font-size: 18px;
  scroll-behavior: smooth;
}

body {
  font-family: var(--font-body);
  color: var(--color-text);
  background-color: var(--color-bg);
  line-height: 1.7;
  /* Subtle linen texture via CSS */
  background-image:
    repeating-linear-gradient(
      0deg,
      transparent,
      transparent 2px,
      rgba(0, 0, 0, 0.01) 2px,
      rgba(0, 0, 0, 0.01) 4px
    );
}

/* --- Typography --- */

h1, h2, h3, h4 {
  font-family: var(--font-heading);
  font-weight: 700;
  line-height: 1.2;
  color: var(--color-text);
}

h1 { font-size: 2.4rem; margin-bottom: 1rem; }
h2 { font-size: 1.6rem; margin-bottom: 0.75rem; margin-top: 2.5rem; }
h3 { font-size: 1.2rem; margin-bottom: 0.5rem; margin-top: 2rem; }

p {
  margin-bottom: 1.2rem;
  max-width: var(--content-width);
}

a {
  color: var(--color-accent);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.2s;
}

a:hover {
  border-bottom-color: var(--color-accent);
}

/* --- Labels / Small Caps --- */

.label {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-teal);
}

/* --- Navigation --- */

.site-header {
  border-bottom: 1px solid var(--color-sand);
  padding: 1rem 2rem;
}

.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: var(--wide-width);
  margin: 0 auto;
}

.nav__logo {
  font-family: var(--font-heading);
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--color-text);
  border-bottom: none;
}

.nav__links {
  display: flex;
  list-style: none;
  gap: 2rem;
}

.nav__link {
  font-family: var(--font-mono);
  font-size: 0.78rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--color-text);
}

.nav__link:hover {
  color: var(--color-accent);
}

.nav__lang {
  display: flex;
  gap: 0.5rem;
}

.nav__lang-link {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  color: var(--color-teal);
  padding: 0.15rem 0.4rem;
  border: 1px solid var(--color-sand);
  border-bottom: 1px solid var(--color-sand);
}

.nav__lang-link--active {
  color: var(--color-text);
  background: var(--color-sand);
}

/* --- Hero --- */

.hero {
  position: relative;
  width: 100%;
  min-height: 70vh;
  display: flex;
  align-items: flex-end;
  overflow: hidden;
}

.hero__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero__overlay {
  position: relative;
  z-index: 1;
  padding: 3rem 2rem;
  width: 100%;
  background: linear-gradient(to top, rgba(27, 40, 56, 0.85), transparent);
}

.hero__title {
  color: var(--color-bg);
  font-size: 2.8rem;
  max-width: var(--wide-width);
  margin: 0 auto;
}

.hero__subtitle {
  color: var(--color-sand);
  font-family: var(--font-mono);
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  max-width: var(--wide-width);
  margin: 0.5rem auto 0;
}

/* --- Content Sections --- */

.section {
  max-width: var(--wide-width);
  margin: 0 auto;
  padding: 3rem 2rem;
}

.section--narrow {
  max-width: var(--content-width);
}

.section + .section {
  border-top: 1px solid var(--color-sand);
}

/* --- Pricing / Info Cards --- */

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.card {
  border: 1px solid var(--color-sand);
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.3);
}

.card__title {
  font-family: var(--font-heading);
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
}

.card__price {
  font-family: var(--font-mono);
  font-size: 1.4rem;
  color: var(--color-accent);
  margin-bottom: 0.75rem;
}

.card__detail {
  font-size: 0.9rem;
  color: var(--color-teal);
  margin-bottom: 0.3rem;
}

/* --- Logbook List --- */

.logbook-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.logbook-card {
  border: 1px solid var(--color-sand);
  overflow: hidden;
  transition: border-color 0.2s;
}

.logbook-card:hover {
  border-color: var(--color-gold);
}

.logbook-card__image {
  width: 100%;
  aspect-ratio: 3 / 2;
  object-fit: cover;
  display: block;
}

.logbook-card__body {
  padding: 1rem 1.2rem;
}

.logbook-card__date {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--color-teal);
  margin-bottom: 0.3rem;
}

.logbook-card__title {
  font-family: var(--font-heading);
  font-size: 1rem;
  margin-bottom: 0.4rem;
}

.logbook-card__summary {
  font-size: 0.88rem;
  line-height: 1.5;
}

/* --- Logbook Single Entry --- */

.entry-hero {
  width: 100%;
  max-height: 60vh;
  object-fit: cover;
  display: block;
}

.entry-meta {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--color-teal);
  margin-bottom: 1.5rem;
}

.entry-content img {
  width: 100%;
  margin: 2rem 0;
}

/* --- Docs Layout --- */

.docs-layout {
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 3rem;
  max-width: var(--wide-width);
  margin: 0 auto;
  padding: 3rem 2rem;
}

.docs-sidebar {
  position: sticky;
  top: 2rem;
  align-self: start;
}

.docs-sidebar__title {
  font-family: var(--font-mono);
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-teal);
  margin-bottom: 1rem;
}

.docs-sidebar ul {
  list-style: none;
}

.docs-sidebar li {
  margin-bottom: 0.5rem;
}

.docs-sidebar a {
  font-size: 0.9rem;
  color: var(--color-text);
}

.docs-sidebar a:hover {
  color: var(--color-accent);
}

.docs-content {
  max-width: var(--content-width);
}

.docs-content h1 { font-size: 2rem; }
.docs-content h2 { font-size: 1.4rem; border-bottom: 1px solid var(--color-sand); padding-bottom: 0.3rem; }

/* --- Footer --- */

.site-footer {
  border-top: 1px solid var(--color-sand);
  padding: 2rem;
  margin-top: 3rem;
  text-align: center;
}

.footer__title {
  font-family: var(--font-heading);
  font-size: 1rem;
  margin-bottom: 0.3rem;
}

.footer__sub {
  font-size: 0.85rem;
  color: var(--color-teal);
  margin-bottom: 0.3rem;
}

.footer__contact {
  font-family: var(--font-mono);
  font-size: 0.78rem;
}

/* --- Responsive --- */

@media (max-width: 700px) {
  html { font-size: 16px; }

  .nav {
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .nav__links {
    gap: 1rem;
    order: 3;
    width: 100%;
    justify-content: center;
    padding-top: 0.5rem;
    border-top: 1px solid var(--color-sand);
  }

  .hero__title { font-size: 2rem; }

  .docs-layout {
    grid-template-columns: 1fr;
  }

  .docs-sidebar {
    position: static;
    border-bottom: 1px solid var(--color-sand);
    padding-bottom: 1rem;
    margin-bottom: 1rem;
  }
}
```

**Step 2: Verify Hugo builds with CSS pipeline**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo`

Expected: Build succeeds. CSS is processed via Hugo's asset pipeline (minified + fingerprinted).

**Step 3: Commit**

```bash
git add assets/css/main.css
git commit -m "feat: add Nautical 70s CSS theme"
```

---

### Task 4: Home Page Template & Content

**Files:**
- Create: `layouts/index.html`
- Create: `content/_index.md`
- Create: `content/_index.fi.md`

**Step 1: Create home page template**

Create `layouts/index.html`:

```html
{{ define "main" }}
<section class="hero">
  <img src="{{ "images/gallery/hero.jpg" | relURL }}" alt="Albin Express under sail" class="hero__image">
  <div class="hero__overlay">
    <h1 class="hero__title">{{ .Title }}</h1>
    <p class="hero__subtitle">{{ .Params.subtitle }}</p>
  </div>
</section>

<section class="section">
  <div class="section--narrow">
    {{ .Content }}
  </div>
</section>

{{ with .Params.pricing }}
<section class="section">
  <h2>{{ $.Params.pricingTitle | default "Pricing" }}</h2>
  <div class="card-grid">
    {{ range . }}
    <div class="card">
      <p class="label">{{ .label }}</p>
      <h3 class="card__title">{{ .title }}</h3>
      <p class="card__price">{{ .price }}</p>
      {{ with .details }}
      {{ range . }}
      <p class="card__detail">{{ . }}</p>
      {{ end }}
      {{ end }}
    </div>
    {{ end }}
  </div>
</section>
{{ end }}

<section class="section">
  <h2>{{ .Params.contactTitle | default "Contact" }}</h2>
  <div class="section--narrow">
    <p>{{ .Params.contactText }}</p>
    <p><a href="mailto:{{ .Site.Params.contactEmail }}">{{ .Site.Params.contactEmail }}</a></p>
    {{ with .Params.contactPhone }}
    <p><a href="tel:{{ . }}">{{ . }}</a></p>
    {{ end }}
  </div>
</section>
{{ end }}
```

**Step 2: Create English home page content**

Create `content/_index.md`:

```markdown
---
title: "Albin Express Experience"
subtitle: "1990 Albin Express 26 — Helsinki, Finland"
pricingTitle: "Charter & Purchase"
pricing:
  - label: "Day Charter"
    title: "Day Sail"
    price: "€XXX"
    details:
      - "Self-skippered"
      - "Helsinki archipelago"
      - "Briefing included"
  - label: "Weekend"
    title: "Weekend Charter"
    price: "€XXX"
    details:
      - "Friday evening – Sunday"
      - "Full equipment included"
  - label: "For Sale"
    title: "Purchase"
    price: "€XX,XXX"
    details:
      - "Well-maintained since 1990"
      - "Full documentation available"
      - "Sea trial by appointment"
contactTitle: "Get in Touch"
contactText: "Interested in chartering or buying? Drop a line."
contactPhone: "+358 XX XXX XXXX"
---

A nimble, well-loved sailboat built for the Nordic archipelago. The Albin Express is a 26-foot Swedish classic — quick, seaworthy, and simple to handle single-handed.

This particular boat has been carefully maintained and documented. Browse the [logbook](/logbook/) for sailing stories, or check the [documentation](/docs/) for the full owner's manual.
```

**Step 3: Create Finnish home page content**

Create `content/_index.fi.md` with equivalent content in Finnish. (Placeholder — the owner will translate.)

```markdown
---
title: "Albin Express Experience"
subtitle: "1990 Albin Express 26 — Helsinki, Suomi"
pricingTitle: "Vuokraus & Myynti"
pricing:
  - label: "Päivävuokra"
    title: "Päiväpurjehdus"
    price: "€XXX"
    details:
      - "Omatoiminen"
      - "Helsingin saaristo"
      - "Perehdytys sisältyy"
  - label: "Viikonloppu"
    title: "Viikonloppuvuokra"
    price: "€XXX"
    details:
      - "Perjantai-ilta – sunnuntai"
      - "Täysi varustelu mukana"
  - label: "Myydään"
    title: "Osta"
    price: "€XX,XXX"
    details:
      - "Hyvin huollettu vuodesta 1990"
      - "Kattava dokumentaatio"
      - "Koeajo sopimuksen mukaan"
contactTitle: "Ota yhteyttä"
contactText: "Kiinnostaako vuokraus tai osto? Laita viestiä."
contactPhone: "+358 XX XXX XXXX"
---

Ketterä ja pidetty purjevene, rakennettu pohjoismaiseen saaristoon. Albin Express on 26-jalkanen ruotsalainen klassikko — nopea, merikelpoinen ja helppo käsitellä yksin.

Tämä vene on huolellisesti ylläpidetty ja dokumentoitu. Selaa [lokikirjaa](/fi/logbook/) purjehduskertomuksia varten, tai tutustu [dokumentaatioon](/fi/docs/) käyttöopasta varten.
```

**Step 4: Add a placeholder hero image**

Create a placeholder so the build works:

Run: `mkdir -p /Users/hruoho/Projects/albin-express-experience/static/images/gallery`

Then add any placeholder image as `static/images/gallery/hero.jpg` (you'll replace this with a real photo later).

**Step 5: Verify with hugo server**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo server`

Expected: Site serves at localhost:1313. Home page renders with nav, hero section, pricing cards, contact section, footer. Language toggle switches between EN/FI.

**Step 6: Commit**

```bash
git add layouts/index.html content/_index.md content/_index.fi.md static/images/
git commit -m "feat: add home page template and bilingual content"
```

---

### Task 5: Logbook List & Single Entry Templates

**Files:**
- Create: `layouts/logbook/list.html`
- Create: `layouts/logbook/single.html`
- Create: `content/logbook/_index.md`
- Create: `content/logbook/example-entry.md` (sample for testing)

**Step 1: Create logbook list template**

Create `layouts/logbook/list.html`:

```html
{{ define "main" }}
<section class="section">
  <h1>{{ .Title }}</h1>
  <p class="label">{{ len .Pages }} {{ if eq (len .Pages) 1 }}entry{{ else }}entries{{ end }}</p>

  <div class="logbook-grid">
    {{ range .Pages.ByDate.Reverse }}
    <a href="{{ .RelPermalink }}" class="logbook-card" style="color: inherit; border-bottom: none;">
      {{ with .Params.images }}
      <img src="{{ index . 0 | printf "/images/%s" | relURL }}" alt="{{ $.Title }}" class="logbook-card__image">
      {{ end }}
      <div class="logbook-card__body">
        <p class="logbook-card__date">
          <time datetime="{{ .Date.Format "2006-01-02" }}">{{ .Date.Format "2 Jan 2006" }}</time>
          {{ with .Params.type }}· <span class="label">{{ . }}</span>{{ end }}
        </p>
        <h3 class="logbook-card__title">{{ .Title }}</h3>
        <p class="logbook-card__summary">{{ .Params.summary }}</p>
      </div>
    </a>
    {{ end }}
  </div>
</section>
{{ end }}
```

**Step 2: Create logbook single entry template**

Create `layouts/logbook/single.html`:

```html
{{ define "main" }}
{{ with (index .Params.images 0) }}
<img src="{{ . | printf "/images/%s" | relURL }}" alt="{{ $.Title }}" class="entry-hero">
{{ end }}

<article class="section section--narrow">
  <p class="entry-meta">
    <time datetime="{{ .Date.Format "2006-01-02" }}">{{ .Date.Format "2 January 2006" }}</time>
    {{ with .Params.type }}· {{ . }}{{ end }}
  </p>
  <h1>{{ .Title }}</h1>
  <div class="entry-content">
    {{ .Content }}
  </div>

  {{ with .Params.images }}
  {{ if gt (len .) 1 }}
  <div style="margin-top: 2rem;">
    {{ range (after 1 .) }}
    <img src="{{ . | printf "/images/%s" | relURL }}" alt="" style="width: 100%; margin-bottom: 1.5rem;">
    {{ end }}
  </div>
  {{ end }}
  {{ end }}
</article>
{{ end }}
```

**Step 3: Create logbook index content**

Create `content/logbook/_index.md`:

```markdown
---
title: "Logbook"
---
```

**Step 4: Create a sample logbook entry for testing**

Create `content/logbook/2025-06-21-midsummer-sail.md`:

```markdown
---
title: "Midsummer Sail to Hanko"
date: 2025-06-21
type: trip
images:
  - gallery/hero.jpg
summary: "First overnight of the season. Light SW winds, perfect conditions."
---

Departed Helsinki at 0800 in light southwesterly winds. The forecast promised 5–8 m/s building through the afternoon — perfect for the Express.

Made good time through the archipelago, averaging 5.5 knots on a beam reach. Anchored in Hanko's eastern harbour by 1600.

## Conditions

- Wind: SW 5–8 m/s
- Sea state: slight
- Temperature: 18°C
```

**Step 5: Verify with hugo server**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo server`

Expected: `/logbook/` shows the grid with one card. Clicking the card opens the single entry with hero image, metadata, and content.

**Step 6: Commit**

```bash
git add layouts/logbook/ content/logbook/
git commit -m "feat: add logbook list and single entry templates"
```

---

### Task 6: Documentation Layout & Templates

**Files:**
- Create: `layouts/docs/list.html`
- Create: `layouts/docs/single.html`
- Create: `content/docs/_index.md`
- Create: `content/docs/rigging.md` (sample)

**Step 1: Create docs list (landing) template**

Create `layouts/docs/list.html`:

```html
{{ define "main" }}
<div class="docs-layout">
  <aside class="docs-sidebar">
    <p class="docs-sidebar__title">Documentation</p>
    <ul>
      {{ range .Pages }}
      <li><a href="{{ .RelPermalink }}">{{ .Title }}</a></li>
      {{ end }}
    </ul>
  </aside>
  <div class="docs-content">
    <h1>{{ .Title }}</h1>
    {{ .Content }}
    <ul style="margin-top: 1.5rem; list-style: none;">
      {{ range .Pages }}
      <li style="margin-bottom: 0.75rem;">
        <a href="{{ .RelPermalink }}">{{ .Title }}</a>
        {{ with .Params.summary }}<br><span style="font-size: 0.85rem; color: var(--color-teal);">{{ . }}</span>{{ end }}
      </li>
      {{ end }}
    </ul>
  </div>
</div>
{{ end }}
```

**Step 2: Create docs single page template**

Create `layouts/docs/single.html`:

```html
{{ define "main" }}
<div class="docs-layout">
  <aside class="docs-sidebar">
    <p class="docs-sidebar__title">Documentation</p>
    <ul>
      {{ range .CurrentSection.Pages }}
      <li>
        <a href="{{ .RelPermalink }}"{{ if eq $.RelPermalink .RelPermalink }} style="color: var(--color-accent); font-weight: 600;"{{ end }}>{{ .Title }}</a>
      </li>
      {{ end }}
    </ul>
  </aside>
  <div class="docs-content">
    <h1>{{ .Title }}</h1>
    {{ .Content }}
  </div>
</div>
{{ end }}
```

**Step 3: Create docs index content**

Create `content/docs/_index.md`:

```markdown
---
title: "Documentation"
---

Everything you need to know to sail, maintain, and enjoy this Albin Express. Written from years of hands-on experience.

Start with the section that's most relevant to you, or read through from top to bottom before your first sail.
```

**Step 4: Create a sample docs page**

Create `content/docs/rigging.md`:

```markdown
---
title: "Rigging"
weight: 1
summary: "Standing and running rigging, sail handling, mast setup"
---

## Standing Rigging

The Albin Express uses a masthead rig with single swept-back spreaders.

### Forestay

- Length: X mm
- Wire: 6mm 1x19

### Shrouds

- Upper shrouds: 5mm 1x19
- Lower shrouds: 4mm 1x19

## Running Rigging

### Main Halyard

Runs internally through the mast. If it jams, check the sheave at the masthead.

### Jib Sheets

Led through blocks on the toerail. Adjust fairlead position based on jib size:
- Genoa: fairlead forward
- Working jib: fairlead aft
```

**Step 5: Verify with hugo server**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo server`

Expected: `/docs/` shows sidebar with "Rigging" link. Clicking it shows the docs page with sidebar still visible and active item highlighted.

**Step 6: Commit**

```bash
git add layouts/docs/ content/docs/
git commit -m "feat: add documentation layout with sidebar navigation"
```

---

### Task 7: GitHub Pages Deployment

**Files:**
- Create: `.github/workflows/deploy.yml`

**Step 1: Create GitHub Actions workflow**

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: "0.143.0"
    steps:
      - uses: actions/checkout@v4
      - name: Install Hugo
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
          sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: Build
        run: hugo --minify
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

**Step 2: Create GitHub repo and push**

Run:
```bash
cd /Users/hruoho/Projects/albin-express-experience
gh repo create albin-express-experience --public --source=. --push
```

**Step 3: Enable GitHub Pages**

Run:
```bash
gh api repos/hruoho/albin-express-experience/pages -X POST -f build_type=workflow
```

Or enable Pages via GitHub Settings > Pages > Source: GitHub Actions.

**Step 4: Verify deployment**

Push a change and wait for the Actions workflow to complete.

Run: `gh run list --repo hruoho/albin-express-experience`

Expected: Workflow completes successfully. Site is live at `https://hruoho.github.io/albin-express-experience/`.

**Step 5: Commit**

```bash
git add .github/workflows/deploy.yml
git commit -m "feat: add GitHub Pages deployment workflow"
git push
```

---

### Task 8: Visual Polish & Final Review

**Step 1: Run hugo server and review all pages**

Run: `cd /Users/hruoho/Projects/albin-express-experience && hugo server`

Review checklist:
- [ ] Home page: hero, pricing cards, contact section
- [ ] Logbook list: card grid layout
- [ ] Logbook entry: hero image, metadata, content
- [ ] Docs landing: sidebar + page list
- [ ] Docs page: sidebar with active highlight
- [ ] Language toggle works (EN ↔ FI)
- [ ] Mobile responsive (resize browser)
- [ ] Typography feels right (heading/body/mono contrast)
- [ ] Colors match the Nautical 70s palette

**Step 2: Adjust CSS as needed**

Fine-tune spacing, font sizes, colors based on visual review. This is an iterative step.

**Step 3: Final commit**

```bash
git add -A
git commit -m "feat: visual polish and final adjustments"
git push
```
