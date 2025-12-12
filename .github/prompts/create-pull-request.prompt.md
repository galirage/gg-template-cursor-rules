---
name: create-pull-request
description: PRテンプレートに沿ってPR本文を作る
argument-hint: "任意: 関連Issue番号/PRタイトル/PRの要点"
---

# PRを作成

PRテンプレート（`.github/pull_request_template.md`）に沿って、タイトルと本文を作成する。
不足情報（Issue番号、背景、動作確認手順など）があれば質問する。

## 手順

1. 前提を確認する
   - `develop` から派生した作業ブランチである
   - 変更はコミット済み/プッシュ済み
2. PRタイトルを作る
   - 形式: `<type>: <概要> (#<Issue番号>)`
3. PR本文を作る
   - 変更点を箇条書きで簡潔に
   - 本文に `- Closes #<issue番号>` を含める
4. 最後に、Assignee設定の要否を確認する

