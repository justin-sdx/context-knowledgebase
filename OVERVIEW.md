# Context Knowledge Base — Overview

## What It Is

A **persistent memory system for Claude Code**. It solves one of the most painful problems with AI-assisted development: Claude has zero memory between sessions. Every new conversation, you're starting from scratch — re-explaining your tech stack, re-litigating decisions you already made, re-providing context that took 30 minutes to build up the last time.

This project captures that reasoning *as structured markdown files* so Claude can reload it on demand.

---

## The Core Problem It Solves

Without this system, here's what happens:

- You spend Session 1 working through why you're using Zustand over Redux
- Session 2: Claude suggests Redux
- You spend 10 minutes re-explaining the decision
- Session 3: same thing
- Token limits force a reset mid-conversation — all reasoning lost
- You join an existing codebase: no idea what decisions were made, or why

With this system: Claude reads the index at session start, loads the relevant files, and already knows. You never re-explain.

---

## How It Works

### Three-Tier Knowledge Model

| Tier | What it holds | How Claude treats it |
|------|--------------|----------------------|
| **Constraints** | Hard rules — tech stack, security reqs, brand rules | Follows strictly, flags if asked to violate |
| **Decisions** | Architecture choices, naming conventions, process flows | Follows, but suggests revisiting if context has shifted |
| **Context** | Background, history, tradeoffs considered, domain info | Uses to inform approach — doesn't constrain |

The tiering is the key insight. Not all knowledge is equal. A constraint ("never use client-side auth") is different from a decision ("we chose Tailwind") which is different from context ("we explored CSS modules but ruled it out because...").

### File Structure

```
your-project/
├── CLAUDE.md                        ← tells Claude to check the index at session start
├── .claude/commands/
│   ├── capture-conversation.md      → /capture-conversation
│   ├── prune-knowledge.md           → /prune-knowledge
│   └── setup-knowledge-base.md     → /setup-knowledge-base
└── docs/knowledge/
    ├── _index.md                    ← master index — Claude reads this first
    ├── constraints/
    ├── decisions/
    └── context/
```

### The Loop

1. **Session start** → Claude reads `_index.md`, loads relevant files, applies by tier
2. **During work** → decisions get made, context gets built
3. **End of session** → `/capture-conversation` → Claude classifies everything, writes individual `.md` files, updates the index
4. **Next session** → Claude already knows

---

## The Three Slash Commands

**`/setup-knowledge-base`** — One-time setup. Creates the folder structure, installs commands globally (so every future project gets them automatically), updates `CLAUDE.md`.

**`/capture-conversation`** — The workhorse. Reviews the current conversation, extracts decisions/constraints/context, creates individual markdown files with full reasoning, updates `_index.md`. Run it at the end of a session or after any significant decision.

**`/prune-knowledge`** — Maintenance. Flags stale files (>6 months old), finds duplicates, checks for knowledge that contradicts current codebase patterns. Asks before deleting anything.

---

## Why It's Powerful

### 1. Solves the context window ceiling
Token limits don't kill your project memory anymore. The knowledge lives in files, not in the conversation. You can reset the session anytime without losing anything that matters.

### 2. Onboarding — for you and for collaborators
Coming into an existing codebase cold? If the previous developer ran `/capture-conversation` throughout their work, you inherit their reasoning — not just the code, but *why* the code is the way it is. This is the artifact most codebases completely lack.

### 3. Real-time capture as you go
You can run `/capture-conversation` mid-session, not just at the end. As you make decisions, capture them. The knowledge base builds up incrementally alongside your work.

### 4. CLAUDE.md as the control layer
The `CLAUDE.md` file is the enforcement mechanism. It tells Claude to check the index at session start, how to treat each tier, and how to handle conflicts. The knowledge files are the data — `CLAUDE.md` is the instruction set for how to use them.

### 5. Works across project types
The system is language/framework agnostic. It's just markdown files and slash commands. It works for a React app, a Python API, a data pipeline, or even non-code projects like research or writing.

---

## Use Cases

### Building new projects
Capture architectural decisions as you make them. When you come back in 3 weeks, Claude already knows your stack, your patterns, your reasoning.

### Coming into existing codebases
Run `/capture-conversation` after your first exploration session. Turn "here's what I learned about this codebase" into a structured knowledge base that future sessions can reference.

### Long-running projects
Prevents knowledge decay. Decisions made in month 1 don't silently get re-litigated in month 4 when a new session doesn't have context.

### General conversations and research
Any conversation worth having can be captured. Research findings, design decisions, product discussions, brainstorming sessions — all of it can be extracted into queryable markdown and referenced in future sessions.

### Storing and querying external research
Download relevant files, papers, and docs and store them in the knowledge structure. Claude can reference them like any other context file. Your project gets a living research library alongside its code.

### Team knowledge sharing
If the `.claude/commands/` folder is committed to git, teammates get the slash commands automatically on clone. The knowledge base becomes a shared artifact — decisions are visible, reasoned, and versioned.

---

## Design Principles

- **Default to `decision`, not `constraint`** — constraints should be rare and intentional
- **Include "when to revisit"** in every decision file — knowledge has a shelf life
- **Prune context aggressively** — it grows fast and goes stale fastest
- **Version control everything** — the knowledge base evolves with the project, and git gives you the history
- **Capture as you go** — don't wait until the end; mid-session capture is valid and often better

---

## What Makes It Genuinely Different

Most AI memory solutions try to bolt memory onto the model. This does the opposite: it treats Claude as a smart interpreter of structured files, and keeps the memory in your repo where you control it, can read it, can edit it, and can version it. The knowledge is yours — Claude is just the consumer.

It's not a plugin, not a service, not a database. It's markdown files and a CLAUDE.md instruction set. Completely portable, completely auditable, zero dependencies.

---

## How It Compares to Browser AI Projects

ChatGPT and Claude both offer "Projects" — persistent memory attached to a workspace. If you already use those, here's why this is different.

Browser Projects store memory on the provider's servers as a flat, opaque blob. All memory is applied with equal weight — a hard architectural rule and a casual preference are treated the same. You can't inspect exactly what the AI is acting on, you can't version it, and you can't share it with teammates through git. It's locked to one provider. And memory can shift silently based on conversations you didn't intend as instructions.

| | Browser Projects | This system |
|---|---|---|
| Where memory lives | Provider servers | Your repo |
| Structure | Flat blob | Tiered: constraints / decisions / context |
| What gets captured | What you said | Why you decided it |
| Version history | No | Git |
| Team shareable | No | Commit it; teammates inherit it |
| Provider-agnostic | No | Yes — any tool that reads files |
| Capture method | Automatic, opaque | Intentional, reviewed by you |

The more important difference is what gets stored. Browser Projects capture facts and preferences. This system captures reasoning — why a decision was made, what alternatives were ruled out, and when it should be revisited.

That's what most knowledge work loses. The output survives. The thinking that produced it usually doesn't.
