---
applyTo: "app/backend/tests/**/*.py"
---

# バックエンドテスト実装ルール

## 概要

バックエンドにおけるテストコード実装のガイドラインです。

## 1. 単体テスト実装ルール

### 1.1 基本方針

- カバレッジ目標: 85%
- テストツール: pytest
- 非同期テストは `asyncio` ではなく `anyio` を使用する
- 新機能には必ずテストを追加する
- バグ修正時は再発防止テストを追加する

### 1.2 対象とスコープ

#### テスト対象

```text
# ドメイン層（最重要）
domain/
└── user/
    ├── user.py          # 必須(Entity)
    ├── id.py            # 必須(ValueObject)
    ├── email_address.py # 必須(ValueObject)
    └── repository.py    # 単体テスト対象外（結合テストで検証）

# ユースケース層（重要）
usecase/
└── user/
    ├── save_user_usecase.py  # 必須
    └── find_user_usecase.py  # 必須
```

#### テスト除外対象

```text
# インフラ層（統合テストで検証）
infrastructure/
└── repository/ # 単体テスト対象外

# プレゼンテーション層（契約テストで検証）
presentation/
└── api/ # 単体テスト対象外
```

### 1.3 実装ルール

- AAAパターンに従う（`# arrange`, `# act`, `# assert`）
- テスト名は日本語で命名する
  - 正常系: `test_OK` / `test_OK_内容`
  - 異常系: `test_NG_内容`
- 各関数ごとに `class Test{関数名}` でグルーピングする
- 複数パターンの検証は `pytest.mark.parametrize` を使用する

### 1.4 実装例

#### ドメインモデルの単体テスト例

```python
class TestInit:
    def test_OK_生成できること(self) -> None:
        # arrange
        user_id = UserId()
        email = EmailAddress.random()
        role = Role()
        name = UserName.random()

        # act
        user = User(
            id=user_id,
            email=email,
            role=role,
            name=name,
        )

        # assert
        assert isinstance(user, User)
```

#### 値オブジェクトの単体テスト例（parametrize）

```python
import pytest

class TestInit:
    @pytest.mark.parametrize(
        ("email_address"),
        [
            pytest.param("", id="空文字"),
            pytest.param("invalid-email", id="@以降が空"),
            pytest.param("@example.com", id="ローカルパートが空"),
        ],
    )
    def test_NG_フォーマットが不正な場合はValueErrorが投げられること(
        self,
        email_address: str,
    ) -> None:
        # act & assert
        with pytest.raises(ValueError):
            EmailAddress(email_address)
```

#### ユースケースの単体テスト例（anyio）

```python
from unittest.mock import AsyncMock

import pytest

@pytest.fixture
def mock_user_repository() -> AsyncMock:
    return AsyncMock(spec=UserRepository)

class TestExecute:
    @pytest.mark.anyio
    async def test_OK(self, mock_user_repository: AsyncMock) -> None:
        # arrange
        mock_user_repository.find_by_id.return_value = test_user
        usecase = FindUserUseCase(user_repository=mock_user_repository)
        request = FindUserRequest(user_id=test_user.id.value)

        # act
        result = await usecase.execute(request)

        # assert
        assert result == test_user
```

### 1.5 実行コマンド

```bash
uv run --frozen pytest -v --tb=short --cov=src --cov-report=term
```

## 2. 契約テスト実装ルール

### 2.1 基本方針

- 目的: APIの仕様（OpenAPI）に準拠していることを確認する
- 対象: REST API（FastAPI）
- 使用ツール: Schemathesis（OpenAPIスキーマ駆動）

### 2.2 実装例

```python
"""API契約テスト。

OpenAPIスキーマに基づくAPIコントラクトの検証を行う。
"""

import pytest
import schemathesis
from hypothesis import HealthCheck, settings
from schemathesis import Case

schemathesis.experimental.OPEN_API_3_1.enable()
schema = schemathesis.from_uri("http://localhost:8000/openapi.json")

@settings(
    deadline=10000,
    suppress_health_check=[HealthCheck.too_slow],
)
@schema.parametrize()
def test_api_contract_compliance(case: Case) -> None:
    response = case.call()
    case.validate_response(response)
```
