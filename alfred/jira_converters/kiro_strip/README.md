# Kiro Strip

Kiro CLIの出力テキストから余計な空白を除去するAlfred Workflow

## 機能
- 各行先頭の半角スペース2文字を除去
- 各行末尾の連続空白を除去

## Alfred Workflowの設定手順

### 1. 新しいWorkflowを作成
1. Alfredを開く（`Cmd` ダブルタップ）
2. 右上の歯車アイコン → `Preferences`
3. `Workflows` タブを選択
4. 左下の `+` → `Blank Workflow`
5. 名前: `Kiro Strip`

### 2. Keyword Triggerを追加
1. 右クリック → `Inputs` → `Keyword`
2. Keyword: `kstrip`
3. Title: `Kiro Strip`
4. Subtitle: `Strip leading/trailing spaces from clipboard text`
5. `Argument`: `No Argument` を選択

### 3. Run Scriptを追加
1. 右クリック → `Actions` → `Run Script`
2. `Language`: `/usr/bin/ruby`
3. スクリプト内容:
```ruby
load '/path/to/tools/alfred/jira_converters/kiro_strip/convert.rb'
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
3. Text: `空白除去してクリップボードに保存しました`

### 6. 接続
- Keyword → Run Script → Copy to Clipboard → Post Notification の順に線で接続

### 使い方
1. Kiro CLIの出力テキストをコピー（`Cmd + C`）
2. `Cmd` ダブルタップ → Alfred起動
3. `kstrip` と入力 → `Enter`
4. 変換された内容がクリップボードに保存される
5. `Cmd + V` でペースト

## 変換例

### 変換前
```
  今日は天気がいい。 
  明日は雨が降るかもしれないので、 
  傘を持っていこう。 
```

### 変換後
```
今日は天気がいい。
明日は雨が降るかもしれないので、
傘を持っていこう。
```
