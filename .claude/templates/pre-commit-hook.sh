#!/bin/bash
# Knowledge Base Pre-Commit Hook
# Validates knowledge files and ensures index is updated

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🔍 Validating knowledge base..."

# Check if knowledge files were modified
KNOWLEDGE_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep "^docs/knowledge/" || true)

if [ -z "$KNOWLEDGE_FILES" ]; then
  echo "✅ No knowledge files modified"
  exit 0
fi

# Function to validate knowledge file format
validate_knowledge_file() {
  local file=$1
  local errors=0

  # Skip _index.md and README files
  if [[ "$file" == *"_index.md"* ]] || [[ "$file" == *"README.md"* ]]; then
    return 0
  fi

  # Check if file has required fields
  if ! grep -q "^**Tier:**" "$file"; then
    echo -e "${RED}❌ Missing '**Tier:**' in $file${NC}"
    errors=$((errors + 1))
  fi

  if ! grep -q "^**Date:**" "$file"; then
    echo -e "${YELLOW}⚠️  Missing '**Date:**' in $file${NC}"
  fi

  if ! grep -q "^**Summary**" "$file"; then
    echo -e "${RED}❌ Missing '**Summary**' section in $file${NC}"
    errors=$((errors + 1))
  fi

  if ! grep -q "^**Usage**" "$file"; then
    echo -e "${YELLOW}⚠️  Missing '**Usage**' section in $file${NC}"
  fi

  # Check tier value
  tier=$(grep "^**Tier:**" "$file" | sed 's/**Tier:** *//')
  if [[ ! "$tier" =~ ^(constraint|decision|context)$ ]]; then
    echo -e "${RED}❌ Invalid tier '$tier' in $file (must be: constraint, decision, or context)${NC}"
    errors=$((errors + 1))
  fi

  # Check if decision has "When to Revisit"
  if [ "$tier" = "decision" ] && ! grep -q "**When to Revisit**" "$file"; then
    echo -e "${YELLOW}⚠️  Decision file missing '**When to Revisit**' section: $file${NC}"
  fi

  # Check filename format (kebab-case)
  filename=$(basename "$file")
  if [[ ! "$filename" =~ ^[a-z0-9-]+\.md$ ]]; then
    echo -e "${YELLOW}⚠️  Filename should be kebab-case: $file${NC}"
  fi

  return $errors
}

# Validate each modified knowledge file
total_errors=0
for file in $KNOWLEDGE_FILES; do
  if [ -f "$file" ]; then
    validate_knowledge_file "$file"
    total_errors=$((total_errors + $?))
  fi
done

# Check if index was updated when knowledge files were added/modified
INDEX_MODIFIED=$(git diff --cached --name-only | grep "docs/knowledge/_index.md" || true)
NON_INDEX_FILES=$(echo "$KNOWLEDGE_FILES" | grep -v "_index.md" | grep -v "README.md" || true)

if [ -n "$NON_INDEX_FILES" ] && [ -z "$INDEX_MODIFIED" ]; then
  echo -e "${YELLOW}⚠️  Knowledge files modified but _index.md not updated${NC}"
  echo "   Modified files:"
  echo "$NON_INDEX_FILES" | sed 's/^/     - /'
  echo ""
  echo "   Run '/capture-conversation' or manually update docs/knowledge/_index.md"

  # Uncomment to make this a hard error:
  # total_errors=$((total_errors + 1))
fi

# Check if index metadata is current
if [ -n "$INDEX_MODIFIED" ]; then
  TODAY=$(date +%Y-%m-%d)
  LAST_UPDATED=$(grep "^Last updated:" docs/knowledge/_index.md | sed 's/Last updated: //')

  if [ "$LAST_UPDATED" != "$TODAY" ]; then
    echo -e "${YELLOW}⚠️  Index 'Last updated' date is not today: $LAST_UPDATED${NC}"
    echo "   Update it to: $TODAY"
    # Uncomment to make this a hard error:
    # total_errors=$((total_errors + 1))
  fi
fi

# Exit with error if validation failed
if [ $total_errors -gt 0 ]; then
  echo ""
  echo -e "${RED}❌ Knowledge base validation failed with $total_errors error(s)${NC}"
  echo "   Fix the errors above or use 'git commit --no-verify' to skip validation"
  exit 1
fi

echo -e "${GREEN}✅ Knowledge base validation passed${NC}"
exit 0
