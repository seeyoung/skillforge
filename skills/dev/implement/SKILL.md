---
name: implement
description: "This skill should be used when the user asks to implement feature, add functionality, create component, or mentions implementation"
version: 2.0.0
---

# /sc:implement - Feature Implementation

## Purpose
Implement features, components, and code functionality with **Clean Architecture**, **Clean Code**, and optional **TDD** approach.
`.skillforge.json` 설정을 지원합니다.

## Usage
```
/sc:implement [feature-description] [--type component|api|service|feature] [--tdd] [--safe]
```

## Arguments
- `feature-description` - Description of what to implement
- `--type` - Implementation type (component, api, service, feature, module)
- `--tdd` - Follow Test-Driven Development (Red → Green → Refactor)
- `--safe` - Use conservative implementation approach
- `--with-tests` - Include test implementation
- `--documentation` - Generate documentation alongside implementation

## Step 1: Load Project Settings

```bash
cat .skillforge.json 2>/dev/null
```

**Settings schema (`implement` section):**
```json
{
  "implement": {
    "framework": "spring",
    "language": "java",
    "tdd": true,
    "qualityGate": "./gradlew qualityGate",
    "testCommand": "./gradlew test",
    "lintCommand": "./gradlew checkstyleMain",
    "srcDir": "src/main/java",
    "testDir": "src/test/java",
    "componentDir": "src/components",
    "conventions": {
      "maxMethodLines": 30,
      "maxParams": 5,
      "maxNestingDepth": 2
    }
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `framework` | 프레임워크 타입 | 자동 감지 |
| `language` | 프로그래밍 언어 | 자동 감지 |
| `tdd` | TDD 기본 활성화 | `false` |
| `qualityGate` | 품질 검증 명령 | - |
| `testCommand` | 테스트 명령 | test.command 사용 |
| `lintCommand` | 린트 명령 | - |
| `srcDir` | 소스 디렉토리 | 자동 감지 |
| `testDir` | 테스트 디렉토리 | 자동 감지 |
| `componentDir` | 컴포넌트 디렉토리 (프론트엔드) | `src/components` |
| `conventions.maxMethodLines` | 메서드 최대 줄 수 | `30` |
| `conventions.maxParams` | 메서드 최대 파라미터 수 | `5` |
| `conventions.maxNestingDepth` | 최대 중첩 깊이 | `2` |

## Step 2: Auto Detection (Fallback)

`.skillforge.json`이 없으면 자동 감지:

| 감지 파일 | 프레임워크 | 언어 | srcDir | testDir |
|-----------|------------|------|--------|---------|
| `build.gradle*` | Spring/Gradle | Java/Kotlin | `src/main/java` | `src/test/java` |
| `pom.xml` | Spring/Maven | Java | `src/main/java` | `src/test/java` |
| `next.config.*` | Next.js | TypeScript | `src` | `__tests__` |
| `vite.config.*` | Vite | TypeScript | `src` | `tests` |
| `angular.json` | Angular | TypeScript | `src/app` | `src/app` |
| `package.json` (react) | React | TypeScript/JS | `src` | `src/__tests__` |
| `go.mod` | Go | Go | `.` | `.` |
| `Cargo.toml` | Rust | Rust | `src` | `tests` |

## Clean Code Principles (MANDATORY)

### Method Rules
- **한 가지 일만**: 메서드는 한 가지 작업만 수행
- **{maxMethodLines}줄 이내**: 메서드 길이 제한
- **파라미터 {maxParams}개 이내**: 많으면 객체로 묶기
- **중첩 {maxNestingDepth}단계 이내**: Early return 활용

### Naming Rules
- **의미 있는 이름**: 축약어 최소화
- **동사+명사**: 메서드는 동작 표현
- **일관된 규칙**: 프로젝트 컨벤션 준수

## Execution Flow

### 1. Requirements Analysis
- Analyze implementation requirements
- Load `.skillforge.json` settings
- Detect technology context (Spring Boot, React, etc.)
- Identify affected layers

### 2. TDD Phase (if `tdd: true` or `--tdd`)
```bash
# 1. Write test first (RED)
# 2. Run test - should fail
${implement.testCommand}

# 3. Implement minimal code (GREEN)
# 4. Run test - should pass
${implement.testCommand}

# 5. Refactor with Clean Code principles
```

### 3. Implementation Phase
- Apply Clean Architecture layer rules
- Follow Clean Code principles
- Generate code with proper separation
- Place files in correct directories (`srcDir`, `componentDir`)

### 4. Validation Phase
```bash
# qualityGate가 설정되어 있으면 실행
${implement.qualityGate}

# 또는 개별 명령
${implement.lintCommand}
${implement.testCommand}
```

### 5. Documentation
- Update relevant documentation
- Add JSDoc/JavaDoc comments

## Examples

### 설정 없이 (자동 감지)
```bash
/sc:implement user authentication --type feature --tdd
/sc:implement dashboard component --type component
/sc:implement REST API for users --type api
```

### .skillforge.json 사용

**Spring Boot 프로젝트:**
```json
{
  "implement": {
    "framework": "spring",
    "language": "java",
    "tdd": true,
    "qualityGate": "./gradlew qualityGate",
    "conventions": {
      "maxMethodLines": 20
    }
  }
}
```

**React 프로젝트:**
```json
{
  "implement": {
    "framework": "react",
    "language": "typescript",
    "componentDir": "src/components",
    "testCommand": "npm test",
    "lintCommand": "npm run lint"
  }
}
```

## Usage Examples
- "로그인 기능 구현해줘" → 전체 구현
- "/sc:implement --tdd" → TDD로 구현
- "컴포넌트 만들어줘 --type component" → 컴포넌트 생성
