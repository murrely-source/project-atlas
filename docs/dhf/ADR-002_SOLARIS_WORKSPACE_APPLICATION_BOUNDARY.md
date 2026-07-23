# ADR-002 — Solaris Workspace Application Boundary

Date: 2026-07-20  
Status: Proposed for Engineering, Governance, and Executive review

## Problem

The repository currently contains a dependency-free public Solaris Lucerna website and a preserved Project Atlas/Solaris Nexus prototype under the GitHub Pages `app/` artifact. The Solaris Workspace requires authenticated, persistent, modular application architecture and cannot safely inherit the public site’s deployment or runtime boundary.

## Decision

Create an isolated `workspace/` Next.js App Router application while preserving `app/` unchanged. The Workspace owns its package manifest, build, tests, routes, components, and domain models. The current GitHub Pages workflow continues to publish only `app/`; Workspace hosting is deferred to a separately approved Vercel configuration.

Sprint 1 uses local, clearly labeled foundation records through typed application models. A repository interface separates UI consumers from the future persistence provider. Supabase, authentication, and AI are not connected until their security, privacy, governance, and operational decisions are approved.

## Rationale

- Prevents an internal operating system from being published with the public website.
- Preserves working public-site infrastructure and governed legacy records.
- Enables strict TypeScript, modular routes, server/client component boundaries, and future authenticated persistence.
- Avoids prematurely committing to database, identity, or AI choices without approved configuration.

## Trade-offs

- The repository temporarily contains two frontend architectures.
- Sprint 1 is not production-operational until authentication and persistence are approved and connected.
- Shared brand tokens are conceptually aligned but not yet packaged across applications.

## Review gates

Engineering Review, Brand Review, Governance Review, and Executive Review are required before this ADR is accepted.
