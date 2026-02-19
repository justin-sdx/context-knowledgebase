# Context Knowledge Base

A lightweight system for preserving Claude Code conversation logic across sessions.

## The Problem

Long conversations hit token limits, forcing resets that lose valuable reasoning. You're left re-explaining decisions you've already made.

## The Solution

Capture knowledge as markdown files *as you go* — not just the answers, but how you got there. Claude automatically references this knowledge in future sessions.

## Three Tiers

| Tier | Purpose | Claude's Behavior |
|------|---------|-------------------|
| **Constraints** | Hard rules | Follow strictly, flag violations |
| **Decisions** | Choices made | Follow, suggest revisiting if stale |
| **Context** | Background info | Inform, don't constrain |

---

## Setup

### How this repo is meant to be used

Clone this repo as a subdirectory inside your project:

```
your-project/
├── context-knowledgebase/   ← this repo
├── src/
├── CLAUDE.md
└── ...
```

### Important: how Claude Code loads commands

Claude Code loads slash commands from two places only:
- `~/.claude/commands/` — global, available in all projects
- `.claude/commands/` at the **project root** — local to that project

It does **not** scan subdirectories. So commands inside `context-knowledgebase/.claude/commands/` won't load automatically — they need to be copied up.

### First time setup (new machine or new team member)

**Step 1: Clone into your project**
```bash
cd your-project
git clone https://github.com/justin-sdx/context-knowledgebase.git context-knowledgebase
```

**Step 2: Bootstrap the commands**

Copy the commands to your project root so Claude Code can load them:
```bash
mkdir -p .claude/commands
cp context-knowledgebase/.claude/commands/*.md .claude/commands/
```

**Step 3: Open Claude Code and run**
```
/setup-knowledge-base
```

This will:
- Create `docs/knowledge/` folder structure at your project root
- Install all commands to `~/.claude/commands/` globally (so future projects skip Step 2)
- Create or update your project's `CLAUDE.md` with knowledge base instructions

**Optional: Install git hooks for validation**
```bash
cp context-knowledgebase/.claude/templates/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Adding to a new project (after first-time setup)

Once the global commands are installed, Step 2 (the manual copy) is no longer needed. For any new project:

```bash
cd new-project
git clone https://github.com/justin-sdx/context-knowledgebase.git context-knowledgebase
```

Then open Claude Code and run `/setup-knowledge-base`. The global install handles the rest.

### Auto-detection

The repo's `CLAUDE.md` tells Claude to check at session start whether setup has been run. If `docs/knowledge/_index.md` doesn't exist in your project root, Claude will prompt you to run `/setup-knowledge-base` automatically.

---

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/setup-knowledge-base` | One-time setup — creates folder structure, installs commands, updates CLAUDE.md |
| `/capture-conversation` | Extract knowledge from the current session into structured files |
| `/prune-knowledge` | Find and clean stale or duplicate knowledge files |

---

## Daily Usage

### Capturing knowledge

Run `/capture-conversation` at the end of a session (or as you make decisions). Claude will:

- Extract knowledge from the conversation
- Classify each item as constraint, decision, or context
- Create files in the appropriate `docs/knowledge/` subfolder
- Update `_index.md` with new entries

### Maintaining knowledge

```bash
# Run periodically to find stale files
/prune-knowledge
```

### How new sessions use knowledge

1. Claude reads `docs/knowledge/_index.md` at session start (per `CLAUDE.md` instructions)
2. Loads relevant files based on your current task
3. Applies knowledge according to tier:
   - **Constraints** → follows strictly
   - **Decisions** → follows, may suggest revisiting
   - **Context** → uses to inform approach

---

## Folder Structure

After setup, your project will look like this:

```
your-project/
├── .claude/
│   └── commands/
│       ├── capture-conversation.md   # /capture-conversation
│       ├── prune-knowledge.md        # /prune-knowledge
│       └── setup-knowledge-base.md  # /setup-knowledge-base
├── context-knowledgebase/            # this repo
│   ├── .claude/
│   │   ├── commands/                 # source of truth for commands
│   │   └── templates/
│   │       ├── knowledge-template.md
│   │       ├── pre-commit-hook.sh
│   │       └── INSTALL-HOOKS.md
│   └── docs/knowledge/               # example files only
├── docs/
│   └── knowledge/                    # your actual knowledge lives here
│       ├── _index.md                 # master index (auto-updated)
│       ├── constraints/              # hard rules
│       ├── decisions/                # choices made
│       └── context/                  # background info
└── CLAUDE.md                         # project instructions (includes KB section)
```

---

## Example Knowledge File

```markdown
**Tier:** decision

**Summary**
Use Tailwind CSS for styling instead of custom CSS

**Detail**
- Switched from writing custom CSS to using Tailwind utility classes
- Applied across all component files in src/components/
- Configured in tailwind.config.js with custom theme extensions

**Reasoning**
- Reduces CSS bundle size and eliminates unused styles
- Provides consistent design system through configuration
- Faster development with utility-first approach
- Team already familiar with Tailwind from previous projects

**Usage**
Continue using Tailwind for all new components. Revisit if:
- Bundle size becomes an issue despite purging
- Team composition changes and new members prefer different approach
- Design system needs exceed Tailwind's customization capabilities
```

---

## When NOT to Use This System

- **Brand new projects** (<1 week old) — you don't have decisions to capture yet
- **One-off prototypes** — the overhead isn't worth it for throwaway code
- **Projects with existing documentation systems** — don't create competing sources of truth
- **Highly regulated environments** — use your compliance-approved documentation tools instead

---

## Tips

- **Default to decision, not constraint** — constraints should be rare and intentional
- **Capture as you go** — don't wait until context runs out
- **Include "when to revisit"** in decision files
- **Prune context aggressively** — it grows fast and gets stale fastest
- **Version control everything** — your knowledge base evolves with your project

---

## Troubleshooting

### Slash commands not appearing

**Cause:** Commands are in a subdirectory, not the project root or `~/.claude/commands/`.

**Fix:**
```bash
mkdir -p .claude/commands
cp context-knowledgebase/.claude/commands/*.md .claude/commands/
```
Then restart Claude Code.

### Knowledge not being applied in new sessions

**Solutions:**
1. Check that `CLAUDE.md` at your project root has the Knowledge Base section
2. Verify `docs/knowledge/_index.md` exists and is up to date
3. Restart Claude Code to reload project instructions

### Too many knowledge files (>30)

1. Run `/prune-knowledge` to identify stale files
2. Consolidate related files — merge instead of creating new ones
3. Be selective: not every conversation has lasting knowledge

### Conflicting knowledge between files

1. Constraints always take precedence over decisions
2. More recent "Last Reviewed" date wins for decisions
3. Update the outdated file: "Superseded by: [new-file].md"

### Claude suggests changes that violate constraints

1. Verify the file is classified as `constraint`, not `decision`
2. Make the constraint explicit about what behavior is prohibited
3. Check that the constraint file is listed in `_index.md`

---

## License

MIT
