#==============================================================================
# ○メッセージウィンドウにアイコン表示 Ver1.00
# for RGSS2
# 西瓜 / Space not far
# http://muspell.raindrop.jp/
# メッセージウィンドウに、\I[インデックス]と書くことで
# アイコンを表示できるようになります。
#==============================================================================

# インデックスは、アイコンファイルの一番左上から
# 0、1、2……となります。
# \I[52] => 盾のアイコン
# \I[\V[10]] のように指定することも出来ます。

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  alias snf_icon_convert_special_characters convert_special_characters
  def convert_special_characters
    snf_icon_convert_special_characters
    @text.gsub!(/\\I\[([0-9]+)\]/i) { "\x09[#{$1}]" }
  end
  #--------------------------------------------------------------------------
  # ● メッセージの更新
  #--------------------------------------------------------------------------
  # すさまじい再定義
  def update_message
    loop do
      c = @text.slice!(/./m)            # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        finish_message                  # 更新終了
        break
      when "\x00"                       # 改行
        new_line
        if @line_count >= MAX_LINE      # 行数が最大のとき
          unless @text.empty?           # さらに続きがあるなら
            self.pause = true           # 入力待ちを入れる
            break
          end
        end
      when "\x01"                       # \C[n]  (文字色変更)
        @text.sub!(/\[([0-9]+)\]/, "")
        contents.font.color = text_color($1.to_i)
        next
      when "\x02"                       # \G  (所持金表示)
        @gold_window.refresh
        @gold_window.open
      when "\x03"                       # \.  (ウェイト 1/4 秒)
        @wait_count = 15
        break
      when "\x04"                       # \|  (ウェイト 1 秒)
        @wait_count = 60
        break
      when "\x05"                       # \!  (入力待ち)
        self.pause = true
        break
      when "\x06"                       # \>  (瞬間表示 ON)
        @line_show_fast = true
      when "\x07"                       # \<  (瞬間表示 OFF)
        @line_show_fast = false
      when "\x08"                       # \^  (入力待ちなし)
        @pause_skip = true
      when "\x09"                       # \I  (アイコン表示)
        @text.sub!(/\[([0-9]+)\]/, "")
        draw_icon($1.to_i, @contents_x, @contents_y)
        @contents_x += 24
      else                              # 普通の文字
        contents.draw_text(@contents_x, @contents_y, 40, WLH, c)
        c_width = contents.text_size(c).width
        @contents_x += c_width
      end
      break unless @show_fast or @line_show_fast
    end
  end
end
