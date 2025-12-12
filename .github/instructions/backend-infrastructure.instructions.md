---
applyTo: "app/backend/src/infrastructure/**/*.py"
---

# インフラ層実装ルール

## 概要

インフラ層の実装ルールです。新しいリポジトリを実装する際は、このルールに従ってください。

> 注記: サンプルコードは文章量削減のためコメントを省略しています。実際の実装では `.github/instructions/backend.instructions.md` に従ってDocstring/インラインコメントを必ず記載してください。

## 1. ディレクトリ構造

### 例: userリポジトリ

```
infrastructure/
├─ __init__.py
├─ repository/
│  └─ user/
│     ├─ __init__.py
│     └─ postgresql_user_repository.py # PostgreSQLを使ったUserリポジトリ実装
└─ models/
   ├─ __init__.py
   └─ users.py # UserのDBモデル
```

### ルール

- 集約ごとに `repository/` 配下にディレクトリを作成する
- リポジトリ実装ファイル名は `{技術名}_{集約名}_repository.py`（例: `postgresql_user_repository.py`）
- 使用DB/ORM/技術名を接頭辞に含める（実装の特徴が分かるようにする）
- DB/ORMごとに実装を分離する
- ORMモデルとドメインモデルの変換はリポジトリ実装内で行う
- `models/` にはDBモデルを定義する

## 2. リポジトリクラスの実装

### 例: UserRepository実装（PostgreSQL）

```python
class PostgresqlUserRepository(UserRepository):
    async def find_by_id(self, user_id: UserId) -> User:
        user_model = await UserModel.select().where(UserModel.id == user_id.value).first()

        if user_model is None:
            raise ExpectedBusinessError(
                code=UserErrorCode.NotFound,
                details={"user_id": user_id.value},
            )

        # ORMモデルからドメインモデルへの変換
        return User(
            id=UserId(value=user_model.id),
            name=UserName(value=user_model.name),
            email=EmailAddress(value=user_model.email),
            role=Role(value=RoleEnum(user_model.role)),
            created_at=user_model.created_at,
        )

    async def save(self, user: User) -> User:
        try:
            # ドメインモデルからORMモデルへの変換
            await UserModel.insert(
                UserModel(
                    id=user.id.value,
                    email=user.email.value,
                    role=user.role.value.value,
                    name=user.name.value,
                    created_at=user.created_at,
                ),
            )
        except Exception as e:
            if "email" in str(e).lower():
                raise ExpectedBusinessError(
                    code=UserErrorCode.EmailAlreadyExists,
                    details={"email": user.email.value},
                ) from e
            raise
        return user
```

### 実装ルール

#### クラス設計

- クラス名は `{技術名}{集約名}Repository` の形式
- ドメイン層のリポジトリインターフェースを継承する
- すべてのメソッドを非同期で実装する（`async def`）
- すべての引数/戻り値に型ヒントを付与する

#### エラーハンドリング

- 削除/更新前は存在チェックを行う
- 制約エラーはビジネスエラーに分類する
- 例外チェーンを保持する（`raise ... from e`）
- エラーメッセージ等から適切なエラーコードを判定する

#### データ変換

- ORMモデル↔ドメインモデルの変換はリポジトリ実装内で行う
- 変換ロジックが複雑ならプライベートメソッドへ抽出する
- 型安全性を優先する

#### パフォーマンス

- 必要最小限のカラムのみ取得する
- 複雑なクエリは分割して実装する
- パフォーマンスを考慮したクエリ設計を行う
