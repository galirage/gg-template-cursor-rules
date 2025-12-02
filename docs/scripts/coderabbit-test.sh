#!/bin/bash
# CodeRabbit CLI テストスクリプト
# pre-commitフックとしての実用性テスト

set -e

echo "=== CodeRabbit CLI 動作テスト ==="
echo ""

# 認証状態確認
echo "1. 認証状態確認..."
coderabbit auth status | grep -q "Logged in" && echo "✅ ログイン済み" || (echo "❌ ログインが必要です" && exit 1)
echo ""

# 実行時間測定
echo "2. レビュー実行時間測定..."
START_TIME=$(date +%s)

coderabbit review --plain --type uncommitted

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "⏱️  実行時間: ${DURATION}秒"
echo ""

# 判定
if [ $DURATION -gt 60 ]; then
    echo "❌ 実行時間が60秒を超えています（${DURATION}秒）"
    echo "   pre-commitフックとしては長すぎます"
    exit 1
elif [ $DURATION -gt 30 ]; then
    echo "⚠️  実行時間が30秒を超えています（${DURATION}秒）"
    echo "   pre-commitフックとしては遅いですが、使用可能かもしれません"
else
    echo "✅ 実行時間は許容範囲内です（${DURATION}秒）"
fi

echo ""
echo "=== テスト完了 ==="

