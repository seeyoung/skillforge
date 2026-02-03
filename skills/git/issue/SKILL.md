---
name: issue
description: "This skill should be used when the user asks to 'resolve GitHub issue', 'fix issue #N', 'close issue', or mentions GitHub issue resolution workflows"
version: 2.1.0
---

# GitHub Issue Resolution Skill

## Overview
GitHub 이슈 분석부터 해결, AI 협업 리뷰, 테스트까지 전체 워크플로우를 자동화합니다.

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

### 2. 작업 (구현)
- 이슈 요구사항에 따라 코드 구현
- 필요시 테스트 코드 작성

### 3. Collab 리뷰 & 보완
AI 협업 리뷰를 통해 코드 품질 검증 (최대 3회 반복):

```bash
# 협업 세션 시작 (전체 경로 사용)
~/.claude/scripts/ai-collab.sh start

# 리뷰 요청
~/.claude/scripts/ai-collab.sh ask both "다음 변경사항을 리뷰해주세요: <변경 내용 요약>"
```

**리뷰 사이클:**
```
1회차: 리뷰 요청 → 이슈 발견 → 협의 → 수정
2회차: 재리뷰 요청 → 이슈 발견 → 협의 → 수정
3회차: 최종 리뷰 → 완료 (이슈 있어도 종료)
```

- 이슈가 없으면 조기 종료
- 3회차 발견 이슈는 기록만 하고 종료 (과잉 엔지니어링 방지)

### 4. Playwright 테스트 & 오류 수정

**A. playwright.config.ts가 있는 경우:**
```bash
npx playwright test
npx playwright test <test-file>
```

**B. 없는 경우 MCP Playwright로 수동 테스트:**

1. **서버 시작** - `/restart` skill 호출
   - 프로젝트별 restart skill이 포트 관리
   - 없으면 기본 포트(3000) 사용:
   ```bash
   npm run dev > /tmp/<project>-dev.log 2>&1 &
   sleep 3
   ```

2. **인증이 필요한 경우 - 세션 저장/로드**

   사용자에게 세션 저장 요청:
   ```bash
   # 터미널에서 실행 (브라우저 열림 → 로그인 → 닫기)
   npx playwright codegen --save-storage=.playwright-auth.json http://localhost:3000
   ```

   MCP Playwright에서 쿠키 로드:
   ```javascript
   // browser_run_code로 실행
   async (page) => {
     const context = page.context();
     const authData = /* .playwright-auth.json 내용 */;
     await context.addCookies(authData.cookies);
     await page.goto('http://localhost:3000');
   }
   ```

   > `.playwright-auth.json`은 민감 정보 포함 → `.gitignore`에 추가 필수

3. **MCP Playwright로 테스트** (http://localhost:3000)
   ```
   mcp__playwright__browser_navigate - 페이지 이동
   mcp__playwright__browser_snapshot - 페이지 상태 확인
   mcp__playwright__browser_click - 버튼/링크 클릭
   mcp__playwright__browser_type - 텍스트 입력
   mcp__playwright__browser_fill_form - 폼 작성
   ```

4. **로그 확인** (문제 발생 시)
   ```bash
   tail -50 /tmp/<project>-dev.log
   ```

- 테스트 실패 시 오류 분석 및 수정
- 모든 테스트 통과할 때까지 반복

### 5. 커밋 & 이슈 종료
```bash
# 커밋 (이슈 번호 참조)
git commit -m "feat: <변경 내용>

Closes #<number>"

# 이슈 종료
gh issue close <number> --comment "구현 완료: <커밋 해시>"
```

## Usage Examples
- "이슈 7 해결해줘"
- "/issue #7"
- "Fix issue #45"
- "https://github.com/org/repo/issues/12 분석해줘"

## Notes
- collab 리뷰는 `multi-ai-collab` skill의 ai-collab.sh 스크립트 활용
- playwright 테스트가 없는 프로젝트는 해당 단계 스킵
- 커밋 시 `--no-verify` 사용 금지 (글로벌 규칙)
