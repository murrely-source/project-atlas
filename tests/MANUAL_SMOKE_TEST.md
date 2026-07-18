# Solaris Lucerna V2 Manual Smoke Test

Run after each public-site UI change.

## Public entry point

- [ ] `app/index.html` opens without a blank page or console errors.
- [ ] The page title and description identify Solaris Lucerna and responsible AI guidance.
- [ ] No user-facing Solaris Nexus, Project Atlas, advisory-name, or legacy website references appear.
- [ ] The wordmark reads **SOLARIS LUCERNA** and the tagline reads **Illuminating Responsible Intelligence**.
- [ ] The primary navigation contains Home, Solutions, LENS, Resources, About, and Contact in that order.
- [ ] Navigation links move to the correct homepage sections without reloading.
- [ ] The hero includes the approved supporting copy and both approved calls to action.
- [ ] The hero artwork area is clearly labeled as pending and does not display cropped guide imagery, stock art, or generated substitute artwork.
- [ ] Core Solutions renders five approved categories without pricing or unsupported claims.
- [ ] LENS is expanded as **Lucerna Executive Navigation System** and is described as decision support rather than autonomous judgment.
- [ ] Planned LENS capability language is clearly marked **In development**.
- [ ] Resource cards are marked **Coming Soon** and do not claim nonexistent publications.
- [ ] The contact preview collects no personal information and does not imply a working form integration.
- [ ] The footer navigation and brand identity are legible and accurate.

## Accessibility and interaction

- [ ] Skip link becomes visible on focus and moves to the main content.
- [ ] Every interactive element is reachable by keyboard with a visible focus indicator.
- [ ] Heading order is logical and there is one primary `h1`.
- [ ] The mobile menu opens, contains focus, closes by close button, Escape, backdrop, and navigation selection, and returns focus appropriately.
- [ ] Status labels and capability markers do not rely on color alone.
- [ ] At 200% and 400% zoom, content remains available without overlap or clipped controls.
- [ ] Reduced-motion preference removes nonessential transitions.

## Responsive and visual review

- [ ] Review at 1440px, 1024px, 768px, 390px, and 320px.
- [ ] The hero, solutions, LENS panel, responsible-AI section, resources, CTA, and footer reflow without page-level horizontal scrolling.
- [ ] The Dark Edition remains the primary experience; the Light Edition resources section remains readable and distinctly Solaris Lucerna.
- [ ] No logo, wordmark, or text is stretched, clipped, or too small to read.
- [ ] Poppins and Montserrat render where available; fallback typography remains usable when they are not installed.

## Preserved legacy application

- [ ] `app/nexus-preview.html` remains available for governed internal review.
- [ ] The five governed intelligence records still load through the legacy preview when served over HTTP.
- [ ] The legacy drawer, safe source links, Chair Notes, bookmarks, filters, and responsive behavior remain intact.
