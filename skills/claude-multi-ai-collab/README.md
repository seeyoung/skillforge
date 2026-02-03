# Multi-AI Collab

> 🤖 Claude Code에서 Gemini + Codex를 동시에 활용하는 CLI 스킬

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![AI Collab](https://img.shields.io/badge/AI%20Collab-Claude%20%7C%20Gemini%20%7C%20Codex-brightgreen)](https://github.com)

하나의 질문으로 **3개 AI의 관점**을 비교하고, 더 나은 결정을 내리세요.

## 데모

![Demo](./demo.gif)

## 기능

- **다중 AI 협업**: Gemini와 Codex에게 동시에 질문하고 다양한 관점 수집
- **세션 관리**: 프로젝트별 협업 세션 관리 (Codex는 컨텍스트 유지)
- **리뷰 워크플로우**: 3회 반복 리뷰 + 협의 프로세스

## 설치

### 요구사항

- **필수**: `jq`, `mktemp`, `uuidgen`
- **AI CLI**: `gemini`, `codex`

### 설치 방법

```bash
git clone https://github.com/YOUR_USERNAME/claude-multi-ai-collab.git
cd claude-multi-ai-collab
./install.sh
```

### PATH 설정

`~/.zshrc` 또는 `~/.bashrc`에 추가:

```bash
export PATH="$HOME/.claude/scripts:$PATH"
```

## 사용법

### 기본 명령어

```bash
# 새 협업 세션 시작
ai-collab.sh start

# AI에 질문 (따옴표 필수)
ai-collab.sh ask gemini "코드 분석해줘"
ai-collab.sh ask codex "개선점 제안해줘"
ai-collab.sh ask both "이 함수의 역할은?"

# 세션 관리
ai-collab.sh list              # 세션 목록
ai-collab.sh status            # 현재 세션 정보
ai-collab.sh switch <uuid>     # 세션 전환
ai-collab.sh delete <uuid>     # 세션 삭제
```

### Claude Code에서 사용

```
# 직접 호출
/multi-ai-collab

# 자연어 호출
"collab 해줘"
"협업 세션 시작"
"Gemini한테 물어봐"
```

## 리뷰 워크플로우

코드/문서/설계 리뷰 시 최대 3회 반복:

```
1회차: 리뷰 요청 → 이슈 발견 → 협의 → 수정
2회차: 재리뷰 요청 → 이슈 발견 → 협의 → 수정
3회차: 최종 리뷰 → 완료
```

**협의 프로세스:**
1. Gemini/Codex 리뷰 결과 수집
2. Claude가 예상 문제 분석 (비용 대비 효과)
3. Claude 의견 제시 (수정/스킵/대안)
4. 합의점 도출 후 수정

## 업데이트

```bash
cd claude-multi-ai-collab
git pull
./install.sh
```

## 세션 데이터

세션 데이터는 각 프로젝트의 `.claude/collab/`에 저장됩니다.
프로젝트 루트는 현재 디렉토리에서 상위로 `.git`을 탐색하여 결정됩니다.

## 라이선스

MIT
