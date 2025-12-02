# Cursor MCP ガイド

## 概要

Model Context Protocol (MCP) は、Cursor を外部ツールやデータソースに接続するためのプロトコルです。  
MCP サーバーを設定することで、AI アシスタントが外部システムやデータに直接アクセスできるようになります。

## セットアップ

- `.cursor/mcp.example.json` を複製し、`.cursor/mcp.json` にリネームして使用してください。
- 環境変数参照は現在うまく機能しないため、API キーが必要な MCP は `.cursor/mcp.json` に直接値を記述してください。
- `.cursor/mcp.json` は `.gitignore` 対象にしています。

## Context7

- ライブラリやフレームワークの最新ドキュメント検索
- コードサンプル取得に便利
- API キー不要

### プロンプトサンプル:

```text
Context7 で Flutter の公式ドキュメントから、ListView.builder のシンプルなサンプルコードを探して、この画面用に少しアレンジしてください。
```

```text
Dart の extension メソッドの使い方について、Context7 で分かりやすいコード例付きで教えてください。
```

```text
Context7 を使って、Next.js App Router で動的ルーティングを実装するサンプルコードを探してください。
このプロジェクトの構成に合うように書き直してください。
```

## Perplexity

- 質問検索、最新の情報調査に強い
- API キー（pplx-...）が必要なため、Perplexity アカウントより取得

> **参考**:
>
> - [`Perplexity MCP Server`](https://perplexity.mintlify.app/guides/mcp-server#cursor)

### 注意:

- Pro アカウントでも API キーの使用量は完全に無料ではなく、月$5 のクレジットが付与され、それを超える分は従量課金（pay-as-you-go）で追加料金が発生する仕組みです。
- Auto reload 無効時は手動トップアップのみ可能で、未購入なら超過分請求なし。

### プロンプトサンプル:

```text
Perplexity で、Flutter の状態管理（Provider, Riverpod, Bloc）の違いと、
この規模のアプリにおすすめの選択肢を理由付きで整理してください。
```

```text
Perplexity を使って、Next.js（App Router）と従来の Pages Router の違いを、移行時の注意点込みでまとめてください。
実務での移行ステップ案も提案してほしいです。
```

## Brave Search

- ニュース検索やウェブ一般検索
- API キーが必要 → 無料枠あり（月 2,000 クエリ）

### プロンプトサンプル:

```text
Brave で「Flutter Riverpod best practices 2024」を検索して、
複数記事を参考にしながら、設計のアンチパターンも含めて整理してください。
```

```text
Brave Search を使って、「Next.js hydration error text content does not match」と
類似エラーの解決方法がまとまっている記事を探して、要点を日本語でまとめてください。
```

## Browser Tools

- Web ページの内容取得やスクレイピング的操作が可能
- Chrome 拡張を[インストール](https://browsertools.agentdesk.ai/installation)して使用

### プロンプトサンプル:

```text
この GitHub Issue の内容を Browser Tools で読んで、
同じ問題をこのプロジェクトで避けるための対策をまとめてください。

https://github.com/flutter/flutter/issues/xxxxx
```

```text
Browser Tools を使って、Flutter の公式ドキュメントのこのページから、
サンプルコード部分だけ抜き出して、このウィジェットに合わせて書き換えてください。

https://docs.flutter.dev/ui/widgets
```

## 関連

- [web-research コマンド](../../.cursor/commands/web-research.md)
