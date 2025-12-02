# PR を作成

## 概要

- このコマンドは、GitHub で Pull Request を作成するワークフローです。
- PR テンプレートを使用し、適切なタイトル・説明・チェック項目を記載して PR を作成します。

## ルール

- PR 作成時の基本ルール（`.cursor/rules/pr-rules.mdc`）を確認する。
- **マージ先ブランチ**: 特に指定がない場合は以下のルールでマージ先ブランチを決定する。
  - main から派生したブランチの場合: `main`
  - develop か派生したブランチの場合: `develop`
- 指示がない限り Draft で PR を作成し、PR タイトルの先頭に「[WIP]」を入れる。
- 作業後にチェックリストを参照し、すべての項目が完了していることを確認する。

## 手順

### 1. 前提確認

```bash
# 現在のブランチと状態を確認
git branch --show-current
git status
git log --oneline -5
```

- **作業ブランチで作業していることを確認する**
  - main/develop ブランチで直接作業している場合は、作業ブランチを作成する
  - 例: `git checkout -b refactor/cleanup-unused-code`
- すべての変更がコミットされ、プッシュされていることを確認する
- PR テンプレートの内容を確認する

### 2. 関連 Issue の確認

- **関連する Issue があるか、ユーザーに確認する**
- Issue がない場合でも PR 作成は可能（タイトルから Issue 番号を省略）

### 3. PR テンプレートの確認

- `.cursor/rules/pr-rules.mdc`に記載の PR テンプレートを確認し、記入すべき項目を把握する。

### 4. PR のタイトルを考える

- `.cursor/rules/pr-rules.mdc`に記載の命名規則に従って考える。

### 6. PR の本文を考える

- `.cursor/rules/pr-rules.mdc`に記載の PR テンプレートに従って記入する。

### 7. PR を作成する

- `.cursor/rules/pr-rules.mdc`に記載の PR 作成方法に従って作成する。

## チェックリスト

### 前提

- [ ] ユーザーにマージ先ブランチを確認済みである
- [ ] マージ先ブランチから派生した作業ブランチで作業している
- [ ] すべての変更がコミット済みである
- [ ] 作業ブランチの変更をリモートへ push 済みである

### PR 作成

- [ ] `.cursor/rules/pr-rules.mdc`に記載のルールに従っている
- [ ] `.cursor/rules/pr-rules.mdc`に記載の PR テンプレートを使用している

### 品質

- [ ] pre-commit hook が全てパスしている
- [ ] セルフレビューを行った
