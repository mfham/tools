#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# クリップボードからテキストを取得
input_text = `pbpaste`.strip

# JIRAのquoteブロック形式に変換
result = "{quote}\n#{input_text}\n{quote}"

# 結果を出力（Alfred用）
puts result
