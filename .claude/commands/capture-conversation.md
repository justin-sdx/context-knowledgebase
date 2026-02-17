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
- @.claude/templates/knowledge-template.md - Use as format reference

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

When running `/capture-conversation`:
- Classify each item as constraint, decision, or context
- Create files in the appropriate subfolder
- Update `_index.md` with new entries under the correct tier
```

### 4. Update Index Metadata
After adding/updating knowledge files, update the metadata at the top of `_index.md`:
- Update "Last updated" to current date
- Count and update total items for each tier

## File Placement

Save to `docs/knowledge/` with subfolders:
- `constraints/` — hard rules
- `decisions/` — choices made
- `context/` — background info

## Guidelines

### Classification
- Be explicit about the tier — it determines how Claude treats the knowledge
- Constraints: Claude should not violate without flagging
- Decisions: Claude can suggest revisiting if context has changed
- Context: Claude uses to inform, not constrain
- When in doubt, classify as `decision` not `constraint`
- Note dependencies between files

### Handling Existing Knowledge
Before creating new files, check `docs/knowledge/_index.md` to avoid duplicates:

**If similar knowledge exists:**
1. Read the existing file
2. Determine if it should be updated (new details added) or merged (combine related concepts)
3. Use Edit tool to update existing file rather than creating duplicate
4. Update the "Last Reviewed" date
5. If merging multiple topics, choose the most descriptive filename

**If knowledge overlaps multiple tiers:**
- Split into separate files (one per tier)
- Cross-reference between files in the Usage section
- Example: "See constraints/api-authentication.md for auth requirements"

**If knowledge contradicts existing entries:**
- Flag this explicitly in your response
- Ask user which should take precedence
- Update or archive the outdated knowledge
- Add note in file: "Supersedes: [old-file].md (archived 2026-02-17)"

### Validation
Before completing, verify each file:
- [ ] Summary is concise (under 80 characters)
- [ ] Tier is explicitly stated at top
- [ ] Date and Last Reviewed fields included
- [ ] Reasoning section explains "why" not just "what"
- [ ] Usage section is actionable
- [ ] For decisions: "When to Revisit" is included
- [ ] For constraints: violation behavior is clear
- [ ] Filename is kebab-case and descriptive (e.g., `state-management-approach.md`)

### File Naming
- Use kebab-case: `file-name-like-this.md`
- Be specific: `zustand-state-management.md` not `state.md`
- Avoid dates in filename (use metadata instead)
- Keep under 50 characters

## Purpose

Future sessions read `_index.md` and apply knowledge based on tier:
- **Constraints** → follow strictly
- **Decisions** → follow unless there's reason to revisit
- **Context** → use to inform approach
