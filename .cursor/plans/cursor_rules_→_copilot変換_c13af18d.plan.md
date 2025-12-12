---
name: Cursor rules → Copilot変換
overview: CursorのRules/Commands（.cursor配下）を、GitHub Copilot公式の「リポジトリ指示」「パス別指示」「プロンプトファイル」に再編し、.github配下へ追加します。既存の.cursorは残して併用可能にします。
todos:
  - id: inventory
    content: "`.cursor/rules` と `.cursor/commands` の内容をCopilot用に再構成する設計（repo-wide / path-specific / prompts）を確定"
    status: pending
  - id: repo-wide
    content: "`.github/copilot-instructions.md` を新規作成（短く要点のみ）"
    status: pending
  - id: path-specific
    content: "`.github/instructions/*.instructions.md` を新規作成し、Cursor rulesをapplyTo付きに変換"
    status: pending
  - id: prompts
    content: "`.github/prompts/*.prompt.md` を新規作成し、Cursor commandsをprompt filesへ変換"
    status: pending
  - id: personal-template
    content: Personal instructions用の推奨テキスト（貼り付け用）を用意
    status: pending
  - id: consistency-check
    content: 指示の重複/矛盾（common vs backend 等）を整理し、Copilotが迷わない形に整える
    status: pending
---

## 参照する公式仕様（変換の前提）

- リポジトリ全体の指示: `.github/copilot-instructions.md`（Markdown）
- パス別指示: `.github/instructions/*.instructions.md`（先頭frontmatterで `applyTo` を指定）
- プロンプトファイル: `.github/prompts/*.prompt.md`（再利用プロンプト）
- 個人指示: ファイルではなく、各ユーザーがGitHub.com側で設定（リポジトリにコミットできない）

