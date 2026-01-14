---
description: Extract knowledge from this conversation into structured markdown files
allowed-tools: Read, Write, Glob, Edit
context: inline
---

# Capture Conversation Logic

Review this conversation and extract its knowledge into structured `.md` files in the `docs/knowledge/` directory.

Reference these files:
- @CLAUDE.md - Add knowledge base instructions if not present
- @docs/knowledge/_index.md - Update with new entries

## Three Tiers of Knowledge

Classify each piece of knowledge into one of three tiers:

### Constraints (hard rules — don't violate)
Things that are locked in and should not be revisited without explicit discussion.
- Tech stack choices
- Accessibility requirements
- Brand guidelines
- Security requirements
- Compliance rules

### Decisions (things we chose — could revisit)
Choices made with reasoning that could be reconsidered if context changes.
- Architecture patterns
- Naming conventions
- Component structures
- Process workflows

### Context (helpful background — informational)
Useful information that informs work but doesn't constrain it.
- Problem history
- Tradeoffs considered
- Alternatives explored
- Domain knowledge

## Output Structure

### 1. Individual Files (`docs/knowledge/[tier]/[topic-name].md`)
For each distinct item, create a file containing:

**Tier:** `constraint` | `decision` | `context`

**Summary**
- One-liner of what this is

**Detail**
- What we solved/decided/learned
- Key details

**Reasoning**
- How we got here
- Tradeoffs considered
- Why this approach

**Usage**
- How to apply in future sessions
- When to revisit (for decisions)

### 2. Update the Index (`docs/knowledge/_index.md`)
After creating files, update the index organized by tier:

```markdown
# Knowledge Base Index

## Constraints
- [filename.md](./constraints/filename.md) — description

## Decisions
- [filename.md](./decisions/filename.md) — description

## Context
- [filename.md](./context/filename.md) — description
```

### 3. Update CLAUDE.md
If not already present, add this section to CLAUDE.md:

```markdown
## Knowledge Base

Before starting work, check `docs/knowledge/_index.md` for existing knowledge.

Knowledge is organized into three tiers:
- **Constraints** → follow strictly, do not violate without flagging
- **Decisions** → follow unless there's reason to revisit, suggest changes if context shifted
- **Context** → use to inform your approach, not to constrain

Scan the index, load relevant files, and apply them according to their tier.
```

## File Placement

Save to `docs/knowledge/` with subfolders:
- `constraints/` — hard rules
- `decisions/` — choices made
- `context/` — background info

## Guidelines

- Be explicit about the tier — it determines how Claude treats the knowledge
- Constraints: Claude should not violate without flagging
- Decisions: Claude can suggest revisiting if context has changed
- Context: Claude uses to inform, not constrain
- When in doubt, classify as `decision` not `constraint`
- Note dependencies between files

## Purpose

Future sessions read `_index.md` and apply knowledge based on tier:
- **Constraints** → follow strictly
- **Decisions** → follow unless there's reason to revisit
- **Context** → use to inform approach
