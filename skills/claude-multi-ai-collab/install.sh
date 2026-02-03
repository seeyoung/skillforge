#!/bin/bash
# Multi-AI Collab 설치 스크립트

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_SCRIPT_DIR="$HOME/.claude/scripts"
TARGET_SKILL_DIR="$HOME/.claude/skills/multi-ai-collab"

echo "=== Multi-AI Collab 설치 ==="
echo ""

# ============================================
# 의존성 체크
# ============================================
echo "의존성 확인 중..."

missing=()
for cmd in jq mktemp uuidgen; do
    if ! command -v "$cmd" &> /dev/null; then
        missing+=("$cmd")
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "Warning: 다음 명령어가 설치되지 않았습니다: ${missing[*]}"
    echo "  macOS: brew install ${missing[*]}"
    echo "  Ubuntu: sudo apt-get install ${missing[*]}"
    echo ""
fi

# AI CLI 체크 (경고만)
ai_missing=()
for cmd in gemini codex; do
    if ! command -v "$cmd" &> /dev/null; then
        ai_missing+=("$cmd")
    fi
done

if [ ${#ai_missing[@]} -gt 0 ]; then
    echo "Warning: AI CLI가 설치되지 않았습니다: ${ai_missing[*]}"
    echo "  gemini: https://github.com/google-gemini/gemini-cli"
    echo "  codex: https://github.com/openai/codex"
    echo ""
fi

# ============================================
# 디렉토리 생성
# ============================================
echo "디렉토리 생성 중..."
mkdir -p "$TARGET_SCRIPT_DIR"
mkdir -p "$TARGET_SKILL_DIR"

# ============================================
# 파일 복사
# ============================================
echo "파일 복사 중..."

# 기존 파일 백업
if [ -f "$TARGET_SCRIPT_DIR/ai-collab.sh" ]; then
    cp "$TARGET_SCRIPT_DIR/ai-collab.sh" "$TARGET_SCRIPT_DIR/ai-collab.sh.bak"
    echo "  기존 스크립트 백업: ai-collab.sh.bak"
fi

cp "$SCRIPT_DIR/scripts/ai-collab.sh" "$TARGET_SCRIPT_DIR/"
cp "$SCRIPT_DIR/skills/multi-ai-collab/SKILL.md" "$TARGET_SKILL_DIR/"

chmod +x "$TARGET_SCRIPT_DIR/ai-collab.sh"

# ============================================
# PATH 확인
# ============================================
echo ""
if [[ ":$PATH:" != *":$TARGET_SCRIPT_DIR:"* ]]; then
    echo "PATH 설정이 필요합니다. 아래 줄을 ~/.zshrc 또는 ~/.bashrc에 추가하세요:"
    echo ""
    echo "  export PATH=\"\$HOME/.claude/scripts:\$PATH\""
    echo ""
else
    echo "PATH가 이미 설정되어 있습니다."
fi

echo "=== 설치 완료 ==="
echo ""
echo "사용법:"
echo "  ai-collab.sh start              # 새 협업 세션 시작"
echo "  ai-collab.sh ask both \"질문\"   # Gemini + Codex에 질문"
echo "  ai-collab.sh --help             # 도움말"
