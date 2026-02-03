---
name: issue
description: "This skill should be used when the user asks to 'resolve GitHub issue', 'fix issue #N', 'close issue', or mentions GitHub issue resolution workflows"
version: 3.0.0
---

# GitHub Issue Resolution Skill

## Overview
GitHub 이슈 분석부터 해결, 테스트, 커밋까지 전체 워크플로우를 가이드합니다.

## When This Skill Applies
- User mentions "이슈 해결", "issue #N", "fix issue"
- GitHub issue URL is provided
- User asks to analyze or close an issue

## Workflow

### 1. 이슈 확인
```bash
gh issue view <number>
```
- 이슈 내용 분석
- 관련 코드 파악
- 작업 범위 정의

### 2. 브랜치 생성 (선택)
```bash
# 이슈 번호 기반 브랜치
git checkout -b fix/issue-<number>
# 또는
git checkout -b feat/issue-<number>
```

### 3. 구현
- 이슈 요구사항에 따라 코드 작성
- 필요시 테스트 코드 작성
- TDD 권장: 실패하는 테스트 → 구현 → 리팩토링

### 4. 코드 리뷰 (선택)

프로젝트에 AI 협업 도구가 설정되어 있다면 활용:
```bash
# 예: ai-collab.sh가 있는 경우
ai-collab.sh ask both "다음 변경사항을 리뷰해주세요: <요약>"
```

리뷰 없이 진행해도 무방합니다.

### 5. 테스트

#### A. 테스트 프레임워크가 있는 경우
프로젝트의 테스트 설정을 자동 감지:

| 감지 파일 | 프레임워크 | 실행 명령 |
|-----------|------------|-----------|
| `jest.config.*` | Jest | `npm test` |
| `vitest.config.*` | Vitest | `npm test` |
| `playwright.config.*` | Playwright | `npx playwright test` |
| `pytest.ini`, `pyproject.toml` | Pytest | `pytest` |
| `build.gradle*` | Gradle | `./gradlew test` |
| `pom.xml` | Maven | `mvn test` |

```bash
# 프로젝트에 맞는 테스트 실행
npm test
# 또는
npx playwright test
# 또는
pytest
```

#### B. 수동 테스트 (MCP Playwright)
테스트 프레임워크가 없는 경우:

1. **개발 서버 시작**
   ```bash
   npm run dev &
   # 또는 프로젝트에 맞는 명령
   ```

2. **MCP Playwright로 확인**
   ```
   mcp__playwright__browser_navigate - 페이지 이동
   mcp__playwright__browser_snapshot - 상태 확인
   mcp__playwright__browser_click - 클릭
   mcp__playwright__browser_type - 입력
   ```

3. **인증이 필요한 경우**
   ```bash
   # 브라우저에서 로그인 후 세션 저장
   npx playwright codegen --save-storage=.auth.json <url>
   ```
   > `.auth.json`은 `.gitignore`에 추가

### 6. 커밋 & 이슈 종료

```bash
# 커밋 (이슈 번호 참조)
git commit -m "fix: <변경 내용>

Closes #<number>"

# PR 생성 (선택)
gh pr create --title "Fix #<number>: <제목>" --body "Closes #<number>"

# 또는 직접 이슈 종료
gh issue close <number> --comment "Fixed in <commit-hash>"
```

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
