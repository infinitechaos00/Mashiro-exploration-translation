#==============================================================================
# ■ 呪われた装備
#------------------------------------------------------------------------------
#   ドラ○エ風の呪われた装備
# つけたら装備変更で取り外さない限り変更できないようにします
# 「*Cursed」(「」を外して)とアイテムのメモ欄に入力するだけで機能します
#
# *月の下の宿
# URL:http://gekkasou.shiteyattari.com/
#==============================================================================

module An
  #呪われた装備の表示文字色を変える
  Change_Cursed_Color = true
  
  #変更した後の文字色(\C[n]と同じ)
  CCC = 1
end

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

module RPG
  class BaseItem
    def an_equip_cursed?
      return self.note.include?("*Cursed")
    end
  end
end

#==============================================================================
# ■ Window_Equip
#==============================================================================

class Window_Equip < Window_Selectable
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  alias an_cursed_refresh refresh
  def refresh
    an_cursed_refresh
    self.contents.font.color = text_color(An::CCC)
    for i in 0..4
      next if @data[i].nil?
      if @data[i].an_equip_cursed?
        self.contents.clear_rect(92, WLH * i, 196, WLH)
        draw_icon(@data[i].icon_index, 92, WLH * i)
        self.contents.draw_text(116, WLH * i, 172, WLH, @data[i].name)
      end
    end
    self.contents.font.color = normal_color
  end
end

#==============================================================================
# ■ Scene_Equip
#==============================================================================

class Scene_Equip < Scene_Base
  #--------------------------------------------------------------------------
  # ● 装備部位選択の更新
  #--------------------------------------------------------------------------
  alias an_cursed_update_equip_selection update_equip_selection
  def update_equip_selection
    if Input.trigger?(Input::C) &&
      !@equip_window.item.nil? && @equip_window.item.an_equip_cursed?
      Sound.play_buzzer
      return
    end
    an_cursed_update_equip_selection
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の更新
  #--------------------------------------------------------------------------
  alias an_cursed_update_item_selection update_item_selection
  def update_item_selection
    if Input.trigger?(Input::C) && !@item_window.item.nil? &&
      !@actor.equips[1 - @equip_window.index].nil?
      an_item = @actor.equips[1 - @equip_window.index].dup
      if an_item.is_a?(RPG::Weapon) && an_item.an_equip_cursed? &&
        an_item.two_handed
        Sound.play_buzzer
        return
      end
    end
    an_cursed_update_item_selection
  end
end
