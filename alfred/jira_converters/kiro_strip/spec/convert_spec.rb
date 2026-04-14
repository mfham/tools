require_relative 'spec_helper'

RSpec.describe 'convert.rb' do
  let(:script_path) { File.expand_path('../convert.rb', __dir__) }

  def run_with_clipboard(input)
    `echo #{input.shellescape} | pbcopy`
    `ruby #{script_path}`.force_encoding('UTF-8').chomp
  end

  describe '正常系' do
    it '各行先頭の半角スペース2文字を除去する' do
      input = "  hello\n  world"
      expected = "hello\nworld"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '各行末尾の連続空白を除去する' do
      input = "hello   \nworld  "
      expected = "hello\nworld"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '先頭スペース除去と末尾空白除去を同時に行う' do
      input = "  今日は天気がいい。 \n  明日は雨が降るかもしれないので、 \n  傘を持っていこう。 "
      expected = "今日は天気がいい。\n明日は雨が降るかもしれないので、\n傘を持っていこう。"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '日本語テキストを正しく処理する' do
      input = "  こんにちは  \n  世界  "
      expected = "こんにちは\n世界"

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'エッジケース' do
    it '空の入力は空文字を返す' do
      expect(run_with_clipboard('')).to eq('')
    end

    it '先頭スペースが2文字未満の行はそのまま残す' do
      input = " hello\n  world"
      expected = " hello\nworld"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '先頭スペースが2文字より多い行は2文字だけ除去する' do
      input = "    hello"
      expected = "  hello"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'スペースのみの行は空行になる' do
      input = "  hello\n    \n  world"
      expected = "hello\n\nworld"

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end
end
