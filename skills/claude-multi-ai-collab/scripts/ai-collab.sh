#!/bin/bash
# Multi-AI Collaboration Script
# Gemini CLI + Codex CLI 협업 세션 관리

set -e

# ============================================
# 프로젝트 루트 탐색 (pwd에서 상위로 .git 찾기)
# ============================================
find_project_root() {
    local dir="$(pwd)"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    # .git 없으면 pwd 반환
    pwd
}

PROJECT_DIR="$(find_project_root)"
COLLAB_DIR="${PROJECT_DIR}/.claude/collab"
SESSIONS_FILE="${COLLAB_DIR}/sessions.json"

# Codex MCP 서버 설정 (context7, sequential-thinking만 활성화)
CODEX_MCP_OPTS=(
    -c "mcp_servers.shadcn-ui.enabled=false"
    -c "mcp_servers.playwright.enabled=false"
    -c "mcp_servers.magicui.enabled=false"
    -c "mcp_servers.chrome-devtools.enabled=false"
    -c "mcp_servers.magic.enabled=false"
    -c "mcp_servers.magic-21st.enabled=false"
    -c "mcp_servers.supabase.enabled=false"
)

# ============================================
# 의존성 체크
# ============================================
check_core_deps() {
    local missing=()

    for cmd in jq mktemp; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo "Error: 필수 명령어가 설치되지 않았습니다: ${missing[*]}" >&2
        exit 1
    fi
}

check_ai_deps() {
    check_core_deps

    local missing=()

    for cmd in gemini codex uuidgen; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo "Error: AI 관련 명령어가 설치되지 않았습니다: ${missing[*]}" >&2
        exit 1
    fi
}

# ============================================
# 초기화
# ============================================
init() {
    mkdir -p "$COLLAB_DIR"
    [ -f "$SESSIONS_FILE" ] || echo '{}' > "$SESSIONS_FILE"
}

