# Solaris Nexus Engineering Principles

## Purpose
These principles define the core values governing all future design, development, testing, maintenance, and technical decision-making for Solaris Nexus, internally engineered under the codename Project Atlas.

They apply to every contributor, coding task, implementation plan, review, defect correction, and release. Engineering Principles take precedence over implementation convenience. They do not replace approved requirements, Design History File decisions, governance controls, or Board authority.

## Human-Centered Design
Solaris Nexus is engineered around the people who make, review, explain, and remain accountable for decisions. Technology must support sound human judgment, not obscure responsibility or remove meaningful oversight. Interfaces and workflows should reflect the user’s real job, context, risks, and decision needs.

## Accessibility by Design
Solaris targets WCAG 2.2 AA as the minimum engineering standard.

Accessibility is considered from design through implementation, testing, and maintenance.

Accessibility issues are treated as engineering defects rather than enhancement requests.

Accessibility applies to:

- Keyboard navigation
- Screen readers
- Color contrast
- Responsive layouts
- Touch targets
- Focus indicators
- Semantic HTML
- Accessible charts
- Accessible tables
- Accessible documents

Accessibility requirements must be included in acceptance criteria, regression checks, and human review. When full conformance cannot be verified, the limitation and remaining review work must be documented explicitly.

## High Touch / High Tech™
Automation should prepare, organize, and strengthen the work while preserving appropriate human involvement. High-quality technology and high-quality human engagement are complementary. Material judgments, methodology changes, governance decisions, and approvals remain human responsibilities.

## Governance Before Convenience
Approved decisions, traceability, review gates, and authorization boundaries take priority over speed or ease of implementation. Engineering must consult the governing sources, preserve decision history, and escalate changes that require new authority rather than bypassing controls.

## Quality Over Speed
A smaller coherent change that is tested, reviewable, and maintainable is preferable to a rushed or incomplete implementation. Failed checks, unresolved material defects, or missing required evidence prevent completion. Shortcuts that create hidden risk are not acceptable.

## Evidence Before Opinion
Engineering decisions should be grounded in approved requirements, verified behavior, authoritative sources, reproducible observations, and test results. Facts, analysis, recommendations, opinions, hypotheses, and demonstration data must be distinguished clearly. Uncertainty must be stated rather than concealed.

## Transparency
The system and its engineering record should make important behavior, assumptions, limitations, data status, decisions, and human responsibilities understandable. Changes must be traceable. Demonstration or placeholder data must be labeled, automated actions must be reviewable, and unresolved risks must be reported plainly.

## Privacy and Security by Design
Privacy and security are design constraints from the beginning, not release-stage additions. Collect, retain, expose, and transmit only what the approved workflow requires. Prefer least privilege, safe defaults, minimized data, local processing where appropriate, explicit authorization, and secure failure behavior. Do not introduce external services, persistence, or data transmission without clear scope and approval.

## Modular Architecture
Separate interface, data, logic, and assets. Build reusable components with clear responsibilities and stable contracts. Prefer the smallest architecture that supports current approved requirements while remaining testable, accessible, maintainable, and capable of controlled evolution. Avoid duplication and hidden coupling.

## Continuous Improvement
Treat defects, reviews, research, operational feedback, and validation results as inputs to controlled improvement. Correct root causes, preserve lessons and rationale, strengthen regression coverage, and update documentation when behavior changes. Improvement must remain governed, evidence-based, and compatible with approved methodology and architecture.

## Application
Every coding task must begin by reading this document and `AGENTS.md`. Plans, implementations, tests, and completion reports should demonstrate alignment with these principles. When principles create a material trade-off or conflict with a proposed implementation, stop, document the conflict, and seek the appropriate decision rather than choosing convenience silently.
