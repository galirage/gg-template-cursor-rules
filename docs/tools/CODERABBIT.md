# CodeRabbit, CodeRabbit CLI ガイド

## 基本の動作

- PR 作成時およびコミット更新時に自動でレビューを実行
- 作業途中などレビューが不要なときは停止も可能

## レビューの種類と優先順位

CodeRabbit が検出する問題タイプ:

1. **potential_issue**: 必ず修正（セキュリティ、バグ、ロジックエラー）
2. **refactor**: 時間があれば修正（コード品質向上）
3. **style**: 必要に応じて修正（一貫性のため）

## 注意事項

- **レビュー時間**: 実際のコードレビューには 7〜30 分以上かかる場合があります
  - 小規模な変更（単一ファイルの軽微な修正）: 数秒〜数分
  - 大規模な変更（複数ファイル、リファクタリング）: 7〜30 分以上
  - `docs/scripts/coderabbit-test.sh` は小規模変更の動作確認用（30 秒以下を目安）

## レビューコマンド

### Incremental Review

```
@coderabbitai review
```

- 新規の変更差分のみを対象にレビューを実行
- 自動レビューが無効化されているとき、または直近の修正に対して追加フィードバックが欲しいときに使用

### Full Review

```
@coderabbitai full review
```

- PR 全体をゼロから再分析してレビューコメントを生成
- 既存コメントは参照せず完全に新しい評価を行う
- 大規模変更時や全体の品質を見直したいときに最適

### 自動レビューの停止

```
@coderabbitai pause
```

- 自動レビューを一時停止する
- 作業初期の WIP 状態に有効

### 自動レビューの再開

```
@coderabbitai resume
```

- 一時停止していたレビューを再開する

## CodeRabbit CLI

### セットアップ

1. **CodeRabbit CLI のインストール（完了済み）**

```bash
curl -fsSL https://cli.coderabbit.ai/install.sh | sh
```

2. **認証**

```bash
coderabbit auth login
```

ブラウザで GitHub アカウントでログインし、トークンを CLI に貼り付けます。

3. **Cursor Rules の確認**

`.cursor/rules/coderabbit-cli.mdc` ファイルに CodeRabbit CLI の使用方法が記載されています。

### 基本的な使い方

> **Note**: このプロジェクトでは、統一性のため `--prompt-only` と `-t` の短縮形式を推奨しています。

### 手動レビュー

```bash
# 未コミット変更をレビュー（推奨形式）
coderabbit --prompt-only -t uncommitted

# コミット済み変更をレビュー
coderabbit --plain -t committed --base-commit HEAD~5

# ヘルプ表示
coderabbit --help
```

### 注意事項

- 同じ変更セットに対して最大 3 回までレビューを実行とする
- レート制限: 無料プラン（1 回/時）、Pro プラン（5 回/時）

### 関連

- Cursor との統合ガイド: [CodeRabbit CLI + Cursor 統合ガイド](docs/tools/CODERABBIT_CURSOR_INTEGRATION.md)
