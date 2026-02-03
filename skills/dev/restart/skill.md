---
name: restart
description: "서버 재시작, restart, 재기동 요청 시 사용"
version: 1.0.0
---

# /restart - Dev Server Restart

## Overview
포트 3002에서 Next.js 개발 서버를 재시작합니다.

## Usage
```
/restart           # 단순 재시작
/restart --clean   # .next 캐시 삭제 후 재시작
/restart --log     # 로그 확인
```

## Log File
`/tmp/servio-dev.log`

## Execution Steps

### For `/restart` or `/restart --clean`

1. Kill existing process on port 3002
```bash
lsof -ti:3002 | xargs kill -9 2>/dev/null || true
```

2. If `--clean` flag, delete .next cache
```bash
rm -rf .next
```

3. Start dev server with log output
```bash
PORT=3002 npm run dev > /tmp/servio-dev.log 2>&1 &
```

4. Wait and show initial log
```bash
sleep 3 && tail -20 /tmp/servio-dev.log
```

5. Report: 서버 재시작 중 http://localhost:3002

### For `/restart --log`

Show recent log:
```bash
tail -50 /tmp/servio-dev.log
```
