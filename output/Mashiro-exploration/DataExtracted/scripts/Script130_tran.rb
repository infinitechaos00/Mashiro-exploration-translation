#==============================================================================
#　＋＋　画面シェイク縦揺れ [VX]　ver. 1.00　＋＋
#　　Script by パラ犬
#　　http://2d6.parasite.jp/
#------------------------------------------------------------------------------
# [縦揺れにするイベントスイッチID]で設定したIDのスイッチがONの間
# イベントコマンド「画面のシェイク」を縦揺れにします
#==============================================================================

class Spriteset_Map

  # 縦揺れにするイベントスイッチID
  VERTICAL_VIBRATION_SWITCH = 20
  
# ↑ 設定項目ここまで
#------------------------------------------------------------------------------

  #--------------------------------------------------------------------------
  # ● ビューポートの更新
  #--------------------------------------------------------------------------
  alias :update_viewports_shake_alias :update_viewports unless method_defined?("update_viewports_shake_alias")
  def update_viewports
    update_viewports_shake_alias
    set_shake_param
  end
  
  #--------------------------------------------------------------------------
  # ○ シェイク位置を設定
  #--------------------------------------------------------------------------
  def set_shake_param
    if $game_switches[VERTICAL_VIBRATION_SWITCH] 
        @viewport1.ox = 0
        @viewport1.oy = $game_map.screen.shake
    else
        @viewport1.ox = $game_map.screen.shake
        @viewport1.oy = 0
    end
  end
end
