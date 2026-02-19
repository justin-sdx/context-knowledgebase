# Project Instructions

## Setup Detection

At the START of every session, check if the knowledge base has been initialized:

1. Look for `docs/knowledge/_index.md` in the project root (the directory where Claude Code was launched, NOT inside this repo)
2. If it does NOT exist → tell the user: "It looks like the knowledge base hasn't been set up yet. Run `/setup-knowledge-base` to initialize it (takes ~10 seconds)."
3. If it DOES exist → proceed normally with the Knowledge Base instructions below

Do this check silently — only speak up if setup is missing.

## Knowledge Base

Before starting work, check `docs/knowledge/_index.md` for existing knowledge.

Knowledge is organized into three tiers:
- **Constraints** → follow strictly, do not violate without flagging
- **Decisions** → follow unless there's reason to revisit, suggest changes if context shifted
- **Context** → use to inform your approach, not to constrain

Scan the index, load relevant files, and apply them according to their tier.

### When to Check Knowledge
- At the START of a session, before beginning work
- NOT mid-task (unless explicitly needed to resolve ambiguity)
- When user mentions past decisions or asks about project conventions

### Handling Conflicts
If multiple knowledge files contradict each other:
1. Constraints always take precedence over decisions
2. More recent "Last Reviewed" date takes precedence for decisions
3. Flag the conflict to the user and ask which should apply
4. Suggest consolidating or archiving the outdated knowledge

### Identifying Stale Knowledge
If knowledge appears outdated (suggest review to user):
- Last Reviewed date is >6 months old
- Contradicts current codebase patterns
- References deprecated tools or approaches
- Decision's "When to Revisit" conditions are met

When running `/capture-conversation`:
- Classify each item as constraint, decision, or context
- Check for existing similar knowledge before creating duplicates
- Create files in the appropriate subfolder
- Update `_index.md` with new entries under the correct tier
- Update metadata (last updated date, item counts)
