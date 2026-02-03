# Skillforge

Claude Code skill 저장소 및 관리 도구

## 구조

```
skillforge/
├── skills/           # skill 파일 저장소
│   ├── dev/          # 개발 관련 skill
│   ├── git/          # Git 관련 skill
│   └── templates/    # skill 템플릿
└── src/              # 유틸리티 코드
```

## Skill 형식

각 skill은 markdown 파일로 작성됩니다:

```markdown
# Skill Name

설명...

## 트리거

- 키워드 1
- 키워드 2

## 프롬프트

실제 skill 내용...
```

## 설치

```bash
npm install
```

## 사용법

```bash
# skill 목록 보기
npm run list

# skill 추가
npm run add <skill-name>
```

## License

MIT
