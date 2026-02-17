# Decisions

Choices made with reasoning that can be revisited if context changes. Claude follows these but may suggest reconsideration if conditions warrant.

## What Belongs Here

- **Architecture patterns** — monorepo vs multi-repo, microservices vs monolith
- **State management** — Redux, Zustand, Jotai, Context, or other approaches
- **Testing strategy** — unit vs integration focus, coverage targets, frameworks
- **Code organization** — folder structure, naming conventions, file patterns
- **Styling approach** — CSS-in-JS, Tailwind, CSS modules, etc.
- **Build tools** — bundlers, compilers, dev servers chosen and why
- **Process workflows** — branching strategy, CI/CD pipeline choices
- **API design** — REST vs GraphQL, versioning strategy, error handling

## What Does NOT Belong Here

- Hard requirements from stakeholders — those are **constraints**
- Historical notes without actionable choices — that's **context**
- Implementation details — keep decisions high-level, avoid code examples

## How to Write Good Decisions

### Include "When to Revisit"
Every decision should have conditions that trigger reconsideration:
```markdown
**When to Revisit**
- If bundle size exceeds 500KB
- If new team members struggle with the API
- If library development stalls for >6 months
- If we need features not supported by current choice
```

### Document Alternatives
Show what you considered:
```markdown
**Alternatives Considered**
- Redux: too much boilerplate for our use case
- Context: performance concerns for frequent updates
- MobX: team unfamiliar, steeper learning curve
```

### Be Specific About Scope
```markdown
**Detail**
- Applied to: all global state in src/stores/
- Not applied to: component-local state, form state
- Configured in: zustand.config.ts
```

## How Many is Too Many?

If you have more than 20-30 decision files, consider:
- **Consolidating related decisions** — "frontend state management" vs separate files for each state type
- **Moving to context** — if it's purely historical and no longer guides action
- **Archiving outdated decisions** — use `/prune-knowledge` to identify candidates

## File Template

Use `.claude/templates/knowledge-template.md` as a starting point. Key sections for decisions:

- **Summary** — What was decided?
- **Reasoning** — Why this choice over alternatives?
- **Alternatives Considered** — What else was evaluated?
- **When to Revisit** — Under what conditions should this be reconsidered?

## Example

See `state-management-example.md` for a well-formed decision file.
