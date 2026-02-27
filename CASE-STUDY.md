# Case Study: Building a Persistent Memory System for Claude Code

---

## The Problem

Claude Code is a genuinely powerful development tool. But it has a structural limitation that compounds with every session: **no memory between conversations**.

This creates a specific kind of friction that's easy to underestimate until you hit it repeatedly. You make a decision — say, choosing a state management library — and spend 20 minutes working through why with Claude. The next session, that reasoning is gone. Claude might suggest the thing you already ruled out. You re-explain. Then the session hits a token limit and resets. You re-explain again.

For short projects or one-off tasks, this is manageable. For anything with duration — a real product, a codebase you're maintaining, a research project that spans weeks — the cumulative cost of re-explanation is significant. And it's not just time: it's the risk that without the reasoning in view, the decision gets quietly reversed.

Browser-based AI tools partially address this — ChatGPT and Claude both offer "Projects" that persist memory across sessions. But they don't solve the core problem. Memory is stored as a flat blob on provider servers, applied opaquely, and all knowledge is weighted equally. There's no distinction between a hard constraint and casual context. And critically, they capture what you said, not why you decided it. When you return to a project, the facts may surface — but the reasoning behind them usually doesn't.

The specific trigger: working on a project across multiple sessions and noticing that the quality of Claude's assistance degraded sharply after a context reset. Not because Claude got worse — but because the context it had been operating on was gone.

---

## The Build

### Starting Point: What Does "Memory" Actually Mean Here?

The first question wasn't "how do we store memory" — it was "what kind of memory matters?"

A naive approach would be to dump conversation transcripts into files and feed them back in. But transcripts are noisy, verbose, and expensive in tokens. What you actually need isn't the full conversation — it's the *decisions and reasoning that came out of it*.

This distinction shaped everything.

The system was designed to capture **derived artifacts** from conversations, not the conversations themselves. The `/capture-conversation` command doesn't archive a transcript — it runs Claude's understanding over the conversation and extracts what's worth keeping.

### The Three-Tier Model

The most important design decision was the tiering system: constraints, decisions, and context.

Early versions treated all knowledge the same. But that created two problems. First, Claude would apply everything with the same weight — treating a piece of background context with the same rigidity as a hard architectural requirement. Second, there was no clear signal for when knowledge was worth revisiting versus when it should be followed without question.

The three tiers solved both:

- **Constraints** are for things that genuinely shouldn't be re-litigated — security requirements, compliance rules, non-negotiable stack choices. Claude flags if asked to violate them.
- **Decisions** are for choices made with good reasoning, but with the explicit understanding that context can shift. They include a "when to revisit" note.
- **Context** is background that informs without constraining — history, tradeoffs explored, domain knowledge.

The key design principle that emerged: **default to decision, not constraint**. Constraints should be rare. If everything is a constraint, nothing is. The system only works if the tiers carry real signal.

### CLAUDE.md as the Enforcement Layer

The knowledge files are the data. But data is useless without an instruction set for how to use it.

`CLAUDE.md` is that instruction set. Every project gets a `CLAUDE.md` with a Knowledge Base section that tells Claude:
- Check the index at session start
- Load relevant files
- Apply knowledge according to tier
- Handle conflicts (constraints over decisions, newer date wins for decisions)
- Flag stale knowledge

This means the system is self-bootstrapping. A new session opens, Claude reads `CLAUDE.md`, understands the protocol, and applies it. No plugins, no integrations, no external services.

### The Slash Command Interface

Three commands cover the full lifecycle:

`/setup-knowledge-base` handles first-time setup — creates the folder structure, installs commands globally, updates `CLAUDE.md`. Designed to work even without the repo cloned (once commands are globally installed, any new project can run it directly).

`/capture-conversation` is the workhorse. It reviews the current conversation, classifies knowledge by tier, creates individual files with reasoning, and updates the master index. The key constraint on this command: check for existing similar knowledge before creating duplicates. The knowledge base should converge, not sprawl.

`/prune-knowledge` handles maintenance — flagging stale files, finding duplicates, checking index accuracy. Designed to be conservative: suggest review rather than delete, archive rather than remove, ask before acting.

### The Index as the Entry Point

Rather than loading all knowledge files at session start (expensive in tokens, not always relevant), Claude loads one file: `_index.md`. The index is a flat list organized by tier with a one-line description for each entry.

Claude then decides which files are relevant to the current task and loads those. This keeps token usage proportional to what's actually needed, and scales cleanly as the knowledge base grows.

