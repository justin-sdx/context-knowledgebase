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

**Option 1: Use as project template**
```bash
git clone https://github.com/YOUR_USERNAME/context-knowledge-base.git your-project
cd your-project
# Start building, knowledge structure is ready
```

**Option 2: Add to existing project**
```bash
cd your-project

# Download and extract just the needed files
curl -L https://github.com/YOUR_USERNAME/context-knowledge-base/archive/main.tar.gz | \
  tar xz --strip-components=1 -C . \
  'context-knowledge-base-main/.claude' \
  'context-knowledge-base-main/docs' \
  'context-knowledge-base-main/CLAUDE.md'
```

**If you already have CLAUDE.md:** Merge the Knowledge Base section from the downloaded file.

**Finish setup:**
```bash
# Restart Claude Code to register commands
claude restart  # or just restart your terminal session

# Optional: Install git hooks for validation
cp .claude/templates/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Done! Run `/capture-conversation` to start building your knowledge base.

## Usage

### Capturing Knowledge

Run `/capture-conversation` at the end of a session (or as you make decisions). Claude will:

- Extract knowledge from the conversation
- Classify each item as constraint, decision, or context
- Create files in the appropriate `docs/knowledge/` subfolder
- Update `_index.md` with new entries
- Auto-update `CLAUDE.md` with knowledge base instructions if not present

### Maintaining Knowledge

Keep your knowledge base healthy:

```bash
# Run periodically to find stale files
/prune-knowledge

# Review the report and clean up outdated knowledge
```

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
│   ├── commands/
│   │   ├── capture-conversation.md   # /capture-conversation command
│   │   └── prune-knowledge.md        # /prune-knowledge command
│   └── templates/
│       ├── knowledge-template.md     # Template for new knowledge files
│       ├── pre-commit-hook.sh        # Git hook for validation
│       └── INSTALL-HOOKS.md          # Hook installation guide
├── docs/
│   └── knowledge/
│       ├── _index.md                 # Master index (auto-updated)
│       ├── constraints/              # Hard rules
│       │   ├── README.md             # Guide for this tier
│       │   └── tech-stack-example.md # Example constraint
│       ├── decisions/                # Choices made
│       │   ├── README.md             # Guide for this tier
│       │   └── state-management-example.md # Example decision
│       └── context/                  # Background info
│           ├── README.md             # Guide for this tier
│           └── api-migration-history.md # Example context
└── CLAUDE.md                         # Project instructions for Claude
```

## When NOT to Use This System

This knowledge base system is NOT appropriate for:

- **Brand new projects** (<1 week old) — you don't have decisions to capture yet
- **One-off prototypes** — the overhead isn't worth it for throwaway code
- **Projects with existing documentation systems** — don't create competing sources of truth
- **Small team with daily sync** — if everyone is always aligned, this may be overkill
- **Highly regulated environments** — use your compliance-approved documentation tools instead

If your project fits these criteria, stick with README files and inline comments.

## Tips

- **Default to decision, not constraint** — constraints should be rare and intentional
- **Capture as you go** — don't wait until context runs out
- **Include "when to revisit"** in decision files
- **Prune context** — it grows fast and gets stale
- **Version control everything** — your knowledge base evolves with your project
- **Review quarterly** — set a reminder to check if decisions are still relevant

## How It Differs from Spec-Driven Design

Spec-driven design defines what to build upfront. This captures *how you solved things* — preserving reasoning for future context injection. Over time, decisions may crystallize into constraints, but that's emergent, not prescribed.

## Troubleshooting

### Knowledge not being applied in new sessions

**Symptoms:** Claude doesn't reference knowledge from previous sessions

**Solutions:**
1. Check that `CLAUDE.md` exists in your project root with the Knowledge Base section
2. Verify `docs/knowledge/_index.md` is updated with your files
3. Try explicitly mentioning: "Check the knowledge base for context"
4. Restart Claude Code to reload project instructions

### Too many knowledge files (>30 files)

**Symptoms:** Knowledge base feels overwhelming, hard to maintain

**Solutions:**
1. Run `/prune-knowledge` to identify stale files
2. Consolidate related files (e.g., merge 3 API decision files into one)
3. Move purely historical context to an `archived/` folder
4. Be more selective: not every conversation needs capturing

### Conflicting knowledge between files

**Symptoms:** Two files say different things about the same topic

**Solutions:**
1. Check "Last Reviewed" dates — newer usually wins for decisions
2. Check tier — constraints override decisions
3. Update the outdated file with: "Superseded by: [new-file].md"
4. Run `/prune-knowledge` to catch these systematically

### Claude suggests changes that violate knowledge

**Symptoms:** Claude recommends approaches that contradict your constraints

**Solutions:**
1. Check that the constraint is properly classified (tier: constraint, not decision)
2. Verify the Usage section clearly states how to handle violations
3. Make the constraint more explicit about what's not allowed
4. Remember: Claude may suggest revisiting decisions if context has changed (that's by design)

### Knowledge base growing too fast

**Symptoms:** Capturing every conversation, files accumulating rapidly

**Solutions:**
1. Be selective: not every conversation has lasting knowledge
2. Default to updating existing files rather than creating new ones
3. Keep summaries concise — avoid essay-length knowledge files
4. Focus on **why** over **what** (reasoning, not implementation details)

### Can't find knowledge when needed

**Symptoms:** You know it's documented but can't locate the file

**Solutions:**
1. Improve `_index.md` descriptions to be more searchable
2. Use grep: `grep -r "search term" docs/knowledge/`
3. Add cross-references between related files
4. Consider consolidating files if they're too granular

### New team members overwhelmed by knowledge base

**Symptoms:** Onboarding takes longer because of knowledge base

**Solutions:**
1. Add `docs/knowledge/START-HERE.md` with essentials
2. Mark critical files in the index with 🔴 or (CRITICAL)
3. Move nice-to-know context to a separate `reference/` folder
4. Remember: constraints are must-read, context can be discovered as needed

## License

MIT
