---
description: One-time setup — installs commands and creates the knowledge folder structure
allowed-tools: Read, Write, Glob, Bash
---

# Setup Knowledge Base

Perform the one-time setup for the context-knowledgebase system in the current project.

## Context

This repo is typically cloned as a subdirectory inside a project (e.g. `my-project/context-knowledgebase/`). Claude Code does NOT auto-load commands from nested subdirectories — only from the project root's `.claude/commands/` and `~/.claude/commands/`. So commands must be copied to be usable.

## Steps

### 1. Find the repo location
Determine where this repo lives. It will be something like `context-knowledgebase/` inside the project root. Use that path in the copy commands below.

### 2. Install slash commands to the project root
Copy the command files to `.claude/commands/` at the **project root** so they're available in this project:

```bash
mkdir -p .claude/commands
cp context-knowledgebase/.claude/commands/capture-conversation.md .claude/commands/capture-conversation.md
cp context-knowledgebase/.claude/commands/prune-knowledge.md .claude/commands/prune-knowledge.md
cp context-knowledgebase/.claude/commands/setup-knowledge-base.md .claude/commands/setup-knowledge-base.md
```

Also install globally so they're available in all future projects:

```bash
mkdir -p ~/.claude/commands
cp context-knowledgebase/.claude/commands/capture-conversation.md ~/.claude/commands/capture-conversation.md
cp context-knowledgebase/.claude/commands/prune-knowledge.md ~/.claude/commands/prune-knowledge.md
cp context-knowledgebase/.claude/commands/setup-knowledge-base.md ~/.claude/commands/setup-knowledge-base.md
```

### 2. Create the knowledge folder structure
In the current working directory (the project root, NOT inside the context-knowledgebase repo):

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

### 3. Update CLAUDE.md
In the project root, create or update `CLAUDE.md` to include the Knowledge Base section from this repo's `CLAUDE.md`. Do not overwrite any existing content — append or merge.

### 4. Confirm
Tell the user:
- Which files were created
- That `/capture-conversation` and `/prune-knowledge` are now available
- To restart Claude Code if the slash commands don't appear immediately
