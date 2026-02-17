# Installing Git Hooks

This project includes a pre-commit hook that validates knowledge base files before committing.

## Install the Hook

From your project root:

```bash
# Copy the hook to your git hooks directory
cp .claude/templates/pre-commit-hook.sh .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit
```

## What the Hook Does

The pre-commit hook validates:
- ✅ Required fields present (`**Tier:**`, `**Summary**`, `**Usage**`)
- ✅ Tier value is valid (`constraint`, `decision`, or `context`)
- ⚠️  Decision files have "When to Revisit" section
- ⚠️  Filename follows kebab-case convention
- ⚠️  `_index.md` is updated when knowledge files change
- ⚠️  Index metadata is current

Items marked with ✅ are errors (block commit). Items marked with ⚠️  are warnings (show but allow commit).

## Customizing Validation

Edit `.git/hooks/pre-commit` to adjust which checks are errors vs warnings.

To make a warning into an error, uncomment the line:
```bash
# total_errors=$((total_errors + 1))
```

## Bypassing the Hook

If you need to commit without validation:

```bash
git commit --no-verify -m "your message"
```

## Removing the Hook

```bash
rm .git/hooks/pre-commit
```

## Note on Sharing Hooks

Git hooks are local and not checked into the repository. Each team member needs to install them separately. Consider adding hook installation to your project's setup documentation.

Alternatively, use a tool like [Husky](https://typicode.github.io/husky/) to manage git hooks as part of your project.
