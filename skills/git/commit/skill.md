---
name: commit
description: "This skill should be used when the user asks to commit changes, make a commit, or mentions git commit"
version: 2.0.0
---

# /commit - Smart Git Commit

## Purpose
Execute git commit with intelligent analysis and meaningful commit messages.

## Workflow

### Step 1: Check Current Status
```bash
git status
git diff --staged --stat
git diff --stat  # unstaged changes
```

### Step 2: Analyze Changed Files
Identify the nature of changes:
- **New files**: What functionality is being added?
- **Modified files**: What is being changed/fixed/improved?
- **Deleted files**: What is being removed and why?

### Step 3: Auto-detect Project Conventions
Check for project-specific commit rules:
```bash
# Check for conventional commits config
cat .commitlintrc* 2>/dev/null
cat package.json | grep -A5 '"commitlint"' 2>/dev/null

# Check for existing commit style
git log --oneline -10
```

### Step 4: Stage and Commit
```bash
# Stage specific files (preferred over git add -A)
git add <files>

# Commit with descriptive message
git commit -m "$(cat <<'EOF'
<type>: <brief description>

<optional body>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## Commit Message Guidelines

### Conventional Commits (Default)
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring |
| `test` | Adding/updating tests |
| `chore` | Maintenance tasks |
| `perf` | Performance improvement |

**Examples:**
```
feat(auth): add OAuth2 login support
fix(api): handle null response from external service
docs: update README installation steps
refactor: extract validation logic to separate module
```

### Project-specific Conventions
If the project uses different conventions (detected from git log or config):
- Follow existing patterns
- Match the language (Korean/English) used in recent commits
- Respect any prefix requirements

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
- "commit" - Commit staged changes
- "커밋해줘" - Commit with auto-generated message
- "/commit" - Run this skill
- "commit the auth changes" - Commit specific changes
