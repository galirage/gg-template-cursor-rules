---
name: create-unit-test
description: 単体テストを設計して実装する
argument-hint: "必須: 対象ファイル/関数（任意: 追加したいテストケース）"
---

# 単体テスト作成

対象の単体テストコードを作成する。
テスト対象・前提条件・既存のテスト方針を確認し、不足情報があれば質問する。

## 手順

1. テスト対象（ファイル/クラス/関数）を特定する
2. テストケースを設計する
   - 正常系
   - 異常系
   - 境界値
3. テストを実装する
   - AAAパターン（`# arrange`, `# act`, `# assert`）
   - テスト名は日本語（`test_OK...`, `test_NG...`）
   - Docstringも日本語
4. テストを実行する（カバレッジ目安: 85%）

```bash
uv run --frozen pytest -v --tb=short --cov=src --cov-report=term
```

