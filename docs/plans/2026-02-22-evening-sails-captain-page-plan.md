# Evening Sails & Captain Page — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add evening sailing experiences as a third pricing card on the home page, and create a simple "About the Captain" page.

**Architecture:** Add a third entry to the `pricing` frontmatter array in both language versions of the home page. Add a new `captain` content section with its own list template. Add nav menu items in hugo.toml. No new CSS or JS needed.

**Tech Stack:** Hugo static site generator, TOML config, Go templates, Markdown content

---

### Task 1: Add evening sail pricing card to home page

**Files:**
- Modify: `content/_index.md` (lines 15-30, pricing frontmatter)
- Modify: `content/_index.fi.md` (lines 15-30, pricing frontmatter)

**Step 1: Add evening sail to English frontmatter**

In `content/_index.md`, add a third entry to the `pricing` array, after the Week Charter entry (after line 30):

```yaml
  - label: "Evening Sail"
    title: "Evening Sail"
    price: "€50/person"
    details:
      - "With the captain"
      - "2–3 hours"
      - "Max 4 guests"
```

**Step 2: Add evening sail to Finnish frontmatter**

In `content/_index.fi.md`, add a third entry to the `pricing` array, after the Viikkovuokra entry (after line 30):

```yaml
  - label: "Iltapurjehdus"
    title: "Iltapurjehdus"
    price: "€50/hlö"
    details:
      - "Kipparin kanssa"
      - "2–3 tuntia"
      - "Max 4 vierasta"
```

**Step 3: Add evening sail booking note to home page template**

In `layouts/index.html`, after the existing "Book on Friilo" button (line 115), add a note about evening sail booking. Replace lines 113-115:

```html
  {{ with $.Params.bookingUrl }}
  <p style="margin-top: 1.5rem;"><a href="{{ . }}" class="btn" target="_blank" rel="noopener">{{ if eq $.Lang "fi" }}Varaa Friilosta{{ else }}Book on Friilo{{ end }}</a></p>
  <p style="margin-top: 0.75rem; font-size: 0.9rem;">{{ if eq $.Lang "fi" }}Iltapurjehdukset: varaa Friilosta tai <a href="mailto:{{ $.Site.Params.contactEmail }}">ota suoraan yhteyttä</a>.{{ else }}Evening sails: book on Friilo or <a href="mailto:{{ $.Site.Params.contactEmail }}">get in touch directly</a>.{{ end }}</p>
  {{ end }}
```

**Step 4: Verify locally**

Run: `hugo server`
Expected: Three pricing cards visible on home page (Day Sail, Week Charter, Evening Sail). Check both EN and FI versions. Evening sail note appears below the booking button.

**Step 5: Commit**

```bash
git add content/_index.md content/_index.fi.md layouts/index.html
git commit -m "feat: add evening sail pricing card to home page"
```

---

### Task 2: Add Captain nav item to menus

**Files:**
- Modify: `hugo.toml` (lines 11-39, menu definitions)

**Step 1: Add English menu item**

In `hugo.toml`, after the Logbook menu entry (after line 19) and before the Docs entry, add:

```toml
      [[languages.en.menus.main]]
        name = "Captain"
        pageRef = "/captain"
        weight = 3
```

Then change the existing Docs weight from 3 to 4.

**Step 2: Add Finnish menu item**

After the Lokikirja menu entry (after line 35) and before the Dokumentaatio entry, add:

```toml
      [[languages.fi.menus.main]]
        name = "Kippari"
        pageRef = "/captain"
        weight = 3
```

Then change the existing Dokumentaatio weight from 3 to 4.

**Step 3: Verify locally**

Run: `hugo server`
Expected: Navigation shows four items: Home, Logbook, Captain, Docs (and Finnish equivalents). Captain link goes to `/captain/` (will 404 until Task 3).

**Step 4: Commit**

```bash
git add hugo.toml
git commit -m "feat: add Captain nav menu item (EN + FI)"
```

---

### Task 3: Create Captain page template and content

**Files:**
- Create: `layouts/captain/list.html`
- Create: `content/captain/_index.md`
- Create: `content/captain/_index.fi.md`

**Step 1: Create captain list template**

Create `layouts/captain/list.html`:

```html
{{ define "main" }}
{{ with .Params.image }}
<img src="{{ . | relURL }}" alt="{{ $.Title }}" class="entry-hero">
{{ end }}
<section class="section">
  <div class="section--narrow">
    <h1>{{ .Title }}</h1>
    {{ .Content }}
    {{ with .Params.ctaText }}
    <p style="margin-top: 2rem;"><a href="{{ $.Params.ctaUrl }}" class="btn" target="_blank" rel="noopener">{{ . }}</a></p>
    {{ end }}
  </div>
</section>
{{ end }}
```

**Step 2: Create English content**

Create `content/captain/_index.md`:

```markdown
---
title: "The Captain"
image: "images/captain/captain.jpg"
ctaText: "Book an Evening Sail"
ctaUrl: "https://www.friilo.fi/venevuokraus/albin/express/4863"
---

_Captain bio coming soon. Add a paragraph or two about yourself, your sailing background, and why you do this._
```

**Step 3: Create Finnish content**

Create `content/captain/_index.fi.md`:

```markdown
---
title: "Kippari"
image: "images/captain/captain.jpg"
ctaText: "Varaa iltapurjehdus"
ctaUrl: "https://www.friilo.fi/venevuokraus/albin/express/4863"
---

_Kipparin esittely tulossa. Kirjoita kappale tai pari itsestäsi, purjehdustaustastasi ja miksi teet tätä._
```

**Step 4: Create placeholder image directory**

```bash
mkdir -p static/images/captain
```

The user will add their photo later to `static/images/captain/captain.jpg`.

**Step 5: Verify locally**

Run: `hugo server`
Expected: `/captain/` page renders with placeholder text. Image will be broken until user adds photo (that's fine). CTA button links to Friilo. Finnish version at `/fi/captain/`. Language toggle works between EN and FI.

**Step 6: Commit**

```bash
git add layouts/captain/list.html content/captain/_index.md content/captain/_index.fi.md
git commit -m "feat: add Captain page with placeholder content"
```
