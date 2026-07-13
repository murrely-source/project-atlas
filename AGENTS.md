# AGENTS.md — Project Atlas

## Purpose
Project Atlas is the internal engineering and intelligence platform for Solaris AI Risk & Governance Advisory.

Codex is the primary implementation environment. Strategic decisions, methodology changes, research interpretation, and Board approvals remain governed outside the codebase and are recorded in the Design History File (DHF).

## Mandatory task startup
Every coding task must begin by reading, in full:
1. `ENGINEERING_PRINCIPLES.md`
2. `AGENTS.md`

The Solaris Nexus Engineering Principles govern all future development and take precedence over implementation convenience. They do not override approved DHF decisions, requirements, governance authority, or Board approvals.

## Mandatory source-of-truth hierarchy
1. `docs/dhf/` — engineering decisions, approved architecture, and traceability.
2. `docs/brand/Solaris_Brand_Guide_Dark_Edition.png` — visual source of truth.
3. `docs/skills/SKILLS.md` — operating procedures and quality controls.
4. `docs/requirements/` — feature requirements and acceptance criteria.
5. Existing approved application behavior — preserve unless an approved requirement changes it.

## Non-negotiable rules
- Check the DHF before proposing or implementing architectural changes.
- Do not recreate approved work from memory.
- Do not overwrite Approved Masters; create a controlled revision.
- Never use screenshots or cropped guide pages as production brand assets.
- Use the approved Solaris symbol, typography, colors, and website: `solarisadvisoryai.com`.
- Solaris assessment scoring uses a 1–10 scale.
- Overview charts and cards must link to dedicated detail workspaces.
- Separate interface, data, logic, and assets.
- Methodology changes require Board approval before implementation.
- Quality takes priority over speed. No shortcuts.
- Do not fabricate live data, citations, standards changes, or regulatory status.
- Clearly label placeholder/demo data.

## Required workflow for every task
1. Confirm `ENGINEERING_PRINCIPLES.md` and `AGENTS.md` were read at the start of the coding task.
2. Read the relevant requirement and related DHF entries.
3. Inspect the existing code before editing.
4. State the implementation plan briefly.
5. Make the smallest coherent change.
6. Run validation and regression checks.
7. Report files changed, tests run, and unresolved risks.
8. Update `CHANGELOG.md` when behavior changes.
9. Do not mark work complete when tests fail.

## Review gates
Every completed feature must pass:
- Engineering Review
- Brand Review
- Governance Review
- Executive Review

## Product principles
- The overview summarizes; dedicated pages explain.
- Every widget must support a decision or workflow.
- Executives receive conclusions; professionals receive evidence.
- Automation prepares the work; humans approve the work.
- Project Atlas is engineered, not improvised.
