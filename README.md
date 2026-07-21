# Solaris Lucerna Website V2.0 — Project Aurora

This repository contains the in-review Solaris Lucerna public website and the preserved Project Atlas/Solaris Nexus engineering prototype.

It also contains the isolated Sprint 1 foundation for the Solaris Workspace executive operating application under `workspace/`. The Workspace has its own Next.js build and is not included in the public GitHub Pages artifact.

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

The `workspace/` directory is a strict-TypeScript Next.js App Router application with a responsive shell, executive dashboard, all charter modules, shared domain models, and clearly identified foundation records. Authentication, Supabase persistence, and AI are intentionally deferred pending approved architecture and configuration.

Run it independently:

```bash
cd workspace
pnpm install
pnpm dev
```

Validate it with `pnpm check`. See `docs/requirements/SOLARIS_WORKSPACE_SPRINT_1.md` and `docs/dhf/ADR-002_SOLARIS_WORKSPACE_APPLICATION_BOUNDARY.md` for scope and architectural rationale.

Changes under `workspace/` are independently checked by `.github/workflows/workspace-ci.yml`. That workflow does not publish the Workspace and does not alter the existing public GitHub Pages artifact.

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
