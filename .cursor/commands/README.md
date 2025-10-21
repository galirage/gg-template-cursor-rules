# カスタムコマンド一覧

開発ワークフローを効率化するためのカスタムコマンド集です。

## コマンド一覧

| コマンド | 概要 |
|---------|------|
| `create-unit-test` | 単体テストコードを生成します |
| `review-codes` | コードレビューを実施します |
| `commit-and-push` | 変更内容のコミットとプッシュを行います |
| `create-pull-request` | PR（Pull Request）を作成します |
| `update-documents` | 関連ドキュメントを更新します |

---

## create-unit-test

**概要**: 単体テストコードを生成します

**用途**: 指定したコードに対する単体テストのコードを自動で作成したい場合に使用します

### 入力例

対象ファイルのみ指定する場合
```
@commands/create-unit-test

対象: src/domain/user/email_address.py
```

テストケースも指定する場合
```
@commands/create-unit-test

対象: src/usecase/user/create_user_usecase.py

テストケース:
- 正常にユーザーを作成できること
- メールアドレスが重複している場合にエラーが発生すること
```

### 期待されるアウトプット

テストファイルが作成され、実行コマンドが提示される

---

## review-codes

**概要**: コードレビューを実施します

**用途**: 品質、セキュリティ、保守性の観点からコードレビューをAIに依頼する際に使用します

### 入力例

レビュー対象を指定する場合
```
@commands/review-codes

以下のファイルをレビューしてください:
- src/usecase/user/create_user_usecase.py
- src/infrastructure/repository/user/postgresql_user_repository.py
```

### 期待されるアウトプット

チェックリストに基づいた改善提案がまとめられる

---

## commit-and-push

**概要**: 変更内容のコミットとプッシュを行います

**用途**: 完了した実装を、規約に沿った適切なコミットメッセージでコミットし、リモートリポジトリにプッシュする際に使用します

### 入力例

コミットメッセージの生成をAIエージェントに任せる場合
```
@commands/commit-and-push
```

コミットメッセージを指定する場合
```
@commands/commit-and-push

fix(auth): トークン検証ロジックのバグを修正
```

### 期待されるアウトプット

品質チェックが実行され、ファイルを個別に確認した上でコミット&プッシュが完了する

---

## create-pull-request

**概要**: PR（Pull Request）を作成します

**用途**: チームの規約に沿った適切なタイトル・説明を持つPRを作成する際に使用します

### 入力例

AIエージェントに任せる場合
```
@commands/create-pull-request

関連Issue: #42
```

詳細を指定する場合
```
@commands/create-pull-request

タイトル: feat: ユーザー作成APIを追加 (#42)
説明:
- Userエンティティを実装
- CreateUserUseCaseを実装
- POST /api/users エンドポイントを追加

関連Issue: #42
```

### 期待されるアウトプット

適切なタイトルと説明文を持つPRが作成される

---

## update-documents

**概要**: 関連ドキュメントを更新します

**用途**: 開発の最新バージョンに合わせて、関連するドキュメントを更新する際に使用します

### 入力例

対象を簡潔に指定する場合
```
@commands/update-documents

README.md を最新の実装に合わせて更新してください
```

### 期待されるアウトプット

実装とドキュメントの差分が表示され、更新される
