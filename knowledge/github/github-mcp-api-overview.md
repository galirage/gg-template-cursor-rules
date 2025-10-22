# GitHub MCP と GitHub API / GitHub Projects API

> _目的_: GitHub MCP および GitHub API / GitHub Projects API に関するナレッジを整理します。

## GitHub MCP で操作可能なパラメータ

- **title**: イシューのタイトル
- **body**: イシューの内容
- **labels**: ラベル
- **assignees**: 担当者
- **milestone**: マイルストーン
- **state**: 状態（open/closed）

## GitHub API と GitHub Projects API の違い

- **GitHub API**: GitHub 全体を操作する汎用 API
  - リポジトリ操作や Issue 登録、PR 作成などが可能
- **GitHub Projects API** : プロジェクト管理機能（Projects v2）の操作に特化した API
  - プロジェクトボードやフィールド更新などが可能
  - **注意**: Projects v2 は GraphQL ベースの API（v4）でのみ操作可能。REST API はサポートされていない。

## GitHub Projects と API のバージョン差異

- GitHub Projects には、**Classic Projects（旧型）** と **Projects v2（新型）** の 2 種類があり、それぞれ利用できる API が異なる。
  - **classic projects**: REST API。従来のプロジェクトボード。リポジトリ単位で管理される。
  - **projects v2**: GraphQL API（v4）。組織・ユーザー単位で管理される最新のプロジェクト管理機能。
- また、利用する **トークンの種類** によって操作権限が異なる。
  - **Organization Projects**: GitHub Apps Token を使用し、組織レベルの Projects にアクセス可能
  - **User Projects**: Personal Access Token（PAT）を使用し、個人アカウントの Projects にアクセス可能

## Github Projects の ID の取得方法

Projects v2 を操作する際には、GraphQL で **プロジェクト ID** を取得する必要があるため、以下のコマンドを実行する。

```
curl --request POST \
  --url https://api.github.com/graphql \
  --header 'Authorization: Bearer {ACCESS_TOKEN}' \
  --data '{"query":"query{organization(login: \"galirage\") {projectV2(number: {URL_NUMBER}){id}}}"}'
```

レスポンス例：

```
{
  "data": {
    "organization": {
      "projectV2": {
        "id": "PVT_kwDOB_ocZ84A43qU"
      }
    }
  }
}
```
