---
applyTo: "app/backend/**/*.py"
---

# ログ実装ガイドライン

## 基本方針

- `print()` は使用しない
- `src/log/logger.py` の構造化ログを使用する

## 使い方

```python
from src.log.logger import logger
```

## ログレベルの使い分け（例）

```python
logger.debug("処理開始", user_id=user.id.value)
logger.info("ユーザー作成完了", user_id=user.id.value, email=user.email.value)
logger.warning("テーブルクリーンアップ失敗", table_name="users", error=str(e))
logger.error("ユーザー保存エラー", user_id=user.id.value, error=str(e))
```

## ログレベル

- DEBUG: 開発時の詳細情報
- INFO: 正常な処理フロー/想定内エラー
- WARNING: 確認が必要な警告
- ERROR: 即座に対応が必要なエラー

## 禁止事項

```python
# NG
print(f"警告: テーブル {table_name} のクリーンアップ失敗: {e}")
```
