# Project Aurora — Phase 1 Repository Audit

Date: 2026-07-18  
Branch: `feature/project-aurora`

## Executive finding

The repository is a dependency-free static website and preserved internal intelligence prototype. Its architecture is usable and does not justify a framework migration. Project Aurora should refine the public Solaris Lucerna entry point while keeping the governed prototype, data, tests, and GitHub Pages boundary intact.

## Architecture summary

- **Framework:** None; semantic HTML, CSS, and browser JavaScript.
- **Languages:** HTML5, CSS, JavaScript, and Ruby test scripts.
- **Package manager and build:** None. GitHub Pages publishes `app/` directly.
- **Public entry point:** `app/index.html`, supported by `site.css`, `site.js`, and centralized `brand-config.js`.
- **Preserved internal application:** `app/nexus-preview.html`, supported by the original application styles, scripts, and governed intelligence dataset.
- **Routing:** In-page anchors for the Phase 1 public website; JavaScript-managed workspaces in the preserved internal preview.
- **Deployment:** GitHub Actions publishes only `app/` from `main`.

## Component hierarchy

The public website uses reusable patterns for its wordmark, primary/footer navigation, mobile navigation drawer, page containers, headings, buttons, solution cards, resource cards, LENS capability panel, and final call-to-action panel. Content and product identity are separated through `brand-config.js`; behavior remains in `site.js`; presentation remains in `site.css`.

## Asset organization

Public and legacy assets are under `app/assets/`; governed brand references are under `docs/brand/`. The repository contains Solaris Lucerna brand-standard boards but not a standalone approved hero artwork, licensed local Poppins/Montserrat files, favicon, or social-preview image. Repository policy prohibits cropping the brand guide into a production asset, so the hero retains an explicit governed asset handoff rather than substitute artwork.

## Technical debt and opportunities

- The preserved internal HTML is compressed and tightly coupled to global DOM selectors.
- Static tests verify contracts but do not replace browser or assistive-technology testing.
- There is no linter, formatter, type checker, package audit, or production build.
- The site has no responsive-image pipeline because approved standalone imagery is not yet available.
- The public site has no canonical production domain, contact backend, analytics, or approved social metadata image.
- Poppins and Montserrat currently depend on local availability and otherwise use system fallbacks.
- The homepage navigation previously left Home marked current after following another section; Phase 1 now synchronizes the accessible current state with the selected hash.
- The previous hero grid decoration risked an interface-like visual language; Phase 1 replaces it with a restrained atmospheric treatment.

## Accessibility observations

The public site includes semantic landmarks, a single primary heading, a skip link, visible focus states, keyboard-operable navigation, mobile-menu focus containment and restoration, reduced-motion handling, responsive touch targets, and contrast-tested tokens. Manual keyboard, screen-reader, zoom, and device review remains required before production approval.

## Branding and naming disposition

Solaris Lucerna and LENS are centralized for the public website. User-facing public pages do not present the retired Nexus name. Project Atlas, Solaris Nexus, and earlier corporate references remain in DHF records, requirements, changelog history, proprietary notices, and the preserved internal preview because they are governed or historical records. This controlled exception prevents loss of traceability and does not expose the retired name on the public homepage.

## Phase 1 conclusion

The static architecture supports the Project Aurora homepage and shared design system with low operational complexity. Remaining production blockers are approved standalone artwork, licensed font files or an approved font-hosting policy, a confirmed production domain, and human accessibility/brand review.
