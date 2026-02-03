---
name: commit
description: "This skill should be used when the user asks to commit changes, make a commit, or mentions git commit"
version: 3.0.0
---

# /commit - Smart Git Commit

## Purpose
Execute git commit with intelligent analysis, project-specific settings, and meaningful commit messages.

## Workflow

### Step 1: Load Project Settings
```bash
# Check for project-specific settings
cat .skillforge.json 2>/dev/null
```

**Settings schema (`index` section):**
```json
{
  "index": {
    "enabled": true,
    "file": "INDEX.md",
    "track": ["*Service.groovy", "*Utils.groovy"],
    "timestampFormat": "YYYY-MM-DD HH:mm"
  },
  "commit": {
    "language": "ko",
    "conventionalCommits": true,
    "coAuthor": "Claude <noreply@anthropic.com>"
  }
}
```

### Step 2: Check Current Status
```bash
git status
git diff --staged --stat
git diff --stat  # unstaged changes
```

### Step 3: Analyze Changed Files
Identify the nature of changes:
- **New files**: What functionality is being added?
- **Modified files**: What is being changed/fixed/improved?
- **Deleted files**: What is being removed and why?

### Step 4: Update Index File (if configured)
If `.skillforge.json` has `index.enabled: true`:

1. **Check if tracked files changed:**
   ```bash
   # Example: check if Service/Utils files changed
   git diff --name-only | grep -E "(Service|Utils)\.(groovy|java|ts)$"
   ```

2. **If tracked files changed, update index:**
   - Read changed files to identify new/modified methods
   - Update the index file with new entries
   - Update timestamp if `timestampFormat` is set

3. **Stage the index file:**
   ```bash
   git add <index.file>  # e.g., INDEX.md
   ```

### Step 5: Auto-detect Project Conventions
If no `.skillforge.json`, detect from project:
```bash
# Check for conventional commits config
cat .commitlintrc* 2>/dev/null
cat package.json | grep -A5 '"commitlint"' 2>/dev/null

# Check for existing commit style
git log --oneline -10
```

### Step 6: Stage and Commit
```bash
# Stage specific files (preferred over git add -A)
git add <files>

# Commit with descriptive message
git commit -m "$(cat <<'EOF'
<type>: <brief description>

<optional body>

Co-Authored-By: <coAuthor from settings or default>
EOF
)"
```

## Commit Message Guidelines

### Language Setting
From `.skillforge.json`:
- `"language": "ko"` → Korean commit messages
- `"language": "en"` → English commit messages (default)

### Conventional Commits (Default)
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
| Type | Description (en) | Description (ko) |
|------|------------------|------------------|
| `feat` | New feature | 기능 추가 |
| `fix` | Bug fix | 버그 수정 |
| `docs` | Documentation only | 문서 |
| `style` | Formatting, no code change | 스타일 |
| `refactor` | Code restructuring | 리팩토링 |
| `test` | Adding/updating tests | 테스트 |
| `chore` | Maintenance tasks | 기타 |
| `perf` | Performance improvement | 성능 개선 |

### Custom Format
If `conventionalCommits: false`:
- Follow patterns from `git log --oneline -10`
- Match the project's existing style

## Index Update Rules

When `index.enabled: true` and tracked files are modified:

1. **Detect new/modified public methods** in tracked files
2. **Update index file** with format:
   ```markdown
   | Method | Description |
   |--------|-------------|
   | methodName(params) | Brief description |
   ```
3. **Update timestamp** at bottom:
   ```markdown
   *Last updated: 2024-01-15 14:30*
   ```

## Split Commits Option
If multiple unrelated changes exist, ask user:
- Single commit (combine all)
- Split by functionality (separate commits)

## Pre-commit Hook Handling
If commit fails due to pre-commit hooks:
1. Read hook output carefully
2. Fix the reported issues (lint, format, tests)
3. Re-stage fixed files
4. Create a NEW commit (never use --amend after hook failure)

## Usage Examples
- "commit" → Commit staged changes
- "커밋해줘" → Commit with auto-generated message
- "/commit" → Run this skill
- "commit the auth changes" → Commit specific changes
