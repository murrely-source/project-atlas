# Changelog

All notable changes to Project Atlas will be documented here.

## [0.21.3] - 2026-07-18
### Changed
- Grouped the homepage hero supporting paragraph and calls to action and moved that group lower at desktop widths using responsive flow spacing.
- Preserved the hero eyebrow, title, tagline, image, typography, button treatment, tablet layout, and mobile layout unchanged.

## [0.21.2] - 2026-07-18
### Fixed
- Corrected the wide-desktop homepage hero grid so the `SOLARIS LUCERNA` heading uses a stable, responsive 48rem copy track instead of a viewport-dependent fractional track that could clip the final glyph.
- Preserved the existing heading scale, two-line treatment, hero artwork, alignment, and navigation while explicitly allowing glyph overflow within the hero copy wrapper.

## [0.21.1] - 2026-07-18
### Changed
- Simplified the public website footer to one centered, two-line copyright and professional-judgment statement.
- Removed the duplicate Solaris Lucerna brand lockup, tagline, footer navigation, and their footer-only layout styles while preserving the existing divider, typography, colors, and responsive behavior.

## [0.21.0] - 2026-07-18
### Fixed
- Replaced the legacy mobile adaptation of `.site-navigation` with a dedicated, deterministic `.mobile-nav-overlay` component.
- Added explicit opaque overlay, label, link, visited-state, selected-state, divider, close-button, SVG, focus, viewport-height, and hidden-state contracts.
- Replaced transform/visibility mobile state transitions with the native `hidden` attribute and direct `aria-expanded`/`aria-hidden` synchronization.

### Governance
- Preserved the existing desktop navigation, centralized navigation data, header dimensions, homepage hero, page content, typography, and all non-navigation sections.

## [0.20.9] - 2026-07-18
### Fixed
- Replaced fragmented mobile navigation color overrides with one menu-scoped `--mobile-navigation-foreground` contract inherited by the heading, links, selected item, and close control.
- Removed the accumulated descendant `!important` rules and explicitly kept the mobile container, list, items, and controls fully opaque.
- Synchronized the existing `is-open` class with `aria-hidden` and inert state so closed-state accessibility behavior cannot remain active after opening.

## [0.20.8] - 2026-07-18
### Fixed
- Overrode the global inactive navigation color for every open mobile-menu label, link, descendant span, close control, and potential SVG path using scoped `!important` contrast declarations.
- Forced full opacity on the open navigation container, list, and list items so no parent state can darken mobile menu content.

## [0.20.7] - 2026-07-18
### Fixed
- Added explicit iPhone Safari text-rendering overrides for the open mobile navigation label, links, selected item, and close control.
- Standardized mobile navigation text on `#F2F6FA` with full opacity, normal blending, no filters or shadows, and current-color WebKit text fill.

## [0.20.6] - 2026-07-18
### Fixed
- Made the mobile navigation a fully opaque, full-viewport deep navy panel with `100vh` and `100dvh` height contracts for iPhone Safari.
- Strengthened the navigation heading, links, dividers, selected state, and close-control contrast.
- Added iOS-safe fixed-body scroll locking and exact scroll-position restoration when the menu closes.

## [0.20.5] - 2026-07-18
### Fixed
- Replaced the mobile navigation drawer's near-black surface with an opaque deep navy background.
- Increased mobile link and close-control contrast and added a clear current-page treatment without changing desktop navigation or menu behavior.

## [0.20.4] - 2026-07-18
### Changed
- Extended the hero artwork across the full viewport width while retaining the existing contained text layout.
- Scaled the background proportionally to `100% auto` so the complete horizontal composition reaches both viewport edges without stretching or cropping the horizon.

## [0.20.3] - 2026-07-18
### Changed
- Integrated the approved sunrise artwork directly into the hero background and removed the separate image component.
- Preserved the complete composition with contained, bottom-centered sizing on the matching solid deep navy background.

## [0.20.2] - 2026-07-18
### Changed
- Removed the frame, border, panel background, padding, rounded corners, shadow, and overlay surrounding the approved homepage hero artwork.
- Matched the hero section to the artwork's near-black deep navy edge so the full uncropped composition blends directly into the page.

