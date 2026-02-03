# Multi-AI Collab Demo
# VHS recording script

Output demo.gif

Set FontSize 15
Set Width 1000
Set Height 650
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 40ms

# ========== PART 1: 설치 ==========
Type "# 📦 1. 설치하기"
Enter
Sleep 1s

Type "git clone https://github.com/seeyoung/claude-multi-ai-collab.git"
Enter
Sleep 1.5s

Type "cd claude-multi-ai-collab && ./install.sh"
Enter
Sleep 2s

# Simulated install output
Type "=== Multi-AI Collab 설치 ==="
Enter
Type "의존성 확인 중... ✓"
Enter
Type "파일 복사 중... ✓"
Enter
Type "=== 설치 완료 ==="
Enter
Sleep 1.5s

# ========== PART 2: CLI 사용 ==========
Type ""
Enter
Type "# 🚀 2. CLI에서 사용하기"
Enter
Sleep 1s

Type "~/.claude/scripts/ai-collab.sh start"
Enter
Sleep 3s

Type "~/.claude/scripts/ai-collab.sh status"
Enter
Sleep 2s

# ========== PART 3: Claude Code 사용 ==========
Type ""
Enter
Type "# 💬 3. Claude Code에서 사용하기"
Enter
Sleep 1s

Type "# 방법 1: 슬래시 명령어"
Enter
Type "#   /multi-ai-collab 이 코드 리뷰해줘"
Enter
Sleep 1.5s

Type "# 방법 2: 자연어"
Enter
Type '#   "collab 해서 버그 분석해줘"'
Enter
Type '#   "Gemini랑 Codex한테 물어봐"'
Enter
Sleep 2s

# ========== OUTRO ==========
Type ""
Enter
Type "# ✨ 하나의 질문 → 3개 AI 관점 비교!"
Enter
Sleep 2s