---

## What Emerged in Practice

A few things became clear through use that weren't obvious in the design phase:

**The system is more general than it first appears.** It was designed for codebases, but it works just as well for research projects, product conversations, even general-purpose knowledge accumulation. Any conversation with lasting value can be captured. Some users are now running `/capture-conversation` on non-code sessions and organizing outputs into project-specific knowledge directories.

**Capture mid-session, not just at the end.** The initial mental model was "run this at the end of a session." But there's real value in capturing decisions as they're made — before the conversation has moved on and the reasoning is still fresh. Mid-session captures are often more precise than end-of-session captures.

**The `CLAUDE.md` mechanism is the most transferable part.** The three-tier model and the knowledge files are useful, but the deeper pattern — using `CLAUDE.md` as an instruction set that loads automatically at session start — is applicable far beyond this specific system. Teams are using the same pattern to encode style guides, workflow rules, and project-specific Claude behaviors.

**Git as the persistence layer.** Because everything is markdown in version control, you get history for free. You can see when a decision was made, how the reasoning evolved, and what was pruned. The knowledge base becomes a living document with an audit trail.

---

## Current State

The system is deployed and in active use across projects. The core loop — setup, capture, prune — is stable. The CLAUDE.md protocol is working as designed: new sessions load the index, apply knowledge by tier, and don't re-litigate settled decisions.

Key behaviors confirmed working:
- Session start knowledge loading without manual prompting
- Correct tier application (constraints flagged on violation, decisions suggested for revisit when context shifts)
- Conflict resolution following the priority rules
- Stale knowledge identification

---

## Where It Could Go

### 1. Automatic Capture Triggers

Currently, capture is manual — you run `/capture-conversation`. The natural evolution is automatic triggers: capture on session end, capture when a decision keyword is detected, capture after a certain token threshold is hit. Claude Code's hooks system (`SessionEnd`, etc.) could power this. The knowledge base would build itself.

### 2. Cross-Project Knowledge

Right now, each project has its own isolated knowledge base. But some knowledge is worth sharing across projects — preferred libraries, standard patterns, team conventions. A global knowledge layer (parallel to the project layer) would let you capture "I always use this auth pattern" once and have it available everywhere.

### 3. Knowledge Diffing

When `/capture-conversation` runs, it could diff new knowledge against existing knowledge and surface conflicts automatically. Currently, Claude does this check during capture, but it's not explicit. A structured diff output — "this decision contradicts constraint X, here's the conflict" — would make maintenance much more deliberate.

### 4. Team Synchronization

The knowledge base is a git repo, which means it's already version-controlled and shareable. The next step is team workflows: who approves a new constraint before it's committed? How do you handle a constraint one developer adds that another would dispute? The file structure supports PR-based review of knowledge changes — this is just a workflow convention away.

### 5. Knowledge Graphs

Right now, knowledge files reference each other informally ("see constraints/api-auth.md"). A more structured approach would be explicit dependency links — "this decision was made given this constraint" — and tooling that lets you trace the reasoning chain. Useful for understanding why a complex set of decisions coheres.

### 6. Export and Portability

The knowledge base is already portable (it's just markdown). But structured export — "give me everything about authentication as a single document" — would make it useful for onboarding, documentation generation, and feeding into other tools. A `/export-knowledge` command that assembles a coherent document from the knowledge base is a natural extension.

### 7. Integration with Other AI Tooling

The CLAUDE.md pattern is Claude-specific, but the underlying knowledge files are plain markdown. They could serve as context for any AI tool that accepts file input — GitHub Copilot, Cursor, custom RAG pipelines. The knowledge base could become a project's canonical AI context layer, not just Claude's.

---

## The Bigger Insight

This project was built to solve a specific problem: context loss across Claude Code sessions. But the system it produced points at something broader.

Most software projects accumulate decisions continuously — in Slack threads, in PR comments, in Notion docs that nobody updates, in the heads of the people who were there when the call was made. That knowledge degrades. People leave. Docs go stale. The codebase accumulates patterns whose origins are unknown.

A knowledge base that's captured in real time, versioned with the code, and loaded automatically into the AI tools working on the project is a different model. The reasoning that produced the code lives adjacent to the code. Future sessions — and future developers — aren't starting from zero.

The core bet is simple: **the most valuable thing a developer conversation produces isn't the code. It's the reasoning behind it.** This system makes that reasoning first-class.
