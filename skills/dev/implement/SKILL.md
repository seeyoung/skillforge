---
name: implement
description: "This skill should be used when the user asks to implement feature, add functionality, create component, or mentions implementation"
version: 1.0.0
---
# /sc:implement - Feature Implementation

## Purpose
Implement features, components, and code functionality with **Clean Architecture**, **Clean Code**, and optional **TDD** approach.

## Usage
```
/sc:implement [feature-description] [--type component|api|service|feature] [--framework react|vue|express|etc] [--tdd] [--safe]
```

## Arguments
- `feature-description` - Description of what to implement
- `--type` - Implementation type (component, api, service, feature, module)
- `--framework` - Target framework or technology stack
- `--tdd` - Follow Test-Driven Development (Red → Green → Refactor)
- `--safe` - Use conservative implementation approach
- `--iterative` - Enable iterative development with validation steps
- `--with-tests` - Include test implementation
- `--documentation` - Generate documentation alongside implementation


## Clean Code Principles (MANDATORY)

### Method Rules
- **한 가지 일만**: 메서드는 한 가지 작업만 수행
- **30줄 이내**: 메서드 길이 제한
- **파라미터 5개 이내**: 많으면 객체로 묶기
- **중첩 2단계 이내**: Early return 활용

### Naming Rules
- **의미 있는 이름**: 축약어 최소화
- **동사+명사**: 메서드는 동작 표현
- **일관된 규칙**: 프로젝트 컨벤션 준수

### Example Pattern
```java
// ❌ BAD
public void process(String a, String b, String c, int d, boolean e) {
    if (a != null) {
        if (b != null) {
            // deeply nested...
        }
    }
}

// ✅ GOOD
public ProcessResult process(ProcessRequest request) {
    validateRequest(request);
    return executeProcess(request);
}

private void validateRequest(ProcessRequest request) {
    if (request.getName() == null) {
        throw new BadRequestException("Name is required");
    }
}
```


## Execution Flow

1. **Requirements Analysis**
   - Analyze implementation requirements
   - Detect technology context (Spring Boot, React, etc.)
   - Identify affected layers

2. **TDD Phase** (if --tdd enabled)
   - Write test first (RED)
   - Implement minimal code (GREEN)
   - Refactor with Clean Code principles

3. **Implementation Phase**
   - Apply Clean Architecture layer rules
   - Follow Clean Code principles
   - Generate code with proper separation

4. **Validation Phase**
   - Run `./gradlew qualityGate` (if Java project)
   - Verify ArchUnit rules pass
   - Check Checkstyle warnings

5. **Documentation**
   - Update relevant documentation
   - Add JSDoc/JavaDoc comments


## Examples
```
/sc:implement user authentication system --type feature --tdd --with-tests
/sc:implement dashboard component --type component --framework react
/sc:implement REST API for user management --type api --safe
/sc:implement KPI data service --type service --tdd
```
