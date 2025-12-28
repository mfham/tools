#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# クリップボードからテキストを取得
input_text = `pbpaste`.strip

# JIRAのcodeブロック形式に変換
result = "{code}\n#{input_text}\n{code}"

# 結果を出力（Alfred用）
puts result
