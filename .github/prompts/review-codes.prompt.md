---
name: review-codes
description: 変更差分をレビューする（品質/セキュリティ/保守性）
argument-hint: "必須: レビュー対象（ブランチ名 or ファイル一覧）"
---

# コードレビュー

差分を確認し、品質・セキュリティ・保守性の観点でレビューする。
指摘は具体的な修正案まで含める。

## 手順

1. 変更差分を確認する

```bash
git fetch origin
git checkout <branch-name>
git diff origin/develop...HEAD
```

2. 必要に応じて品質チェックの実行手順を提示する（バックエンドは `.github/instructions/backend.instructions.md` を基準）
3. チェックリストで確認する
   - 機能性: エラーハンドリング、入力バリデーション
   - 品質: 命名、コメント/Docstring（日本語）、アーキテクチャ
   - セキュリティ: 入力検証、機微情報のログ出力なし
4. 指摘事項を重要度順にまとめる（必須/推奨/任意）
