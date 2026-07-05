#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Update data.csv in the repo in ONE command, via the GitHub API.
# GitHub needs the file's current sha to replace it, so this does
# the GET-sha + PUT-new-content in a single step for you.
#
# One-time setup:
#   1. Make a GitHub token (Settings → Developer settings →
#      Fine-grained tokens) with "Contents: Read and write" on this repo.
#   2. Fill in the four variables below (or export them in your shell).
#
# Usage:
#   ./update-data.sh path/to/new-data.csv
# ─────────────────────────────────────────────────────────────
set -euo pipefail

OWNER="YOUR_GITHUB_USERNAME"
REPO="first-million"
BRANCH="main"
FILE="data.csv"
TOKEN="${GITHUB_TOKEN:-YOUR_TOKEN_HERE}"

NEW_CSV="${1:?Usage: ./update-data.sh <new-data.csv>}"

API="https://api.github.com/repos/$OWNER/$REPO/contents/$FILE"

# 1) get current sha (empty if file doesn't exist yet)
SHA=$(curl -s -H "Authorization: Bearer $TOKEN" "$API?ref=$BRANCH" | grep '"sha"' | head -1 | cut -d'"' -f4 || true)

# 2) base64-encode the new file (portable across mac/linux)
CONTENT=$(base64 < "$NEW_CSV" | tr -d '\n')

# 3) PUT the update
curl -s -X PUT "$API" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "{\"message\":\"update revenue data\",\"content\":\"$CONTENT\",\"branch\":\"$BRANCH\"${SHA:+,\"sha\":\"$SHA\"}}" \
  | grep -E '"(name|message)"' | head -3

echo "✓ pushed $NEW_CSV to $OWNER/$REPO ($BRANCH). Reload the board to see it."