## [0.20.1] - 2026-07-18
### Changed
- Replaced the temporary homepage hero-artwork placeholder with the approved `hero-sunrise.png` production asset.
- Preserved the artwork's native 1536×1024 proportions with responsive intrinsic sizing and no cropping, filters, overlays, or animation.

## [0.20.0] - 2026-07-18
### Added
- Added the Project Aurora Phase 1 repository audit, architecture summary, and phased implementation plan.
- Added a calm educational homepage passage that places AI within the longer history of tools extending human capability and explains governance before presenting services.

### Changed
- Replaced the hero's grid-like decoration with a restrained atmospheric treatment aligned with the Solaris Lucerna visual standards.
- Centralized the public typography stacks as design tokens and added a reusable responsive narrative layout.
- Updated the accessible primary-navigation state when visitors move between homepage sections.

### Governance
- Preserved the governed internal preview, intelligence dataset, deployment boundary, and historical naming records unchanged.
- Retained the explicit approved-artwork handoff rather than cropping a brand guide or introducing substitute imagery.
- Kept Phase 2 interior pages, integrations, publications, and unapproved factual content outside this change.

## [0.19.0] - 2026-07-18
### Added
- Added the Solaris Lucerna V2 repository audit and phased implementation plan.
- Added centralized Solaris Lucerna and LENS configuration.
- Added a dependency-free public website design system, accessible shared navigation, and executive-facing homepage.
- Added explicit production-asset guidance for the pending approved cinematic hero artwork.

### Changed
- Changed the GitHub Pages entry point from the Nexus dashboard to the Solaris Lucerna public homepage while preserving the existing static deployment architecture.
- Renamed the Pages workflow for the Solaris Lucerna website preview.
- Updated repository documentation and public-site validation contracts.

### Governance
- Preserved the complete former entry point at `app/nexus-preview.html` and retained its application logic, styles, theme implementation, governed intelligence dataset, and internal engineering references.
- Did not crop the brand-standard boards, invent client claims, add unapproved imagery, fabricate publications, activate unfinished LENS capabilities, or add a non-functional data-collecting contact form.

## [0.18.1] - 2026-07-15
### Changed
- Replaced the three-part application footer with the exact approved statement: **© 2026 Powered by Solaris Labs - Technology for Human-Centered AI**.
- Removed the global header search interface, responsive search presentation, and placeholder search behavior without changing Intelligence Center filters.
- Returned the 768–1100px header to a single identity row and limited the header-tools row to the mobile menu breakpoint.

### Governance
- Preserved the approved four-route navigation, Solaris Labs and Solaris Nexus identity, governed intelligence data, legacy unexposed content, themes, and GitHub Pages-compatible resources.
- Retained prior search-scope information as explicitly unexposed legacy structured data for controlled future extensibility.

## [0.18.0] - 2026-07-15
### Changed
- Simplified the Solaris Nexus primary navigation to Overview, Ask Nexus, Intelligence Center, and Settings.
- Replaced the former dashboard-card Overview with Top AI Headlines, previous-conversation status, and Notifications only.
- Added the Ask Nexus prompt foundation with explicit preview-only, non-connected behavior.
- Consolidated governed news, learning, standards, frameworks, laws, and regulations into one Intelligence Center feed and retained filterable monitoring scope.
- Updated Settings to distinguish the working Theme preference from future Accessibility, Notifications, and Language placeholders.

### Governance
- Preserved all five governed intelligence records unchanged and retained the preliminary-pending-Board-disposition notice.
- Retained former workspace content in the application source without exposing obsolete primary routes, preserving information and future extensibility.

### Validation
- Added an exact four-route navigation regression test and updated smoke, contextual-intelligence, responsive, and manual review contracts.
- Preserved the shared Intelligence Drawer, safe source links, Chair Notes, bookmarks, theme persistence, mobile navigation, global search, approved header identity, and GitHub Pages-compatible relative resources.

