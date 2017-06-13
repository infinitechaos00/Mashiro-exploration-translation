#==============================================================================
# ■ Window_Message
#==============================================================================
class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  def convert_special_characters
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    @text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    @text.gsub!(/\\G/)              { "\x02" }
    @text.gsub!(/\\\./)             { "\x03" }
    @text.gsub!(/\\\|/)             { "\x04" }
    @text.gsub!(/\\!/)              { "\x05" }
    @text.gsub!(/\\>/)              { "\x06" }
    @text.gsub!(/\\</)              { "\x07" }
    @text.gsub!(/\\\^/)             { "\x08" }
    @text.gsub!(/\\\\/)             { "\\" }
    @text.gsub!(/\\SE\[(.*),(\d+),(\d+)]/i)  { RPG::SE.new($1.to_s, $2.to_i, $3.to_i).play }
  end
end