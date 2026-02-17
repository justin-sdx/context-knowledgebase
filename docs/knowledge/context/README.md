# Context

Background information that informs approach but doesn't constrain decisions. Claude uses this to understand the project but won't enforce it as a rule.

## What Belongs Here

- **Migration history** — transitions from old to new systems, current state
- **Problem history** — why certain issues exist, past attempts at solutions
- **Domain knowledge** — business rules, industry concepts, user behavior patterns
- **Technical debt** — known issues, workarounds, planned refactors
- **Team dynamics** — who owns what, expertise areas, collaboration patterns
- **External dependencies** — third-party APIs, vendor relationships, integration quirks
- **Performance profiles** — bottleneck analysis, optimization history
- **Incident postmortems** — what went wrong and what was learned (summarized)

## What Does NOT Belong Here

- Anything that constrains future action — that's a **constraint** or **decision**
- Step-by-step tutorials — link to documentation instead
- Code snippets — keep context conceptual, not implementational
- Unchanged for >1 year with no relevance — archive it

## How to Write Good Context

### Make It Informational, Not Prescriptive
```markdown
**Usage**
This is background information. When working on the checkout flow:
- Be aware of the legacy payment provider limitations
- Check if new features are better suited to the new provider
- Don't feel constrained — use whichever approach serves the task best
```

### Include Timeline and Status
```markdown
**Detail**
- Legacy system: deployed 2023, handles 60% of traffic
- New system: deployed Q4 2025, handles 40% of traffic
- Target: 100% migration by Q3 2026
- Current blocker: payment reconciliation automation incomplete
```

### Note When to Discard
```markdown
**Relevance**
This context becomes obsolete when:
- Legacy system is fully decommissioned
- All traffic routes through new system
- Old codebase is archived
```

## How Many is Too Many?

Context files grow fastest and become stale quickest. If you have >30 files:
- **Run `/prune-knowledge` quarterly** — context tier should be pruned aggressively
- **Archive liberally** — if it hasn't been relevant in 6 months, archive it
- **Consolidate related context** — "payment system history" vs 5 separate migration files
- **Link to docs instead** — if the full context is documented elsewhere, just add a pointer

Context is useful but should be lightweight. Don't let it become a second codebase.

## File Template

Use `.claude/templates/knowledge-template.md` as a starting point. Key sections for context:

- **Summary** — What's the background?
- **Detail** — Timeline, current state, relevant history
- **Background** — How did we get here? What's the bigger picture?
- **Usage** — Clarify this is informational, explain how it might inform decisions

## Example

See `api-migration-history.md` for a well-formed context file.
