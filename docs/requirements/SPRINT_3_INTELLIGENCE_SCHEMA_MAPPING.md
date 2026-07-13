# Sprint 3 — Intelligence Schema Mapping

## Status

Implemented 2026-07-12.

## Goal

Load the governed intelligence dataset from `app/data/intelligence.json` without modifying governed records or coupling the interface directly to the governed storage schema.

## Governed input contract

- Top-level collection: `items`
- Mappings: `published` → `publishedDate`; `url` → `originalUrl`; `readTime` → `estimatedReadingTime`; `recommendation` → `boardRecommendation`
- Categories may contain multiple strings.
- Original governed fields remain present on each normalized record.

## Compatibility

- The loader continues to accept the legacy `articles` collection.
- A legacy single-string category is normalized into a one-item category array.
- Numeric reading times are presented as minutes without altering the governed value retained on the record.

## Interface behavior

- Every assigned category is displayed in the News Desk and Intelligence Drawer.
- A category filter matches when its normalized label occurs in any category assigned to the record.
- Verified HTTPS sources enable **Read Original Article** and open safely in a new tab.
- Unverified or missing sources remain disabled.
- Governed intelligence is labeled preliminary pending Board disposition.

## Error handling

Missing, malformed, empty, structurally invalid, duplicate-ID, and insecure verified-source datasets produce an accessible News Desk error state without disabling other workspaces.

## Acceptance criteria

- All five governed records load with unique IDs.
- All mapped fields populate the existing News Desk and drawer model.
- Category arrays render and filter correctly.
- Every selected record opens its matching drawer content.
- Every verified source uses HTTPS and retains safe new-tab attributes.
- No demonstration placeholder URL or `live: false` dependency remains.
- Existing routes, themes, responsive layouts, search, Settings, and accessibility contracts continue to pass regression checks.

## Governance boundary

This requirement changes schema integration and interface status labels only. It does not authorize changes to intelligence content, evidence interpretation, recommendations, methodology, or Board disposition.
