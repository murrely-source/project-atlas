# Solaris Lucerna Website V2.0 — Project Aurora

This repository contains the in-review Solaris Lucerna public website and the preserved Project Atlas/Solaris Nexus engineering prototype.

## Public-site preview

The public entry point is `app/index.html`. It uses dependency-free HTML, CSS, and browser JavaScript:

- `app/brand-config.js` — centralized Solaris Lucerna and LENS naming/content
- `app/site.css` — public design system and responsive layout
- `app/site.js` — shared navigation, content rendering, and mobile-menu behavior
- `app/assets/brand/README.md` — approved-artwork handoff requirements

Serve the repository locally:

`ruby -run -e httpd -- --port=8000 .`

Then open:

`http://localhost:8000/app/`

## Preserved Nexus prototype

The former application entry point is retained at `app/nexus-preview.html`. Its supporting `styles.css`, `theme-init.js`, `data.js`, `app.js`, and governed `data/intelligence.json` files remain in place for traceability and controlled future decisions.

## Solaris Workspace

Solaris Workspace was extracted after Sprint 1 technical review and is now maintained in the private standalone repository [murrely-source/solaris-workspace](https://github.com/murrely-source/solaris-workspace). This repository retains the original Sprint 1 requirement and architecture records for traceability but no longer contains or validates the Workspace runtime.

See `docs/requirements/SOLARIS_WORKSPACE_SPRINT_1.md`, `docs/dhf/ADR-002_SOLARIS_WORKSPACE_APPLICATION_BOUNDARY.md`, and `docs/dhf/ADR-003_SOLARIS_WORKSPACE_REPOSITORY_EXTRACTION.md` for the controlled history and repository-boundary decision.

## Deployment

GitHub Actions runs every repository Ruby validation check for pull requests targeting `main`. On an approved push to `main` or an authorized manual run, those same checks must pass before the workflow publishes only `app/` to GitHub Pages. This feature branch must be reviewed before merge or deployment.

The current repository Pages URL is [https://murrely-source.github.io/project-atlas/](https://murrely-source.github.io/project-atlas/). A production Solaris Lucerna domain and canonical URL have not yet been approved in this repository.

## Audit and plan

- [Project Aurora Phase 1 audit](docs/project-aurora-audit.md)
- [Project Aurora phased plan](docs/project-aurora-plan.md)
- [Solaris Lucerna V2 audit](docs/solaris-lucerna-v2-audit.md)
- [Solaris Lucerna V2 phased plan](docs/solaris-lucerna-v2-plan.md)
- [Engineering Principles](ENGINEERING_PRINCIPLES.md)
- [Accessibility Standard](docs/standards/ACCESSIBILITY.md)

## Validation

Run all repository Ruby checks:

`for test in tests/*_test.rb; do ruby "$test" || exit 1; done`

Then follow `tests/MANUAL_SMOKE_TEST.md` for browser, responsive, keyboard, visual, and console review.

The repository has no package manager, type checker, linter, or production build step. GitHub Pages serves the static files directly.

The source-contract suite does not replace human accessibility review. In particular, Hero text over raster artwork must be measured using actual rendered foreground and background pixels at the required viewport sizes; the token/fallback contrast check is not evidence of image contrast.
