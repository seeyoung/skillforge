# Skillforge

Claude Code용 재사용 가능한 skill 모음집입니다.

## 왜 Skillforge인가?

### 문제: 컨텍스트 윈도우의 한계
Claude의 컨텍스트 윈도우는 크지 않습니다. 프로젝트가 커지면 공통 코드, 역할별 기능, 아키텍처 정보를 매번 설명해야 하는 비효율이 발생합니다.

### 해결: INDEX.md + 체계적인 워크플로우
- **INDEX.md**: 공통 코드와 주요 참조 정보를 한 곳에 관리. `/commit` 시 자동 업데이트
- **이슈 기반 개발**: GitHub 이슈에서 시작해서 TDD로 구현, 커밋까지 일관된 워크플로우
- **다중 AI 협업**: Gemini CLI, Codex CLI와 협업하여 다양한 관점의 리뷰

## Quick Start

```bash
# 1. 설치
git clone https://github.com/seeyoung/skillforge.git

# ~/.claude/settings.json에 추가
{
  "skills": [
    "~/projects/skillforge/skills/dev",
    "~/projects/skillforge/skills/git"
  ]
}
```

```bash
# 2. 프로젝트 초기화
> /init                    # CLAUDE.md + .skillforge.json 생성

# 3. 이슈 기반 개발 시작
> /issue #42               # 이슈 분석 → 브랜치 생성 → TDD 구현

# 4. AI 리뷰 (선택)
> /collab                  # Gemini, Codex와 협업 리뷰

# 5. 커밋
> /commit                  # INDEX.md 업데이트 + 스마트 커밋
```

## 핵심 Skills

### `/issue` - 이슈 기반 전체 워크플로우

GitHub 이슈를 받아서 해결까지 전체 과정을 가이드합니다.

```
/issue #42
```

**워크플로우:**
1. **이슈 분석** - GitHub 이슈 내용 파악, 라벨/타입 확인
2. **브랜치 생성** - `fix/issue-42` 또는 `feat/issue-42` 자동 생성
3. **TDD 구현** - Red → Green → Refactor 사이클
4. **테스트 실행** - 단위/통합 테스트 검증
5. **커밋 & PR** - Conventional Commits + PR 생성

### `/commit` - INDEX.md 자동 관리

단순 커밋이 아닙니다. 공통 코드나 다른 곳에서 참조할 만한 변경사항이 있으면 **INDEX.md를 자동 업데이트**합니다.

```
/commit
```

**INDEX.md 예시:**
```markdown
## Services
- `UserService.groovy` - 사용자 CRUD, 인증 처리
- `OrderService.groovy` - 주문 생성, 상태 관리

## Utils
- `DateUtils.groovy` - 날짜 포맷팅, 파싱
- `ValidationUtils.groovy` - 공통 검증 로직
```

**왜 필요한가?**
- 컨텍스트 윈도우 제한으로 모든 코드를 매번 읽을 수 없음
- INDEX.md를 통해 "어떤 파일이 무슨 역할인지" 빠르게 파악
- 커밋 시 변경된 파일의 역할이 INDEX.md에 반영됨

### `/collab` - Multi-AI 협업 리뷰

Gemini CLI와 Codex CLI를 커맨드라인으로 호출하여 다중 AI 관점의 리뷰를 받습니다.

```
/collab
```

**워크플로우:**
1. 협업 세션 시작
2. Gemini/Codex에 리뷰 요청
3. 각 AI의 피드백 수집
4. Claude가 종합하여 협의
5. 합의된 수정사항 반영

**활용 예시:**
- 코드 리뷰: 여러 AI 관점에서 품질/보안 분석
- 설계 검토: 아키텍처 결정에 대한 다중 의견
- 버그 분석: 다양한 시각으로 문제 진단

### `/init` - 프로젝트 초기화

기존 Claude Code의 `/init` (CLAUDE.md 생성) 기능에 **프로젝트별 skill 세팅**을 추가했습니다.

```
/init                    # CLAUDE.md + .skillforge.json 생성
/init --claude-only      # CLAUDE.md만 생성
/init --skill-only       # .skillforge.json만 생성
```

**생성되는 파일:**
- `CLAUDE.md` - 프로젝트 규칙, 기술 스택, 컨벤션
- `.skillforge.json` - skill별 설정 (테스트 명령, 빌드 명령 등)

**자동 감지:**
- 프레임워크 (Next.js, Spring, Django 등)
- 테스트 도구 (Jest, Vitest, JUnit 등)
- 린터 (ESLint, Checkstyle 등)
- 포트, 빌드 명령

