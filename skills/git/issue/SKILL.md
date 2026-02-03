---
name: issue
description: "This skill should be used when the user asks to 'resolve GitHub issue', 'fix issue #N', 'close issue', or mentions GitHub issue resolution workflows"
version: 4.0.0
---

# GitHub Issue Resolution Skill

## Overview
GitHub 이슈 분석부터 해결, 테스트, 커밋까지 전체 워크플로우를 가이드합니다.
`.skillforge.json` 설정을 지원합니다.

## When This Skill Applies
- User mentions "이슈 해결", "issue #N", "fix issue"
- GitHub issue URL is provided
- User asks to analyze or close an issue

## Step 1: Load Project Settings

```bash
cat .skillforge.json 2>/dev/null
```

**Settings schema (`issue` section):**
```json
{
  "issue": {
    "branchPrefix": {
      "fix": "fix/issue-",
      "feat": "feat/issue-",
      "default": "fix"
    },
    "review": {
      "enabled": true,
      "command": "~/.claude/scripts/ai-collab.sh",
      "maxRounds": 3
    },
    "autoCreateBranch": true,
    "autoClose": true
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `branchPrefix.fix` | 버그 수정 브랜치 접두사 | `fix/issue-` |
| `branchPrefix.feat` | 기능 추가 브랜치 접두사 | `feat/issue-` |
| `branchPrefix.default` | 기본 타입 | `fix` |
| `review.enabled` | AI 리뷰 활성화 | `false` |
| `review.command` | 리뷰 스크립트 경로 | - |
| `review.maxRounds` | 최대 리뷰 라운드 | `3` |
| `autoCreateBranch` | 자동 브랜치 생성 | `false` |
| `autoClose` | 커밋 후 자동 이슈 종료 | `true` |

## Workflow

### 1. 이슈 확인
```bash
gh issue view <number>
```
- 이슈 내용 분석
- 관련 코드 파악
- 작업 범위 정의
- 이슈 라벨로 타입 판단 (bug → fix, enhancement → feat)

### 2. 브랜치 생성

**설정에 따라 동작:**
- `autoCreateBranch: true` → 자동 생성
- `autoCreateBranch: false` → 사용자에게 확인

```bash
# branchPrefix 설정 사용
git checkout -b ${branchPrefix.fix}<number>   # bug 라벨
git checkout -b ${branchPrefix.feat}<number>  # enhancement 라벨
```

**기본값 (설정 없음):**
```bash
git checkout -b fix/issue-<number>
# 또는
git checkout -b feat/issue-<number>
```

### 3. 구현
- 이슈 요구사항에 따라 코드 작성
- 필요시 테스트 코드 작성
- TDD 권장: 실패하는 테스트 → 구현 → 리팩토링

### 4. 코드 리뷰

**`review.enabled: true` 인 경우:**
```bash
# review.command 실행
${review.command} ask both "다음 변경사항을 리뷰해주세요: <요약>"
```

리뷰 사이클 (최대 `review.maxRounds` 회):
```
1회차: 리뷰 요청 → 이슈 발견 → 수정
2회차: 재리뷰 → 이슈 발견 → 수정
3회차: 최종 리뷰 → 완료
```

**`review.enabled: false` 또는 설정 없음:**
- 리뷰 단계 스킵

### 5. 테스트

`.skillforge.json`의 `test` 섹션 또는 자동 감지:

```bash
# .skillforge.json test.command 사용
${test.command}

# 또는 자동 감지
```

| 감지 파일 | 프레임워크 | 실행 명령 |
|-----------|------------|-----------|
| `jest.config.*` | Jest | `npm test` |
| `vitest.config.*` | Vitest | `npm test` |
| `playwright.config.*` | Playwright | `npx playwright test` |
| `pytest.ini`, `pyproject.toml` | Pytest | `pytest` |
| `build.gradle*` | Gradle | `./gradlew test` |
| `pom.xml` | Maven | `mvn test` |

#### 수동 테스트 (MCP Playwright)
테스트 프레임워크가 없는 경우:

1. **개발 서버 시작** (`/restart` 사용)
2. **MCP Playwright로 확인**
   ```
   mcp__playwright__browser_navigate - 페이지 이동
   mcp__playwright__browser_snapshot - 상태 확인
   mcp__playwright__browser_click - 클릭
   mcp__playwright__browser_type - 입력
   ```

### 6. 커밋 & 이슈 종료

```bash
# 커밋 (이슈 번호 참조)
git commit -m "fix: <변경 내용>

Closes #<number>"
```

**`autoClose: true` (기본값):**
```bash
# PR 생성 또는 직접 종료
gh pr create --title "Fix #<number>: <제목>" --body "Closes #<number>"
# 또는
gh issue close <number> --comment "Fixed in <commit-hash>"
```

**`autoClose: false`:**
- 이슈 종료하지 않음 (수동 확인 후 종료)

## Commit Message with Issue Reference

GitHub은 특정 키워드로 이슈를 자동 종료합니다:
- `Closes #123`
- `Fixes #123`
- `Resolves #123`

```bash
git commit -m "feat: add user authentication

- Implement JWT token validation
- Add login/logout endpoints
- Create auth middleware

Closes #42"
```

## Usage Examples
- "이슈 7 해결해줘"
- "/issue #7"
- "Fix issue #45"
- "https://github.com/org/repo/issues/12 분석해줘"

## Notes
- 커밋 시 `--no-verify` 사용 금지
- 이슈 종료 전 테스트 통과 확인
- 큰 이슈는 여러 커밋으로 분리 권장
