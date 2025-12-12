---
applyTo: "app/backend/**/*.py"
---

# エラーハンドリングと例外処理

## エラーの分類

すべてのエラーは `BaseError` を継承し、以下の属性を持ちます。

- `code`: エラーコード（ErrorCode型）
- `raw_message`: 開発者向けの詳細メッセージ（任意）
- `details`: エラーの詳細情報（任意）

想定される種別（例）:

- ExpectedBusinessError（ビジネスロジックで想定）
- ExpectedTechnicalError（技術的な問題で想定）
- ExpectedUseCaseError（ユースケース層で想定）
- UnexpectedTechnicalError / UnexpectedBusinessError（予期しないエラー）

## エラーコード

- エラーコードはEnumで定義する
- Enumクラス名: `{ドメイン}ErrorCode`
- 値: 大文字スネークケース（例: `USER_NOT_FOUND`）

### 定義例（抜粋）

```python
class CommonErrorCode(str, Enum):
    """共通エラーコード"""

    Unauthorized = "UNAUTHORIZED"
    Forbidden = "FORBIDDEN"
    InvalidValue = "INVALID_VALUE"
    UnexpectedError = "UNEXPECTED_ERROR"
    ConfigurationError = "CONFIGURATION_ERROR"

class UserErrorCode(str, Enum):
    """ユーザー関連エラーコード"""

    NotFound = "USER_NOT_FOUND"
    EmailAlreadyExists = "EMAIL_ALREADY_EXISTS"
    InvalidLoginCredentials = "INVALID_LOGIN_CREDENTIALS"
```

## 実装パターン

- リポジトリ層: 想定内エラーはビジネス/技術エラーとして送出する
- ユースケース層: リポジトリ層の想定内エラーをユースケースエラーへ変換する
- ルーター層: ユースケースエラーをHTTPステータスへ変換する

### 1. リポジトリ層でのエラー処理（例）

```python
async def find_by_id(self, user_id: UserId) -> User:
    user = await UserModel.select().where(UserModel.id == user_id.value).first()

    if user is None:
        raise ExpectedBusinessError(
            code=UserErrorCode.NotFound,
            details={"user_id": user_id.value},
        )

    return self._to_domain_model(user)
```

### 2. ユースケース層でのエラー変換（例）

```python
async def execute(self, request: FindUserRequest) -> User:
    try:
        return await self._user_repository.find_by_id(request.user_id)
    except (ExpectedBusinessError, ExpectedTechnicalError) as e:
        logger.info(
            "ユーザー検索に失敗しました",
            raw_message=e.raw_message,
            details=e.details,
        )
        raise ExpectedUseCaseError(code=e.code, details=e.details) from e
```

### 3. ルーター層でのHTTPステータス変換（例）

```python
@router.get("/{user_id}")
async def find_user(
    user_id: UserId,
    user_repository: Annotated[UserRepository, Depends(get_user_repository)],
) -> UserResponse:
    try:
        user = await FindUserUseCase(user_repository).execute(FindUserRequest(user_id=user_id))
        return UserResponse.model_validate(user, from_attributes=True)
    except ExpectedUseCaseError as e:
        if e.code == UserErrorCode.NotFound:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=e.code.value,
            ) from e
        raise
```

## バリデーション

- Pydanticの `RequestValidationError` は422で返す
- ドメイン側のバリデーションは `__post_init__()` 等で行い、違反時は `ValueError` を送出する

### Pydanticバリデーションエラー（例）

```python
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
    request: Request,
    exc: RequestValidationError,
) -> JSONResponse:
    errors: dict[str, list[str]] = {}

    for error in exc.errors():
        field = ".".join(str(loc) for loc in error["loc"][1:])
        error_type = error["type"]

        if field not in errors:
            errors[field] = []
        errors[field].append(error_type)

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={"errors": errors},
    )
```

### カスタムバリデーション（例）

```python
@dataclass(frozen=True, slots=True)
class UserName:
    value: str

    def __post_init__(self) -> None:
        if len(self.value) < 1:
            raise ValueError(f"user name is less than 1 character, name: {self.value}")
        if len(self.value) > 255:
            raise ValueError(f"user name is greater than 255 characters, name: {self.value}")
```

## ログ出力

- `print()` は使用しない
- `src/log/logger.py` の構造化ログを使用する

```python
from src.log.logger import logger

logger.error(
    "ユーザーが見つかりません",
    user_id=user_id.value,
    error_code=UserErrorCode.NotFound.value,
    exc_info=True,
)
```

### ログレベル

- DEBUG: 開発時の詳細情報
- INFO: 正常な処理フローと想定内のエラー
- WARNING: 確認が必要な警告
- ERROR: 即座に対応が必要なエラー

## レスポンス形式（例）

成功:

```json
{ "id": "...", "email": "user@example.com", "name": "John Doe" }
```

エラー:

```json
{ "detail": "USER_NOT_FOUND" }
```

バリデーションエラー（422）:

```json
{
  "errors": {
    "name": ["string_too_short"],
    "email": ["invalid_email"]
  }
}
```
