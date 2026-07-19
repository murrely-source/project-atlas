# Solaris Lucerna V2 Manual Smoke Test

Run after each public-site UI change.

## Public entry point

- [ ] `app/index.html` opens without a blank page or console errors.
- [ ] The page title and description identify Solaris Lucerna and responsible AI guidance.
- [ ] No user-facing Solaris Nexus, Project Atlas, advisory-name, or legacy website references appear.
- [ ] The wordmark reads **SOLARIS LUCERNA** and the tagline reads **Illuminating Responsible Intelligence**.
- [ ] The primary navigation contains Home, Solutions, LENS, Resources, About, and Contact in that order.
- [ ] Navigation links move to the correct homepage sections without reloading.
- [ ] Every navigation destination aligns beneath the sticky header with the same visual offset; moving through the navigation in order always moves through the page in the same order.
- [ ] The hero includes the approved supporting copy and both approved calls to action.
- [ ] The approved `hero-sunrise.png` artwork spans the full viewport as a seamless hero background without side gutters, distortion, dimming, overlays, filters, or placeholder content.
- [ ] Core Solutions renders five approved categories without pricing or unsupported claims.
- [ ] LENS is expanded as **Lucerna Executive Navigation System** and is described as decision support rather than autonomous judgment.
- [ ] Planned LENS capability language is clearly marked **In development**.
- [ ] Resource cards are marked **Coming Soon** and do not claim nonexistent publications.
- [ ] The contact preview collects no personal information and does not imply a working form integration.
- [ ] The footer contains only the centered two-line copyright statement beneath the existing divider; no duplicate brand lockup or navigation appears.

## Accessibility and interaction

- [ ] Skip link becomes visible on focus and moves to the main content.
- [ ] Use Tab, Shift+Tab, Enter, Space, Escape, and arrow keys where the control pattern supports them; every interactive element is reachable and operable with a visible focus indicator, and no keyboard trap occurs.
- [ ] Heading order is logical and there is one primary `h1`.
- [ ] The mobile menu opens, makes background content unavailable, contains focus, closes by close button, Escape, backdrop, and navigation selection, and returns focus appropriately.
- [ ] Status labels and capability markers do not rely on color alone.
- [ ] At 100%, 125%, 150%, 200%, and 400% zoom, content remains available without overlap, clipping, disappearing focus, or unreachable controls.
- [ ] At the 320 CSS-pixel equivalent, portrait orientation, and landscape orientation, content reflows without page-level horizontal scrolling.
- [ ] User text spacing of 1.5× line height, 2× paragraph spacing, 0.12em letter spacing, and 0.16em word spacing does not clip, overlap, or hide content.
- [ ] Forced Colors mode displays the Hero heading, buttons, links, controls, and focus indicators.
- [ ] A representative screen reader announces the landmarks, heading hierarchy, navigation names and states, mobile dialog, and controls without redundant Hero-artwork output.
- [ ] Reduced-motion preference removes nonessential transitions.

## Responsive and visual review

- [ ] Review at 320px, 375px, 390px, 414px, 768px, 820px, 1024px, 1280px, 1366px, 1440px, 1600px, 1728px, 1920px, and 2560px.
- [ ] Continuously resize between the listed widths and confirm there is no clipping, overlap, disappearing content, unreadable content, or unexpected layout shift.
- [ ] Repeat the public-site review in the latest stable Chrome, Firefox, Safari, and Edge.
- [ ] Observe initial rendering and continuous resizing for avoidable layout shift, delayed content movement, excessive repainting, or unresponsive interaction.
- [ ] At 1280px, 1440px, 1600px, 1728px, and 1920px, `SOLARIS LUCERNA` remains two lines, the final `A` is fully visible, and no horizontal scrollbar appears.
- [ ] At 1280px, 1366px, 1440px, 1600px, 1728px, 1920px, and 2560px, the supporting paragraph and both calls to action remain readable, grouped, fully visible, and clear of the hero boundary.
- [ ] Measure actual rendered foreground and raster-background pixels beneath the Hero text at every required width; normal text is at least 4.5:1 and large text is at least 3:1. Do not substitute token contrast or average image sampling.
- [ ] The hero, solutions, LENS panel, responsible-AI section, resources, CTA, and footer reflow without page-level horizontal scrolling.
- [ ] The Dark Edition remains the primary experience; the Light Edition resources section remains readable and distinctly Solaris Lucerna.
- [ ] No logo, wordmark, or text is stretched, clipped, or too small to read.
- [ ] Poppins and Montserrat render where available; fallback typography remains usable when they are not installed.

## Preserved legacy application

- [ ] `app/nexus-preview.html` remains available for governed internal review.
- [ ] The five governed intelligence records still load through the legacy preview when served over HTTP.
- [ ] The legacy drawer, safe source links, Chair Notes, bookmarks, filters, and responsive behavior remain intact.