## 전체 Skills 목록

### Development (`/sc:*`)

| Skill | 명령어 | 설명 |
|-------|--------|------|
| **init** | `/init` | 프로젝트 초기화 (CLAUDE.md + .skillforge.json) |
| design | `/sc:design` | 시스템/API/컴포넌트 설계 |
| explain | `/sc:explain` | 코드 설명 및 분석 |
| troubleshoot | `/sc:troubleshoot` | 버그/성능/빌드 문제 진단 |
| test | `/sc:test` | 테스트 작성 및 실행 |
| document | `/sc:document` | 문서화 |
| restart | `/restart` | 개발 서버 재시작 (프레임워크 자동 감지) |
| load | `/sc:load` | 프로젝트 컨텍스트 로딩 |
| cleanup | `/sc:cleanup` | 코드 정리 및 리팩토링 |
| workflow | `/sc:workflow` | 구현 워크플로우 생성 |
| task | `/sc:task` | 태스크 관리 |
| implement | `/sc:implement` | 기능 구현 (TDD 지원) |
| index | `/sc:index` | 프로젝트 인덱싱 |
| analyze | `/sc:analyze` | 코드 품질/보안 분석 |
| estimate | `/sc:estimate` | 개발 시간 추정 |
| improve | `/sc:improve` | 코드 개선 |
| build | `/sc:build` | 빌드 및 배포 |
| spawn | `/sc:spawn` | 병렬 태스크 실행 |

### Git (`/commit`, `/push`, etc.)

| Skill | 명령어 | 설명 |
|-------|--------|------|
| **commit** | `/commit` | 스마트 커밋 + INDEX.md 자동 업데이트 |
| push | `/push` | 원격 저장소에 푸시 |
| **issue** | `/issue #N` | 이슈 기반 전체 워크플로우 (TDD) |
| git | `/sc:git` | 일반 Git 작업 |

### Multi-AI Collaboration

| Skill | 명령어 | 설명 |
|-------|--------|------|
| **collab** | `/collab` | Gemini, Codex CLI와 협업 리뷰 |

## 프로젝트별 설정 (`.skillforge.json`)

각 프로젝트 루트에 `.skillforge.json`을 생성하여 skill 동작을 커스터마이징할 수 있습니다.

```json
{
  "$schema": "https://raw.githubusercontent.com/seeyoung/skillforge/main/skills/templates/skillforge.schema.json",
  "index": {
    "enabled": true,
    "file": "INDEX.md",
    "track": ["*Service.groovy", "*Utils.groovy"]
  },
  "commit": {
    "language": "ko",
    "conventionalCommits": true
  },
  "restart": {
    "port": 8080,
    "command": "./gradlew bootRun",
    "framework": "spring"
  },
  "test": {
    "command": "./gradlew test",
    "coverage": true
  },
  "implement": {
    "tdd": true
  }
}
```

### 설정 옵션

<details>
<summary><b>index</b> - INDEX.md 관리</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `enabled` | INDEX 파일 자동 업데이트 | `false` |
| `file` | INDEX 파일 경로 | `INDEX.md` |
| `track` | 추적할 파일 패턴 | `[]` |
| `timestampFormat` | 타임스탬프 형식 | `YYYY-MM-DD HH:mm` |

</details>

<details>
<summary><b>commit</b> - 커밋 설정</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `language` | 커밋 메시지 언어 (`en`/`ko`) | `en` |
| `conventionalCommits` | Conventional Commits 사용 | `true` |
| `coAuthor` | Co-author 설정 | `Claude <noreply@anthropic.com>` |

</details>

<details>
<summary><b>restart</b> - 개발 서버</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `port` | 개발 서버 포트 | `3000` |
| `command` | 커스텀 시작 명령 | 자동 감지 |
| `framework` | 프레임워크 지정 | `auto` |
| `cacheDir` | 캐시 디렉토리 (--clean 시 삭제) | 프레임워크별 |
| `logFile` | 로그 파일 경로 | - |

</details>

<details>
<summary><b>test</b> - 테스트</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `command` | 테스트 명령 | 자동 감지 |
| `watchCommand` | 워치 모드 명령 | - |
| `unitPattern` | 유닛 테스트 패턴 | `**/*.test.*` |
| `integrationPattern` | 통합 테스트 패턴 | `**/*.integration.*` |
| `e2ePattern` | E2E 테스트 패턴 | `e2e/**/*` |
| `coverage` | 커버리지 기본 포함 | `false` |
| `coverageThreshold` | 최소 커버리지 % | - |
| `e2eCommand` | E2E 테스트 명령 | 자동 감지 |
| `setupCommand` | 테스트 전 실행 명령 | - |
| `teardownCommand` | 테스트 후 실행 명령 | - |

