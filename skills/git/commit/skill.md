---
name: commit
description: "This skill should be used when the user asks to commit changes, make a commit, or mentions git commit"
version: 1.0.0
---

# /commit - Smart Git Commit with INDEX.md Update

## Purpose
Execute git commit with automatic INDEX.md synchronization for projects that require documentation updates.

## Workflow

### Step 1: Check Current Status
```bash
git status
git diff --stat
```

### Step 2: Analyze Changed Files
Identify which files were modified:
- **Utils files** (`*Utils.groovy`): Check if new methods added
- **Service files** (`*Service.groovy`): Check if new public methods added
- **Other files**: No INDEX.md update needed

### Step 3: Update INDEX.md (if needed)
If Utils or Service files have new methods:
1. Read the changed file to identify new/modified methods
2. Update INDEX.md with new method signatures
3. Update the timestamp at the bottom

**INDEX.md Update Rules:**
- Add new method entries to the appropriate section
- Keep the format consistent: `| methodName(params) | description |`
- Update timestamp: `*마지막 업데이트: YYYY-MM-DD HH:MM*`

### Step 4: Stage and Commit
```bash
# Stage INDEX.md if updated
git add INDEX.md

# Stage other changes
git add <files>

# Commit with descriptive message
git commit -m "$(cat <<'EOF'
Commit message here

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)"
```

## Commit Message Guidelines
- Korean preferred for this project
- Format: `[Type]: Brief description`
- Types: 기능 추가, 버그 수정, 리팩토링, 문서 업데이트
- Examples:
  - `태그 시스템 개선: 클릭 투 태그 UI 추가`
  - `버그 수정: 갤러리 삭제 시 태그 정리`
  - `리팩토링: 썸네일 생성 로직 분리`

## Split Commits Option
If multiple unrelated changes exist, ask user:
- 단일 커밋 (Single commit)
- 기능별 분리 (Split by functionality)

## Pre-commit Hook Handling
This project has pre-commit hooks. If commit fails:
1. Check hook output for required changes
2. Fix issues (usually INDEX.md update)
3. Re-attempt commit

## Usage Examples
- "커밋해줘" - Commit all staged changes
- "변경사항 커밋" - Commit with smart message
- "/commit" - Run this skill
