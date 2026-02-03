---
name: multi-ai-collab
description: Multi-AI collab/협업 session with Gemini and Codex CLI. Use when user says 'collab', '협업', 'review with AI', 'ask Gemini/Codex', or wants multiple AI perspectives.
allowed-tools: Bash, Read, Write
user-invocable: true
---

# Multi-AI Collaboration

Gemini CLI와 Codex CLI를 활용한 다중 AI 협업 세션을 관리합니다.

## 사용 가능한 명령

```bash
# 새 협업 세션 시작
~/.claude/scripts/ai-collab.sh start

# Gemini에 질문 (따옴표 필수)
~/.claude/scripts/ai-collab.sh ask gemini "<질문>"

# Codex에 질문 (따옴표 필수)
~/.claude/scripts/ai-collab.sh ask codex "<질문>"

# 둘 다에게 질문
~/.claude/scripts/ai-collab.sh ask both "<질문>"

# 세션 관리
~/.claude/scripts/ai-collab.sh list      # 세션 목록
~/.claude/scripts/ai-collab.sh status    # 현재 세션 정보
~/.claude/scripts/ai-collab.sh switch <uuid>  # 세션 전환
~/.claude/scripts/ai-collab.sh delete <uuid>  # 세션 삭제
```

## 세션 관리

- 각 협업 세션은 고유 UUID로 식별됩니다
- **Codex**: 세션 ID로 대화 컨텍스트가 유지됩니다
- **Gemini**: 세션 컨텍스트를 유지하지 않습니다 (태그만 프롬프트에 포함)
- 세션 정보는 **프로젝트별** `<project>/.claude/collab/sessions.json`에 저장됩니다
- 프로젝트 루트는 pwd에서 상위로 `.git` 탐색하여 결정 (없으면 pwd 사용)

## 자동 컨텍스트 (v2.1.0+)

`ask` 명령 시 다음 정보가 자동으로 프롬프트에 포함됩니다:

```
[프로젝트 정보]
- CLAUDE.md 또는 AGENTS.md에서 추출 (컨벤션 포함)

[현재 변경사항]
- git diff --stat (staged/unstaged)

[리뷰 관점]
- 코드 품질, 보안, 성능, 유지보수성
```

이를 통해 Gemini/Codex가 프로젝트 맥락을 이해하고 더 정확한 리뷰를 제공합니다.

## MCP 설정

- **Gemini**: `-e` 옵션으로 사용할 extension 명시 (context7, exa-mcp-server, github)
- **Codex**: 비활성화 목록 기반 - 불필요한 MCP 서버를 개별 비활성화

> **주의**: Codex는 "사용할 MCP만 지정"이 아닌 "불필요한 MCP를 비활성화"하는 방식입니다.
> 새 MCP 서버가 추가되면 `CODEX_MCP_OPTS` 배열에 비활성화 옵션을 추가해야 합니다.

## 주의사항

- 프롬프트는 반드시 **따옴표로 감싸야** 합니다
- 스크립트는 프로젝트 루트가 아닌 다른 디렉토리에서도 실행 가능합니다
- 필수 의존성:
  - **Core** (list/status/switch/delete): `jq`, `mktemp`
  - **AI** (start/ask): `gemini`, `codex`, `uuidgen` + Core

## 활용 예시

1. **코드 리뷰**: 여러 AI의 관점에서 코드 분석
2. **버그 분석**: 다양한 시각으로 문제 진단
3. **설계 검토**: 아키텍처 결정에 대한 다중 의견 수렴

## 리뷰 워크플로우

코드, 문서, 설계 등 리뷰 시 최대 3회까지 반복합니다:

```
1회차: 리뷰 요청 → 이슈 발견 → 협의 → 수정
2회차: 재리뷰 요청 → 이슈 발견 → 협의 → 수정
3회차: 최종 리뷰 → 완료 (이슈 있어도 종료)
```

**협의 프로세스:**
1. Gemini/Codex 리뷰 결과 수집
2. Claude가 각 이슈의 예상 문제 분석 (비용 대비 효과)
3. Claude 의견 제시 (수정/스킵/대안)
4. 필요시 Gemini/Codex와 추가 협의
5. 합의점 도출 후 수정 진행

- 이슈가 없으면 조기 종료
- 3회차에서 발견된 이슈는 기록만 하고 종료 (과잉 엔지니어링 방지)
- 리뷰 대상: 코드, 문서(README, SKILL.md 등), API 설계, 아키텍처 등