## [0.17.8] - 2026-07-14
### Changed
- Increased the Solaris Labs tagline size from 30px to 34.5px while preserving Montserrat Medium (500).
- Reduced tagline tracking from 11px to 8px, keeping its overall width, optical center, wording, and hierarchy effectively unchanged.
- Added controlled Dark and Light v4 lockups and updated the dashboard header references.

### Validation
- Preserved the Solaris monogram, SOLARIS LABS wordmark, colors, backgrounds, overall proportions, header layout, and Solaris Nexus product block.

## [0.17.7] - 2026-07-14
### Changed
- Increased only the **Technology for Human-Centered AI** tagline from Montserrat Regular (400) to Montserrat Medium (500) in both Solaris Labs theme lockups.
- Added versioned Dark and Light v3 production assets and updated the dashboard header references.

### Validation
- Preserved tagline size, tracking, centering, wording, hyphenation, capitalization, and theme colors.
- Preserved the Solaris monogram, SOLARIS LABS wordmark, backgrounds, lockup proportions, header layout, Solaris Nexus product block, and responsive behavior.

## [0.17.6] - 2026-07-14
### Changed
- Updated the global header to use the newly approved Dark and Light Solaris Labs production lockups carrying the **Technology for Human-Centered AI** tagline.
- Updated the grouped logo accessible name and image alternatives to match the approved corporate identity.

### Validation
- Preserved the existing lockup sizing, header alignment, Solaris Nexus product block, responsive behavior, and persisted theme switching.

## [0.17.5] - 2026-07-13
### Changed
- Cropped native-resolution Dark and Light Solaris Labs header lockups from the Chair-approved composite source without resizing or altering the artwork.
- Replaced the standalone monogram and live-text identity with one complete, theme-appropriate Solaris Labs lockup while preserving the Solaris Nexus product block and header behavior.

### Accessibility
- Applied the accessible name **Solaris Labs — Executive Intelligence for Responsible AI** to the consolidated corporate identity and both theme assets.
- Preserved one accessible identity announcement through the grouped image role and excluded the non-active theme asset from presentation with `display: none`.

### Validation
- Preserved lockup proportions with fluid native-resolution images and responsive widths for desktop, tablet, and phone layouts.
- Preserved the approved source image unchanged at `app/assets/brand/solaris-labs-approved-theme-lockups.png`.

## [0.17.4] - 2026-07-13
### Fixed
- Removed duplicate theme-specific monogram elements from the Solaris Labs header identity.
- Replaced the 86px theme assets with the approved 512px transparent monogram at `app/assets/brand/solaris-labs-monogram-transparent-512.png`.
- Retained one live-text Poppins/Montserrat corporate identity block for both Dark and Light themes.

### Accessibility
- Consolidated the monogram and adjacent live text into one accessible Solaris Labs identity announcement while preserving `alt="Solaris Labs"` on the monogram.
- Preserved the existing WCAG AA wordmark and descriptor color tokens in both themes.

### Validation
- Preserved header dimensions, divider placement, product identity, search, mobile navigation, responsive sizing, and persisted theme behavior.

## [0.17.3] - 2026-07-13
### Changed
- Applied the same 4px optical lift to the Dark-theme Solaris Labs monogram.
- Preserved both logo dimensions, lockup spacing, header height, and responsive sizing.

## [0.17.2] - 2026-07-13
### Changed
- Raised only the Light-theme Solaris Labs monogram by 4px to align its optical center with the corporate wordmark.
- Preserved the logo dimensions, lockup gap, header height, responsive sizing, and Dark-theme presentation.

## [0.17.1] - 2026-07-13
### Fixed
- Removed the embedded dark rectangle from the Solaris Labs monogram in Light theme by adding a transparent-background light asset.
- Added explicit theme-aware image switching while preserving the original dark-theme asset unchanged.
- Set both theme-specific logo alternatives to the accessible name **Solaris Labs** without using CSS filters or background images.

### Validation
- Confirmed transparent light-asset corners, preserved 86×83 proportions, unchanged dark-asset checksum, responsive logo sizing, and existing Dark/Light contrast contracts.

