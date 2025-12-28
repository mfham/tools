# Text to JIRA Code Block Converter

テキストをJIRAのcodeブロック形式に変換するAlfred Workflow

## 機能
- テキストをJIRAのcodeブロック形式に変換

## Alfred Workflowの設定手順

### 1. 新しいWorkflowを作成
1. Alfredを開く（`Cmd` ダブルタップ）
2. 右上の歯車アイコン → `Preferences`
3. `Workflows` タブを選択
4. 左下の `+` → `Blank Workflow`
5. 名前: `Text to JIRA Code`

### 2. Keyword Triggerを追加
1. 右クリック → `Inputs` → `Keyword`
2. Keyword: `code`
3. Title: `Text to JIRA Code Block`
4. Subtitle: `Convert clipboard content to JIRA code block format`
5. `Argument`: `No Argument` を選択

### 3. Run Scriptを追加
1. 右クリック → `Actions` → `Run Script`
2. `Language`: `/usr/bin/ruby`
3. スクリプト内容:
```ruby
load '/path/to/convert.rb'
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
3. Text: `JIRAコードブロック形式でクリップボードに保存しました`

### 6. 接続
- Keyword → Run Script → Copy to Clipboard → Post Notification の順に線で接続

### 使い方
1. 変換したいテキストをコピー（`Cmd + C`）
2. `Cmd` ダブルタップ → Alfred起動
3. `code` と入力 → `Enter`
4. 変換された内容がクリップボードに保存される
5. JIRAで普通に `Cmd + V` でペースト

## 変換例

### 変換前
```
SELECT * FROM users WHERE id = 1;
UPDATE users SET name = 'John' WHERE id = 1;
```

### 変換後（JIRA）
```
{code}
SELECT * FROM users WHERE id = 1;
UPDATE users SET name = 'John' WHERE id = 1;
{code}
```
