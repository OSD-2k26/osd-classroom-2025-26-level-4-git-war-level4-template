#!/bin/bash
set -e

# Expected content (case-insensitive check)
EXPECTED="system_status=ok"

# Check system.txt exists
[ -f system.txt ] || {
  echo "❌ system.txt not found"
  exit 1
}

CONTENT=$(cat system.txt | tr '[:upper:]' '[:lower:]')

if [ "$CONTENT" != "$EXPECTED" ]; then
  echo "❌ system.txt content is incorrect"
  exit 1
fi

# Ensure commit count unchanged (must still be 3 or more, but not fewer)
COUNT=$(git rev-list --count HEAD)

if [ "$COUNT" -lt 3 ]; then
  echo "❌ Commit history was altered"
  exit 1
fi

# Ensure original commit messages still exist (case-insensitive)
MESSAGES=$(git log --pretty=%B | tr '[:upper:]' '[:lower:]')

echo "$MESSAGES" | grep -q "initial state" || {
  echo "❌ Original commit 'initial state' missing"
  exit 1
}

echo "$MESSAGES" | grep -q "update system" || {
  echo "❌ Original commit 'update system' missing"
  exit 1
}

echo "$MESSAGES" | grep -q "attempt fix" || {
  echo "❌ Original commit 'attempt fix' missing"
  exit 1
}

echo "✅ Hard Level A Passed"
