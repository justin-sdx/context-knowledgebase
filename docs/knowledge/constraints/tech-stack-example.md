**Tier:** constraint

**Date:** 2026-02-17

**Last Reviewed:** 2026-02-17

**Summary**
Use React with TypeScript for all frontend components

**Detail**
- All new components must be written in TypeScript, not JavaScript
- Use React 18+ features (hooks, concurrent rendering)
- Function components only, no class components
- Applied across entire src/components/ directory

**Reasoning**
- TypeScript catches type errors at compile time, reducing runtime bugs
- React is the established framework for this project (migrating would be too costly)
- Team has deep expertise in React ecosystem
- Existing component library and design system built on React
- Constraint established to prevent framework fragmentation

**Usage**
Follow this strictly. Do not introduce Vue, Angular, or other frameworks. Do not write JavaScript files in component directories.

If asked to violate (e.g., "rewrite this in Vue"), flag to user that this violates a project constraint. Only proceed if user explicitly approves changing the constraint.
