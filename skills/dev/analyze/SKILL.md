---
name: analyze
description: "This skill should be used when the user asks to analyze code, review code quality, check security, or mentions code analysis"
version: 2.0.0
---

# /sc:analyze - Code Analysis

## Purpose
Execute comprehensive code analysis across quality, security, performance, and architecture domains.
`.skillforge.json` 설정을 지원합니다.

## Usage
```
/sc:analyze [target] [--focus quality|security|performance|architecture] [--depth quick|deep]
```

## Arguments
- `target` - Files, directories, or project to analyze
- `--focus` - Analysis focus area (quality, security, performance, architecture)
- `--depth` - Analysis depth (quick, deep)
- `--format` - Output format (text, json, report)
- `--fix` - Auto-fix issues when possible

## Step 1: Load Project Settings

```bash
cat .skillforge.json 2>/dev/null
```

**Settings schema (`analyze` section):**
```json
{
  "analyze": {
    "lintCommand": "npm run lint",
    "formatCommand": "npm run format",
    "typeCheckCommand": "npm run type-check",
    "securityCommand": "npm audit",
    "qualityCommand": "./gradlew qualityGate",
    "exclude": ["node_modules", "dist", "build", ".git"],
    "rules": {
      "maxFileLines": 500,
      "maxMethodLines": 30,
      "maxComplexity": 10
    },
    "security": {
      "enabled": true,
      "scanSecrets": true,
      "dependencyCheck": true
    }
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `lintCommand` | 린트 명령 | 자동 감지 |
| `formatCommand` | 포맷 검사 명령 | - |
| `typeCheckCommand` | 타입 검사 명령 | - |
| `securityCommand` | 보안 스캔 명령 | 자동 감지 |
| `qualityCommand` | 품질 게이트 명령 | - |
| `exclude` | 분석 제외 경로 | `["node_modules", "dist"]` |
| `rules.maxFileLines` | 파일 최대 줄 수 | `500` |
| `rules.maxMethodLines` | 메서드 최대 줄 수 | `30` |
| `rules.maxComplexity` | 최대 순환 복잡도 | `10` |
| `security.enabled` | 보안 분석 활성화 | `true` |
| `security.scanSecrets` | 시크릿 스캔 | `true` |
| `security.dependencyCheck` | 의존성 취약점 검사 | `true` |

## Step 2: Auto Detection (Fallback)

`.skillforge.json`이 없으면 자동 감지:

| 감지 파일 | 프레임워크 | 린트 명령 | 보안 명령 |
|-----------|------------|-----------|-----------|
| `eslint.config.*`, `.eslintrc*` | ESLint | `npm run lint` | `npm audit` |
| `biome.json` | Biome | `npx biome check` | - |
| `.prettierrc*` | Prettier | `npm run format:check` | - |
| `build.gradle*` | Gradle | `./gradlew checkstyleMain` | `./gradlew dependencyCheckAnalyze` |
| `pom.xml` | Maven | `mvn checkstyle:check` | `mvn dependency-check:check` |
| `pylint.cfg`, `pyproject.toml` | Pylint | `pylint` | `safety check` |
| `golangci.yml` | Go | `golangci-lint run` | `govulncheck` |
| `clippy.toml` | Rust | `cargo clippy` | `cargo audit` |

## Execution Flow

### 1. Quality Analysis (`--focus quality`)
```bash
# .skillforge.json 설정 사용
${analyze.lintCommand}
${analyze.formatCommand}
${analyze.typeCheckCommand}

# 또는 자동 감지
npm run lint
```

**검사 항목:**
- 코드 스타일 위반
- 미사용 변수/import
- 복잡도 초과 (maxComplexity)
- 파일/메서드 길이 초과

### 2. Security Analysis (`--focus security`)
```bash
# 의존성 취약점 검사
${analyze.securityCommand}

# 시크릿 스캔 (scanSecrets: true)
# .env, credentials, API keys 등 검사
```

**검사 항목:**
- 의존성 취약점 (CVE)
- 하드코딩된 시크릿
- SQL Injection, XSS 패턴
- 안전하지 않은 함수 사용

### 3. Performance Analysis (`--focus performance`)
**검사 항목:**
- N+1 쿼리 패턴
- 불필요한 재렌더링 (React)
- 메모리 누수 패턴
- 비효율적인 알고리즘

### 4. Architecture Analysis (`--focus architecture`)
**검사 항목:**
- 레이어 의존성 위반
- 순환 참조
- 단일 책임 원칙 위반
- 과도한 결합도

### 5. Full Analysis (기본)
모든 영역 분석 후 종합 리포트 생성

## Auto-fix (`--fix`)
```bash
# 자동 수정 가능한 이슈 해결
${analyze.lintCommand} --fix
${analyze.formatCommand} --write
```

## Report Format

### Summary
```
📊 Analysis Report
==================
Quality:     ✅ 95/100
Security:    ⚠️  2 warnings
Performance: ✅ No issues
Architecture: ✅ Clean

📋 Issues Found: 5
  - 🔴 Critical: 0
  - 🟠 Warning: 2
  - 🟡 Info: 3
```

### Detailed Findings
```
⚠️ [Security] Potential SQL injection
   File: src/api/users.ts:42
   Suggestion: Use parameterized queries

⚠️ [Quality] Method too long (45 lines > 30)
   File: src/services/auth.ts:120
   Suggestion: Extract into smaller methods
```

## Examples

### 설정 없이 (자동 감지)
```bash
/sc:analyze                      # 전체 분석
/sc:analyze --focus security     # 보안 분석만
/sc:analyze src/ --depth deep    # 특정 디렉토리 상세 분석
/sc:analyze --fix                # 자동 수정
```

### .skillforge.json 사용

**Node.js 프로젝트:**
```json
{
  "analyze": {
    "lintCommand": "npm run lint",
    "securityCommand": "npm audit --audit-level=moderate",
    "typeCheckCommand": "tsc --noEmit",
    "rules": {
      "maxComplexity": 15
    }
  }
}
```

**Java 프로젝트:**
```json
{
  "analyze": {
    "qualityCommand": "./gradlew qualityGate",
    "securityCommand": "./gradlew dependencyCheckAnalyze",
    "exclude": ["build", ".gradle"]
  }
}
```

## Usage Examples
- "코드 분석해줘" → 전체 분석
- "/sc:analyze --focus security" → 보안 분석
- "린트 돌려줘" → 품질 분석
- "취약점 검사해줘" → 보안 분석
