---
name: commit-and-push
description: 品質チェック→コミット→プッシュを進める
argument-hint: "任意: コミットメッセージ（未指定なら候補を提示）"
---

# コミット&プッシュ

変更内容を確認し、品質チェックを通し、Conventional Commitsでコミットしてプッシュする。
不明点があれば質問し、ユーザーの合意を取って進める。

## 手順

1. 品質チェックを実行する（バックエンドは `.github/instructions/backend.instructions.md` のコマンドを基準）
2. 変更内容を確認する
   - `git status`
   - `git diff`
3. 変更をファイル単位でステージングする（必要なものだけ `git add <file-path>`）
4. コミットする
   - 形式は `.github/instructions/git-commit.instructions.md` に従う
   - コミットメッセージが未指定なら候補を提示し、確定してから実行する

```bash
git commit -m "<type>[optional scope]: <description>"
```

5. リモートへプッシュする（`main/master` へ直接プッシュしない）

```bash
git push origin <branch-name>
# 初回
git push -u origin <branch-name>
```

## チェックリスト

- [ ] 整形/静的解析/型チェック/テストがパスしている
- [ ] コミットメッセージがConventional Commits形式（日本語）
- [ ] `main/master` に直接プッシュしていない
