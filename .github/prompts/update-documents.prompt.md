---
name: update-documents
description: 実装に合わせてドキュメントを更新する
argument-hint: "必須: 更新対象ドキュメント（例: README.md）"
---

# ドキュメント更新

直近の実装変更とドキュメントの差分を確認し、整合するように更新する。
不足情報（変更範囲、対象ブランチ等）があれば質問する。

## 手順

1. 直近の変更内容を把握する（差分/コミットログなど）

```bash
git fetch origin
git checkout <branch-name>
git diff origin/develop...HEAD
```

2. ドキュメントとの差分を洗い出す（`/docs` や `README.md` など）
3. ドキュメントを更新する
   - 実装と一致させる
   - 用語/表記を統一する
   - 日本語で記載する
4. 更新内容を要約し、更新箇所の一覧を出す
