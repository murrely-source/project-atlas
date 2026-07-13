# Solaris Nexus

**Solaris Nexus: Intelligence Platform** is the public product name for the internal engineering platform developed under the codename **Project Atlas** by Solaris AI Risk & Governance Advisory.

## Current status
Codex-ready repository initialized from the approved clickable dashboard prototype.

## Founder’s Preview deployment

The expected GitHub Pages URL is [https://murrely-source.github.io/project-atlas/](https://murrely-source.github.io/project-atlas/).

The Pages workflow publishes only the contents of `app/`. Repository governance files, `docs/`, `tests/`, and other root-level engineering material are not included in the website artifact.

Deployment runs automatically when a commit is pushed to `main`. An authorized maintainer can also run **Deploy Solaris Nexus Founder's Preview** manually from the repository’s Actions tab. Future deployments should update and validate the application, commit the controlled change to `main`, and push it; no application files need to be moved or duplicated.

## Open locally
Because Sprint 3 loads intelligence from external JSON, the most consistent local workflow is to serve the repository from its root:

`ruby -run -e httpd -- --port=8000 .`

Then open:

`http://localhost:8000/app/`

The application remains static and requires no backend. Directly opening `app/index.html` also attempts a local-file JSON fallback, but browser security policies vary; the local server is recommended for predictable loading and console behavior.

## Intelligence data
The five governed News Desk and Intelligence Drawer records are stored in `app/data/intelligence.json`. News rows, category filters, drawer content, and original-source behavior are driven by every record loaded from that file rather than duplicate article content in JavaScript.

`app/data.js` owns external dataset loading, schema normalization, and validation. It accepts the governed `items` collection and maps `published`, `url`, `readTime`, and `recommendation` into the stable application model while preserving the governed source fields. Legacy `articles` collections and single-string categories remain supported. Category arrays render in the News Desk and drawer, and filters match any category assigned to a record.

The loader rejects missing, malformed, empty, duplicate-ID, invalid-schema, and non-HTTPS verified-source data before records reach the interface. If loading fails, the News Desk displays an accessible status while the rest of Solaris Nexus remains operational. Verified HTTPS sources open from the drawer in a new tab with `noopener noreferrer`; unverified or missing sources remain disabled.

## Engineering governance
All Solaris Nexus development is governed by [ENGINEERING_PRINCIPLES.md](ENGINEERING_PRINCIPLES.md) and [AGENTS.md](AGENTS.md). Every coding task must begin by reading both documents. The Engineering Principles define the repository-wide values for human-centered design, WCAG 2.2 AA accessibility, governed development, quality, evidence, transparency, privacy and security, modularity, and continuous improvement.

Engineering Principles take precedence over implementation convenience while approved DHF decisions, requirements, governance authority, and Board approvals remain controlling sources for authorized product and methodology decisions.

## Accessibility standard
Solaris Nexus targets **WCAG 2.2 AA** as its minimum engineering standard. Accessibility is designed into every feature from the beginning and accessibility defects are treated as engineering defects, not enhancement requests.

The dedicated [Solaris Nexus Accessibility Standard](docs/standards/ACCESSIBILITY.md) defines expectations for keyboard and screen-reader operation, focus, contrast, responsive and touch behavior, semantic HTML, tables, charts, forms, accessible PDFs, reduced motion, and Light/Dark theme support.

## Intelligence Drawer
In the News Desk, select any governed article to open its intelligence record in a right-side drawer without leaving Solaris Nexus. All assigned categories appear in both surfaces, and category filters match records containing the selected category. Chair Notes and Bookmark state persist for the current browser session only.

The drawer return control is contextual. News Desk records show **← Return to News Desk**; Standards & Learning records show **← Return to Standards & Learning**. Returning closes the drawer without reload and preserves the originating workspace, filters, scroll position, theme, and article-trigger focus. The close button, Escape, and backdrop controls remain available.

Use **Read Original Article** only when an enabled, verified source link is present. Records without one display **Source link pending verification**. Governed summaries and recommendations remain preliminary pending Board disposition.

## Contextual intelligence

The reusable Workspace Intelligence Feed makes verified governed records available in the News Desk, Intelligence Center, Standards & Learning, Regulatory Watch, and Human Firewall™ Intelligence. Each surface uses the single `app/data/intelligence.json` dataset through governed categories, optional tags, source, and optional related-workspace mappings, then opens the same Intelligence Drawer.

Standards & Learning preserves the existing `standards` route and unifies standards, professional organizations, certifications, training and webinars, conferences and events, and publications and guidance. Organization, Content Type, Certification, Status, and Recommendation filters combine against governed metadata. Current governed coverage contains two matching standards records and no matching certification, training, webinar, conference, exam, or course update; unsupported areas are not populated with invented content.

The workspace monitors the approved organization and learning ecosystem, including IAPP AIGP in both its professional-governance and certification/learning contexts. Monitoring labels define scope only; a record appears only when verified governed intelligence contains matching metadata.

## Theme switching
Use **Settings → Appearance** to change the Solaris Nexus appearance between Dark and Light. Dark is the default when no valid preference exists.

The selection is stored locally in the browser under `solaris-nexus-theme` and restored on the next visit. Theme switching does not reload the page or reset the active workspace, News Desk filters, Intelligence Drawer, Chair Notes, or Bookmarks. No theme preference is sent to a backend.

## Settings workspace
Open **Settings** from the workspace navigation to manage Solaris Nexus preferences. The initial **Appearance** setting is the exclusive interface for the persisted Dark and Light theme choice.

The Settings workspace is structured to accept future approved categories without redesign. Accessibility, Dashboard, Intelligence, and Account are currently labeled placeholders only—no future settings or account behavior are implemented.

## Global search and notifications
The executive header contains a full global search interface on desktop, a reduced-width version on tablet, and an expandable search control on mobile. Search is an accessible interface placeholder in this release; it does not query, index, rank, or return results yet.

The component is structured for future discovery across News, Intelligence, Standards, Regulations, Documents, Skills Library, DHF, Board Decisions, Atlas Backlog, Executive Briefs, and future client assessments. **Notifications** and **Settings** are dedicated workspace navigation items rather than global header actions. Notification delivery, preferences, and history are not yet implemented.

## Supported screen sizes
Solaris Nexus uses one responsive application across:

- Large desktop: 1440px and above
- Desktop/laptop: 1024px–1439px
- Tablet: 768px–1023px
- Mobile: 320px–767px

The left workspace sidebar remains visible at 768px and above. On smaller screens, use the **Menu** control in the global header to open the same workspace navigation as an off-canvas menu. It closes through its close control, Escape, backdrop selection, or workspace selection without resetting the active workspace.

Wide tables retain every column inside a labeled horizontal-scroll region. Overview cards stack to one column on mobile, and the Intelligence Drawer expands to the full mobile width while retaining independent scrolling and keyboard behavior. Responsive behavior is shared by Dark and Light themes.

## Validate locally
Run the automated static smoke check from the repository root:

`ruby tests/smoke_test.rb`

Run the Sprint 3 intelligence dataset checks:

`ruby tests/intelligence_data_test.rb`

Run the core WCAG contrast checks:

`ruby tests/contrast_test.rb`

Run the responsive-layout contract checks:

`ruby tests/responsive_test.rb`

Then follow `tests/MANUAL_SMOKE_TEST.md` for interaction, console, and responsive-layout checks.

## Repository map
- `ENGINEERING_PRINCIPLES.md` — mandatory repository-wide engineering values and minimum standards
- `AGENTS.md` — mandatory instructions for Codex
- `app/` — current web application
- `app/data/` — externally loaded structured application datasets
- `docs/brand/` — authoritative brand guide and visual inspiration
- `docs/dhf/` — Design History File and engineering notebook
- `docs/skills/` — Solaris operating skills
- `docs/requirements/` — approved requirements and acceptance criteria
- `docs/standards/` — repository-wide engineering and accessibility standards
- `tests/` — automated and manual validation assets
- `archive/` — superseded prototypes retained for traceability

## First Codex sprint
1. Inspect the current prototype.
2. Split the single HTML file into reusable CSS, JavaScript, and structured data.
3. Preserve all current navigation and behavior.
4. Add a lightweight local test/check process.
5. Do not redesign the UI during the refactor.

## Sprint 2
The reusable Intelligence Drawer adds in-context article review, accessible close and focus behavior, session-only Chair Notes and Bookmarks, and guarded original-source navigation.

## Sprint 3
The intelligence data architecture separates records from application logic through validated external JSON, governed-schema normalization, category-array support, graceful loading states, and dedicated dataset integrity tests. See [Sprint 3 Intelligence Schema Mapping](docs/requirements/SPRINT_3_INTELLIGENCE_SCHEMA_MAPPING.md).

## ECR-012

Standards & Learning consolidates the former Standards Watch and Learning & Certification Watch into the existing `standards` route while retaining contextual feeds elsewhere. See [ECR-012 Standards & Learning Workspace](docs/requirements/ECR-012_CONTEXTUAL_INTELLIGENCE.md).
