# Sprint 2 Requirement — Intelligence Drawer

## Status
Implementation requirement for Project Atlas Sprint 2.

## Goal
Keep users inside the News Desk while they review a structured intelligence record, then allow an explicit choice to open a verified original source in a new tab.

## Functional requirements
- News records are structured demonstration data with unique IDs and the required source, analysis, relationship, recommendation, notes, and bookmark fields.
- Selecting an article opens one reusable right-side dialog without navigating away from Atlas.
- Category filters continue to operate.
- The drawer closes by its close control, Escape, or backdrop selection.
- Focus enters the drawer when opened and returns to the selected article when closed.
- Chair Notes and Bookmark persist only in `sessionStorage`.
- Original-source links use a new tab with `noopener noreferrer`; records without a verified URL show a disabled pending-verification state.

## Governance constraints
- All Sprint 2 article records are clearly labeled demonstration data.
- No live news, regulatory status, citations, or methodology changes are introduced.
- Human review remains mandatory for Board recommendations and methodology decisions.

## Acceptance criteria
- All required drawer fields render for the selected article.
- Article IDs are unique and map to the correct drawer content.
- Keyboard, Escape, focus return, backdrop, scroll lock, notes, and bookmark behaviors work.
- Existing 12 workspace routes, nine overview-card routes, sidebar navigation, and News Desk filters remain intact.
- Layout remains usable at 1440px, 1024px, and 768px.
- No console errors or unsafe outbound-link attributes are present.
