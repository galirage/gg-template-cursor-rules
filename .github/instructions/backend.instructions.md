---
applyTo: "app/backend/**/*.py,app/backend/**/*.toml"
---

# バックエンド (FastAPI)

## 技術スタック

| 技術 | バージョン |
|------|------------|
| Python | 3.12–3.13 |
| uv | ~=0.8.0 |
| FastAPI | ~=0.118.0 |
| Pydantic | ~=2.11.0 |
| pytest | ~=8.4.0 |
| httpx | ~=0.28.0 |
| pytest-cov | ~=7.0.0 |
| pyright | ~=1.1.0 |
| ruff | ~=0.13.0 |

正確なバージョンと採用パッケージは `app/backend/pyproject.toml` を優先します。

## ソフトウェアアーキテクチャ

バックエンドのアーキテクチャは**オニオンアーキテクチャ**を採用します。  
※ 分かりやすさのため **Application/Service** を **UseCase** と呼びます。

### レイヤー構成

```
┌──────────────────────┐
│ Presentation Layer   │← APIエンドポイント
├──────────────────────┤
│ UseCase Layer        │← アプリケーションロジック
├──────────────────────┤
│ Domain Layer         │← ドメインモデル
├──────────────────────┤
│ Infrastructure Layer │← DB/外部API等へのアクセス
└──────────────────────┘
```

## ディレクトリ構造（例）

```
app/backend/src/
├── domain/                       # ドメイン層（外部に依存しない）
│   └── user/                     # ユーザー集約
│       ├── user.py               # エンティティ
│       ├── id.py                 # 値オブジェクト
│       ├── email_address.py      # 値オブジェクト
│       ├── name.py               # 値オブジェクト
│       ├── role.py               # 値オブジェクト
│       └── repository.py         # リポジトリインターフェース
├── usecase/                      # ユースケース層（アプリケーションサービス）
│   └── user/
│       ├── create_user_usecase.py  # ユースケース
│       ├── delete_user_usecase.py  # ユースケース
│       ├── find_user_usecase.py    # ユースケース
│       └── ...
├── infrastructure/               # インフラ層（外部I/Oの具体実装）
│   ├── repository/               # リポジトリ実装
│   │   └── user/
│   │       └── postgresql_user_repository.py
│   └── models/                   # DBモデル
│       └── users.py
├── presentation/                 # プレゼンテーション層（外界との接点）
│   └── api/                      # FastAPIルータ/ハンドラ
│       ├── routes/               # APIRouterによるエンドポイント定義
│       │   ├── route.py          # メインルータ
│       │   └── user.py           # ユーザールータ
│       └── schema/               # I/O DTO（Pydantic BaseModel）
│           ├── error_response.py # エラーレスポンススキーマ
│           └── user/             # ユーザー関連スキーマ
│               ├── create_user_request.py
│               ├── create_user_response.py
│               ├── find_user_request.py
│               ├── delete_user_request.py
│               ├── ...
│               └── user.py
└── main.py                       # アプリケーションエントリポイント（FastAPI起動）
```

## DDDに基づく構造ルール

### ドメイン層（`app/backend/src/domain/`）

- 責務: ビジネスルールの実装、ドメイン知識の表現
- 配置するもの: エンティティ、値オブジェクト、ドメインイベント、ドメインサービス、抽象リポジトリ
- 制約: I/O処理禁止、フレームワークや外部ライブラリへの依存を最小化

### ユースケース層（`app/backend/src/usecase/`）

- 責務: ユースケースの調停（トランザクション境界、ドメイン呼び出し、整合性担保）
- 配置するもの: ユースケースクラス
- 制約: ドメインの抽象インターフェースにのみ依存する。HTTP変換やシリアライズは扱わない（プレゼンテーション層へ委譲）

### インフラ層（`app/backend/src/infrastructure/`）

- 責務: 抽象インターフェースの具体実装、外部システム連携
- 配置するもの: ORMモデル、外部APIクライアント、リポジトリ実装、マイグレーション補助
- 制約: 外部サービス仕様変更をこの層で吸収し、内側への影響を防ぐ

### プレゼンテーション層（`app/backend/src/presentation/`）

- 責務: HTTP API提供、ユースケース呼び出し、レスポンス整形
- 配置するもの: FastAPIルータ、Request/Responseスキーマ（Pydantic）、依存注入の構成
- 制約: ビジネスロジックは持たず、入出力変換・認可チェック・例外変換に限定する

## 共通ルール

### 依存関係の原則

- 上位層は下位層に依存するが、逆は不可
- 内側の層は抽象インターフェースにのみ依存する（DIP）

### 各層の責務遵守

- 各層の責務を逸脱しない
- ユビキタス言語に基づいた命名を使用する
- 境界の明確化: DTOとドメインオブジェクトを混在させない

## 参照（詳細ルール）

各レイヤの詳細ルールは以下を参照してください。

- ドメイン: `.github/instructions/backend-domain.instructions.md`
- ユースケース: `.github/instructions/backend-usecase.instructions.md`
- インフラ: `.github/instructions/backend-infrastructure.instructions.md`
- プレゼンテーション: `.github/instructions/backend-presentation.instructions.md`
- テスト: `.github/instructions/backend-tests.instructions.md`
- エラー処理: `.github/instructions/backend-error-handling.instructions.md`
- ログ: `.github/instructions/backend-logging.instructions.md`

## セットアップ（例）

必須ツール（例）: Python / uv / Git

```bash
cd app/backend
uv sync
uv run uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

- APIドキュメント: `http://localhost:8000/docs`
- ヘルスチェック: `curl http://localhost:8000/api/healthz`

## 品質保証（変更時・コミット前）

```bash
uv run ruff format --check .
uv run ruff check . --fix
uv run pyright .
uv run --frozen pytest -v --tb=short --cov=src --cov-report=term
```

- 自動修正後は、必ずテストを実行して動作確認する
- `ruff.toml` の `ignore` 追加でルールを無効化する場合は、事前合意がない限り行わない

## Python コーディングスタイル

### 命名

- 変数・関数: `snake_case`
- クラス: `PascalCase`
- 定数: `ALL_CAPS_WITH_UNDERSCORES`
- プライベート: 先頭に `_`

### 型ヒント

- すべての関数に引数と戻り値の型を付与する
- Python 3.12+ の構文を使用する

### Docstring（Google形式・日本語）

```python
"""ユーザー検索ユースケース。

IDでユーザーを検索するビジネスロジックを実装する。
"""
```

```python
def random(role: Role | None = None) -> User:
    """テスト用のランダムなユーザーを生成する。

    Args:
        role (Role | None): 指定するロール（Noneの場合はデフォルト）

    Returns:
        User: ランダムなユーザー
    """
```

### インラインコメント（日本語）

- 「なぜそうするか」を書く
- 処理内容をそのままなぞるコメントは書かない
