# Evening Sails & Captain Page — Design

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add evening sailing experiences as a third offering on the home page, and a simple "About the Captain" page for trust.

**Architecture:** Minimal additions to existing Hugo site — one new pricing card in home page frontmatter, one new content section (`/captain/`), one new nav item. No new CSS or JS needed.

## Evening Sail — Home Page Pricing Card

Add a third card to the existing pricing grid:

- **Label:** "Evening Sail" (FI: "Iltapurjehdus")
- **Title:** "Evening Sail" (FI: "Iltapurjehdus")
- **Price:** €50/person
- **Details:**
  - "With the captain" (FI: "Kipparin kanssa")
  - "2–3 hours" (FI: "2–3 tuntia")
  - "Max 4 guests" (FI: "Max 4 vierasta")

Below the card grid, add a note distinguishing booking for evening sails: "For evening sails, book on Friilo or get in touch directly." with appropriate links. The existing "Book on Friilo" button remains as-is.

## Captain Page (`/captain/`)

Simple standalone page:

1. **Photo** — full-width hero-style image at top (user provides later)
2. **Bio** — short text, 1-2 paragraphs (user writes later)
3. **CTA** — soft call-to-action linking to Friilo and direct contact

Uses existing `section--narrow` styling. No sidebar. Bilingual with placeholder text until user provides real content.

Template: a simple custom layout or reuse baseof with a narrow section.

Content files: `content/captain/_index.md` + `content/captain/_index.fi.md`

## Navigation

Add "Captain" (FI: "Kippari") to the main menu in `hugo.toml`, positioned between Logbook and Docs.

## What the user provides later

- Captain bio text (EN + FI)
- Captain photo
- Friilo listing URL for evening sails (if separate from existing listing)
