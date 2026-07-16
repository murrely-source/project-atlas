# Manual Smoke Test

Run after every UI change.

- [ ] `app/index.html` opens without a blank page or console errors.
- [ ] The approved Solaris Labs corporate lockup and Solaris Nexus product block are unchanged.
- [ ] The global search interface is absent without leaving a blank header row or broken alignment.
- [ ] The footer reads exactly: **© 2026 Powered by Solaris Labs - Technology for Human-Centered AI**.
- [ ] First use defaults to Dark; Settings → Appearance switches Dark and Light immediately and persists the selection.
- [ ] Primary navigation contains only Overview, Ask Nexus, Intelligence Center, and Settings, in that order.
- [ ] At 767px and below, the menu opens, traps focus, and closes by its close control, Escape, backdrop, or route selection, then restores focus.
- [ ] Overview contains only Top AI Headlines, Continue a Previous Nexus Conversation, and Notifications.
- [ ] Overview contains no separate Reminders section and no new-conversation control.
- [ ] The three headline summaries use governed records and open the matching Intelligence Drawer.
- [ ] Ask Nexus contains a labelled prompt field and clearly reports that model connectivity is not implemented; no fabricated response appears.
- [ ] Intelligence Center loads all five verified governed records from `app/data/intelligence.json`.
- [ ] News-category and intelligence metadata filters work alone and together without duplicating records.
- [ ] Knowledge and learning, standards and frameworks, laws and regulations, professional organizations, events, publications, and guidance information remain available in Intelligence Center.
- [ ] Every intelligence record opens the shared drawer with the correct source, summary, categories, Business Impact, Chair Notes, Bookmark, and Board recommendation.
- [ ] The drawer return control reflects Overview or Intelligence Center, preserves filter and scroll state, and does not reload the application.
- [ ] Drawer close, Escape, and backdrop close the drawer and restore focus to its trigger.
- [ ] Verified original-source links open the matching HTTPS URL in a new tab with `noopener noreferrer`; unverified links remain disabled.
- [ ] Chair Notes and Bookmark persist during the current browser session.
- [ ] Settings exposes working Theme controls; Accessibility, Notifications, and Language are clearly non-interactive future placeholders.
- [ ] Legacy workspace content remains in the repository but cannot be opened from primary navigation.
- [ ] Review Dark and Light themes at 1440px, 1024px, 768px, 390px, and 320px.
- [ ] Confirm no page-level horizontal overflow, clipped header content, inaccessible controls, or hidden critical information at each width.
- [ ] No methodology, governed intelligence record, or approved brand content changed.
