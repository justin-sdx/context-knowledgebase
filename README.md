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

## Quick Start

1. Clone this repo (or copy the files) into your project root:

```bash
git clone https://github.com/YOUR_USERNAME/context-knowledge-base.git temp-kb
cp -r temp-kb/.claude temp-kb/docs temp-kb/CLAUDE.md your-project/
rm -rf temp-kb
```

2. If you already have a `CLAUDE.md`, merge the Knowledge Base section into it.

3. Restart Claude Code to register the `/capture-conversation` command.

4. Done. Start capturing.

## Usage

### Capturing Knowledge

Run `/capture-conversation` at the end of a session (or as you make decisions). Claude will:

- Extract knowledge from the conversation
- Classify each item as constraint, decision, or context
- Create files in the appropriate `docs/knowledge/` subfolder
- Update `_index.md` with new entries
- Auto-update `CLAUDE.md` with knowledge base instructions if not present

### Using Knowledge

New sessions automatically benefit:

1. Claude reads `docs/knowledge/_index.md` (per CLAUDE.md instructions)
2. Pulls relevant files based on your current task
3. Applies knowledge according to tier:
   - **Constraints** → follows strictly
   - **Decisions** → follows, may suggest revisiting
   - **Context** → uses to inform approach

### Example Knowledge File

Here's what a captured knowledge file looks like:

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

## Folder Structure

```
your-project/
├── .claude/
│   └── commands/
│       └── capture-conversation.md   # The /capture-conversation command
├── docs/
│   └── knowledge/
│       ├── _index.md                 # Master index (auto-updated)
│       ├── constraints/              # Hard rules
│       ├── decisions/                # Choices made
│       └── context/                  # Background info
└── CLAUDE.md                         # Project instructions for Claude
```

## Tips

- **Default to decision, not constraint** — constraints should be rare and intentional
- **Capture as you go** — don't wait until context runs out
- **Include "when to revisit"** in decision files
- **Prune context** — it grows fast and gets stale
- **Version control everything** — your knowledge base evolves with your project

## How It Differs from Spec-Driven Design

Spec-driven design defines what to build upfront. This captures *how you solved things* — preserving reasoning for future context injection. Over time, decisions may crystallize into constraints, but that's emergent, not prescribed.

## License

MIT
