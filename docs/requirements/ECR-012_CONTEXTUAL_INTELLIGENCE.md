# ECR-012 — Standards & Learning Workspace

## Status

Implemented 2026-07-12. This controlled revision supersedes the earlier separate Learning & Certification Watch implementation.

## Goal

Unify standards, professional organizations, certifications, training, webinars, conferences, publications, and implementation guidance in one **Standards & Learning** workspace while preserving the existing `standards` route.

## Navigation

- The sidebar label is **Standards & Learning**.
- The route remains `standards`.
- There is no separate Learning & Certification route or navigation item.

## Workspace sections

- Standards
- Professional Organizations
- Certifications
- Training & Webinars
- Conferences & Events
- Publications & Guidance

The monitored scope includes NIST, ISO / ISO/IEC, OECD, IEEE, W3C, CISA, OWASP, EU AI Office, UK AI Safety Institute, Singapore IMDA / AI Verify, IAPP, IAPP AIGP, ISACA, ISACA AAIA, PMI, ISO/IEC 42001 learning and auditor pathways, ISO 23894 learning, and ITIL AI Governance.

IAPP AIGP is represented both as part of the professional AI governance ecosystem and as a certification and learning pathway. Monitoring scope is not evidence of a current update.

## Intelligence architecture

- `app/data/intelligence.json` remains the only intelligence record store.
- The reusable Workspace Intelligence Feed and article-trigger factory are shared with News Desk, Intelligence Center, Human Firewall™, and Regulatory Watch.
- Records must have `verified: true`.
- Categories, optional tags, source, and optional related-workspace mappings determine Standards & Learning relevance.
- Supported content metadata includes Standard, Guidance, Certification, Training, Webinar, Conference, Publication, Exam Update, and Course Update.
- No record is created merely to populate a monitored section.

## Filters

The workspace provides composable filters for:

- Organization
- Content Type
- Certification
- Status
- Recommendation

Every selected filter must match. Filters use visible labels, native keyboard-accessible controls, theme tokens, and practical 44px touch targets.

## Intelligence Drawer

All matching records open the shared Intelligence Drawer with Solaris Executive Summary, Key Takeaways, Why It Matters, Business Impact, Related Standards, Related Solaris Modules, Board Recommendation, Evidence Quality, Chair Notes, Bookmark, and safe original-source behavior.

Records opened from this workspace display **← Return to Standards & Learning**. Returning preserves the workspace, combined filters, theme, scroll position, and trigger focus without reloading. Close, Escape, backdrop, and News Desk return behavior remain intact.

## Acceptance criteria

- Standards & Learning is the only standards/learning navigation item.
- The existing `standards` route remains valid.
- Current governed standards records render and irrelevant records are excluded.
- Governed certification and learning records are supported without adding invented content.
- IAPP AIGP is supported in organization and certification contexts.
- Filters work individually and together.
- Drawer content and safe source links match the selected governed record.
- Existing routes, themes, responsive behavior, search, Settings, News Desk, accessibility, notes, and bookmarks remain intact.
- The workspace is validated at 1440px, 1024px, 768px, 390px, and 320px in Dark and Light themes.

## Governance boundary

This requirement does not authorize new standards, certification, training, webinar, conference, event, publication, exam, or course updates. New feed content requires a verified governed record in the approved dataset.
