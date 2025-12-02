# CodeRabbit CLI + Cursor 統合ガイド

## 概要

CodeRabbit CLI と Cursor を統合することで、AI 駆動の自律的な開発ワークフローを実現できます。  
Cursor がコードを書き、CodeRabbit がレビューし、Cursor が問題を修正する、という一連の流れを自動化できます。

## 統合ワークフロー

### パターン 1: 新機能実装 + 自動レビュー

Cursor に以下のようなプロンプトを送信:

```text
新しいユーザー認証機能を実装してください。
実装後、coderabbit --prompt-only -t uncommitted を実行し、
必要な修正をすべて適用してください。
```

このプロンプトの構成要素:

1. **機能実装**: Cursor が機能をコーディング
2. **CodeRabbit 実行**: `--prompt-only` フラグで AI 最適化された出力
3. **未コミット変更レビュー**: `-t uncommitted` で現在の変更のみレビュー
4. **問題修正**: Cursor が CodeRabbit が特定した問題に対処

### パターン 2: 段階的な実装

```text
phase 7.3 の計画書を実装してから、
coderabbit --prompt-only -t uncommitted を実行し、
必要に応じて修正してください。
```

### パターン 3: 重大な問題のみ修正

```text
支払いWebhookハンドラーを実装してください。
その後、coderabbit --prompt-only -t uncommitted を実行し、
重大な問題のみ修正してください。細かい指摘は無視してください。
```

## 実行例

### 例 1: API 統合実装

```bash
# フィーチャーブランチ作成
git checkout -b feature/payment-webhooks

# Cursorで実装
```

Cursor プロンプト:

```text
仕様書から支払いWebhookハンドラーを実装してください。
その後、coderabbit --prompt-only -t uncommitted を実行し、
提案を確認してから重大な問題を修正してください。
細かい指摘は無視してください。
```

CodeRabbit が検出する問題例:

- 署名検証の欠如
- 支払い状態更新における競合状態
- ネットワーク障害に対する不十分なエラー処理
- Webhook リプレイ攻撃の脆弱性

Cursor が自動的に修正:

- HMAC 署名検証を追加
- 状態の整合性のためのデータベーストランザクションを実装
- 指数バックオフを使用した再試行ロジックを追加
- 冪等性キー処理を含める

## 最適化のヒント

### 1. prompt-only モードの使用

手動で CodeRabbit を実行する場合、AI 統合に最適な `--prompt-only` を使用:

```bash
coderabbit --prompt-only
```

このモードの利点:

- 簡潔な問題コンテキストを提供
- トークン効率的なフォーマット
- 特定のファイル位置と行番号を含む
- 詳細すぎない修正アプローチの提案

### 2. コードガイドライン機能の活用

CodeRabbit は自動的に `.cursorrules` および`.cursor/rules/*.mdc`ファイルを読み取ります。
以下の情報を追加できます:

> **参考**:
> https://docs.coderabbit.ai/changelog/enhanced-code-guidelines-support

## トラブルシューティング

### CodeRabbit が問題を検出しない場合

1. **認証状態を確認**:

   ```bash
   coderabbit auth status
   ```

2. **Git ステータスを確認**:

   ```bash
   git status
   ```

   CodeRabbit は追跡された変更を分析します。

3. **レビュータイプを指定**:

   ```bash
   # 未コミット変更のみ
   coderabbit --type uncommitted

   # コミット済み変更のみ
   coderabbit --type committed

   # 両方（デフォルト）
   coderabbit --type all
   ```

4. **ベースブランチを指定**:
   ```bash
   coderabbit --base develop
   coderabbit --base master
   ```

### レビュー時間の管理

CodeRabbit のレビューは 7〜30 分以上かかる場合があります:

1. **バックグラウンド実行を確保**:
   Cursor がバックグラウンドで実行するように設定

2. **小さな変更セットをレビュー**:

   - `--type uncommitted` で未コミット変更のみをレビュー
   - main と比較して小さなフィーチャーブランチで作業
   - 大きな機能を小さなレビュー可能なチャンクに分割

3. **diff スコープの設定**:
   - `--base develop` でコンパリゾンポイントを設定
   - フォーカスされたフィーチャーブランチで作業

## 実践的な Cursor プロンプト例

### 例 1: 新機能実装 + レビュー + 修正

```text
新しいログ保存機能を実装してください。
実装が完了したら、以下を実行してください:
1. coderabbit --prompt-only -t uncommitted を実行
2. レビュー結果を分析
3. 重大な問題（potential_issue）をすべて修正
4. リファクタリング提案は無視して構いません
5. 修正完了後、もう一度CodeRabbitを実行して確認
```

### 例 2: バグ修正 + レビュー

```text
issue #123 のメモリリークを修正してください。
修正後、coderabbit --prompt-only -t uncommitted を実行し、
修正が他の問題を引き起こしていないか確認してください。
```

### 例 3: リファクタリング

```text
src/domain/base.py のリファクタリングを行ってください。
完了後、coderabbit --prompt-only -t uncommitted を実行し、
すべての提案を確認して重大な問題を修正してください。
最大3回までレビューと修正のループを実行してください。
```

## ベストプラクティス

1. **レビュー回数の制限**

   - 同じ変更セットに対して最大 3 回までレビューを実行
   - 無限ループを避ける

2. **問題の優先順位付け**

   - `potential_issue`: 必ず修正
   - `refactor`: 時間があれば修正
   - `style`: 必要に応じて修正

3. **段階的な実装**

   - 大きな機能を小さなステップに分割
   - 各ステップでレビューと修正を実行

4. **コンテキストの提供**
   - `.cursorrules` にプロジェクト固有の規約を記載
   - `cursor.md` に詳細なアーキテクチャ情報を記載（Pro 機能）

## まとめ

CodeRabbit CLI + Cursor の統合により:

- ✅ AI 駆動の自律的な開発ワークフロー
- ✅ コミット前の包括的なコードレビュー
- ✅ 自動的な問題修正
- ✅ 品質の高いコードの継続的な生成

この統合は、既存の pre-commit フック（Ruff、Pytest 等）と併用することで、
多層的なコード品質保証を実現します。
