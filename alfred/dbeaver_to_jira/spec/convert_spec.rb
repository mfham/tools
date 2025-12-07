require 'spec_helper'
require 'shellwords'

RSpec.describe 'convert.rb' do
  let(:script_path) { File.expand_path('../convert.rb', __dir__) }

  def run_with_clipboard(input)
    `echo #{input.shellescape} | pbcopy`
    `ruby #{script_path}`.chomp
  end

  describe '正常系' do
    context 'DBeaver標準出力形式' do
      it 'ヘッダー、区切り線、データ行を正しく変換する' do
        input = <<~INPUT.chomp
          AlbumId|Title|ArtistId|
          -------+-----+--------+
                1|Rock|       1|
                2|Jazz|       2|
        INPUT

        expected = <<~OUTPUT.chomp
          |AlbumId|Title|ArtistId|
          |      1|Rock|       1|
          |      2|Jazz|       2|
        OUTPUT

        expect(run_with_clipboard(input)).to eq(expected)
      end

      it '複数データ行を処理する' do
        input = <<~INPUT.chomp
          ID|Name|
          --+----+
           1|AAA|
           2|BBB|
           3|CCC|
        INPUT

        expected = <<~OUTPUT.chomp
          |ID|Name|
          | 1|AAA|
          | 2|BBB|
          | 3|CCC|
        OUTPUT

        expect(run_with_clipboard(input)).to eq(expected)
      end
    end

    context '区切り線なし' do
      it 'ヘッダーとデータのみでも変換する' do
        input = <<~INPUT.chomp
          AlbumId|Title|
                1|Rock|
        INPUT

        expected = <<~OUTPUT.chomp
          |AlbumId|Title|
          |      1|Rock|
        OUTPUT

        expect(run_with_clipboard(input)).to eq(expected)
      end

      it 'ヘッダーのみでも変換する' do
        input = 'AlbumId|Title|'
        expected = '|AlbumId|Title|'

        expect(run_with_clipboard(input)).to eq(expected)
      end
    end
  end

  describe 'エッジケース' do
    it '空の入力は空文字を返す' do
      expect(run_with_clipboard('')).to eq('')
    end

    it '空白のみの入力は空文字を返す' do
      expect(run_with_clipboard('   ')).to eq('')
    end

    it '改行のみの入力は空文字を返す' do
      expect(run_with_clipboard("\n\n")).to eq('')
    end
  end

  describe '区切り線パターン' do
    it '短い区切り線を検出する' do
      input = <<~INPUT.chomp
        A|B|
        -+-+
        1|2|
      INPUT

      expected = <<~OUTPUT.chomp
        |A|B|
        |1|2|
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '長い区切り線を検出する' do
      input = <<~INPUT.chomp
        Column1|Column2|
        -------+-------+
        Value1|Value2|
      INPUT

      expected = <<~OUTPUT.chomp
        |Column1|Column2|
        |Value1|Value2|
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '区切り線が3行目以降にある場合は削除しない' do
      input = <<~INPUT.chomp
        Header|
        Data1|
        -----+
        Data2|
      INPUT

      expected = <<~OUTPUT.chomp
        |Header|
        |Data1|
        |-----+
        |Data2|
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end

  describe '特殊文字を含むデータ' do
    it '日本語を含むデータを処理する' do
      input = <<~INPUT.chomp
        ID|名前|
        --+----+
         1|太郎|
      INPUT

      expected = <<~OUTPUT.chomp
        |ID|名前|
        | 1|太郎|
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it 'スペースを含むデータを処理する' do
      input = <<~INPUT.chomp
        Name|Description|
        ----+-----------+
        Test|Hello World|
      INPUT

      expected = <<~OUTPUT.chomp
        |Name|Description|
        |Test|Hello World|
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end

    it '値に+が含まれる場合は区切り線として扱わない' do
      input = <<~INPUT.chomp
        Formula|Result|
        -------+------+
        1+1    |2     |
        2+3    |5     |
      INPUT

      expected = <<~OUTPUT.chomp
        |Formula|Result|
        |1+1    |2     |
        |2+3    |5     |
      OUTPUT

      expect(run_with_clipboard(input)).to eq(expected)
    end
  end
end
