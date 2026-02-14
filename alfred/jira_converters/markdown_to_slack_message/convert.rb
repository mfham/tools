#!/usr/bin/env ruby

# クリップボードから Markdown を取得
input_text = `pbpaste`.strip

# Markdown を Slack mrkdwn 形式に変換
def markdown_to_mrkdwn(text)
  result = text.dup
  
  # 見出し (h1-h6) を一時マーカーに変換
  result.gsub!(/^[#]{1,6}\s+(.+)$/, '<<<BOLD>>>\1<<<BOLD>>>')
  
  # 太字 **text** を一時マーカーに変換
  result.gsub!(/\*\*(.+?)\*\*/, '<<<BOLD>>>\1<<<BOLD>>>')
  
  # 斜体 *text* を _text_ に変換
  result.gsub!(/\*(.+?)\*/, '_\1_')
  
  # 一時マーカーを *text* に変換
  result.gsub!(/<<<BOLD>>>(.+?)<<<BOLD>>>/, '*\1*')
  
  # 取り消し線 ~~text~~ を ~text~ に変換
  result.gsub!(/~~(.+?)~~/, '~\1~')
  
  # チェックリスト - [x] を • ✓ に、- [ ] を • に変換
  result.gsub!(/^(\s*)[-*]\s+\[x\]\s+/, '\1• ✓ ')
  result.gsub!(/^(\s*)[-*]\s+\[ \]\s+/, '\1• ')
  
  # 箇条書き - を • に変換
  result.gsub!(/^(\s*)[-*]\s+/, '\1• ')
  
  # コードブロックの言語指定を削除
  result.gsub!(/```\w+\n/, "```\n")
  
  result
end

# 変換を実行
result = markdown_to_mrkdwn(input_text)

# 結果を出力（Alfred用）
puts result
