# Constraints

Hard rules that must be followed strictly. Claude will not violate these without flagging and getting explicit user approval.

## What Belongs Here

- **Tech stack requirements** — languages, frameworks, libraries that are non-negotiable
- **Security requirements** — authentication patterns, encryption standards, vulnerability constraints
- **Compliance rules** — GDPR, HIPAA, PCI-DSS, or other regulatory requirements
- **Brand guidelines** — color schemes, typography, voice/tone requirements
- **Accessibility standards** — WCAG level requirements, screen reader support
- **Architecture constraints** — deployment targets, performance SLAs, integration requirements

## What Does NOT Belong Here

- Preferences that could reasonably change — those are **decisions**
- Background information without rules — that's **context**
- Temporary workarounds — those should have expiration dates and belong in decisions
- "Best practices" without hard requirements — suggest decisions instead

## How Many is Too Many?

If you have more than 10-15 constraint files, you likely have:
- **Decisions masquerading as constraints** — re-classify them
- **Over-specification** — combine related constraints
- **Micro-management** — step back and trust the process

Constraints should be rare and intentional. Each one limits flexibility, so use sparingly.

## File Template

Use `.claude/templates/knowledge-template.md` as a starting point. Key sections for constraints:

- **Summary** — What's the rule?
- **Detail** — Specific requirements and scope
- **Reasoning** — Why is this a hard constraint? What's at stake?
- **Usage** — How should Claude handle violation requests?

## Example

See `tech-stack-example.md` for a well-formed constraint file.
