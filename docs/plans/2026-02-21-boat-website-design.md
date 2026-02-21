# Albin Express Experience — Website Design

## Overview

A static marketing + documentation website for a 1990 Albin Express sailing boat. Serves dual purpose: charter rental marketing and potential sale, combined with a self-service owner's manual for renters/buyers.

Hosted on GitHub Pages, built with Hugo.

## Site Architecture

Three sections forming a trinity:

| Section | URL | Purpose |
|---------|-----|---------|
| **Home / Charter** | `/` | Landing page: hero image, boat intro, charter rates, purchase price, contact |
| **Logbook** | `/logbook/` | Trip stories with photos + maintenance records. Serves as the experiential gallery |
| **Documentation** | `/docs/` | Owner's manual: rigging, engine, electrical, plumbing, quirks, winter storage |

### Bilingual Support

Simple language toggle (FI/EN) in header. Content duplicated as `_index.md` / `_index.fi.md`. Hugo's built-in multilingual mode, kept minimal.

### Navigation

Minimal top bar: site name/logo, three section links, language toggle.

## Visual Identity — "Nautical 70s"

### Color Palette

| Role | Hex | Reference |
|------|-----|-----------|
| Background | `#F5F0E8` | Aged paper, old sail cloth |
| Primary text | `#1B2838` | Classic nautical dark |
| Accent warm | `#C4652A` | Burnt orange — 70s sunset |
| Accent muted | `#D4A843` | Mustard gold — brass fittings |
| Secondary bg | `#5B8A8A` | Faded teal — weathered hull paint |
| Subtle | `#D9CFBD` | Sand — borders, dividers |

### Typography

- **Headings:** Chunky serif — Libre Baskerville or Playfair Display. Bold, editorial, sailing magazine feel.
- **Body:** Clean sans — Source Sans 3 or Inter.
- **Accents/labels:** Monospace — IBM Plex Mono in small caps. Logbook/technical manual feel.

### Photography Treatment

Manually edited photos targeting:
- Slightly desaturated, warm-shifted tones
- Lifted blacks (faded film look)
- Subtle grain
- Kodachrome slides aesthetic

### Layout Principles

- Generous whitespace
- Full-bleed hero images on home page and logbook entries
- Text in narrow readable column (~650px max)
- Cards for logbook list: photo + date + title + teaser
- Docs: left sidebar nav, content area right
- Subtle paper/linen CSS texture on background
- Thin 1px sand-colored rules as dividers
- Flat, printerly — no drop shadows
- Albin Express profile silhouette as recurring motif

### Footer

Minimal: boat name, Albin Express class line, contact email, boat silhouette.

## Content Structure

```
albin-express-experience/
├── content/
│   ├── _index.md / _index.fi.md       # Home page
│   ├── logbook/
│   │   ├── _index.md                   # Logbook list
│   │   ├── 2025-07-midsummer-sail.md   # Trip entries
│   │   └── 2025-09-haul-out.md         # Maintenance entries
│   └── docs/
│       ├── _index.md                   # Docs landing
│       ├── rigging.md
│       ├── engine.md
│       └── electrical.md
├── static/images/
│   ├── gallery/                        # Hero & general photos
│   ├── logbook/                        # Per-entry photos
│   └── docs/                           # Diagrams, reference photos
├── layouts/                            # Custom Hugo templates
├── assets/css/                         # Styles
├── hugo.toml                           # Config
└── .github/workflows/deploy.yml        # GitHub Pages CI
```

### Logbook Entry Format

```yaml
---
title: "Midsummer Sail to Hanko"
date: 2025-06-21
type: trip        # or "maintenance"
images:
  - logbook/2025-midsummer-1.jpg
  - logbook/2025-midsummer-2.jpg
summary: "First overnight of the season. Light SW winds."
---
```

### Content Workflow

1. Write markdown, drop photos in `static/images/`
2. Push to `main` — GitHub Actions builds and deploys

## Explicitly Out of Scope

- No CMS or admin panel
- No search
- No comments or social features
- No analytics (can add later)
- No JavaScript beyond language toggle

## Technical Stack

- **Generator:** Hugo
- **Hosting:** GitHub Pages
- **CI:** GitHub Actions
- **Fonts:** Google Fonts (Libre Baskerville / Playfair Display, Source Sans 3 / Inter, IBM Plex Mono)
- **Media:** Static assets in repo
