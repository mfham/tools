#!/usr/bin/env ruby
require_relative 'models/kiro_step'
require_relative 'models/notifier'

channel_name = ARGV[0]
if channel_name.nil? || channel_name.empty?
  warn "Usage: #{$0} <channel_name>"
  warn "  例: #{$0} test"
  exit 1
end

BASE_DIR = File.dirname(File.expand_path(__FILE__))
PROMPTS_DIR = "#{BASE_DIR}/prompts"

SLACK_INPUT_TOOLS = %w[
  @slack/slack_search_channels
  @slack/slack_read_channel
  @slack/slack_read_thread
  @slack/slack_get_reactions
].join(',')

SLACK_OUTPUT_TOOLS = %w[
  @slack/slack_send_message
].join(',')

# Step 1: Slack確認 → 対象メッセージ取得
puts "=== Step 1: Slackチャンネル確認 ==="
input_prompt = File.read("#{PROMPTS_DIR}/slack_input_two_stage.txt") % {
  channel: channel_name,
  trigger_emoji: "tada",
  action_emoji: "heart",
}
slack_result = KiroStep.new(dir: BASE_DIR, prompt: input_prompt, trust_tools: SLACK_INPUT_TOOLS).run

if slack_result.nil? || slack_result.include?("NOT_FOUND")
  puts "対象メッセージが見つかりませんでした。"
  Notifier.notify("対象メッセージなし")
  exit 0
end

thread_ts = slack_result[/THREAD_TS:\s*(.+)/, 1]&.strip
channel_id = slack_result[/CHANNEL_ID:\s*(.+)/, 1]&.strip
content = slack_result[/CONTENT:\s*(.+)/m, 1]&.strip

if thread_ts.nil? || channel_id.nil? || content.nil?
  puts "結果のパースに失敗しました。"
  puts slack_result
  exit 1
end

puts "channel_id: #{channel_id}"
puts "thread_ts: #{thread_ts}"
puts "入力内容: #{content[0..100]}..."
Notifier.notify("Step 1 完了: メッセージ取得")

# Step 2: foo で分析
puts "\n=== Step 2: foo 分析 ==="
foo_result = KiroStep.new(dir: "#{BASE_DIR}/foo", prompt: "鯖缶詰を使ったおすすめアレンジ料理を3つ教えて").run
if foo_result.nil?
  puts "[WARN] foo の分析に失敗"
  foo_result = "（fooの分析に失敗しました）"
  Notifier.notify("Step 2: foo 分析失敗")
else
  Notifier.notify("Step 2 完了: foo 分析")
end

# Step 3: bar で分析
puts "\n=== Step 3: bar 分析 ==="
bar_result = KiroStep.new(dir: "#{BASE_DIR}/bar", prompt: "卵料理のおすすめを3つ教えて").run
if bar_result.nil?
  puts "[WARN] bar の分析に失敗"
  bar_result = "（barの分析に失敗しました）"
  Notifier.notify("Step 3: bar 分析失敗")
else
  Notifier.notify("Step 3 完了: bar 分析")
end

# Step 4: 結果をSlackスレッドに投稿
puts "\n=== Step 4: Slack投稿 ==="
message = <<~MSG
  ## 分析1（foo）
  #{foo_result}

  ---

  ## 分析2（bar）
  #{bar_result}
MSG

output_prompt = File.read("#{PROMPTS_DIR}/slack_output.txt") % {
  channel_id: channel_id,
  thread_ts: thread_ts,
  message: message,
}
KiroStep.new(dir: BASE_DIR, prompt: output_prompt, trust_tools: SLACK_OUTPUT_TOOLS).run

puts "\n完了！"
Notifier.notify("全ステップ完了！")
