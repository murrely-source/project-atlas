# PP-001 — Codex Engineering Change Request (ECR)

## Purpose

Provide a consistent format for requesting engineering changes from Codex while preserving Solaris engineering standards.

---

## When to Use

Use this pattern whenever implementing:

- New features
- Bug fixes
- Refactoring
- UI improvements
- Accessibility enhancements
- Documentation updates

---

## Prompt Template

Read ENGINEERING_PRINCIPLES.md and AGENTS.md before making changes.

### Goal

Clearly describe the engineering objective.

### Requirements

Provide numbered implementation requirements.

### Validation

Describe how success will be verified.

### Documentation

Update README.md and CHANGELOG.md.

### Report

- Files changed
- Tests run
- Defects found
- Unresolved risks

### Constraints

List anything Codex must not change.

---

## Lessons Learned

- Keep one engineering objective per request.
- Avoid combining unrelated work into a single ECR.
- Preserve existing functionality unless explicitly requested.
- Validate before implementing additional enhancements.

---

## Revision History

**Version:** 1.0

**Status:** Active

**Author:** Solaris AI Risk & Governance Advisory