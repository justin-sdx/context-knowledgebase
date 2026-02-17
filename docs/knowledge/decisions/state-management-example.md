**Tier:** decision

**Date:** 2026-02-17

**Last Reviewed:** 2026-02-17

**Summary**
Use Zustand for global state management instead of Redux

**Detail**
- Switched from Redux to Zustand in January 2026
- Applied to all global stores in src/stores/
- Uses simple hook-based API with minimal boilerplate
- State stores organized by domain (auth, user, cart, etc.)

**Reasoning**
- Redux boilerplate was slowing development velocity
- Zustand provides similar features with 90% less code
- Better TypeScript inference out of the box
- Team voted 4-1 in favor after spike
- Middleware support covers our logging and persistence needs

**Alternatives Considered**
- Staying with Redux: too much boilerplate, team frustration high
- React Context: performance concerns for frequent updates
- Jotai: newer, smaller community, less middleware options

**Usage**
Continue using Zustand for new global state needs. For component-local state, use useState/useReducer.

**When to Revisit**
- If Zustand development stalls or library is abandoned
- If we need Redux-specific tooling (e.g., Redux DevTools advanced features)
- If bundle size becomes critical and Zustand is a significant contributor
- If new team members strongly prefer Redux and can justify the complexity
