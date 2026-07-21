# ADR-003 — Solaris Workspace Repository Extraction

Date: 2026-07-20
Status: Implemented under approved migration instruction; formal Governance and Executive record review pending

## Context

ADR-002 established a temporary isolated `workspace/` application boundary inside Project Atlas for Sprint 1. Technical review confirmed that the Workspace application had no runtime dependency on Project Atlas files and could be governed independently without changing its behavior or visual design.

Keeping the public Solaris Lucerna website, the preserved Project Atlas/Solaris Nexus engineering prototype, and the future executive operating application in one repository created unnecessary access, CI, deployment, and product-lifecycle coupling.

## Decision

The committed Sprint 1 Workspace subtree is extracted into the private standalone repository:

`https://github.com/murrely-source/solaris-workspace`

Project Atlas no longer owns the Workspace runtime, package manifest, lockfile, application tests, or Workspace CI workflow. The standalone repository owns those materials and maintains its own engineering principles, contributor instructions, accessibility standard, skills, requirements, decision records, changelog, and legal-notice approval placeholder.

Project Atlas retains the original Sprint 1 requirement, ADR-002, changelog history, public Solaris Lucerna website, preserved engineering prototype, governed intelligence, public-site validation, and GitHub Pages deployment.

## Constraints preserved

- No Workspace application source, routes, styling, responsive design, dashboard content, module structure, or tests changed during extraction.
- Generated files, dependencies, build output, caches, and local metadata were not migrated.
- Authentication, persistence, AI, production hosting, and Sprint 2 remain deferred.
- The Project Atlas GitHub Pages workflow continues to publish only `app/`.

## Supersession

This decision supersedes the repository-location portion of ADR-002. ADR-002 remains preserved as the historical record of the temporary Sprint 1 boundary.

## Review gates

Engineering Review, Brand Review, Governance Review, and Executive Review remain required before the boundary record is treated as fully released.
