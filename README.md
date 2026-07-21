# Solaris Workspace

The Solaris Workspace is the isolated executive operating application for Solaris Lucerna. Sprint 1 establishes its application shell, routes, shared models, responsive navigation, accessible component patterns, and clearly labeled foundation records.

## Local development

Requires Node.js 20.9 or later and pnpm.

```bash
pnpm install
pnpm dev
```

Open `http://localhost:3000`.

## Validation

```bash
pnpm check
```

## Sprint 1 boundaries

- Authentication is visibly stubbed.
- No production database is connected.
- Foundation records are not live operating data.
- No AI dependency or capability is implemented.
- The public Solaris Lucerna website under `../app/` remains separate and unchanged.