# ============================================
# 새 협업 세션 시작
# ============================================
start() {
    check_ai_deps
    init

    local UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')
    echo "=== 협업 세션 시작: $UUID ===" >&2

    # 1. Gemini 세션 시작
    echo "Gemini 세션 생성 중..." >&2
    local GEMINI_TAG="$UUID"

    # Gemini 비대화형 호출 (필요한 extensions만 사용)
    local gemini_err=$(mktemp)
    if ! gemini -e context7 exa-mcp-server github \
           --output-format json \
           "협업 세션을 시작합니다. 세션 ID: ${UUID}. 이 ID를 기억해주세요." \
           > /dev/null 2>"$gemini_err"; then
        echo "Warning: Gemini 세션 시작 실패" >&2
        [ -s "$gemini_err" ] && cat "$gemini_err" >&2
    fi
    rm -f "$gemini_err"

    # 2. Codex 세션 시작 + ID 캡처
    echo "Codex 세션 생성 중..." >&2
    local today_dir="$HOME/.codex/sessions/$(date +%Y)/$(date +%m)/$(date +%d)"
    mkdir -p "$today_dir" 2>/dev/null || true

    # 시작 전 파일 목록
    local before_files=$(ls -t "$today_dir"/*.jsonl 2>/dev/null | head -10 || echo "")

    # Codex 실행 (exec 모드로 비대화형 실행, 필요한 MCP만 사용)
    local codex_err=$(mktemp)
    if ! codex "${CODEX_MCP_OPTS[@]}" exec \
          "협업 세션을 시작합니다. 세션 ID: ${UUID}. 이 ID를 기억해주세요." \
          > /dev/null 2>"$codex_err"; then
        echo "Warning: Codex 세션 시작 실패" >&2
        [ -s "$codex_err" ] && cat "$codex_err" >&2
    fi
    rm -f "$codex_err"

    sleep 2

    # 새로 생성된 파일에서 세션 ID 추출
    local after_files=$(ls -t "$today_dir"/*.jsonl 2>/dev/null | head -10 || echo "")
    local new_file=""

    for f in $after_files; do
        if ! echo "$before_files" | grep -q "$f"; then
            new_file="$f"
            break
        fi
    done

    local CODEX_ID=""
    if [ -n "$new_file" ]; then
        CODEX_ID=$(basename "$new_file" | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' || echo "")
    fi

    if [ -z "$CODEX_ID" ]; then
        echo "Warning: Codex 세션 ID 캡처 실패. 새 대화로 시작됩니다." >&2
    fi

    # 3. 매핑 저장
    local tmp=$(mktemp)
    jq --arg uuid "$UUID" \
       --arg gemini "$GEMINI_TAG" \
       --arg codex "$CODEX_ID" \
       --arg created "$(date -Iseconds)" \
       '.[$uuid] = {created: $created, gemini_tag: $gemini, codex_id: $codex}' \
       "$SESSIONS_FILE" > "$tmp" && mv "$tmp" "$SESSIONS_FILE"

    # 4. 현재 세션 설정
    echo "$UUID" > "${COLLAB_DIR}/current"

    echo "" >&2
    echo "세션 생성 완료:" >&2
    echo "  UUID: $UUID" >&2
    echo "  Gemini Tag: $GEMINI_TAG" >&2
    echo "  Codex ID: ${CODEX_ID:-없음}" >&2
    echo "" >&2

    # UUID 반환
    echo "$UUID"
}

# ============================================
# 현재 세션 가져오기
# ============================================
current() {
    [ -f "${COLLAB_DIR}/current" ] && cat "${COLLAB_DIR}/current"
}

get_session() {
    local uuid="${1:-$(current)}"
    if [ -z "$uuid" ]; then
        return 1
    fi

    local session
    session=$(jq -r --arg u "$uuid" '.[$u] // empty' "$SESSIONS_FILE" 2>/dev/null)

    if [ -z "$session" ]; then
        return 1
    fi

    echo "$session"
}

# ============================================
# AI에 질문
# ============================================
ask() {
    check_ai_deps

    local ai="$1"
    local prompt="$2"
    local uuid=$(current)

    if [ -z "$uuid" ]; then
        echo "Error: 활성 세션 없음. 먼저 'start' 실행" >&2
        return 1
    fi

    if [ -z "$prompt" ]; then
        echo "Error: 프롬프트가 필요합니다. 따옴표로 감싸서 입력하세요." >&2
        echo "Example: $0 ask $ai \"질문 내용\"" >&2
        return 1
    fi

    local session
    if ! session=$(get_session "$uuid"); then
        echo "Error: 세션 정보를 찾을 수 없습니다. UUID: $uuid" >&2
        echo "새 세션을 시작하려면: $0 start" >&2
        return 1
    fi

    case "$ai" in
        gemini)
            local tag=$(echo "$session" | jq -r '.gemini_tag')
            if [ -z "$tag" ] || [ "$tag" = "null" ]; then
                echo "Error: Gemini 세션 태그를 찾을 수 없습니다." >&2
                return 1
            fi
            echo "[Gemini] 세션 태그: $tag" >&2
            echo "" >&2
            gemini -e context7 exa-mcp-server github \
                   "세션 ID ${tag}의 대화입니다. ${prompt}"
            ;;
        codex)
            local codex_id=$(echo "$session" | jq -r '.codex_id')
            if [ -n "$codex_id" ] && [ "$codex_id" != "null" ] && [ "$codex_id" != "" ]; then
                echo "[Codex] 세션 ID: $codex_id" >&2
                echo "" >&2
                codex "${CODEX_MCP_OPTS[@]}" exec resume "$codex_id" "$prompt"
            else
                echo "[Codex] 저장된 세션 없음, 새 대화 시작" >&2
                echo "" >&2
                codex "${CODEX_MCP_OPTS[@]}" exec "$prompt"
            fi
            ;;
        both)
            echo "========== Gemini ==========" >&2
            ask gemini "$prompt" || echo "[Gemini 실패]" >&2
            echo ""
            echo "========== Codex ==========" >&2
            ask codex "$prompt" || echo "[Codex 실패]" >&2
            ;;
        *)
            echo "Error: 알 수 없는 AI: $ai" >&2
            echo "사용 가능: gemini, codex, both" >&2
            return 1
            ;;
    esac
}

# ============================================
# 세션 전환
# ============================================
switch() {
    check_core_deps
    init
    local uuid="$1"

    if [ -z "$uuid" ]; then
        echo "Error: UUID가 필요합니다." >&2
        echo "Usage: $0 switch <uuid>" >&2
        exit 1
    fi

    if jq -e --arg u "$uuid" '.[$u]' "$SESSIONS_FILE" > /dev/null 2>&1; then
        echo "$uuid" > "${COLLAB_DIR}/current"
        echo "세션 전환: $uuid" >&2
        get_session "$uuid"
    else
        echo "Error: 세션 없음: $uuid" >&2
        echo "사용 가능한 세션 확인: $0 list" >&2
        exit 1
    fi
}

# ============================================
# 세션 목록
# ============================================
list() {
    check_core_deps
    init
    local current_uuid=$(current)

    echo "=== 협업 세션 목록 ==="

    if [ ! -f "$SESSIONS_FILE" ] || [ "$(jq 'length' "$SESSIONS_FILE" 2>/dev/null)" = "0" ]; then
        echo "  (없음)"
        return
    fi

    jq -r 'to_entries[] | "\(.key)|\(.value.created)|\(if .value.codex_id == "" or .value.codex_id == null then "none" else .value.codex_id end)"' "$SESSIONS_FILE" | \
    while IFS='|' read -r uuid created codex_id; do
        local short_codex="${codex_id:0:8}"
        local marker=""
        [ "$uuid" = "$current_uuid" ] && marker=" <- current"
        echo "  $uuid | $(echo "$created" | cut -d'T' -f1) | codex:${short_codex}${marker}"
    done
}

# ============================================
# 상태
# ============================================
status() {
    check_core_deps
    init
    local uuid=$(current)

    if [ -z "$uuid" ]; then
        echo "활성 세션 없음"
        echo ""
        echo "새 세션 시작: $0 start"
        return
    fi

    echo "=== 현재 세션 ==="
    echo "UUID: $uuid"
    echo ""

    local session
    if session=$(get_session "$uuid"); then
        echo "$session" | jq .
    else
        echo "Warning: 세션 정보를 찾을 수 없습니다."
        echo "세션 파일이 손상되었을 수 있습니다."
    fi
}

# ============================================
# 세션 삭제
# ============================================
delete() {
    check_core_deps
    local uuid="$1"

    if [ -z "$uuid" ]; then
        echo "Error: UUID가 필요합니다." >&2
        echo "Usage: $0 delete <uuid>" >&2
        exit 1
    fi

    if jq -e --arg u "$uuid" '.[$u]' "$SESSIONS_FILE" > /dev/null 2>&1; then
        local tmp=$(mktemp)
        jq --arg u "$uuid" 'del(.[$u])' "$SESSIONS_FILE" > "$tmp" && mv "$tmp" "$SESSIONS_FILE"

        # 현재 세션이면 current 파일도 삭제
        if [ "$(current)" = "$uuid" ]; then
            rm -f "${COLLAB_DIR}/current"
        fi

        echo "세션 삭제됨: $uuid"
    else
        echo "Error: 세션 없음: $uuid" >&2
        exit 1
    fi
}

# ============================================
# 도움말
# ============================================
show_help() {
    cat << 'EOF'
Multi-AI Collaboration Script

Usage: ai-collab.sh <command> [args]

Commands:
  start              새 협업 세션 시작 (UUID 반환)
  ask <ai> <prompt>  AI에 질문 (gemini|codex|both)
  switch <uuid>      다른 세션으로 전환
  list               모든 세션 목록
  status             현재 세션 정보
  current            현재 세션 UUID
  delete <uuid>      세션 삭제
  help               이 도움말

Note:
  - 프롬프트는 반드시 따옴표로 감싸야 합니다.
  - Gemini는 세션 컨텍스트를 유지하지 않습니다 (태그만 전달).
  - Codex는 세션 ID로 대화 컨텍스트를 유지합니다.

Examples:
  ./ai-collab.sh start
  ./ai-collab.sh ask gemini "코드를 분석해줘"
  ./ai-collab.sh ask codex "개선점을 제안해줘"
  ./ai-collab.sh ask both "이 함수의 역할은?"
EOF
}

# ============================================
# Main
# ============================================
case "${1:-}" in
    start)   start ;;
    ask)     ask "$2" "$3" ;;
    switch)  switch "$2" ;;
    list)    list ;;
    status)  status ;;
    current) current ;;
    delete)  delete "$2" ;;
    help)    show_help ;;
    *)
        show_help
        echo ""
        echo "Current session: $(current 2>/dev/null || echo 'none')"
        ;;
esac
