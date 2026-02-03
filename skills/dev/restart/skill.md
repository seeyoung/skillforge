---
name: restart
description: "서버 재시작, restart, 재기동 요청 시 사용"
version: 2.0.0
---

# /restart - Dev Server Restart

## Overview
개발 서버를 재시작합니다. 프로젝트 설정을 자동 감지합니다.

## Usage
```
/restart              # 단순 재시작
/restart --clean      # 캐시 삭제 후 재시작
/restart --log        # 로그 확인
/restart --port 3001  # 특정 포트로 재시작
```

## Auto Detection

실행 전 다음을 자동 감지합니다:

### 1. 프로젝트명
```bash
PROJECT_NAME=$(basename "$(pwd)")
```

### 2. 포트 (우선순위)
1. `--port` 인자
2. `.env` 또는 `.env.local`의 `PORT=`
3. `package.json`의 `scripts.dev`에서 추출
4. 기본값: `3000`

```bash
# .env에서 포트 추출
PORT=$(grep -E "^PORT=" .env .env.local 2>/dev/null | tail -1 | cut -d= -f2)
```

### 3. 프레임워크 & 캐시 디렉토리
| 감지 파일 | 프레임워크 | 캐시 디렉토리 |
|-----------|------------|---------------|
| `next.config.*` | Next.js | `.next` |
| `vite.config.*` | Vite | `dist`, `.vite` |
| `nuxt.config.*` | Nuxt | `.nuxt`, `.output` |
| `svelte.config.*` | SvelteKit | `.svelte-kit` |
| `angular.json` | Angular | `.angular` |
| 기타 | Node.js | `dist` |

### 4. 로그 파일
```bash
LOG_FILE="/tmp/${PROJECT_NAME}-dev.log"
```

## Execution Steps

### For `/restart` or `/restart --clean`

1. 자동 감지 실행
```bash
PROJECT_NAME=$(basename "$(pwd)")
PORT=${PORT:-3000}
LOG_FILE="/tmp/${PROJECT_NAME}-dev.log"
```

2. 기존 프로세스 종료
```bash
lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
```

3. `--clean` 시 캐시 삭제
```bash
# 프레임워크별 캐시 디렉토리 삭제
rm -rf .next .nuxt .output .svelte-kit .vite .angular dist 2>/dev/null || true
```

4. 개발 서버 시작
```bash
npm run dev > "$LOG_FILE" 2>&1 &
# 또는 PORT 지정이 필요한 경우
PORT=$PORT npm run dev > "$LOG_FILE" 2>&1 &
```

5. 초기 로그 확인
```bash
sleep 3 && tail -20 "$LOG_FILE"
```

6. 결과 보고
```
서버 재시작 중: http://localhost:$PORT
로그: $LOG_FILE
```

### For `/restart --log`

```bash
tail -50 "/tmp/${PROJECT_NAME}-dev.log"
```

## Examples

```bash
# Next.js 프로젝트 (자동 감지)
/restart
# → 포트 3000, 캐시 .next

# 특정 포트 지정
/restart --port 8080

# 캐시 클린 후 재시작
/restart --clean
```
