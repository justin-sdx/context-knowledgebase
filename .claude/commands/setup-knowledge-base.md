---
description: One-time setup — installs commands and creates the knowledge folder structure
allowed-tools: Read, Write, Glob, Bash, AskUserQuestion
---

# Setup Knowledge Base

Set up the context-knowledgebase system in the current project.

## Step 1: Detect setup mode

Check if `context-knowledgebase/` exists in the current directory.

**If the repo IS present** → first-time install from source. Proceed to Step 2.

**If the repo is NOT present** → commands are already globally installed. Skip to Step 3.

## Step 2: Install slash commands (only if repo is present)

Copy commands to the project root `.claude/commands/` so they work in this project:

```bash
mkdir -p .claude/commands
cp context-knowledgebase/.claude/commands/capture-conversation.md .claude/commands/capture-conversation.md
cp context-knowledgebase/.claude/commands/prune-knowledge.md .claude/commands/prune-knowledge.md
cp context-knowledgebase/.claude/commands/setup-knowledge-base.md .claude/commands/setup-knowledge-base.md
```

Then ask the user:

> "Install commands globally so they're available in all future projects without cloning? (recommended)"

If yes, also run:

```bash
mkdir -p ~/.claude/commands
cp context-knowledgebase/.claude/commands/capture-conversation.md ~/.claude/commands/capture-conversation.md
cp context-knowledgebase/.claude/commands/prune-knowledge.md ~/.claude/commands/prune-knowledge.md
cp context-knowledgebase/.claude/commands/setup-knowledge-base.md ~/.claude/commands/setup-knowledge-base.md
```

## Step 3: Create the knowledge folder structure

In the current working directory (the project root):

```
docs/knowledge/
├── _index.md
├── constraints/
├── decisions/
└── context/
```

Create `docs/knowledge/_index.md` with this content:

```markdown
# Knowledge Base Index

Last updated: [today's date]
Total items: 0 (0 constraints, 0 decisions, 0 context)

## Constraints
<!-- Hard rules — Claude follows strictly, flags if asked to violate -->

## Decisions
<!-- Choices made — Claude follows, suggests revisiting if context shifted -->

## Context
<!-- Background info — Claude uses to inform, not constrain -->
```

## Step 4: Update CLAUDE.md

In the project root, create or update `CLAUDE.md` to include the section below. Do not overwrite any existing content — append or merge.

```markdown
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
```

## Step 5: Confirm

Tell the user:
- Which files were created
- Whether commands were installed globally
- That `/capture-conversation` and `/prune-knowledge` are now available
- To restart Claude Code if the slash commands don't appear immediately
