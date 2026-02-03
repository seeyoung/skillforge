# CLAUDE.md

Claude Code + Gemini CLI + Codex CLI 협업 스킬 프로젝트

## 설계 결정 사항

### 세션 데이터 위치
- **결정**: 프로젝트별 `.claude/collab/`
- **이유**: 프로젝트 간 컨텍스트 격리

### 프로젝트 루트 탐색
- **결정**: pwd → 상위로 `.git` 탐색 → 없으면 pwd
- **이유**: 단순함, git 프로젝트 기준

### 의존성 분리
- **Core**: `jq`, `mktemp` (세션 조회용)
- **AI**: `gemini`, `codex`, `uuidgen` (AI 호출용)

### 리뷰 워크플로우
- 3회 반복, 협의 프로세스 포함
- Claude가 예상 문제 분석 → 의견 제시 → 합의점 도출

## 로드맵

- [ ] uninstall.sh
- [ ] --version 옵션
- [ ] 자동 업데이트 체크
- [ ] 더 많은 AI CLI 지원
- [ ] 세션 내보내기/가져오기
