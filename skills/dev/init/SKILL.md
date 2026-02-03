---
name: init
description: "This skill should be used when the user asks to initialize project, setup project, /init, or mentions project initialization"
version: 1.0.0
---

# /init - Project Initialization

## Purpose
프로젝트 초기화: CLAUDE.md와 .skillforge.json을 자동 생성합니다.

## Usage
```
/init                    # 전체 초기화 (CLAUDE.md + .skillforge.json)
/init --claude-only      # CLAUDE.md만 생성
/init --skill-only       # .skillforge.json만 생성
/init --force            # 기존 파일 덮어쓰기
```

## Workflow

### Step 1: 프로젝트 분석

```bash
# 프레임워크 감지
ls -la
cat package.json 2>/dev/null
cat build.gradle* 2>/dev/null
cat pom.xml 2>/dev/null
cat go.mod 2>/dev/null
cat Cargo.toml 2>/dev/null
cat requirements.txt 2>/dev/null
cat pyproject.toml 2>/dev/null
```

**감지 항목:**
| 감지 파일 | 프레임워크 | 언어 |
|-----------|------------|------|
| `next.config.*` | Next.js | TypeScript |
| `vite.config.*` | Vite | TypeScript |
| `angular.json` | Angular | TypeScript |
| `package.json` (react) | React | JavaScript/TypeScript |
| `build.gradle*` | Spring/Gradle | Java/Kotlin |
| `pom.xml` | Spring/Maven | Java |
| `go.mod` | Go | Go |
| `Cargo.toml` | Rust | Rust |
| `requirements.txt`, `pyproject.toml` | Python | Python |

### Step 2: 기존 파일 확인

```bash
# 기존 파일 존재 여부 확인
ls -la CLAUDE.md .skillforge.json 2>/dev/null
```

- 기존 파일 있으면 사용자에게 확인
- `--force` 옵션이면 덮어쓰기

### Step 3: CLAUDE.md 생성

프로젝트 분석 결과를 바탕으로 CLAUDE.md 생성:

```markdown
# Project Name

## Overview
[프로젝트 설명]

## Tech Stack
- Framework: [감지된 프레임워크]
- Language: [감지된 언어]
- Build: [빌드 도구]

## Project Structure
[주요 디렉토리 구조]

## Development Guidelines
- [프로젝트별 규칙]

## Commands
- `[시작 명령]` - 개발 서버 시작
- `[테스트 명령]` - 테스트 실행
- `[빌드 명령]` - 빌드
```

### Step 4: .skillforge.json 생성

프로젝트 분석 결과를 바탕으로 .skillforge.json 생성:

#### Node.js 프로젝트 (Next.js, Vite, React)
```json
{
  "restart": {
    "port": 3000,
    "command": "npm run dev"
  },
  "test": {
    "command": "npm test"
  },
  "build": {
    "command": "npm run build"
  },
  "commit": {
    "conventionalCommits": true
  },
  "analyze": {
    "lintCommand": "npm run lint"
  }
}
```

#### Java/Spring 프로젝트 (Gradle)
```json
{
  "restart": {
    "port": 8080,
    "command": "./gradlew bootRun"
  },
  "test": {
    "command": "./gradlew test"
  },
  "build": {
    "command": "./gradlew build"
  },
  "implement": {
    "framework": "spring",
    "language": "java",
    "tdd": true
  },
  "analyze": {
    "lintCommand": "./gradlew checkstyleMain"
  }
}
```

#### Python 프로젝트
```json
{
  "restart": {
    "command": "python manage.py runserver"
  },
  "test": {
    "command": "pytest"
  },
  "analyze": {
    "lintCommand": "pylint",
    "securityCommand": "safety check"
  }
}
```

#### Go 프로젝트
```json
{
  "build": {
    "command": "go build"
  },
  "test": {
    "command": "go test ./..."
  },
  "analyze": {
    "lintCommand": "golangci-lint run"
  }
}
```

### Step 5: 포트 감지

```bash
# .env에서 포트 확인
grep -E "^PORT=" .env .env.local 2>/dev/null

# package.json scripts에서 포트 확인
cat package.json | grep -E "(--port|PORT=)" 2>/dev/null
```

### Step 6: 결과 출력

```
✅ 프로젝트 초기화 완료!

📄 생성된 파일:
  - CLAUDE.md (프로젝트 규칙)
  - .skillforge.json (skill 설정)

🔍 감지 결과:
  - Framework: Next.js
  - Language: TypeScript
  - Port: 3000

💡 다음 단계:
  - CLAUDE.md를 프로젝트에 맞게 수정하세요
  - .skillforge.json 설정을 확인하세요
```

## Detection Logic

### 프레임워크 우선순위
1. `next.config.*` → Next.js
2. `nuxt.config.*` → Nuxt
3. `vite.config.*` → Vite
4. `angular.json` → Angular
5. `svelte.config.*` → SvelteKit
6. `build.gradle*` → Spring/Gradle
7. `pom.xml` → Spring/Maven
8. `go.mod` → Go
9. `Cargo.toml` → Rust
10. `pyproject.toml` / `requirements.txt` → Python
11. `package.json` → Node.js (generic)

### 테스트 프레임워크 감지
1. `jest.config.*` → Jest
2. `vitest.config.*` → Vitest
3. `playwright.config.*` → Playwright
4. `cypress.config.*` → Cypress
5. `pytest.ini` → Pytest
6. `build.gradle*` (with test) → JUnit

### 린터 감지
1. `eslint.config.*` / `.eslintrc*` → ESLint
2. `biome.json` → Biome
3. `.prettierrc*` → Prettier
4. `checkstyle.xml` → Checkstyle

## Examples

### 기본 사용
```bash
/init
# → CLAUDE.md + .skillforge.json 생성
```

### CLAUDE.md만 생성
```bash
/init --claude-only
```

### 기존 파일 덮어쓰기
```bash
/init --force
```

## Notes
- 기존 CLAUDE.md가 있으면 백업 후 생성
- .skillforge.json은 감지된 설정만 포함 (불필요한 섹션 제외)
- 감지 실패 시 사용자에게 수동 입력 요청
