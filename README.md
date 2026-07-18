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

## Deployment

GitHub Actions publishes only `app/` to GitHub Pages when approved changes reach `main`, or when an authorized maintainer runs the Pages workflow manually. This feature branch must be reviewed before merge or deployment.

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
