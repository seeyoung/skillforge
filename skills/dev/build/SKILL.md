---
name: build
description: "This skill should be used when the user asks to build project, compile, package, or mentions build/deployment"
version: 2.0.0
---

# /sc:build - Project Building

## Purpose
Build, compile, and package projects with comprehensive error handling and optimization.
`.skillforge.json` 설정을 지원합니다.

## Usage
```
/sc:build [target] [--type dev|prod|test] [--clean] [--optimize]
```

## Arguments
- `target` - Project or specific component to build
- `--type` - Build type (dev, prod, test)
- `--clean` - Clean build artifacts before building
- `--optimize` - Enable build optimizations
- `--verbose` - Enable detailed build output

## Step 1: Load Project Settings

```bash
cat .skillforge.json 2>/dev/null
```

**Settings schema (`build` section):**
```json
{
  "build": {
    "command": "npm run build",
    "devCommand": "npm run build:dev",
    "prodCommand": "npm run build:prod",
    "cleanCommand": "rm -rf dist",
    "outputDir": "dist",
    "artifactDir": ["dist", "build"],
    "preBuildCommand": "npm run lint",
    "postBuildCommand": "npm run test",
    "env": {
      "NODE_ENV": "production"
    }
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `command` | 기본 빌드 명령 | 자동 감지 |
| `devCommand` | 개발 빌드 명령 | `{command}` |
| `prodCommand` | 프로덕션 빌드 명령 | `{command}` |
| `cleanCommand` | 클린 명령 | 자동 감지 |
| `outputDir` | 빌드 출력 디렉토리 | 자동 감지 |
| `artifactDir` | 정리할 아티팩트 디렉토리 | `["dist", "build"]` |
| `preBuildCommand` | 빌드 전 실행 명령 | - |
| `postBuildCommand` | 빌드 후 실행 명령 | - |
| `env` | 빌드 환경 변수 | `{}` |

## Step 2: Auto Detection (Fallback)

`.skillforge.json`이 없으면 자동 감지:

| 감지 파일 | 프레임워크 | 빌드 명령 | 출력 디렉토리 |
|-----------|------------|-----------|---------------|
| `next.config.*` | Next.js | `npm run build` | `.next` |
| `vite.config.*` | Vite | `npm run build` | `dist` |
| `nuxt.config.*` | Nuxt | `npm run build` | `.output` |
| `angular.json` | Angular | `ng build` | `dist` |
| `webpack.config.*` | Webpack | `npm run build` | `dist` |
| `tsconfig.json` | TypeScript | `tsc` | `dist` |
| `build.gradle*` | Gradle | `./gradlew build` | `build` |
| `pom.xml` | Maven | `mvn package` | `target` |
| `Cargo.toml` | Rust | `cargo build --release` | `target/release` |
| `go.mod` | Go | `go build` | `.` |
| `Makefile` | Make | `make` | - |
| `Dockerfile` | Docker | `docker build .` | - |

## Step 3: Execution

### 기본 빌드
```bash
# .skillforge.json 설정 사용
${build.command}

# 또는 자동 감지
npm run build
```

### 타입별 빌드

**개발 빌드 (`--type dev`):**
```bash
${build.devCommand}
# 또는
NODE_ENV=development ${build.command}
```

**프로덕션 빌드 (`--type prod`):**
```bash
${build.prodCommand}
# 또는
NODE_ENV=production ${build.command}
```

### 클린 빌드 (`--clean`)
```bash
# cleanCommand 또는 artifactDir 삭제
${build.cleanCommand}
# 또는
rm -rf ${build.artifactDir}

# 빌드 실행
${build.command}
```

### Pre/Post Build Hooks
```bash
# preBuildCommand 실행
${build.preBuildCommand}

# 빌드 실행
${build.command}

# postBuildCommand 실행
${build.postBuildCommand}
```

### 환경 변수 설정
```bash
# env 설정 적용
export NODE_ENV=production
export API_URL=https://api.example.com
${build.command}
```

## Step 4: Report & Analysis

빌드 완료 후:
1. **결과 요약** - 성공/실패, 소요 시간
2. **출력 분석** - 빌드 아티팩트 크기, 파일 수
3. **오류 분석** - 실패 시 원인 분석 및 해결 제안
4. **최적화 제안** - 빌드 시간/크기 개선 방안

## Examples

### 설정 없이 (자동 감지)
```bash
/sc:build              # 기본 빌드
/sc:build --clean      # 클린 빌드
/sc:build --type prod  # 프로덕션 빌드
```

### Node.js 프로젝트
```json
{
  "build": {
    "command": "npm run build",
    "prodCommand": "npm run build:prod",
    "cleanCommand": "rm -rf dist node_modules/.cache",
    "preBuildCommand": "npm run lint && npm run test",
    "env": {
      "NODE_ENV": "production"
    }
  }
}
```

### Gradle 프로젝트
```json
{
  "build": {
    "command": "./gradlew build",
    "cleanCommand": "./gradlew clean",
    "prodCommand": "./gradlew build -Pprod",
    "outputDir": "build/libs",
    "preBuildCommand": "./gradlew test"
  }
}
```

### Docker 프로젝트
```json
{
  "build": {
    "command": "docker build -t myapp .",
    "prodCommand": "docker build -t myapp:latest --target production .",
    "preBuildCommand": "npm run test",
    "postBuildCommand": "docker push myapp:latest"
  }
}
```

## Usage Examples
- "빌드해줘" → 기본 빌드
- "/sc:build --clean" → 클린 빌드
- "프로덕션 빌드" → `--type prod`
- "빌드하고 테스트" → preBuildCommand/postBuildCommand 활용
