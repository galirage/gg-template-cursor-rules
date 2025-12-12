---
applyTo: "app/backend/src/usecase/**/*.py"
---

# ユースケース層実装ルール

## 概要

ユースケース層の実装ルールです。新しいユースケースを実装する際は、このルールに従ってください。

> 注記: サンプルコードは文章量削減のためコメントを省略しています。実際の実装では `.github/instructions/backend.instructions.md` に従ってDocstring/インラインコメントを必ず記載してください。

## 1. ディレクトリ構造

### 例: userユースケース

```
usecase/
├─ __init__.py
└─ user/
   ├─ __init__.py
   ├─ create_user_usecase.py # ユーザー作成
   ├─ delete_user_usecase.py # ユーザー削除
   └─ ...
```

### ルール

- 集約ごとにディレクトリを作成する
- 各ユースケースは独立したファイルとして実装する
- ファイル名は `{操作名}_usecase.py` の形式とする

## 2. ユースケースクラスの実装

### 例: DeleteUserUseCase

```python
class DeleteUserUseCase:
    def __init__(
        self,
        user_repository: UserRepository,
    ) -> None:
        self.user_repository = user_repository

    async def execute(
        self,
        request: DeleteUserRequest,
    ) -> None:
        try:
            user = await self.user_repository.find_by_id(UserId(value=request.user_id))
            await self.user_repository.delete(user_id=user.id)
        except (ExpectedBusinessError, ExpectedTechnicalError) as e:
            logger.info(
                "ユーザー削除に失敗しました",
                raw_message=e.raw_message,
                details=e.details,
            )
            raise ExpectedUseCaseError(code=e.code, details=e.details) from e

    @staticmethod
    def is_allowed(current_user: User) -> bool:
        return current_user.role.value in {
            RoleEnum.SUPERADMIN,
            RoleEnum.ADMIN,
        }
```

### 実装ルール

- クラス名は `{操作名}UseCase` の形式
- `__init__` で依存注入する
- `execute` でアプリケーションロジックを実装する
- I/O操作を効率的に処理するため、非同期メソッドとして定義する（`async def`）
- リポジトリ層の想定内エラーをユースケース層のエラーへ変換する
- 想定内エラーのログは `logger.info` を使用し、構造化ログで情報を残す
- 例外チェーンを保持する（`raise ... from e`）
