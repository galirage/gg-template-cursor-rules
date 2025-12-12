---
applyTo: "app/backend/src/domain/**/*.py"
---

# ドメイン層実装ルール

## 概要

ドメイン層の実装ルールです。新しいドメインモデルを実装する際は、このルールに従ってください。

> 注記: サンプルコードは文章量削減のためコメントを省略しています。実際の実装では `.github/instructions/backend.instructions.md` に従ってDocstring/インラインコメントを必ず記載してください。

## 1. ディレクトリ構造

### 例: userドメイン

```
domain/
├─ __init__.py
└─ user/
   ├─ __init__.py
   ├─ user.py # Userエンティティ
   ├─ id.py # UserId値オブジェクト
   ├─ email_address.py # EmailAddress値オブジェクト
   ├─ name.py # UserName値オブジェクト
   ├─ role.py # Role値オブジェクト
   └─ repository.py # UserRepositoryインターフェース
```

### ルール

- 集約ごとにディレクトリを作成する
- エンティティは集約名と同じファイル名で作成する
- 値オブジェクトはそれぞれ独立したファイルとして作成する
- リポジトリインターフェースは1つの集約に1つだけ作成する

## 2. エンティティの実装

### 例: Userエンティティ

```python
from __future__ import annotations

@dataclass(eq=False, slots=True)
class User:
    email: EmailAddress
    name: UserName
    id: UserId = field(default_factory=lambda: UserId(value=str(uuid.uuid4())))
    role: Role = field(default_factory=lambda: Role())
    created_at: datetime = field(default_factory=lambda: datetime.now(UTC))
    updated_at: datetime = field(default_factory=lambda: datetime.now(UTC))

    def __eq__(self, other: object) -> bool:
        if self is other:
            return True
        if not isinstance(other, User):
            return NotImplemented
        return self.id == other.id

    def __hash__(self) -> int:
        return hash(self.id)

    @staticmethod
    def create_admin(email: str, name: str) -> User:
        if not email.endswith("@admin.company.com"):
            raise ValueError("管理者は@admin.company.comドメインのメールが必要です")

        return User(
            id=UserId.random(),
            email=EmailAddress(email),
            name=UserName(name),
            role=Role(value=RoleEnum.ADMIN),
        )

    @staticmethod
    def random() -> User:
        return User(
            id=UserId.random(),
            email=EmailAddress.random(),
            name=UserName.random(),
            role=Role(value=RoleEnum.MEMBER),
        )
```

### 実装ルール

- `@dataclass(eq=False, slots=True)` デコレータを使用する
- すべてのフィールドに型ヒントを付与する
- `__eq__()` / `__hash__()` を実装する（IDベース）
- `__post_init__()` でバリデーションを実装する
- IDはUUID v4を使用する
- 日時はUTCの `datetime` を使用する
- 動的なデフォルト値は `field(default_factory=...)` を使う
- テスト用の静的メソッド `random()` を実装する

### ファクトリーメソッドの実装ルール

- 生成時にビジネスルール/複雑な生成ロジックがある場合に実装する
- 命名は `create_` で始める
- 責務は「生成」に限定し、生成後の操作は含めない
- バリデーションエラーは `ValueError` とする

## 3. 値オブジェクトの実装

### 例: UserId

```python
from __future__ import annotations

@dataclass(frozen=True, slots=True)
class UserId:
    value: str = field(default_factory=lambda: str(uuid.uuid4()))

    def __post_init__(self) -> None:
        if not self.value:
            raise ValueError("user id is empty")

    @staticmethod
    def random() -> UserId:
        return UserId()
```

### 実装ルール

- `@dataclass(frozen=True, slots=True)` で不変性を保証する
- 実値は `value` に保持する
- `__post_init__()` でバリデーションを行う（`ValueError` / `TypeError`）
- テスト用の静的メソッド `random()` を実装する

## 4. リポジトリインターフェースの実装

### 例: UserRepository

```python
class UserRepository(ABC):
    @abstractmethod
    async def find_by_id(self, user_id: UserId) -> User:
        pass

    @abstractmethod
    async def find_by_email(self, email: EmailAddress) -> User:
        pass

    @abstractmethod
    async def save(self, user: User) -> User:
        pass
```

### 実装ルール

- `ABC` を継承して抽象基底クラスとして定義する
- メソッドは `@abstractmethod`
- 非同期メソッドとして定義する（`async def`）

## 5. Enumの実装

### 例: RoleEnum

```python
class RoleEnum(str, Enum):
    SUPERADMIN = "superadmin"
    ADMIN = "admin"
    MEMBER = "member"
```

### 実装ルール

- `str, Enum` を多重継承する
- Enum名は大文字スネークケース
- 値文字列は小文字
