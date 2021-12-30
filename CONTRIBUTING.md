# KHU PASS Contributing Guide

KHU PASS 프로젝트에 기여하여 현재보다 더 나은 모습이 되길 바랍니다! Contributor로서 다음과 같은 지침을 준수해주세요.

 - [Submission Guidelines](#submit)
 - [Git Commit Message Convention](#commit)
 - [Github PR Merge Commit Message Convention](#merge-commit)

## <a name="submit"></a> Submission Guidelines

### Issue 제출하기

만약 당신이 아이디어나 버그를 알고있다면, 다음 사항을 따라 알려주세요:

1. Issue를 생성합니다.

2. Assignee를 지정합니다.

3. 관련있는 Label를 추가합니다.

4. 템플릿 컨벤션을 준수하여 제출해주세요.

### Pull Request 제출하기

당신의 Pull Request를 제출하기 전에 다음 사항을 따라주세요:

1. 이미 존재하는 하나의 Issue를 해결할 수 있는 것인지 확인해주세요.

2. 해결할 수 있으면 Fork / Clone 후 다음과 같이 Branch를 만들어주세요:

  ```shell
  git checkout -b <issue number>
  ```

3. 코드를 작성하여 해당 Issue를 해결해주세요.

4. [Git Commit Message Convention](#commit) 규칙을 따르는 커밋 메시지를 사용하여 커밋해주세요.

5. 당신의 브랜치를 Github에 푸쉬해주세요.

6. Github에서 템플릿 컨벤션을 준수하여 Pull Request를 제출해주세요.

7. 만약 Pull Request가 승인이 되면 해당 Local Branch는 삭제해주세요.

### Pull Request 리뷰하기

당신이 해당 레파지토리의 관리자이면 다음 사항을 따라주세요:

1. 코드를 리뷰하여 Comment / Approve / Request changes 를 남깁니다.

2. 해당 PR이 최소 두 개의 Approve가 승인되면 머지를 할 수 있습니다.

3. [Github PR Merge Commit Message Convention](#merge-commit) 규칙을 따르는 커밋 메시지를 사용하여 머지해주세요.

4. 머지가 완료되면 해당 Remote Branch는 삭제해주세요.


## <a name="commit"></a> Git Commit Message Convention

### Commit Message Format

모든 커밋 메시지는 **제목**, **본문**, **꼬릿말** 영역으로 구성되며, 각 영역은 빈 줄로 분리됩니다.

```
<제목 | header>
<BLANK LINE>
<본문 | body>
<BLANK LINE>
<꼬릿말 | footer>
```

**제목**은 필수적이며, [Commit Message Header](#commit-header) 형식을 준수해야 합니다.

**본문**은 "docs" 유형의 커밋을 제외한 모든 커밋에 대해 필수 사항이며, [Commit Message Body](#commit-body) 형식을 준수해야 합니다.

**꼬릿말**은 선택적이며, [Commit Message Footer](#commit-footer) 형식을 준수해야 합니다.

#### <a name="commit-header"></a>Commit Message Header
```
<type>: <short summary> (#<issue number>)
  │       │               │
  │       │               └─⫸ Github Issue Number를 입력해주세요. 메인 브랜치인 경우 빼주세요.
  │       │
  │       └─⫸ 현재시제 및 소문자로 이루어진 영어로 요약해주세요. 끝에 마침표를 빼주세요.
  │
  └─⫸ Commit Type: feat|fix|chore|docs|style|refactor|test|merge
```

`<type>`과 `<summary>` 영역은 필수적이며, `(#<issue number>)` 영역은 선택적입니다.

##### Type
다음 중 하나여야 합니다:

* **feat**: 기능추가 / 새로운 로직
* **fix**: 버그 수정
* **chore**: 기타 변경사항 (빌드 스크립트 수정 등)
* **docs**: 문서 (문서 추가, 수정, 삭제)
* **style**: 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
* **refactor**: 리팩토링 / 이해하기 쉬운 구조로 변경하며 기능의 변경은 없다.
* **test**: 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
* **merge**:  머지, 충돌

##### Summary

변경 사항에 대한 간략한 설명을 제공합니다.

* 명령형 현재 시제 영어를 사용합니다.
* 첫 글자를 대문자로 쓰지 마세요.
* 끝에는 마침표 (.)가 없습니다.

#### <a name="commit-body"></a>Commit Message Body

어떻게 변경했는지 보다 무엇을 변경했는지 또는 왜 변경했는지를 최대한 상세히 설명합니다.

* 언어 상관없이 현재 시제를 사용합니다.
* 한 줄 당 72자 내로 작성합니다.
* 여러 줄의 메시지를 작성할 땐 "-"로 구분

#### <a name="commit-footer"></a>Commit Message Footer

현재 커밋과 관련된 이슈 번호가 있는 경우 작성합니다.

* `유형: #이슈번호` 형식으로 사용합니다.
* 이슈 트래커 유형은 다음 중 하나를 사용합니다:
    * **Fixes**: 이슈 수정중 (아직 해결되지 않은 경우)
    * **Resolves**: 이슈를 해결했을 때 사용
    * **Ref**: 참고할 이슈가 있을 때 사용
    * **Related to**: 해당 커밋에 관련된 이슈번호 (아직 해결되지 않은 경우)

#### 예시

```
feat: add snapkit library (#1)

UI Layout를 손쉽게 관리하기 위해 Snapkit 라이브러리를 추가합니다.

Related to: #1
```

## <a name="merge-commit"></a> Github PR Merge Commit Message Convention

Pull Request를 머지하는 경우 커밋 메시지에 다음와 같이 작성합니다.

```
Fix #<issue number>
PR Close #<PR number>
```
