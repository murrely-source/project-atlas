# ECR-004 — Responsive Layout

## Status
Approved implementation requirement for Solaris Nexus.

## Goal
Keep the complete Solaris Nexus interface usable across large desktop, desktop/laptop, tablet, and mobile widths without changing approved content, navigation structure, methodology, routes, or product behavior.

## Supported ranges
- Large desktop: 1440px and above.
- Desktop/laptop: 1024px–1439px.
- Tablet: 768px–1023px.
- Mobile: 320px–767px.

## Functional requirements
- Preserve the left sidebar at 768px and above.
- At 767px and below, expose the same workspace navigation through an accessible off-canvas menu.
- The mobile menu closes by its control, Escape, backdrop, or workspace selection and returns focus to the menu control when appropriate.
- Menu actions must not change the active workspace except when a workspace is explicitly selected.
- Preserve Dark/Light theme behavior and all Intelligence Drawer, filter, note, bookmark, and source-link behavior.

## Layout requirements
- Use one fluid application DOM with CSS media queries; no separate mobile application or duplicated page.
- Render overview cards in three, two, or one columns as space permits.
- Keep wide tables inside labeled, keyboard-focusable horizontal scroll regions without truncating data.
- Prevent page-level horizontal overflow and keep charts within their cards.
- Maintain practical 44px touch targets for critical controls.
- Keep the Intelligence Drawer right-sided on desktop and full-width on mobile, with independently scrolling content and a persistent close control.
- Respect reduced-motion preferences.

## Acceptance criteria
- All 12 workspaces and nine overview destinations remain reachable at every target width.
- Mobile menu open, close, Escape, backdrop, selection, `aria-expanded`, scroll lock, and focus-return contracts are present.
- No page-level horizontal overflow is introduced.
- Both themes remain operable at 1440px, 1024px, 768px, 390px, and 320px.
- Existing article, filter, drawer, note, bookmark, source-link, and theme regressions pass.
- No console errors are introduced.
