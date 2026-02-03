# Skillforge

Claude Code용 재사용 가능한 skill 모음집입니다.

## 설치

```bash
# 저장소 클론
git clone https://github.com/seeyoung/skillforge.git

# Claude Code에 skill 경로 추가
# ~/.claude/settings.json
{
  "skills": [
    "~/projects/skillforge/skills/dev",
    "~/projects/skillforge/skills/git"
  ]
}
```

## Skills

### Development (`/sc:*`)

| Skill | 명령어 | 설명 |
|-------|--------|------|
| design | `/sc:design` | 시스템/API/컴포넌트 설계 |
| explain | `/sc:explain` | 코드 설명 및 분석 |
| troubleshoot | `/sc:troubleshoot` | 버그/성능/빌드 문제 진단 |
| test | `/sc:test` | 테스트 작성 및 실행 |
| document | `/sc:document` | 문서화 |
| restart | `/restart` | 개발 서버 재시작 (프레임워크 자동 감지) |
| load | `/sc:load` | 프로젝트 컨텍스트 로딩 |
| cleanup | `/sc:cleanup` | 코드 정리 및 리팩토링 |
| workflow | `/sc:workflow` | 구현 워크플로우 생성 |
| task | `/sc:task` | 태스크 관리 |
| implement | `/sc:implement` | 기능 구현 |
| index | `/sc:index` | 프로젝트 인덱싱 |
| analyze | `/sc:analyze` | 코드 품질/보안 분석 |
| estimate | `/sc:estimate` | 개발 시간 추정 |
| improve | `/sc:improve` | 코드 개선 |
| build | `/sc:build` | 빌드 및 배포 |
| spawn | `/sc:spawn` | 병렬 태스크 실행 |

### Git (`/commit`, `/push`, etc.)

| Skill | 명령어 | 설명 |
|-------|--------|------|
| commit | `/commit` | 스마트 커밋 (Conventional Commits) |
| push | `/push` | 원격 저장소에 푸시 |
| issue | `/issue #N` | GitHub 이슈 해결 워크플로우 |
| git | `/sc:git` | 일반 Git 작업 |

### Multi-AI Collab

| Skill | 명령어 | 설명 |
|-------|--------|------|
| multi-ai-collab | `/collab` | Gemini, Codex와 협업 리뷰 |

## 사용 예시

```bash
# 커밋하기
> /commit

# 이슈 해결
> /issue #42

# 개발 서버 재시작
> /restart

# 코드 분석
> /sc:analyze security
```

## 구조

```
skillforge/
├── skills/
│   ├── dev/                 # 개발 워크플로우
│   │   ├── design/
│   │   ├── explain/
│   │   ├── troubleshoot/
│   │   ├── test/
│   │   ├── document/
│   │   ├── restart/
│   │   ├── load/
│   │   ├── cleanup/
│   │   ├── workflow/
│   │   ├── task/
│   │   ├── implement/
│   │   ├── index/
│   │   ├── analyze/
│   │   ├── estimate/
│   │   ├── improve/
│   │   ├── build/
│   │   └── spawn/
│   ├── git/                 # Git 관련
│   │   ├── commit/
│   │   ├── push/
│   │   ├── issue/
│   │   └── git/
│   ├── claude-multi-ai-collab/  # AI 협업
│   └── templates/           # skill 템플릿
└── README.md
```

## Skill 작성법

```markdown
---
name: my-skill
description: "트리거 조건 설명"
version: 1.0.0
---

# Skill Title

## Purpose
skill의 목적

## Workflow
1. Step 1
2. Step 2

## Usage Examples
- "example trigger 1"
- "example trigger 2"
```

## License

MIT
