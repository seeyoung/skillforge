---
name: restart
description: "서버 재시작, restart, 재기동 요청 시 사용"
version: 3.0.0
---

# /restart - Dev Server Restart

## Overview
개발 서버를 재시작합니다. `.skillforge.json` 설정 또는 프로젝트 자동 감지를 사용합니다.

## Usage
```
/restart              # 단순 재시작
/restart --clean      # 캐시 삭제 후 재시작
/restart --log        # 로그 확인
/restart --port 3001  # 특정 포트로 재시작
```

## Step 1: Load Project Settings

```bash
# 프로젝트 설정 확인
cat .skillforge.json 2>/dev/null
```

**Settings schema (`restart` section):**
```json
{
  "restart": {
    "port": 8080,
    "command": "./gradlew bootRun",
    "framework": "spring",
    "cacheDir": ["build", ".gradle"],
    "logFile": "logs/dev.log"
  }
}
```

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `port` | 개발 서버 포트 | 자동 감지 또는 `3000` |
| `command` | 시작 명령어 | `npm run dev` |
| `framework` | 프레임워크 타입 | `auto` |
| `cacheDir` | 캐시 디렉토리 목록 | 프레임워크별 자동 |
| `logFile` | 로그 파일 경로 | `/tmp/${PROJECT_NAME}-dev.log` |

## Step 2: Auto Detection (Fallback)

`.skillforge.json`이 없으면 자동 감지:

### 프로젝트명
```bash
PROJECT_NAME=$(basename "$(pwd)")
```

### 포트 (우선순위)
1. `--port` 인자
2. `.skillforge.json`의 `restart.port`
3. `.env` 또는 `.env.local`의 `PORT=`
4. `package.json`의 `scripts.dev`에서 추출
5. 기본값: `3000`

```bash
PORT=$(grep -E "^PORT=" .env .env.local 2>/dev/null | tail -1 | cut -d= -f2)
```

### 프레임워크 & 캐시 디렉토리
| 감지 파일 | 프레임워크 | 캐시 디렉토리 | 기본 명령 |
|-----------|------------|---------------|-----------|
| `next.config.*` | Next.js | `.next` | `npm run dev` |
| `vite.config.*` | Vite | `dist`, `.vite` | `npm run dev` |
| `nuxt.config.*` | Nuxt | `.nuxt`, `.output` | `npm run dev` |
| `svelte.config.*` | SvelteKit | `.svelte-kit` | `npm run dev` |
| `angular.json` | Angular | `.angular` | `ng serve` |
| `build.gradle*` | Spring | `build`, `.gradle` | `./gradlew bootRun` |
| `pom.xml` | Maven | `target` | `mvn spring-boot:run` |
| `manage.py` | Django | `__pycache__` | `python manage.py runserver` |
| 기타 | Node.js | `dist` | `npm run dev` |

### 로그 파일
```bash
LOG_FILE="${restart.logFile:-/tmp/${PROJECT_NAME}-dev.log}"
```

## Step 3: Execution

### For `/restart` or `/restart --clean`

1. **설정 로드**
```bash
# .skillforge.json에서 설정 읽기 (있으면)
PORT=${설정값 또는 자동감지}
COMMAND=${설정값 또는 자동감지}
LOG_FILE=${설정값 또는 기본값}
```

2. **기존 프로세스 종료**
```bash
lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
```

3. **`--clean` 시 캐시 삭제**
```bash
# .skillforge.json의 cacheDir 또는 프레임워크별 기본값
rm -rf ${CACHE_DIRS} 2>/dev/null || true
```

4. **개발 서버 시작**
```bash
$COMMAND > "$LOG_FILE" 2>&1 &
# 또는 PORT 지정이 필요한 경우
PORT=$PORT $COMMAND > "$LOG_FILE" 2>&1 &
```

5. **초기 로그 확인**
```bash
sleep 3 && tail -20 "$LOG_FILE"
```

6. **결과 보고**
```
서버 재시작 중: http://localhost:$PORT
로그: $LOG_FILE
```

### For `/restart --log`

```bash
tail -50 "$LOG_FILE"
```

## Examples

### 자동 감지 (설정 파일 없음)
```bash
# Next.js 프로젝트
/restart
# → 포트 3000, 캐시 .next, npm run dev
```

### .skillforge.json 사용
```json
// .skillforge.json
{
  "restart": {
    "port": 8080,
    "command": "./gradlew bootRun",
    "cacheDir": ["build"]
  }
}
```
```bash
/restart
# → 포트 8080, ./gradlew bootRun 실행
```

### 명령줄 오버라이드
```bash
/restart --port 9000
# → .skillforge.json 설정 무시하고 포트 9000 사용
```