参照: [リポジトリ指示](https://docs.github.com/ja/copilot/how-tos/configure-custom-instructions/add-repository-instructions) / [個人指示](https://docs.github.com/ja/copilot/how-tos/configure-custom-instructions/add-personal-instructions) / [プロンプトファイル](https://docs.github.com/ja/copilot/concepts/prompting/response-customization#about-prompt-files)

## 現状（Cursor側の元データ）

- Rules: `.cursor/rules/`（共通・backend・workflow）
- 例: `.cursor/rules/coding-rules/00-common/00-common-rules.mdc`
- backend: `.cursor/rules/coding-rules/01-backend/*.mdc`（tech stack / architecture / setup / quality / coding style / 各層実装 / error / logging / tests）
- workflow: `.cursor/rules/workflow-rules/git-commit-rule.mdc`
- Commands: `.cursor/commands/*.md`
- `commit-and-push.md`, `review-codes.md`, `create-pull-request.md`, `create-unit-test.md`, `update-documents.md`, `README.md`

## 変換方針（Copilot側の3種類に再編）

### 1) `.github/copilot-instructions.md`（repo-wide）

目的: 「このリポジトリで働くときの最重要ルール」を短く集約。

- リポジトリ概要（Cursor Rulesテンプレである点）
- モノレポ構成（`app/backend`, `app/frontend`）
- 共通規約の要点（DRY/KISS、早期return、マジックナンバー禁止、**コメントは日本語**、Docstring必須、品質チェック必須、AAAパターン）
- backendの技術スタック（Python/uv/FastAPI/ruff/pyright/pytest など）
- 「詳細は path-specific instructions / prompts にある」ことを明示（repo-wideを肥大化させない）

※ Copilot code reviewは指示ファイルの先頭4,000文字までしか読まない制約があるため、repo-wideは要点のみ＋詳細は分割します。

### 2) `.github/instructions/*.instructions.md`（path-specific）

目的: **適用範囲が明確なルールを、衝突しない単位で分割**して適用。
作成するファイル案:

- `common.instructions.md`
- frontmatter: `applyTo: "**"`
- 内容: `.cursor/rules/coding-rules/00-common/00-common-rules.mdc`をCopilot向けに整形（Cursorの `alwaysApply` 等は削除）
- `backend.instructions.md`
- `applyTo: "app/backend/**/*.py"`
- 内容: tech stack / setup / quality / python coding style（.cursorの `00-tech-stack.mdc`, `02-setup.mdc`, `03-python-quality-check.mdc`, `04-python-coding-style.mdc` の要点）
- レイヤ別（より具体な指示を「その層だけ」に適用）
- `backend-domain.instructions.md` → `applyTo: "app/backend/src/domain/**/*.py"`（`05-00-domain-implementation.mdc`）
- `backend-usecase.instructions.md` → `applyTo: "app/backend/src/usecase/**/*.py"`（`05-03-usecase-implementation.mdc`）
- `backend-infrastructure.instructions.md` → `applyTo: "app/backend/src/infrastructure/**/*.py"`（`05-01-infrastructure-implementation.mdc`）
- `backend-presentation.instructions.md` → `applyTo: "app/backend/src/presentation/**/*.py"`（`05-02-presentation-implementation.mdc`）
- `backend-tests.instructions.md` → `applyTo: "app/backend/tests/**/*.py"`（`05-04-test-code-implementation.mdc`）
- 横断 concerns
- `backend-error-handling.instructions.md` → `applyTo: "app/backend/**/*.py"`（`06-error-handling.mdc`）
- `backend-logging.instructions.md` → `applyTo: "app/backend/**/*.py"`（`07-logging-guidelines.mdc`）
- workflow
- `git-commit.instructions.md` → `applyTo: "**"`（`workflow-rules/git-commit-rule.mdc`の要点）

各.instructions.mdは、GitHub仕様のfrontmatter（`applyTo`）に変換し、Cursor特有のfrontmatter（`alwaysApply`, `globs` 等）は撤去します。

### 3) `.github/prompts/*.prompt.md`（Cursor commands の移植）

目的: Cursorの `@commands/...` を、Copilot Prompt filesとして再利用可能にする。

- `commit-and-push.prompt.md`（`.cursor/commands/commit-and-push.md`）
- `review-codes.prompt.md`（`.cursor/commands/review-codes.md`）
- `create-pull-request.prompt.md`（`.cursor/commands/create-pull-request.md`）
- `create-unit-test.prompt.md`（`.cursor/commands/create-unit-test.md`）
- `update-documents.prompt.md`（`.cursor/commands/update-documents.md`）

プロンプト内容は、Copilotでの利用前提（入力テンプレ＋期待アウトプット＋チェックリスト）に合わせて、Cursor固有の表現を除去しつつ同等の運用を再現します。

補足（VS Code）: Prompt filesは機能フラグが必要な場合があるため、必要ならWorkspace設定に `"chat.promptFiles": true` を追加する手順もドキュメントとして `.github/copilot-instructions.md` に短く記載します（設定ファイル自体はユーザー要望に応じて後で追加）。

## 個人指示（personal instructions）について

個人指示はリポジトリにファイルとして置けないため、変換物としては「推奨テキスト」を用意し、各メンバーがGitHub.comの **Personal instructions** に貼り付ける運用にします。
例（このリポジトリ向け推奨）:

- 常に日本語で回答
- コメント/Docstringは日本語
- 変更時は品質チェック（ruff/pyright/pytest）を提案
- モノレポ構成・オニオンアーキテクチャ前提

## 実施手順（作業順）

1. `.github/` 配下に以下のディレクトリを作成: `.github/instructions/`, `.github/prompts/`
2. `.github/copilot-instructions.md` を新規作成（repo-wide要点のみ、短く）
3. `.github/instructions/` に上記の path-specific instructions を新規作成（Cursor rulesを移植・整理）
4. `.github/prompts/` に上記の prompt files を新規作成（Cursor commandsを移植・整理）
5. 既存 `.cursor/` は **keep** 方針のため残し、READMEに「Copilot版の場所」と「使い分け」を追記（必要であれば）
6. 追加したCopilot用ファイルの内容を重複/矛盾チェック（特にcommon vs backend）

## 成果物（追加ファイル一覧）

- `.github/copilot-instructions.md`
- `.github/instructions/common.instructions.md`
- `.github/instructions/backend.instructions.md`
- `.github/instructions/backend-domain.instructions.md`
- `.github/instructions/backend-usecase.instructions.md`
- `.github/instructions/backend-infrastructure.instructions.md`
- `.github/instructions/backend-presentation.instructions.md`
- `.github/instructions/backend-tests.instructions.md`
- `.github/instructions/backend-error-handling.instructions.md`
- `.github/instructions/backend-logging.instructions.md`
- `.github/instructions/git-commit.instructions.md`
- `.github/prompts/commit-and-push.prompt.md`
- `.github/prompts/review-codes.prompt.md`
- `.github/prompts/create-pull-request.prompt.md`
- `.github/prompts/create-unit-test.prompt.md`
- `.github/prompts/update-documents.prompt.md`

（既存の `.cursor/*` は残します）