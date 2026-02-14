# Markdown と Slack mrkdwn の記法比較

このドキュメントは、標準 Markdown と Slack mrkdwn（メッセージ用）の記法の違いをまとめたものです。

## Slack mrkdwn とは

Slack mrkdwn は、Slack のメッセージで使用される軽量マークアップ言語です。標準 Markdown とは異なり、Slack のメッセージ環境に特化した記法です。

**重要な違い:**
- **Slack mrkdwn**: メッセージで使用（手動貼り付け可能）
- **Slack Canvas Markdown**: Canvas で使用（API 経由のみ）

このツールは **Slack mrkdwn（メッセージ用）** に変換します。

## 基本フォーマット

| 要素 | 標準 Markdown | Slack mrkdwn | 変換 |
|------|---------------|--------------|------|
| 太字 | `**text**` | `*text*` | ✅ 変換 |
| 斜体 | `*text*` | `_text_` | ✅ 変換 |
| 取り消し線 | `~~text~~` | `~text~` | ✅ 変換 |
| インラインコード | `` `code` `` | `` `code` `` | ✅ 互換 |
| コードブロック | ` ```lang` | ` ``` ` | ✅ 変換（言語指定削除） |

## 構造要素

| 要素 | 標準 Markdown | Slack mrkdwn | 変換 |
|------|---------------|--------------|------|
| 見出し1 | `# h1` | `*h1*` | ✅ 太字に変換 |
| 見出し2 | `## h2` | `*h2*` | ✅ 太字に変換 |
| 見出し3 | `### h3` | `*h3*` | ✅ 太字に変換 |
| 見出し4-6 | `#### h4` 以降 | `*h4*` | ✅ 太字に変換 |
| 水平線 | `---` | `---` | ✅ 互換 |
| 箇条書き | `- item` | `• item` | ✅ 変換 |
| 番号付きリスト | `1. item` | `1. item` | ✅ 互換 |
| 引用 | `> quote` | `> quote` | ✅ 互換 |
| 段落 | 空行で区切る | 空行で区切る | ✅ 互換 |

## リンクと画像

| 要素 | 標準 Markdown | Slack mrkdwn | 変換 |
|------|---------------|--------------|------|
| リンク | `[text](url)` | `[text](url)` | ✅ 互換 |
| 画像 | `![alt](url)` | `![alt](url)` | ✅ 互換 |
| URL のみ | `https://example.com` | `https://example.com` | ✅ 互換 |

**注意**: Slack は Markdown 形式のリンクと画像をそのまま認識します。`<url|text>` 形式への変換は不要です。

## チェックリスト

| 要素 | 標準 Markdown | Slack mrkdwn | 変換 |
|------|---------------|--------------|------|
| 未完了 | `- [ ] task` | `• task` | ✅ 変換 |
| 完了 | `- [x] task` | `• ✓ task` | ✅ 変換 |

**注意**: Slack mrkdwn にはチェックリスト機能がないため、通常の箇条書きに変換されます。

## Slack 固有の記法

| 要素 | 記法 | 備考 |
|------|------|------|
| ユーザーメンション | `<@U123ABC>` | ユーザーID が必要 |
| チャンネルメンション | `<#C123ABC>` | チャンネルID が必要 |
| 絵文字 | `:emoji:` | 標準 Markdown でも使えるが、Slack 固有の絵文字も利用可能 |
| 改行 | `Shift + Enter` | メッセージ内での改行 |

## サポートされていない要素

以下の要素は Slack mrkdwn ではサポートされていません:

| 要素 | 標準 Markdown | Slack mrkdwn | 対応 |
|------|---------------|--------------|------|
| テーブル | `\| header \|` | ❌ 非対応 | プレーンテキスト |
| 脚注 | `[^1]` | ❌ 非対応 | プレーンテキスト |
| 定義リスト | `term : definition` | ❌ 非対応 | プレーンテキスト |
| HTML タグ | `<div>` | ❌ 非対応 | プレーンテキスト |
| 数式 | `$x^2$` | ❌ 非対応 | プレーンテキスト |
| ネストされた引用 | `> > quote` | ❌ 非対応 | 単一レベルのみ |

## 変換例

### 例1: 基本的なフォーマット

**Markdown:**
```markdown
# Project Update
**Status**: On Track
*Last updated*: 2026-02-15
```

**Slack mrkdwn:**
```
*Project Update*
*Status*: On Track
_Last updated_: 2026-02-15
```

### 例2: リストとリンク

**Markdown:**
```markdown
## Resources
- [Documentation](https://example.com/docs)
- [GitHub](https://github.com/example/repo)
```

**Slack mrkdwn:**
```
*Resources*
• [Documentation](https://example.com/docs)
• [GitHub](https://github.com/example/repo)
```

### 例3: コードブロック

**Markdown:**
```markdown
```python
def hello():
    print("Hello, World!")
` ``
```

**Slack mrkdwn:**
```
` ``
def hello():
    print("Hello, World!")
` ``
```

## Slack Canvas との違い

| 機能 | Slack mrkdwn (メッセージ) | Slack Canvas (API) |
|------|---------------------------|-------------------|
| 使用方法 | 手動貼り付け可能 | API 経由のみ |
| 見出し | ❌ なし（太字に変換） | ✅ h1-h3 サポート |
| テーブル | ❌ なし | ✅ サポート（最大300セル） |
| チェックリスト | ❌ なし | ✅ サポート |
| 太字 | `*text*` | `**text**` |
| 斜体 | `_text_` | `*text*` |
| リンク | `[text](url)` | `[text](url)` |

## 使い分け

### Slack メッセージ（mrkdwn）を使う場合
- 通常のチャットメッセージ
- クイックな情報共有
- 簡単なフォーマットで十分な場合

### Slack Canvas（API）を使う場合
- 構造化されたドキュメント
- テーブルやチェックリストが必要
- API 統合が可能な環境

## 参考リンク

- [Slack mrkdwn Reference](https://api.slack.com/reference/surfaces/formatting)
- [Markdown Guide](https://markdownguide.offshoot.io/basic-syntax/)
- [Slack Canvas API](https://api.slack.com/surfaces/canvases)

## バージョン履歴

- **v1.0** (2026-02-15) - 初回リリース、Slack mrkdwn 形式への変換
