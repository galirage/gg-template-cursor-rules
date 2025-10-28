# Cursor での GitHub MCP Server セットアップ方法

## 1. GitHub の Personal Access Token（PAT）を作成する

- GitHub にログインし、右上のプロフィールアイコンをクリック
- 「Settings → Developer settings → Personal access tokens」で「Generate new token」をクリック
- 必要事項を入力
- 「Generate token」をクリックして作成完了
- ⚠️ 重要: 作成したトークンは必ず安全な場所に保存してください。画面を離れると二度と全文を見ることはできません。

## 2. Cursor に MCP サーバーを追加する

- Cursor を起動し、設定アイコンをクリック
- 「MCP」を選択
- 「Add new MCP Server」をクリック
- 以下の情報を入力：
  ```json
  "GitHub": {
  	"command": "docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server",
  	"env": {
  		"GITHUB_PERSONAL_ACCESS_TOKEN": "xxxxx", // 1.で作成した PAT を入力します
  		"GITHUB_OWNER": "galirage"
  	},
  	"args": []
  }
  ```
- 「Save」をクリックして追加完了

## 3. 動作確認

- 設定が完了したら、Cursor のチャットウィンドウで以下のようなプロンプトを試してみましょう：
  ```
  本リポジトリの issue 一覧を取得して。
  ```
- 正しく設定されていれば、GitHub の issue 一覧が表示されるはずです。

## 参考

https://zenn.dev/shiaf/articles/6526b4a17c1d73
