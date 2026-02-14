# Markdown to Slack Message Converter

Markdown 形式のテキストを Slack メッセージ用の mrkdwn 形式に変換する Alfred Workflow

## 機能
- Markdown を Slack mrkdwn 形式に変換
- Slack メッセージに貼り付けて使用可能

## Alfred Workflowの設定手順

### 1. 新しいWorkflowを作成
1. Alfredを開く（`Cmd` ダブルタップ）
2. 右上の歯車アイコン → `Preferences`
3. `Workflows` タブを選択
4. 左下の `+` → `Blank Workflow`
5. 名前: `Markdown to Slack Message`

### 2. Keyword Triggerを追加
1. 右クリック → `Inputs` → `Keyword`
2. Keyword: `slack`
3. Title: `Markdown to Slack Message`
4. Subtitle: `Convert clipboard Markdown to Slack mrkdwn format`
5. `Argument`: `No Argument` を選択

### 3. Run Scriptを追加
1. 右クリック → `Actions` → `Run Script`
2. `Language`: `/usr/bin/ruby`
3. スクリプト内容:
```ruby
load '/path/to/tools/alfred/jira_converters/markdown_to_slack_message/convert.rb'
```
4. `with input as {query}` を選択
5. `Running Instances`: `Sequentially` を選択（順次実行）

### 4. Copy to Clipboardを追加
1. 右クリック → `Outputs` → `Copy to Clipboard`
2. 内容欄は**空欄**のまま（前のステップの出力が自動的にコピーされる）
3. `Type`: `Plain Text` を選択
4. `Mark item as transient in clipboard`: **チェックしない**（履歴に残す）
5. `Automatically paste to front most app` は**チェックしない**

### 5. Post Notificationを追加（オプション）
1. 右クリック → `Outputs` → `Post Notification`
2. Title: `変換完了`
3. Text: `Slack mrkdwn形式でクリップボードに保存しました`

### 6. 接続
- Keyword → Run Script → Copy to Clipboard → Post Notification の順に線で接続

### 使い方
1. 変換したい Markdown をコピー（`Cmd + C`）
2. `Cmd` ダブルタップ → Alfred起動
3. `slack` と入力 → `Enter`
4. 変換された内容がクリップボードに保存される
5. Slack メッセージで `Cmd + V` でペースト

## 変換ルール

### テキストフォーマット
| Markdown | Slack mrkdwn |
|----------|--------------|
| `**bold**` | `*bold*` |
| `*italic*` | `_italic_` |
| `~~strikethrough~~` | `~strikethrough~` |
| `` `code` `` | `` `code` `` |

### 見出し
| Markdown | Slack mrkdwn |
|----------|--------------|
| `# Heading` | `*Heading*` |
| `## Heading` | `*Heading*` |
| `### Heading` | `*Heading*` |

**注意**: Slack mrkdwn には見出しがないため、太字に変換されます。

### リスト
| Markdown | Slack mrkdwn |
|----------|--------------|
| `- item` | `• item` |
| `* item` | `• item` |
| `1. item` | `1. item` |

### リンクと画像
| Markdown | Slack mrkdwn |
|----------|--------------|
| `[text](url)` | `[text](url)` |
| `![alt](url)` | `![alt](url)` |

**注意**: Slack はリンクと画像を Markdown 形式のまま認識します。変換不要です。

### チェックリスト
| Markdown | Slack mrkdwn |
|----------|--------------|
| `- [ ] task` | `• task` |
| `- [x] done` | `• ✓ done` |

### コードブロック
| Markdown | Slack mrkdwn |
|----------|--------------|
| ` ```javascript` | ` ``` ` |

**注意**: Slack mrkdwn はコードブロックの言語指定をサポートしていないため、削除されます。

## 変換例

### 変換前（Markdown）
```markdown
# Project Update
## Status
**On Track** - All milestones are being met

## Tasks
- [x] Complete design
- [ ] Implement features

Check out the [documentation](https://example.com/docs)
```

### 変換後（Slack mrkdwn）
```
*Project Update*
*Status*
*On Track* - All milestones are being met

*Tasks*
• ✓ Complete design
• Implement features

Check out the [documentation](https://example.com/docs)
```

## サンプルファイル

- `sample-basic.md` - 標準 Markdown のサンプル
- `sample-basic-mrkdwn.md` - 変換後の mrkdwn サンプル

## Slack mrkdwn の制限

Slack mrkdwn は標準 Markdown と比べて制限があります:

**サポートされていない要素:**
- 見出し（h1-h6）→ 太字に変換
- テーブル
- 脚注
- 定義リスト
- HTML タグ
- 数式

これらの要素は変換時に削除されるか、プレーンテキストとして扱われます。

## Slack Canvas について

**注意**: このツールは **Slack メッセージ用**です。

Slack Canvas に Markdown を使いたい場合は、**API 経由でのみ可能**です:
- Canvas の UI に貼り付けても Markdown として解釈されません
- `canvases.create` や `canvases.edit` API を使用する必要があります
- 詳細は [SYNTAX_REFERENCE.md](./SYNTAX_REFERENCE.md) を参照

## 詳細な記法リファレンス

Markdown と Slack mrkdwn の記法の詳細な比較については、[SYNTAX_REFERENCE.md](./SYNTAX_REFERENCE.md) を参照してください。

## トラブルシューティング

### スクリプトが動作しない
- スクリプトのパスが正しいか確認してください
- 実行権限が付与されているか確認してください: `chmod +x convert.rb`

### 変換結果が期待通りでない
- Slack mrkdwn でサポートされていない記法を使用していないか確認してください
- [SYNTAX_REFERENCE.md](./SYNTAX_REFERENCE.md) でサポート状況を確認してください

### Slack で正しく表示されない
- Slack の設定で「Format messages with markup」が有効になっているか確認してください
- Preferences → Advanced → Format messages with markup

## バージョン

- **v1.0** (2026-02-15) - 初回リリース、Slack mrkdwn 形式への変換
