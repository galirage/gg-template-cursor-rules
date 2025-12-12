# GitHub Copilot: リポジトリ指示

このリポジトリは、社内配布用の Cursor / GitHub Copilot 向けルール・プロンプト集です。

## 重要

- 返答は日本語で行う
- コード内のコメント/Docstringは日本語で記載する
- 変更は最小限にする（無関係なリファクタや仕様変更はしない）

## ルールの参照先

- リポジトリ全体の前提はこのファイルに集約する
- 実装ルールは `.github/instructions/*.instructions.md` に分割してある（対象パスに合うものが適用される）
- 再利用プロンプトは `.github/prompts/*.prompt.md` にある

## 前提（バックエンド）

- 技術: Python 3.12–3.13 / FastAPI / Pydantic / uv
- アーキテクチャ: オニオンアーキテクチャ（詳細は `.github/instructions/backend.instructions.md` と各レイヤの指示）

## 品質チェック（バックエンド）

変更後・コミット前は以下を基準に実行する（詳細は `.github/instructions/backend.instructions.md`）。

```bash
uv run ruff format --check .
uv run ruff check . --fix
uv run pyright .
uv run --frozen pytest -v --tb=short --cov=src --cov-report=term
```