## [0.17.0] - 2026-07-13
### Changed
- Updated only the global header corporate identity from Solaris AI Risk & Governance Advisory to **Solaris Labs — Executive Intelligence for Responsible AI**.
- Preserved the **Solaris Nexus — Intelligence Platform** product block, divider, header dimensions, search, navigation, responsive behavior, and theme behavior.
- Added theme-aware corporate wordmark and tagline tokens using the approved Solaris palette and declared Poppins/Montserrat typography with system fallbacks.
- Added a future Solaris Labs ecosystem website and product-switcher item to the Atlas Backlog without implementing either capability.
- Resolved pre-existing README deployment conflict markers to the already-approved Founder’s Preview Pages URL.

### Accessibility
- Updated the approved monogram alternative text to identify Solaris Labs and kept the corporate name and descriptor as live text.
- Added Dark and Light contrast regression coverage for the corporate wordmark and descriptor.

### Governance
- Reused the existing approved Solaris monogram; no advisory logo, substitute mark, cropped guide image, methodology content, navigation, or dashboard behavior was changed.
- Dedicated approved Dark and Light Solaris Labs lockup files and packaged Poppins/Montserrat font files are not present in the repository and remain subject to Brand Review.

## [0.16.0] - 2026-07-12
### Added
- Added the GitHub Pages deployment workflow for the Solaris Nexus Founder’s Preview.
- Added automatic deployment from `main` and authorized manual deployment through GitHub Actions.

### Changed
- Documented the expected Founder’s Preview URL and controlled future deployment process.

### Governance
- The Pages artifact is restricted to `app/`; private engineering documentation, tests, governance files, and other repository-root content are not published.
- No application behavior, intelligence record, theme, navigation, or styling was changed.

## [0.15.0] - 2026-07-12
### Added
- Added the unified ECR-012 Standards & Learning workspace sections for standards, professional organizations, certifications, training and webinars, conferences and events, and publications and guidance.
- Added composable Organization, Content Type, Certification, Status, and Recommendation filters with accessible labels and 44px controls.
- Added Business Impact to the shared Intelligence Drawer and context-aware return labels for originating workspaces.

### Changed
- Renamed Standards Watch to Standards & Learning while preserving the `standards` route.
- Consolidated the separate Learning & Certification Watch into Standards & Learning, returning navigation to 14 unique workspaces.
- Expanded standards feed mapping to support governed standards, guidance, certification, training, webinar, conference, publication, exam, and course metadata.
- Updated the Atlas Backlog entry to ECR-012 Standards & Learning Workspace.

### Governance
- Preserved the single governed dataset and did not invent standards, certification, training, webinar, conference, publication, exam, course, or event updates.
- IAPP AIGP is represented as both part of the professional ecosystem and a tracked certification/learning pathway, without asserting a current update.

## [0.14.0] - 2026-07-12
### Added
- Added ECR-012 reusable Workspace Intelligence Feed components to Intelligence Center, Standards Watch, Regulatory Watch, Human Firewall™ Intelligence, and Learning & Certification Watch.
- Added Learning & Certification Watch as the fifteenth workspace with approved monitoring filters and Solaris learning-roadmap scope, including IAPP AIGP.
- Added contextual mapping tests covering relevant-record inclusion, irrelevant-record exclusion, verified-only presentation, shared drawer behavior, routes, and learning scope.

### Changed
- Extended normalized intelligence records to support optional governed `tags` and `relatedWorkspaces` arrays without changing the source dataset.
- Added the completed ECR-012 implementation to the Atlas Backlog workspace.

### Governance
- Reused the single governed intelligence dataset; no article or learning record was copied or invented.
- Learning & Certification Watch presents an explicit empty state because the current governed dataset contains no matching certification or training record.

## [0.13.0] - 2026-07-12
### Added
- Added ECR-011 **← Return to News Desk** at the top of the reusable Intelligence Drawer.
- Added regression coverage for accessible labeling, visible focus, touch-target sizing, filter preservation, and scroll restoration contracts.

### Changed
- Reused the existing drawer close and focus-restoration path while explicitly returning to the News Desk without navigation or reload.
- Preserved active News Desk filters, scroll position, theme state, and all existing close behaviors.

