# Solaris Nexus Accessibility Standard

## Purpose
This standard defines the accessibility expectations for Solaris Nexus software, content, charts, tables, forms, and documents. It applies to design, implementation, testing, review, release, and maintenance.

Accessibility is designed into every feature from the beginning. It is not a final-stage checklist or optional refinement.

## Minimum engineering target
Solaris targets **WCAG 2.2 AA** as the minimum engineering standard.

Where automated tools cannot verify conformance, teams must perform appropriate keyboard, screen-reader, visual, responsive, document, and human review. Any limitation or unverified requirement must be recorded as an unresolved risk.

Accessibility defects are treated as engineering defects rather than enhancement requests. They must be prioritized, traced, corrected, tested, and reviewed according to their user impact and risk.

## Keyboard-only navigation
- Every interactive function must be operable without a mouse or touch input.
- Use native interactive elements whenever possible.
- Avoid keyboard traps except intentional, accessible focus containment in modal interfaces.
- Support expected keys for controls and patterns, including Enter, Space, Escape, arrow keys, and Tab where applicable.
- Ensure menus, dialogs, drawers, filters, links, buttons, tables, and forms remain usable by keyboard.

## Screen readers
- Provide meaningful accessible names, descriptions, roles, states, and relationships.
- Announce important dynamic changes without creating unnecessary or repetitive output.
- Keep reading order aligned with the visual and operational sequence.
- Decorative images and icons must be hidden from assistive technology; informative assets require useful alternatives.
- Test critical workflows with representative screen-reader and browser combinations during human accessibility review.

## Focus order
- Focus must follow a logical, predictable order that reflects the task and visual structure.
- Opening a modal, drawer, or menu must move focus to an appropriate element within it.
- Closing temporary UI must return focus to the control that opened it when that control remains available.
- Do not use positive `tabindex` values to force an artificial order.
- Hidden or inactive content must not receive focus.

## Focus indicators
- Every keyboard-focusable element must have a clearly visible focus indicator.
- Focus treatment must remain distinguishable in Dark and Light themes, on all component surfaces, and at every supported width.
- Do not remove browser focus indicators without supplying an equal or stronger replacement.
- Focus must not be fully obscured by sticky headers, drawers, menus, or other overlays.

## Color contrast
- Normal text and interactive controls must meet WCAG 2.2 AA contrast requirements.
- Large text, non-text controls, focus indicators, chart marks, and meaningful boundaries must meet their applicable contrast requirements.
- Color must not be the only means of communicating state, category, severity, selection, or required action.
- Validate approved brand colors in their actual foreground, background, size, and state combinations.
- Document any approved color adjustment required for accessibility without altering protected brand assets.

## Responsive layouts
- Content and functionality must remain available across supported desktop, laptop, tablet, and mobile widths.
- Reflow must not create page-level horizontal scrolling except where a contained component, such as a data table, requires two-dimensional access.
- Text, controls, labels, charts, and status information must not overlap, clip, or become unreachable.
- Zoom, text resizing, and orientation changes must preserve meaningful content and operation where applicable.
- Responsive variants must use the same accessible content and behavior rather than remove critical information.

## Touch targets
- Critical interactive controls should provide a target of approximately 44 by 44 CSS pixels where practical.
- Targets must have sufficient spacing to reduce accidental activation.
- Touch interaction must not depend on hover, fine pointer precision, or complex gestures without an equivalent alternative.
- Mobile menus, theme controls, drawer actions, filters, links, and form controls require particular review.

## Semantic HTML
- Prefer native headings, landmarks, buttons, links, lists, tables, labels, and form controls.
- Maintain a logical heading hierarchy and meaningful page landmarks.
- Use ARIA only when native semantics cannot express the required behavior.
- ARIA roles, names, properties, and states must remain accurate as the interface changes.
- Validate markup structure and avoid clickable generic containers when a native control is appropriate.

## Accessible tables
- Use semantic table elements for tabular data, including appropriate header cells and relationships.
- Provide a caption or accessible contextual label when the table’s purpose is not already clear.
- Preserve every critical value at narrow widths; use contained horizontal scrolling or an accessible equivalent rather than silent truncation.
- Keyboard users must be able to reach and operate interactive content within tables.
- Complex tables require additional header scope, descriptions, or simplified alternatives as appropriate.

## Accessible charts
- Charts must have an accessible name and a concise text summary of the conclusion or meaning.
- Provide the underlying data in an accessible table or equivalent format when needed for full interpretation.
- Do not rely on color alone; use labels, patterns, shapes, position, or text as additional signals.
- Ensure labels, legends, marks, and tooltips remain readable with keyboard access, zoom, responsive layouts, and both themes.
- Decorative charts must not create redundant screen-reader output.

## Accessible forms
- Every input must have a persistent, programmatically associated label.
- Instructions, required status, constraints, and expected formats must be available before submission.
- Errors must be identified in text, associated with the relevant fields, and summarized when appropriate.
- Validation must not rely on color alone, and users must be able to review and correct their work.
- Disabled, read-only, saved, pending, and success states must be distinguishable visually and programmatically.

## Accessible PDFs
- PDFs intended for distribution must be tagged and have a logical reading order.
- Use real headings, lists, tables, links, document language, bookmarks, and descriptive metadata where appropriate.
- Images and meaningful graphics require alternative text; decorative graphics must be marked appropriately.
- Tables require identified headers and correct cell relationships.
- Form fields require accessible names, instructions, states, and a logical tab order.
- Verify text selection, reflow or zoom usability, contrast, and assistive-technology reading before release.
- When an accessible PDF cannot be produced, provide an equivalent accessible format and document the limitation.

## Reduced motion
- Respect the user’s `prefers-reduced-motion` preference.
- Remove or reduce non-essential animation, parallax, smooth scrolling, and large transitions.
- Motion must not be required to understand state or complete a task.
- Essential motion must include an accessible alternative or user control where applicable.

## Light and Dark theme support
- All accessibility requirements apply equally in Light and Dark themes.
- Verify text, controls, focus, hover, active, selected, disabled, warning, success, chart, table, input, and overlay states in both themes.
- Theme switching must expose its current state, remain keyboard accessible, and preserve the user’s work and current context.
- Approved Solaris brand assets must remain readable without filters or unapproved alterations.

## Delivery and validation
Every feature must include relevant accessibility acceptance criteria and proportional validation. At minimum:

1. Review semantic structure and accessible names.
2. Complete the workflow using only the keyboard.
3. Verify focus order, containment, visibility, and restoration.
4. Check applicable contrast and non-color indicators.
5. Review responsive and touch behavior at supported widths.
6. Test dynamic states, errors, disabled controls, themes, and reduced motion.
7. Review tables, charts, forms, and documents using the relevant guidance above.
8. Run available automated checks and complete required human review.
9. Record defects, limitations, evidence, and unresolved risks.

A feature is not complete when required accessibility checks fail. Human review remains necessary for material accessibility decisions and for behavior that automated tools cannot assess reliably.

## Maintenance
Accessibility must be preserved through refactoring, content updates, dependency changes, responsive changes, theme changes, and new platform capabilities. Regression coverage and this standard should be updated when defects, research, standards changes, or validated user feedback reveal a stronger engineering practice.
