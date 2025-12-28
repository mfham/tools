require_relative 'spec_helper'

RSpec.describe 'convert.rb' do
  let(:script_path) { File.expand_path('../convert.rb', __dir__) }

  def run_with_clipboard(input)
    `echo #{input.shellescape} | pbcopy`
    `ruby #{script_path}`.force_encoding('UTF-8').chomp
  end

  describe '正常系' do
    it 'テキストをJIRAのquoteブロックに変換する' do
      input = 'これは重要な引用です。'
      expected = "{quote}\nこれは重要な引用です。\n{quote}"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '複数行のテキストを変換する' do
      input = <<~INPUT.chomp
        これは複数行の
        引用テキストです。
        重要な内容が含まれています。
      INPUT

      expected = <<~OUTPUT.chomp
        {quote}
        これは複数行の
        引用テキストです。
        重要な内容が含まれています。
        {quote}
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '英語のテキストを変換する' do
      input = 'This is an important quote from the documentation.'
      expected = "{quote}\nThis is an important quote from the documentation.\n{quote}"

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'エッジケース' do
    it '空の入力は空のquoteブロックを返す' do
      expected = "{quote}\n\n{quote}"
      expect(run_with_clipboard('')).to eq(expected)
    end

    it '空白のみの入力は空文字になる（stripされる）' do
      input = '   '
      expected = "{quote}\n\n{quote}"
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '改行のみの入力は空文字になる（stripされる）' do
      input = "\n\n"
      expected = "{quote}\n\n{quote}"
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end
end