### Governance
- No intelligence content, methodology, workspace navigation, or interface layout outside the drawer was changed.

## [0.12.0] - 2026-07-12
### Added
- Added a governed-schema normalization boundary that accepts the `items` collection while preserving legacy `articles` support.
- Added array-category rendering in News Desk rows and the Intelligence Drawer.
- Added governed-record, schema-mapping, category-membership, verified-source, and placeholder-removal regression coverage.

### Changed
- Mapped `published`, `url`, `readTime`, and `recommendation` into the stable application fields used by the existing interface.
- Updated category filtering to match any assigned category while retaining legacy single-string support.
- Replaced demonstration labels and the four-record overview count with the approved governed-intelligence language and five-record count.

### Fixed
- Restored News Desk and Intelligence Drawer loading after the governed dataset introduced its approved schema.
- Prevented records explicitly marked unverified from enabling the original-source action.

### Governance
- Did not modify any governed intelligence record or invent additional content.

## [0.11.0] - 2026-07-12
### Added
- Completed Sprint 3 integration validation for every JSON-backed News Desk and Intelligence Drawer field.
- Added regression checks for safe new-tab source links and the disabled pending-verification state.

### Changed
- Clarified that News Desk rows, filters, drawer content, and source actions are populated from `app/data/intelligence.json` at runtime.
- Documented the governance boundary between runtime integration and the dataset's current demonstration classification.

### Governance
- Preserved all existing intelligence records without inventing content or source links.
- Retained `live: false`; the current reserved placeholder URL is not described as verified live intelligence.

## [0.10.0] - 2026-07-12
### Added
- Added the Sprint 3 external intelligence data architecture under `app/data/intelligence.json`.
- Added loader validation for required fields, array shapes, unique article IDs, boolean bookmark state, and HTTPS-only non-null source URLs.
- Added classified graceful handling for missing, malformed, empty, and invalid intelligence datasets.
- Added a dedicated Sprint 3 dataset integrity test covering JSON loading, unchanged records, unique IDs, HTTPS sources, News Desk rendering, and drawer binding.

### Changed
- Refactored `app/data.js` from an embedded intelligence store into the external JSON loader and validator while retaining synchronous workspace, overview, filter, and search configuration.
- Updated News Desk initialization to render validated records asynchronously and preserve the selected category during loading.
- Added an accessible intelligence loading/error state without changing successful News Desk or drawer presentation.
- Documented a local static-server workflow for consistent external JSON loading, with a direct-file request path retained where browser policy permits and selected before `fetch()` to avoid a recoverable console network error.

### Validation
- Confirmed the same four demonstration records and titles were preserved; no intelligence or methodology content was invented or changed.
- Confirmed all 14 workspaces, nine overview routes, themes, responsive behavior, filters, drawer controls, Settings, search interface, notes, bookmarks, and source-link contracts remain intact.

## [0.9.0] - 2026-07-11
### Added
- Added ECR-010 Executive Header & Navigation Refinement.
- Added an accessible semantic global search form with visible-label support, focus states, future-scope metadata, and non-destructive placeholder submission behavior.
- Added responsive global search presentation: full desktop bar, constrained tablet bar, and expandable mobile search with Escape/focus restoration.
- Added Notifications as the fourteenth Solaris Nexus workspace with an explicit non-functional foundation placeholder.

### Changed
- Removed Notifications and Settings icon actions from the global header.
- Kept Notifications and Settings as dedicated workspace navigation items while preserving every existing navigation item and route.
- Updated responsive, smoke, and manual validation contracts for global search and 14 workspaces.

### Validation
- Preserved Settings theme functionality and persistence, all nine overview destinations, responsive navigation, filters, drawer controls, notes, bookmarks, and source links.
- No search engine, indexing, search results, notification delivery, methodology, article content, or dashboard redesign was introduced.

