---
description: Identify and clean stale or unused knowledge files
allowed-tools: Read, Write, Glob, Edit, Bash
context: inline
---

# Prune Knowledge Base

Review the knowledge base and identify files that may be stale, outdated, or no longer relevant.

Reference these files:
- @docs/knowledge/_index.md - The master index
- All files in @docs/knowledge/constraints/, @docs/knowledge/decisions/, @docs/knowledge/context/

## Tasks

### 1. Check for Stale Files
Review all knowledge files and flag any that:
- Have "Last Reviewed" date >6 months old
- Reference tools, libraries, or approaches no longer in the codebase
- Have "When to Revisit" conditions that are now met
- Contain information that contradicts current code patterns

### 2. Identify Duplicates or Overlaps
Look for:
- Multiple files covering the same topic
- Files that should be merged
- Information split across files that should be consolidated

### 3. Check Index Accuracy
Verify that:
- All files listed in `_index.md` actually exist
- All files in the tier folders are listed in `_index.md`
- Descriptions in index match the Summary in each file
- Item counts are accurate

### 4. Analyze Usage Patterns (Optional)
If git history is available, check:
```bash
# Files that haven't been edited in >6 months
find docs/knowledge -name "*.md" -type f -mtime +180
```

## Output Format

Provide a summary report:

### Stale Knowledge (Recommend Review)
- `filename.md` - Last reviewed: DATE, Issue: [description]

### Duplicate/Overlapping Knowledge
- `file1.md` and `file2.md` - Overlap: [description], Suggest: merge into [new-name]

### Index Issues
- Missing from index: `file.md`
- Listed but doesn't exist: `old-file.md`
- Count mismatch: Index shows X, actual is Y

### Recommended Actions
1. Archive or update: [list of files]
2. Merge: [pairs of files to combine]
3. Update index: [specific changes needed]

## Actions

After presenting the report:
- Ask user which files to archive (move to `docs/knowledge/archived/`)
- Ask which to update (bump Last Reviewed date if still valid)
- Ask which to merge (consolidate and remove duplicates)
- Update `_index.md` to reflect changes
- Update metadata (last updated date, item counts)

## Guidelines

- Don't delete knowledge without user approval
- When archiving, preserve files in `docs/knowledge/archived/` folder
- Add archive note to index: `- [filename.md](./archived/filename.md) — [ARCHIVED 2026-02-17] description`
- Be conservative: suggest review rather than assuming knowledge is wrong
- Context tier files should be pruned most aggressively (they grow stale fastest)
- Constraint tier files should rarely be pruned (they represent stable requirements)
