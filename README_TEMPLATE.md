# Project Title

<!-- ※ 実際のプロジェクトタイトルに変更してください -->

---

## Overview

<!-- ※ プロジェクトの概要・背景・目的を簡潔に説明してください -->

例：
教育現場での学習教材管理を効率化を目的として開発された Web アプリケーションです。  
このリポジトリでは、バックエンド及びフロントエンド実装・環境構築・開発ルールを管理します。

---

## Tech Stack

<!-- 主要な技術スタックとその用途を明示してください -->

例：
| Category | Technology |
| --------- | --------------------- |
| Language | TypeScript |
| Framework | Next.js 15 |
| Styling | Tailwind CSS |
| Database | Prisma + PostgreSQL |
| Others | ESLint, Prettier, Bun |

---

## Features

<!-- ※ 本アプリケーションの主な機能を簡潔に説明してください -->

例：

- ユーザー認証（NextAuth 対応）
- AI 検索機能（OpenAI API 使用）
- ダッシュボード分析
- Markdown エディタ付き教材管理
- モバイル対応 UI

---

## Setup

ローカル環境で動作確認するための手順を記載します。

```bash
# Clone repository
git clone https://github.com/your-org/your-repo.git

# Move into directory
cd your-repo

# Install dependencies
bun install

# Setup environment variables
cp .env.example .env

# Run local server
bun run dev
```

---

## Usage

1. ブラウザで `http://localhost:3000` を開く
2. ログインし、教材を登録
3. 「AI 検索」タブから教材を検索

デモ URL: [https://your-demo-link.vercel.app](https://your-demo-link.vercel.app)

---

## Directory Structure

```bash
project/
├── src/
│   ├── components/
│   ├── hooks/
│   ├── pages/
│   └── utils/
├── prisma/
│   └── schema.prisma
├── docs/
│   ├── setup.md
│   ├── usage.md
│   ├── contributing.md
│   └── images/
│       ├── setup.png
│       └── usage.png
└── README.md
```

---

## Development Guide

### Coding Guidelines

コーディング規約に関する詳細:
[docs/development/base-coding-rule.md](docs/development/base-coding-rule.md)

### Code Quality

- Formatter: Prettier
- Linter: ESLint
- Type Check: `bun run typecheck`

### Test

```bash
bun test
```

詳細: [docs/test.md](docs/test.md)

---

## Git Rules

詳細ルール: [docs/development/git-guidelines.md](docs/development/git-guidelines.md)

---

## API / Routing

詳細ドキュメント: [docs/development/api-reference.md](docs/development/api-reference.md)

---

## Links

<!-- 関連ドキュメント・外部リソースをまとめてください -->

- [xxx](xxx)