## [0.8.0] - 2026-07-11
### Changed
- Implemented ECR-009 Executive Header Simplification for Solaris Nexus.
- Updated the product subtitle from **The Intelligence Platform** to **Intelligence Platform** in current product-facing identity locations.
- Removed Dark/Light controls from the global header while preserving existing theme selection and `localStorage` persistence exclusively under Settings → Appearance.
- Removed the `Internal — Solaris Use Only` development banner from the header.
- Moved the approved `solarisadvisoryai.com` reference from header metadata to the existing footer brand line.
- Increased spacing between the approved Solaris lockup, divider, and product title without altering the logo or wordmark.

### Added
- Added accessible Search, Notifications, and Settings icon actions to the right side of the global header.
- Added non-destructive live-region placeholder announcements for Search and Notifications.
- Connected the Settings header action to the existing Settings workspace route.

### Validation
- Preserved all 13 workspaces, nine overview routes, theme persistence, responsive navigation, filters, drawer controls, notes, bookmarks, and source links.
- No dashboard, methodology, article, navigation structure, or non-header layout behavior changed.

## [0.7.0] - 2026-07-11
### Added
- Added ECR-008 User Settings Foundation as the thirteenth Solaris Nexus workspace.
- Added an Appearance panel with Dark and Light controls that reuse the existing persisted theme architecture.
- Added non-interactive structural placeholders for future Accessibility, Dashboard, Intelligence, and Account settings.

### Changed
- Extended the existing workspace registry, desktop sidebar, and mobile workspace menu with Settings.
- Added a responsive settings layout designed to accept future approved setting panels without restructuring the workspace.
- Updated smoke, responsive, and manual checks for the new route and synchronized theme controls.

### Validation
- Preserved all existing workspace routes, overview destinations, theme persistence, filters, drawer controls, notes, bookmarks, source links, and responsive behavior.
- No future settings, account functionality, methodology content, backend, or external service was implemented.

## [0.6.0] - 2026-07-11
### Added
- Added ECR-007 as the dedicated Solaris Nexus Accessibility Standard under `docs/standards/ACCESSIBILITY.md`.
- Established WCAG 2.2 AA as the minimum engineering target across software, content, charts, tables, forms, and documents.
- Documented expectations for keyboard-only navigation, screen readers, focus order and indicators, contrast, responsive layouts, touch targets, semantic HTML, tables, charts, forms, PDFs, reduced motion, and both themes.

### Changed
- Updated repository documentation to identify accessibility as a beginning-to-end feature responsibility.
- Confirmed accessibility defects are treated as engineering defects rather than enhancement requests.
- Added `docs/standards/` to the repository map.

### Validation
- Documentation-only standards change; no application content, methodology, navigation, layout, theme, or behavior changed.

## [0.5.0] - 2026-07-11
### Added
- Added ECR-006 repository-wide Engineering Principles for all future Solaris Nexus development.
- Established Human-Centered Design, Accessibility by Design, High Touch / High Tech™, Governance Before Convenience, Quality Over Speed, Evidence Before Opinion, Transparency, Privacy and Security by Design, Modular Architecture, and Continuous Improvement as the core engineering values.
- Established WCAG 2.2 AA as the minimum accessibility engineering standard and defined accessibility issues as engineering defects.

### Changed
- Updated `AGENTS.md` so every coding task must begin by reading `ENGINEERING_PRINCIPLES.md` and `AGENTS.md` in full.
- Established that Engineering Principles take precedence over implementation convenience without overriding DHF decisions, approved requirements, governance authority, or Board approvals.
- Updated repository documentation and the repository map to identify the new mandatory governance document.

### Validation
- Documentation-only governance change; no application content, methodology, navigation, layout, theme, or behavior changed.

## [0.4.0] - 2026-07-11
### Added
- Added ECR-004 responsive behavior for large desktop, desktop/laptop, tablet, and mobile widths from 320px upward.
- Added an accessible off-canvas workspace menu below 768px with close-control, Escape, backdrop, selection-close, scroll-lock, focus containment, and focus-return behavior.
- Added labeled keyboard-focusable horizontal scroll regions around all eight existing data tables.
- Added the ECR-004 requirement record and automated responsive contract checks.

