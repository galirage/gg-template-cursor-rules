# コミット&プッシュ

## 概要

変更内容のコミットとプッシュを行います。

次の手順に従って作業を進め、不明点があればユーザーへ質問する。
作業後にチェックリストを参照し、すべての項目が完了していることを確認する。

## 用途

完了した実装を、規約に沿った適切なコミットメッセージでコミットし、リモートリポジトリにプッシュする際に使用します。

## 手順

### 1. 品質チェックを実行
- プロジェクトのRulesで定義されている品質チェックツールを実行する
  - フォーマットチェック
  - リンターチェック
  - 型チェック
  - テスト実行
- すべてパスすることを確認する

> **参考**: 各言語の品質チェック方法は以下を参照
> - バックエンド: `.cursor/rules/coding-rules/01-backend/03-python-quality-check.mdc`

### 2. 変更内容を確認
- 変更されたファイルを確認する
- 差分を確認する

```bash
git status
git diff
```

### 3. 変更をステージング
- 変更されたファイルを1つ1つ確認する
- コミットに含めるべきファイルのみを個別にステージングする

```bash
# 各ファイルを個別に追加
git add <file-path>
```

### 4. コミットメッセージを作成してコミット
- Conventional Commits形式に従ってコミットメッセージを作成する
- コミットする

```bash
git commit -m "<type>[optional scope]: <description>"
```

> **参考**: Conventional Commits形式の詳細は以下を参照
> - `.cursor/rules/workflow-rules/git-commit-rule.mdc`

### 5. リモートにプッシュ
- 変更をリモートリポジトリにプッシュする

```bash
git push origin <branch-name>

# 初回
git push -u origin <branch-name>
```

## チェックリスト

### 品質
- [ ] すべての品質チェックがパス

### コミット
- [ ] コミットメッセージがConventional Commits形式
- [ ] main/masterに直接プッシュしていない
