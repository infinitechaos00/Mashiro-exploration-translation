#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 書式指定文字描画 - KGC_DrawFormatText ◆ VX ◆
#_/    ◇ Last update : 2007/12/19 ◇
#_/----------------------------------------------------------------------------
#_/  書式指定文字描画機能を追加します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

$imported = {} if $imported == nil
$imported["DrawFormatText"] = true

class Bitmap
  @@__dummy_window = Window_Base.new(-64, -64, 64, 64)
  @@__dummy_window.visible = false
  #--------------------------------------------------------------------------
  # ● 書式指定文字描画
  #--------------------------------------------------------------------------
  def draw_format_text(x, y, width, height, text, align = 0)
    str = convert_special_characters(text)
    dx = 0
    buf = Bitmap.new(Graphics.width * 2, Window_Base::WLH)
    buf.font = self.font.clone
    loop {
      c = str.slice!(/./m)              # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        break
      when "\x01"                       # \C[n]  (文字色変更)
        str.sub!(/\[([0-9]+)\]/, "")
        buf.font.color = @@__dummy_window.text_color($1.to_i)
        next
      else                              # 普通の文字
        buf.draw_text(dx, 0, 40, Window_Base::WLH, c)
        c_width = buf.text_size(c).width
        dx += c_width
      end
    }
    self.font = buf.font.clone
    # バッファをウィンドウ内に転送
    dest = Rect.new(x, y, [width, dx].min, height)
    src = Rect.new(0, 0, dx, Window_Base::WLH)
    offset = width - dx
    case align
    when 1  # 中央揃え
      dest.x += offset / 2
    when 2  # 右揃え
      dest.x += offset
    end
    stretch_blt(dest, buf, src)
    buf.dispose
  end
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  def convert_special_characters(str)
    text = str.dup
    text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    text.gsub!(/\\G/)              { $game_party.gold }
    text.gsub!(/\\\\/)             { "\\" }
    return text
  end
end