</details>

<details>
<summary><b>issue</b> - 이슈 워크플로우</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `branchPrefix.fix` | 버그 수정 브랜치 접두사 | `fix/issue-` |
| `branchPrefix.feat` | 기능 브랜치 접두사 | `feat/issue-` |
| `branchPrefix.default` | 기본 브랜치 타입 | `fix` |
| `review.enabled` | AI 리뷰 활성화 | `false` |
| `review.command` | 리뷰 스크립트 경로 | - |
| `review.maxRounds` | 최대 리뷰 라운드 | `3` |
| `autoCreateBranch` | 자동 브랜치 생성 | `false` |
| `autoClose` | 자동 이슈 종료 | `true` |

</details>

<details>
<summary><b>build</b> - 빌드</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `command` | 빌드 명령 | 자동 감지 |
| `devCommand` | 개발 빌드 명령 | - |
| `prodCommand` | 프로덕션 빌드 명령 | - |
| `cleanCommand` | 클린 명령 | 자동 감지 |
| `outputDir` | 빌드 출력 디렉토리 | - |
| `artifactDir` | 아티팩트 디렉토리 | `["dist", "build"]` |
| `preBuildCommand` | 빌드 전 실행 명령 | - |
| `postBuildCommand` | 빌드 후 실행 명령 | - |
| `env` | 빌드 환경 변수 | `{}` |

</details>

<details>
<summary><b>implement</b> - 구현</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `framework` | 프레임워크 타입 | 자동 감지 |
| `language` | 프로그래밍 언어 | 자동 감지 |
| `tdd` | TDD 기본 활성화 | `false` |
| `qualityGate` | 품질 검증 명령 | - |
| `srcDir` | 소스 디렉토리 | 자동 감지 |
| `testDir` | 테스트 디렉토리 | 자동 감지 |
| `componentDir` | 컴포넌트 디렉토리 | `src/components` |
| `conventions.maxMethodLines` | 메서드 최대 줄 수 | `30` |
| `conventions.maxParams` | 파라미터 최대 개수 | `5` |
| `conventions.maxNestingDepth` | 최대 중첩 깊이 | `2` |

</details>

<details>
<summary><b>analyze</b> - 코드 분석</summary>

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `lintCommand` | 린트 명령 | 자동 감지 |
| `formatCommand` | 포맷 검사 명령 | - |
| `typeCheckCommand` | 타입 검사 명령 | - |
| `securityCommand` | 보안 스캔 명령 | 자동 감지 |
| `qualityCommand` | 품질 게이트 명령 | - |
| `exclude` | 분석 제외 경로 | `["node_modules", "dist", "build"]` |
| `rules.maxFileLines` | 파일 최대 줄 수 | `500` |
| `rules.maxMethodLines` | 메서드 최대 줄 수 | `30` |
| `rules.maxComplexity` | 최대 순환 복잡도 | `10` |
| `security.enabled` | 보안 분석 활성화 | `true` |
| `security.scanSecrets` | 시크릿 스캔 | `true` |
| `security.dependencyCheck` | 의존성 취약점 검사 | `true` |

</details>

## 프로젝트 구조

```
skillforge/
├── skills/
│   ├── dev/                 # 개발 워크플로우
│   │   ├── init/            # 프로젝트 초기화
│   │   ├── implement/       # 기능 구현 (TDD)
│   │   ├── test/            # 테스트
│   │   ├── analyze/         # 코드 분석
│   │   ├── build/           # 빌드
│   │   └── ...
│   ├── git/                 # Git 관련
│   │   ├── commit/          # 스마트 커밋 + INDEX.md
│   │   ├── issue/           # 이슈 워크플로우
│   │   └── ...
│   ├── claude-multi-ai-collab/  # AI 협업
│   └── templates/           # 스키마, 예제
└── README.md
```

## Skill 작성법

```markdown
---
name: my-skill
description: "트리거 조건 설명"
version: 1.0.0
---

# Skill Title

## Purpose
skill의 목적

## Workflow
1. Step 1
2. Step 2

## Usage Examples
- "example trigger 1"
- "example trigger 2"
```

## License

MIT
