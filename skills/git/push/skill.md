---
name: push
description: "This skill should be used when the user asks to push changes, git push, or mentions pushing to remote"
version: 1.0.0
---

# /push - Git Push with Safety Checks

## Purpose
Push commits to remote repository with safety validations.

## Workflow

### Step 1: Pre-push Validation
```bash
# Check current branch
git branch --show-current

# Check if there are commits to push
git log @{upstream}..HEAD --oneline 2>/dev/null || echo "No upstream set"

# Check remote status
git remote -v
```

### Step 2: Safety Checks
Before pushing, verify:
1. **Branch name**: Warn if pushing to `main` or `master` directly
2. **Unpushed commits**: Show what will be pushed
3. **Remote tracking**: Ensure branch tracks a remote

### Step 3: Push Options

**Standard Push:**
```bash
git push
```

**First push (set upstream):**
```bash
git push -u origin <branch-name>
```

**Force push (with confirmation):**
- Warn user about risks
- Require explicit confirmation
- Never force push to main/master

### Step 4: Post-push Verification
```bash
git log @{upstream}..HEAD --oneline
# Should be empty after successful push
```

## Safety Rules
- NEVER force push to main/master without explicit user confirmation
- Always show what commits will be pushed before executing
- Warn if pushing directly to protected branches

## Usage Examples
- "푸시해줘" - Push current branch
- "리모트에 올려줘" - Push to remote
- "/push" - Run this skill

## Error Handling
- **No upstream**: Suggest `git push -u origin <branch>`
- **Rejected (non-fast-forward)**: Suggest `git pull --rebase` first
- **Permission denied**: Check SSH key or credentials
