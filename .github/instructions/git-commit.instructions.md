---
applyTo: "**"
---

# Git: コミットメッセージ

コミットメッセージはConventional Commitsに従って作成してください。

> 重要: コミットメッセージは日本語で記載する

## フォーマット

```
<type>[optional scope]: <description>
```

## scope（任意）

変更範囲を表すスコープを `()` で書けます。

```
例: feat(auth): ログインAPIを追加
```

## description

簡潔に「何をしたか」を日本語で書きます。

## よく使う type

- feat: 新機能
- fix: バグ修正
- docs: ドキュメント変更
- style: コードの意味に影響しない変更
- refactor: リファクタリング
- test: テスト追加/修正
- chore: ビルド/依存/設定など

## 実践例

```text
feat: ユーザーログインページを追加
fix: ユーザーサービスのnullポインタエラーを修正
docs: セットアップ手順をREADMEに追加
style: ruffでコードをフォーマット
test: ユーザー認証のテストケースを追加
chore: 依存関係を最新バージョンに更新
```

## BREAKING CHANGE

- typeに `!` を付ける

```
feat!: APIレスポンス形式を変更
```

- またはフッターに記載する

```
feat: 新しい認証システムを追加

BREAKING CHANGE: 既存の認証APIが削除されました
```

## よくある間違い

```text
# typeがない
ユーザーログイン機能を追加

# 英語で記載
feat: add user login feature

# コロンとスペースがない
feat:ユーザーログイン機能を追加

# typeが大文字
FEAT: ユーザーログイン機能を追加
```