### Changed
- Added fluid header spacing and typography while preserving the approved Solaris lockup and asset proportions.
- Preserved the left sidebar at 768px and above; overview cards now resolve to three, two, or one columns according to available width.
- Increased critical navigation, theme, filter, table-action, drawer, bookmark, and source controls toward the practical 44px touch target.
- Expanded the Intelligence Drawer to full mobile width and refined phone spacing without changing drawer behavior.
- Extended reduced-motion handling to mobile navigation transitions.

### Validation
- Confirmed all 12 workspaces, nine overview routes, four demonstration articles, filters, drawer controls, notes, bookmarks, source links, and both theme contracts remain covered.
- Confirmed all core theme contrast checks continue to pass.
- No methodology, article content, workspace, route, or navigation structure was removed or renamed.

## [0.3.0] - 2026-07-11
### Added
- Added ECR-003 Dark / Light Theme Switching for Solaris Nexus.
- Added accessible Dark and Light header controls with icons, text, selected-state semantics, and visible focus treatment.
- Added first-use Dark default, invalid-value fallback, and browser-local persistence under `solaris-nexus-theme`.
- Added an ECR-003 requirement record and automated core WCAG contrast checks.

### Changed
- Refactored existing component colors into shared semantic design tokens for page, header, sidebar, cards, panels, tables, inputs, buttons, badges, charts, and the Intelligence Drawer.
- Added a Solaris-aligned light palette using Soft White/light neutrals, Deep Solaris Blue structure, and controlled Electric Blue, Magenta, and Violet accents.
- Adjusted tablet header wrapping to accommodate the theme control without changing navigation or workspace layout.

### Validation
- Confirmed core normal-text token pairs meet or exceed the WCAG AA 4.5:1 contrast target.
- Preserved all 12 workspaces, nine overview routes, News Desk filters, article links, drawer controls, notes, bookmarks, navigation, methodology, and content.

## [0.2.1] - 2026-07-11
### Changed
- Applied ADR-001 public product naming across product-facing UI and appropriate public repository language.
- The public product is now presented as **Solaris Nexus: The Intelligence Platform**.
- Preserved **Project Atlas** as the internal engineering codename throughout DHF, architecture, sprint, requirements, and engineering contexts.
- No functionality, navigation, methodology names, or structured behavior changed.

## [0.2.0] - 2026-07-11
### Added
- Added a reusable, accessible right-side Intelligence Drawer for News Desk articles.
- Added four clearly labeled structured demonstration article records with governance metadata, summaries, relationships, recommendations, evidence quality, notes, and bookmark state.
- Added session-only Chair Notes and Bookmark persistence.
- Added guarded original-source behavior with safe new-tab attributes and a pending-verification state.
- Added the Sprint 2 Intelligence Drawer requirement and expanded automated/manual validation coverage.

### Changed
- News Desk article rows are now keyboard-accessible drawer triggers while preserving existing titles, summaries, recommendations, and category filters.
- Corrected the overview News Desk count and removed unverified source-name attribution so it accurately describes the four demonstration records.

### Validation
- Existing 12 workspace routes, nine overview destinations, sidebar navigation, assets, and data-separation checks remain covered.
- No Solaris methodology content or live intelligence was added.

## [0.1.1] - 2026-07-11
### Changed
- Separated the prototype's HTML, CSS, JavaScript, and routing data into focused application files.
- Preserved the existing interface, workspace content, navigation, overview-card destinations, and news filtering.
- Corrected the Solaris symbol path to use the approved asset under `app/assets/`.
- Added documented automated and manual local smoke-test processes.

### Validation
- Added static checks for workspace routes, overview-card destinations, local assets, separated resources, and the approved website.
- No methodology content or prototype data was changed.

## [0.1.0] - 2026-07-11
### Added
- Codex-ready repository structure.
- Current clickable executive-overview prototype.
- AGENTS.md governance instructions.
- Solaris Skills Library.
- MVP requirements and acceptance criteria.
- Brand and DHF reference folders.

### Notes
- Existing dashboard data may include clearly labeled prototype values.
- No methodology changes were made during repository initialization.
