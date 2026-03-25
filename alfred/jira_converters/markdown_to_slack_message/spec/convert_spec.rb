require_relative 'spec_helper'

RSpec.describe 'convert.rb' do
  let(:script_path) { File.expand_path('../convert.rb', __dir__) }

  def run_with_clipboard(input)
    `echo #{input.shellescape} | pbcopy`
    `ruby #{script_path}`.force_encoding('UTF-8').chomp
  end

  describe '見出しの変換' do
    it 'h1を太字に変換する' do
      input = '# Heading 1'
      expected = '*Heading 1*'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'h2を太字に変換する' do
      input = '## Heading 2'
      expected = '*Heading 2*'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'h3を太字に変換する' do
      input = '### Heading 3'
      expected = '*Heading 3*'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'h4-h6も太字に変換する' do
      input = '#### Heading 4'
      expected = '*Heading 4*'
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'テキストフォーマットの変換' do
    it '太字を変換する' do
      input = '**bold text**'
      expected = '*bold text*'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '斜体を変換する' do
      input = '*italic text*'
      expected = '_italic text_'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '取り消し線を変換する' do
      input = '~~strikethrough~~'
      expected = '~strikethrough~'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '太字と斜体を組み合わせて変換する' do
      input = '**bold** and *italic*'
      expected = '*bold* and _italic_'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '太字内の斜体を変換する' do
      input = '**_bold and italic_**'
      expected = '*_bold and italic_*'
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'リストの変換' do
    it '箇条書き（-）を変換する' do
      input = '- Item 1'
      expected = '* Item 1'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '箇条書き（*）を変換する' do
      input = '* Item 1'
      expected = '* Item 1'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '番号付きリストはそのまま' do
      input = '1. Item 1'
      expected = '1. Item 1'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'ネストされた箇条書きを変換する' do
      input = <<~INPUT.chomp
        - Item 1
          - Nested item
      INPUT
      expected = <<~OUTPUT.chomp
        * Item 1
            * Nested item
      OUTPUT
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'チェックリストの変換' do
    it '未完了のチェックリストを変換する' do
      input = '- [ ] Task'
      expected = '* Task'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '完了したチェックリストを変換する' do
      input = '- [x] Done'
      expected = '* ✓ Done'
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'リンクと画像' do
    it 'リンクはそのまま' do
      input = '[text](https://example.com)'
      expected = '[text](https://example.com)'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '画像はそのまま' do
      input = '![alt](https://example.com/image.png)'
      expected = '![alt](https://example.com/image.png)'
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'コードの変換' do
    it 'インラインコードはそのまま' do
      input = '`code`'
      expected = '`code`'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'コードブロックの言語指定を削除する' do
      input = <<~INPUT.chomp
        ```javascript
        console.log("hello");
        ```
      INPUT
      expected = <<~OUTPUT.chomp
        ```
        console.log("hello");
        ```
      OUTPUT
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'コードブロック（言語指定なし）はそのまま' do
      input = <<~INPUT.chomp
        ```
        code
        ```
      INPUT
      expected = <<~OUTPUT.chomp
        ```
        code
        ```
      OUTPUT
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe '複合的な変換' do
    it '複数の要素を含むMarkdownを変換する' do
      input = <<~INPUT.chomp
        # Title
        **Bold** and *italic*
        - Item 1
        - [x] Done
        [link](https://example.com)
      INPUT
      expected = <<~OUTPUT.chomp
        *Title*
        *Bold* and _italic_
        * Item 1
        * ✓ Done
        [link](https://example.com)
      OUTPUT
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe 'エッジケース' do
    it '空の入力は空文字を返す' do
      expect(run_with_clipboard('')).to eq('')
    end

    it '空白のみの入力は空文字を返す' do
      expect(run_with_clipboard('   ')).to eq('')
    end

    it '日本語を含むテキストを変換する' do
      input = '# タイトル'
      expected = '*タイトル*'
      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '絵文字を含むテキストはそのまま' do
      input = ':smile: **Hello**'
      expected = ':smile: *Hello*'
      expect(run_with_clipboard(input)).to eq(expected)
    end
  end
end
