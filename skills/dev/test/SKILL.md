---
name: test
description: "This skill should be used when the user asks to run tests, write tests, check coverage, or mentions testing"
version: 2.0.0
---

# /sc:test - Testing and Quality Assurance

## Purpose
Execute tests, generate comprehensive test reports, and maintain test coverage standards.
`.skillforge.json` 설정을 지원합니다.

## Usage
```
/sc:test [target] [--type unit|integration|e2e|all] [--coverage] [--watch]
```

## Arguments
- `target` - Specific tests, files, or entire test suite
- `--type` - Test type (unit, integration, e2e, all)
- `--coverage` - Generate coverage reports
- `--watch` - Run tests in watch mode
- `--fix` - Automatically fix failing tests when possible

## Step 1: Load Project Settings

```bash
cat .skillforge.json 2>/dev/null
```

**Settings schema (`test` section):**
```json
{
  "test": {
    "command": "npm test",
    "coverage": true,
    "coverageThreshold": 80,
    "watchCommand": "npm test -- --watch",
    "e2eCommand": "npx playwright test",
    "unitPattern": "**/*.test.{ts,js}",
    "integrationPattern": "**/*.integration.{ts,js}",
    "e2ePattern": "e2e/**/*.spec.{ts,js}",
    "setupCommand": "npm run test:setup",
    "teardownCommand": "npm run test:teardown"
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `command` | 기본 테스트 명령 | 자동 감지 |
| `coverage` | 커버리지 기본 포함 | `false` |
| `coverageThreshold` | 최소 커버리지 % | - |
| `watchCommand` | watch 모드 명령 | `{command} --watch` |
| `e2eCommand` | E2E 테스트 명령 | 자동 감지 |
| `unitPattern` | unit 테스트 패턴 | `**/*.test.*` |
| `integrationPattern` | integration 테스트 패턴 | `**/*.integration.*` |
| `e2ePattern` | E2E 테스트 패턴 | `e2e/**/*` |
| `setupCommand` | 테스트 전 실행 명령 | - |
| `teardownCommand` | 테스트 후 실행 명령 | - |

## Step 2: Auto Detection (Fallback)

`.skillforge.json`이 없으면 자동 감지:

| 감지 파일 | 프레임워크 | 기본 명령 | 커버리지 명령 |
|-----------|------------|-----------|---------------|
| `jest.config.*` | Jest | `npm test` | `npm test -- --coverage` |
| `vitest.config.*` | Vitest | `npm test` | `npm test -- --coverage` |
| `playwright.config.*` | Playwright | `npx playwright test` | - |
| `cypress.config.*` | Cypress | `npx cypress run` | - |
| `pytest.ini`, `pyproject.toml` | Pytest | `pytest` | `pytest --cov` |
| `build.gradle*` | Gradle | `./gradlew test` | `./gradlew test jacocoTestReport` |
| `pom.xml` | Maven | `mvn test` | `mvn test jacoco:report` |
| `go.mod` | Go | `go test ./...` | `go test -cover ./...` |
| `Cargo.toml` | Rust | `cargo test` | `cargo tarpaulin` |

## Step 3: Execution

### 기본 테스트 실행
```bash
# .skillforge.json 설정 사용
${test.command}

# 또는 자동 감지된 명령
npm test
```

### 타입별 실행

**Unit 테스트 (`--type unit`):**
```bash
# unitPattern으로 필터링
npm test -- --testPathPattern="${test.unitPattern}"
```

**Integration 테스트 (`--type integration`):**
```bash
npm test -- --testPathPattern="${test.integrationPattern}"
```

**E2E 테스트 (`--type e2e`):**
```bash
${test.e2eCommand}
# 또는
npx playwright test
```

### 커버리지 (`--coverage`)
```bash
# .skillforge.json에서 coverage: true이면 기본 포함
${test.command} --coverage

# coverageThreshold 설정 시 검증
# 커버리지가 threshold 미만이면 경고
```

### Watch 모드 (`--watch`)
```bash
${test.watchCommand}
# 또는
${test.command} --watch
```

### Setup/Teardown
```bash
# setupCommand가 있으면 테스트 전 실행
${test.setupCommand}

# 테스트 실행
${test.command}

# teardownCommand가 있으면 테스트 후 실행
${test.teardownCommand}
```

## Step 4: Report & Analysis

테스트 완료 후:
1. **결과 요약** - 통과/실패/스킵 개수
2. **실패 분석** - 실패한 테스트 원인 분석
3. **커버리지 리포트** - 커버리지 % 및 미커버 영역
4. **개선 제안** - 테스트 추가 필요 영역

## Examples

### 설정 없이 (자동 감지)
```bash
/sc:test                    # 전체 테스트
/sc:test --coverage         # 커버리지 포함
/sc:test src/auth --watch   # 특정 경로 watch
```

### .skillforge.json 사용
```json
{
  "test": {
    "command": "./gradlew test",
    "coverage": true,
    "coverageThreshold": 80,
    "e2eCommand": "./gradlew e2eTest"
  }
}
```

```bash
/sc:test                # ./gradlew test --coverage
/sc:test --type e2e     # ./gradlew e2eTest
```

### Python 프로젝트
```json
{
  "test": {
    "command": "pytest",
    "coverage": true,
    "e2eCommand": "pytest e2e/",
    "setupCommand": "docker-compose up -d"
  }
}
```

## Usage Examples
- "테스트 실행해줘" → 전체 테스트
- "/sc:test --coverage" → 커버리지 포함
- "unit 테스트만" → `--type unit`
- "e2e 테스트 돌려줘" → `--type e2e`
