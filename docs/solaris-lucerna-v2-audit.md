# Solaris Lucerna Website V2.0 — Repository Audit

Date: 2026-07-18  
Branch: `feature/solaris-lucerna-v2`

## Executive finding

This repository was not a Solaris Lucerna public website at the start of this work. It was the static Solaris Nexus Founder’s Preview, internally engineered as Project Atlas. The existing deployment infrastructure is usable, but its interface, routes, content model, and tests were designed for an internal intelligence application rather than a public advisory website.

The V2 approach therefore preserves the dependency-free static architecture, GitHub Pages workflow, governed intelligence dataset, loader, legacy application source, and accessibility practices while introducing a separate public-site entry point and shared design system.

## Architecture discovered

- **Framework:** None. The application is dependency-free static HTML, CSS, and browser JavaScript.
- **Languages:** HTML5, CSS, JavaScript; Ruby is used for repository tests.
- **Package manager:** None. There is no `package.json`, lockfile, Bundler configuration, or vendored dependency tree.
- **Build system:** None. GitHub Pages publishes `app/` directly; there is no compile, bundle, or optimization stage.
- **Data:** Governed intelligence is stored in `app/data/intelligence.json` and normalized by `app/data.js`.
- **Runtime storage:** Browser `localStorage` for the legacy theme and `sessionStorage` for legacy article notes/bookmarks.

## Page and routing structure before V2

The public entry point was `app/index.html`, implemented as a single-page workspace shell. JavaScript toggled four primary workspace sections:

1. Overview
2. Ask Nexus
3. Intelligence Center
4. Settings

Older News Desk, Human Firewall™, Standards & Learning, Regulatory Watch, Progress, Backlog, Documents, Board Queue, DHF, Skills, and Notifications sections remained in the HTML but were not primary routes. Routing used `data-page` and `data-open-page` attributes rather than URLs or a router.

For traceability, the original entry point is now retained at `app/nexus-preview.html` and continues to use the original `styles.css`, `theme-init.js`, `data.js`, and `app.js` files. The new public homepage uses `site.css`, `brand-config.js`, and `site.js`.

## Existing component hierarchy

The legacy application had no component framework. Reusable behavior was expressed through DOM functions for workspace navigation, filters, article triggers, contextual intelligence feeds, theme controls, mobile navigation, and the Intelligence Drawer.

The new public-site shell establishes reusable static component patterns for:

- Corporate wordmark
- Primary and footer navigation
- Page container and section heading
- Buttons and text links
- Solution cards
- Resource cards
- LENS capability panel
- Mobile navigation drawer and backdrop
- Final call-to-action panel

## Styling and themes

The legacy interface used CSS custom properties with persisted Dark and Light application themes. The public V2 design system uses the Dark Edition as the primary experience and applies a controlled Light Edition to the resources section. It does not expose a theme toggle.

V2 tokens include Deep Midnight Navy, Deep Solaris Blue, Atmospheric Cyan, restrained Solaris Magenta, Warm Sunrise Gold, Soft White, shared surface/border/focus tokens, responsive spacing, and reusable container widths.

Poppins and Montserrat are declared as the preferred font families. Licensed local font files are not present, so the implementation currently falls back to system fonts when those families are unavailable.

## Brand assets

Production assets are under `app/assets/` and `app/assets/brand/`. They consist primarily of Solaris Labs and legacy Solaris identity files. Reference material is under `docs/brand/`.

Two Solaris Lucerna brand-standard boards exist under `docs/brand/Standards/`, but that directory was untracked at audit time and has not been modified. The boards show the approved cinematic sunrise-and-horizon signature, typography, palette, and usage guidance.

No standalone approved Solaris Lucerna hero artwork, favicon, social-preview image, or licensed Poppins/Montserrat font files were found. Repository governance prohibits cropping a guide board into a production asset. The required hero path is documented in `app/assets/brand/README.md`.

## Deployment

`.github/workflows/deploy-pages.yml` deploys only `app/` to GitHub Pages on pushes to `main` and by manual dispatch. It uses official Pages actions and the required `contents: read`, `pages: write`, and `id-token: write` permissions. The V2 work preserves this artifact boundary and does not deploy repository-root governance or test files.

No production domain or approved canonical URL for Solaris Lucerna is present. The existing README references the Project Atlas GitHub Pages URL, so no canonical tag has been invented.

## Forms, integrations, analytics, and SEO

- No functional public contact form or backend integration exists.
- The legacy Ask Nexus form is a non-connected placeholder.
- No analytics implementation was found.
- No CRM, email, scheduling, API, or form-service integration was found.
- The prior entry point contained only a title and viewport metadata.
- V2 adds page title, description, Open Graph text metadata, Twitter text metadata, and theme color.
- A favicon, canonical URL, Open Graph image, and social-preview image remain pending approved assets and production-domain decisions.

## Technical debt and risks

- The legacy HTML is highly compressed and difficult to maintain.
- Legacy JavaScript relies on global DOM queries and string-coupled selectors.
- Many tests are static string-contract checks rather than browser behavior tests.
- There is no linter, formatter, type checker, dependency audit, or production build.
- There is no image optimization pipeline or responsive-image generation.
- The README contains material that describes earlier Nexus workspaces and behavior.
- Legacy theme storage uses the key `solaris-nexus-theme`.
- Old Solaris Labs, advisory, Project Atlas, and Nexus references remain intentionally in governed engineering records and the preserved legacy application.
- Existing tests for the Nexus interface require revision or separation from public-site tests; the intelligence dataset integrity test remains applicable unchanged.
- The approved hero artwork and font files are not production-ready repository assets.

No dependency vulnerabilities or outdated packages can be reported because the repository contains no package dependencies. GitHub Action version currency was not independently verified during this local audit.

## Branding occurrence disposition

Occurrences of **Project Atlas**, **Solaris Nexus**, **Nexus**, **Solaris AI Risk & Governance Advisory**, and `solarisadvisoryai.com` were found across:

- Governance documents (`AGENTS.md`, `ENGINEERING_PRINCIPLES.md`, DHF-related requirements)
- Repository and deployment documentation
- Legacy application source and tests
- Roadmap and prompt-pattern documentation
- Proprietary notice

These internal, historical, governance, and traceability references are not blindly renamed. Public V2 naming is centralized in `app/brand-config.js`, and the new `app/index.html` presents only Solaris Lucerna and LENS. The preserved legacy application remains clearly separated at `app/nexus-preview.html`.

## Accessibility findings

Positive existing practices included native controls, focus states, dialog semantics, mobile-menu focus management, contained table scrolling, reduced-motion support, and automated contrast checks.

V2 carries forward semantic landmarks, a skip link, keyboard-operable navigation, focus trapping and restoration, visible focus indicators, non-color status labels, reduced-motion handling, and responsive touch targets. Browser and assistive-technology review is still required before release.

## Baseline conclusion

The static architecture is suitable for the first V2 phase and does not justify a framework migration. The main constraints are missing approved production artwork/fonts, absence of public-site integrations, and tests/documentation that remain oriented toward the preserved Nexus prototype.
