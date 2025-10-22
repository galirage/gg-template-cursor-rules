# AI-Driven Development Template Pack

---

## Overview

本リポジトリは、全エンジニアが効率的に AI 駆動開発を実践することを目的に、
CTO 室が**AI 駆動開発の標準基盤**として提供するテンプレートです。

プロジェクト開始時に必要なルール・ナレッジ・ガイドラインを体系的に整備し、
0→1 フェーズからチーム全体で一貫した AI 駆動開発を推進できるよう支援します。

- **プロジェクト知識と方針の統一**  
  AI 駆動開発における設計方針や運用ルールを共通化し、チーム全体のナレッジ共有を促進します。

- **AI コンテキスト定義のベース構築**  
  設計思想・コーディングスタイル・開発手順などを AI に継続的に伝えるための“初期設定テンプレート”として活用できます。

- **一貫したコード生成・ドキュメント生成の実現**  
  カスタムコマンドを通じて、Cursor などの AI エージェントがプロジェクト標準に沿った高品質なコードやドキュメントを生成します。

---

## Tech Stack

| Category        | Technology           |
| --------------- | -------------------- |
| AI Tool         | Cursor               |
| Rules Format    | Project Rules (.mdc) |
| Documentation   | Markdown             |
| Version Control | Git                  |

---

## Features

- **Cursor AI ルールベース**（`.cursor/rules/`）  
  AI エージェントが遵守すべき設計・実装ルールを定義するための雛形ファイル群。

- **カスタムコマンド定義**（`.cursor/commands/`）  
  チームや開発フェーズに応じた AI 操作を自動化するためのコマンドテンプレート。

- **開発ガイドラインテンプレート**（`docs/`）  
  チーム運用やスクラムルール、設計原則などを標準化するための初期ドキュメント。

- **ナレッジベース雛形**（`knowledge/`）  
  AI 駆動開発に関する実践知・運用知を体系的に蓄積するためのフォルダ構成。

---

## Directory Structure

```bash
gg-template-cursor-rules/
├── .cursor/
│   ├── commands/          # Cursor AI カスタムコマンド
│   └── rules/             # Cursor AI ルール設定
├── .github/
│   ├── ISSUE_TEMPLATE/    # Issue作成時のテンプレート
│   ├── PR_TEMPLATE/       # Pull Request作成時のテンプレート
│   └── PR_TEMPLATE/       # GitHub Actions ワークフロー
├── docs/
│   ├── development/       # 開発ガイドライン
│   ├── scrum-rules/       # スクラム関連ルール
│   ├── team/              # チーム運営関連ドキュメント
│   └── templates/         # 汎用テンプレート
├── flow/                  # プロジェクトフロー管理
├── knowledge/             # ナレッジベース
├── project-config.yaml    # プロジェクト設定ファイル
└── README.md
```

---

## Setup

```bash
# Clone repository to local
git clone https://github.com/galirage/gg-template-cursor-rules.git

# Move into directory
cd gg-template-cursor-rules
```

---

## Usage

本テンプレートは、以下の 2 パターンで利用できます。

- **新規プロジェクト作成時**：本リポジトリをクローン後、開発環境を構築およびテンプレート内容を調整
- **既存プロジェクト導入時**：必要な構成要素のみ導入し、段階的にルールを追加

いずれの場合も、プロジェクト要件に応じて各種ファイルを調整してください。

---

## Git Rules

本リポジトリでは以下の Git 運用ルールを採用しています。

- main ブランチから chore ブランチを作成
- ブランチ名は `{issue-number}_{subject}` の形式で命名
- CTO 室メンバーによるレビューを経て main へマージ

---

## Contributing

改善提案や修正を歓迎します。以下の手順で PR をお送りください。

1. Fork してブランチを作成
2. 新しいブランチを作成して修正を加える
3. PR を作成し、CODEOWNERS に従ってレビュー依頼

詳細: [docs/contributing.md](docs/contributing.md)

---

## Links

- [Cursor 公式ドキュメント](https://cursor.sh/docs)
- [AI 駆動開発ガイドライン](knowledge/ai-driven-development/)
