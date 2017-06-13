#==============================================================================
# ☆ Scene_Menu_load     Ver. 1.00
#------------------------------------------------------------------------------
# 　メニュー画面にロード機能を追加します。
#==============================================================================
module Vocab
    LOAD = "ロード"
end


class Scene_Menu < Scene_Base
  #--------------------------------------------------------------------------
  # ☆ コマンドウィンドウの作成 <変更>
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::item
    s2 = Vocab::skill
    s3 = Vocab::equip
    s4 = Vocab::status
    s5 = Vocab::save
    s6 = Vocab::game_end
    s7 = Vocab::LOAD  #追加
    #@command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6])
    @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s7, s6]) #変更
    @command_window.index = @menu_index
    if $game_party.members.size == 0          # パーティ人数が 0 人の場合
      @command_window.draw_item(0, false)     # アイテムを無効化
      @command_window.draw_item(1, false)     # スキルを無効化
      @command_window.draw_item(2, false)     # 装備を無効化
      @command_window.draw_item(3, false)     # ステータスを無効化
    end
    if $game_system.save_disabled             # セーブ禁止の場合
      @command_window.draw_item(4, false)     # セーブを無効化
    end
  end
  #--------------------------------------------------------------------------
  # ☆ コマンド選択の更新 <変更>
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::C)
      if $game_party.members.size == 0 and @command_window.index < 4
        Sound.play_buzzer
        return
      elsif $game_system.save_disabled and @command_window.index == 4
        Sound.play_buzzer
        return
      end
      Sound.play_decision
      case @command_window.index
      when 0      # アイテム
        $scene = Scene_Item.new
      when 1,2,3  # スキル、装備、ステータス
        start_actor_selection
      when 4      # セーブ
        $scene = Scene_File.new(true, false, false)
      when 5      # ロード                           #追加
        $scene = Scene_File.new(false, false, false) 
      when 6      # ゲーム終了                       #変更 5→6
        $scene = Scene_End.new 
      end
    end
  end
end

#////////////////////////////////////////////////////////////////
#作成者：ehime
#http://www.abcoroti.com/~nekoneko/index.html
#readmeやスタッフロールの明記，使用報告は任意．
#////////////////////////////////////////////////////////////////