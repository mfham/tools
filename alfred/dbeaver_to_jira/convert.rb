#!/usr/bin/env ruby
# encoding: utf-8

clipboard = `pbpaste`.force_encoding('UTF-8')
lines = clipboard.strip.split("\n")

lines.delete_at(1) if lines.size > 1 && lines[1].match?(/^-+\+/)

puts lines.map { |line| "|#{line}" }.join("\n")
