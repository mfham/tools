#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# クリップボードからテキストを取得
input_text = `pbpaste`

# 各行先頭の半角スペース2文字を除去、末尾の連続空白を除去
result = input_text.lines.map { |line| line.sub(/^  /, '').rstrip }.join("\n")

# 結果を出力（Alfred用）
puts result
