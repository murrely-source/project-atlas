# ECR-003 — Dark / Light Theme Switching

## Status
Approved implementation requirement for Solaris Nexus.

## Goal
Allow users to switch immediately between the approved dark presentation and a Solaris-aligned light presentation without changing layout, content, navigation, workspace, filters, drawer state, notes, or bookmarks.

## Functional requirements
- Provide keyboard-accessible Dark and Light controls in the global header with visible text, icons, and `aria-pressed` state.
- Default first-time and invalid stored preferences to Dark.
- Store the selected value under `localStorage` key `solaris-nexus-theme` and restore it before the interface renders.
- Apply the normalized theme through `data-theme` on the document root.
- Theme changes must not reload the page or reconstruct application state.

## Design requirements
- Use shared semantic CSS custom properties rather than duplicate component styles.
- Preserve Deep Solaris Blue, Electric Blue, Solaris Magenta, Solaris Violet, Near Black, Dark Slate, and Soft White according to the approved Brand Guide.
- Use Deep Solaris Blue for normal interactive text on light surfaces where Electric Blue does not provide sufficient contrast.
- Keep the approved Solaris symbol asset unchanged and do not apply image filters.

## Acceptance criteria
- Dark is the first-use and invalid-value fallback.
- Both theme controls update the interface and assistive state immediately.
- The selection persists through reload.
- Page, header, sidebar, cards, tables, inputs, buttons, badges, charts, and Intelligence Drawer consume shared tokens.
- Existing 12 workspace routes, nine overview routes, filters, articles, drawer behavior, notes, and bookmarks remain intact.
- Both themes receive visual review at 1440px, 1024px, and 768px.
- No console errors are introduced.
