require_relative 'spec_helper'

RSpec.describe 'convert.rb' do
  let(:script_path) { File.expand_path('../convert.rb', __dir__) }

  def run_with_clipboard(input)
    `echo #{input.shellescape} | pbcopy`
    `ruby #{script_path}`.force_encoding('UTF-8').chomp
  end

  describe '正常系' do
    it 'テキストをJIRAのcodeブロックに変換する' do
      input = 'console.log("Hello World");'
      expected = "{code}\nconsole.log(\"Hello World\");\n{code}"

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '複数行のコードを変換する' do
      input = <<~INPUT.chomp
        function hello() {
          console.log("Hello");
        }
      INPUT

      expected = <<~OUTPUT.chomp
        {code}
        function hello() {
          console.log("Hello");
        }
        {code}
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '日本語コメントを含むコードを変換する' do
      input = '// これはコメントです\nvar x = 1;'
      expected = "{code}\n// これはコメントです\nvar x = 1;\n{code}"

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'エッジケース' do
    it '空の入力は空のcodeブロックを返す' do
      expected = "{code}\n\n{code}"
      expect(run_with_clipboard('')).to eq(expected)
    end

    it '空白のみの入力は空文字になる（stripされる）' do
      input = '   '
      expected = "{code}\n\n{code}"
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '改行のみの入力は空文字になる（stripされる）' do
      input = "\n\n"
      expected = "{code}\n\n{code}"
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end
end
