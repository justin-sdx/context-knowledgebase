# The Reasoning Layer

## This Is Not Just a Developer Tool

The context-knowledgebase was built inside Claude Code, so it looks like a developer tool. It isn't.

It's a reasoning layer — memory and context infrastructure that makes Claude useful for any sustained knowledge work. The "code" in Claude Code is increasingly beside the point. You can use it to write documentation, explore design, develop strategy, run research, prototype ideas, and think through problems. The knowledge base is what makes that work *continuous* rather than starting over every session.

---

## The Problem for Non-Technical Users

Claude is genuinely useful in a single session. You bring it a problem, it helps you think through it. But when the session ends, everything you built together — the framing you landed on, the decisions you made, the directions you ruled out — is gone.

Next session, you start over. You re-explain the project. You re-establish the context. You re-make decisions you already made. The AI you're working with has no idea who you are or what you've been building.

For a one-off task, this is fine. For anything with duration — a product you're developing, a document you're writing across multiple sessions, a design you're iterating on — the context loss compounds into real cost.

---

## The Core Workflow

The pattern that makes this work for any type of project:

```
New work → new directory → drop in artifacts → start prompting → capture what comes out
```

**1. New work gets a new directory.**
Every project, every research thread, every piece of writing gets its own folder on your machine. That folder is the container for everything related to it — not just files, but the reasoning about it.

**2. Drop in your existing artifacts.**
Before the first Claude session, bring in whatever you already have:
- Notion docs, PRDs, product briefs
- Figma file links or exported specs
- Research papers, articles, reference material
- Old drafts, previous versions, competitor examples
- Brand guidelines, style guides, voice docs

These aren't just reference files. They're the starting context. Claude reads them and already understands the project — instead of you spending the first 20 minutes of every session re-explaining it.

**3. Start prompting.**
Work with Claude the way you normally would. Write, explore, decide, iterate.

**4. Capture what comes out.**
Run `/capture-conversation` at the end (or as you go). Claude extracts the reasoning — not a transcript, but the actual decisions and context that matter — and writes them into structured files. The knowledge base builds up as a side effect of working.

**5. Every future session starts informed.**
New session opens. Claude reads the index, loads the relevant knowledge, and picks up where you left off. No re-explaining. No lost context. The work is continuous.

---

## What This Looks Like in Practice

### Writing Documentation

You're writing product documentation for something you've been building for months. You bring in the PRD, the design specs, and a few example docs for tone reference.

Claude understands the product from the start. You work through structure — what sections make sense, who the audience is, what level of detail to go to. Those decisions get captured. Next session, Claude isn't asking you to re-explain the audience. It already knows.

The documentation gets written faster. More importantly, the *reasoning* behind the documentation — why it's structured this way, what the tone decisions were, what was deliberately left out — lives alongside it.

### Exploring Design

You're exploring design directions for a new product. You link to a Figma file, drop in a design brief, and describe what you're going for.

Claude helps you think through the directions. What's the visual language you're after? What are you reacting against? What do comparable products do, and why are you doing something different? You iterate on descriptions, explore reference directions, develop the conceptual frame.

The design reasoning gets captured. When you come back the next day, Claude already knows the direction you landed on and why. You're not re-litigating aesthetics every session.

### Vibe Prototyping

Before committing to building something, you want to test whether the idea actually makes sense. You drop in whatever you have — a rough brief, some notes, a few screenshots of things you like — and start exploring with Claude.

What's the core interaction? What does it feel like to use? What are the edge cases that would break the experience? What's the minimum version that would prove the concept?

The knowledge base captures the prototype reasoning — the decisions about what this is and isn't — before a single line of code is written. When you do start building, you're not figuring out what you're building while you build it.

### Research

You're going deep on a topic. You pull in papers, articles, reports, and start working through them with Claude. What's the current consensus? Where are the open questions? What are you trying to figure out?

Insights get captured as context. The knowledge base becomes a research library — not just files, but synthesized understanding. Future sessions don't start by re-reading everything. They start from what you already know.

### Product Strategy

You're working on positioning for a product. You bring in competitor research, customer interview notes, the current positioning doc, and some examples of messaging you admire.

You work through the positioning with Claude — what's the actual differentiation, who's the real audience, what's the frame that makes the product make sense. The strategic decisions get captured. When you bring in a copywriter or a designer later, the strategy is documented. They're not starting from zero.

---

## Why This Matters: Documentation as a Side Effect

The standard relationship between work and documentation looks like this:

> Do the work → (eventually) document it → documentation is immediately out of date

This system inverts that:

> Do the work → capture reasoning as you go → documentation is always current

You're not writing documentation. You're having conversations, making decisions, exploring ideas — and the documentation emerges as a byproduct of that process. The `/capture-conversation` command is the bridge between the working and the recording.

This matters especially for non-technical users because documentation is often the thing that doesn't happen. It's the task that gets skipped when time is short. When it's a side effect of your actual workflow, it happens automatically.

---

## What You Can Bring In

The richer the starting context, the faster Claude gets to useful work. Things worth importing at project start:

| Artifact | What it gives Claude |
|----------|---------------------|
| Notion docs / wikis | Existing knowledge, decisions already made, team context |
| PRDs / briefs | Scope, goals, constraints, stakeholder context |
| Figma file links | Visual intent, design language, component structure |
| Research papers / articles | Domain knowledge, prior art, reference material |
| Old drafts / previous versions | What was tried, why it changed, what to build on |
| Brand / style guidelines | Voice, tone, visual constraints |
| Competitor examples | What you're positioning against |
| Interview notes / user research | Who you're building for, what they actually said |

None of this requires technical knowledge to set up. Drop the files in the directory. Link to what you can't download. Tell Claude what they are. It reads them.

---

## The Deeper Value

Most knowledge work loses its reasoning. You have the output — the document, the design, the product — but the thinking that produced it lives in meeting notes nobody reads, in Slack threads that scroll away, in the heads of the people who were in the room.

When that reasoning is gone, work has to be re-done. Decisions get re-made. Teams re-litigate things they already resolved. New collaborators start from scratch instead of from what's already known.

The knowledge base keeps the reasoning alive. Not as an archive, but as an active layer that informs every future session. It makes your work with Claude cumulative — each session builds on the last — rather than episodic, where each session starts over.

That's the reasoning layer. It's not a feature of Claude. It's the infrastructure you build around it.
