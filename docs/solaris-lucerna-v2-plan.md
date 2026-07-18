# Solaris Lucerna Website V2.0 — Phased Implementation Plan

## Phase 1 — Public foundation and homepage

Status: Implemented for review on `feature/solaris-lucerna-v2`.

- Preserve the static GitHub Pages architecture and legacy Nexus source.
- Establish centralized Solaris Lucerna and LENS configuration.
- Implement the Dark Edition design tokens and selected Light Edition reading section.
- Build the accessible shared header, navigation, mobile menu, footer, buttons, cards, links, focus states, containers, and spacing system.
- Implement the executive-briefing homepage sections.
- Add honest “Coming Soon” resource states and an explicit non-collecting contact preview.
- Add SEO text metadata without inventing a canonical domain or social artwork.
- Document the required standalone hero artwork path.
- Update repository tests for the public entry point while retaining intelligence-data integrity validation.

Review gate: Engineering, Brand, Governance, and Executive review of the homepage and global design system.

## Phase 2 — Interior information architecture

- Implement dedicated Solutions and LENS pages using the approved shared shell.
- Distinguish current LENS capabilities from planned roadmap capabilities.
- Preserve accurate methodology language and avoid unsupported operational claims.
- Determine whether legacy hash routes require redirects or remain available only through the preserved preview entry point.
- Add page-level titles, descriptions, Open Graph metadata, and heading validation.

Review gate: Confirm service taxonomy, LENS capability status, and route strategy.

## Phase 3 — Resources, About, and Contact

- Implement reusable resource collections and detail/download patterns.
- Add only approved publications; retain “Coming Soon” states otherwise.
- Implement About using verified mission, vision, company, founder, and history content.
- Select and integrate an approved contact backend before adding a live form.
- Provide accessible validation, success, error, privacy, and data-retention behavior.

Review gate: Approve factual company content, contact destination, privacy language, and publication inventory.

## Phase 4 — Production assets and launch readiness

- Add the approved standalone cinematic hero artwork, favicon, and social-preview image.
- Add licensed local Poppins and Montserrat font files with optimized loading.
- Confirm the production domain and canonical URL strategy.
- Add responsive image sources and size metadata.
- Complete keyboard, screen-reader, zoom, contrast, reduced-motion, and mobile review.
- Run Lighthouse and address material performance, accessibility, SEO, and layout-shift findings.
- Validate GitHub Pages deployment from a review environment without merging or deploying prematurely.

## Decisions required before later phases

1. Approved standalone hero, favicon, and social-preview assets.
2. Licensed font files or approved external font-hosting policy.
3. Production domain and canonical URL.
4. Verified company/founder content for About.
5. Contact email, form provider/backend, privacy notice, and retention policy.
6. Approved publication inventory and download files.
7. Confirmed current-versus-planned LENS capability matrix.
