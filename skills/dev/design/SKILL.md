---
name: design
description: "This skill should be used when the user asks to design system, create architecture, design API, or mentions system design"
version: 1.0.0
---
# /sc:design - System and Component Design

## Purpose
Design system architecture, APIs, component interfaces with **Clean Architecture** principles and **TDD** approach.

## Usage
```
/sc:design [target] [--type architecture|api|component|database] [--format diagram|spec|code] [--tdd]
```

## Arguments
- `target` - System, component, or feature to design
- `--type` - Design type (architecture, api, component, database)
- `--format` - Output format (diagram, spec, code)
- `--tdd` - Include TDD test design upfront
- `--iterative` - Enable iterative design refinement


## TDD Test Design (when --tdd flag is used)

### Test-First Design Template
```
┌─────────────────────────────────────────────────────────────┐
│  STEP 1: Define Test Cases First                            │
│                                                             │
│  기능 구현 전에 테스트 케이스를 먼저 설계합니다.              │
└─────────────────────────────────────────────────────────────┘

## Test Cases for [Feature Name]

### Happy Path Tests
| ID | Test Name | Given | When | Then |
|----|-----------|-------|------|------|
| T1 | shouldReturnData_whenValidInput | 유효한 입력 | API 호출 | 정상 응답 |
| T2 | shouldSaveData_whenValidRequest | 유효한 요청 | 저장 호출 | DB 저장 확인 |

### Edge Cases
| ID | Test Name | Given | When | Then |
|----|-----------|-------|------|------|
| T3 | shouldThrowException_whenNullInput | null 입력 | API 호출 | BadRequest |
| T4 | shouldReturnEmpty_whenNoData | 데이터 없음 | 조회 호출 | 빈 목록 |

### Error Cases
| ID | Test Name | Given | When | Then |
|----|-----------|-------|------|------|
| T5 | shouldReturn404_whenNotFound | 없는 ID | 조회 호출 | NotFoundException |
| T6 | shouldReturn401_whenUnauthorized | 토큰 없음 | API 호출 | Unauthorized |
```

### Test Code Template
```java
@ExtendWith(MockitoExtension.class)
class [Feature]ServiceTest {

    @Mock
    private [Repository] repository;

    @InjectMocks
    private [Feature]ServiceImpl service;

    @Test
    @DisplayName("[T1] 유효한 입력으로 조회 시 정상 응답 반환")
    void shouldReturnData_whenValidInput() {
        // Given
        // ... setup test data

        // When
        // ... call service method

        // Then
        // ... verify result
    }

    @Test
    @DisplayName("[T3] null 입력 시 BadRequestException 발생")
    void shouldThrowException_whenNullInput() {
        // Given
        // ... null input

        // When & Then
        assertThrows(BadRequestException.class, () -> {
            service.process(null);
        });
    }
}
```


## Execution Flow

1. **Requirements Analysis**
   - Understand feature requirements
   - Identify affected layers and components
   - Define success criteria

2. **TDD Test Design** (if --tdd enabled)
   - Design test cases BEFORE implementation
   - Document expected behaviors
   - Create test code templates

3. **Architecture Design**
   - Apply Clean Architecture layer separation
   - Define interfaces and contracts
   - Document dependencies

4. **API Design**
   - Define endpoints and contracts
   - Document request/response formats
   - Specify validation rules

5. **Review & Refine**
   - Validate against requirements
   - Check for Clean Architecture violations
   - Confirm TDD coverage
