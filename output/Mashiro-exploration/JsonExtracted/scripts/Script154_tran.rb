#==============================================================================
# ■ Game_Player
#------------------------------------------------------------------------------
# 　プレイヤーを扱うクラスです。イベントの起動判定や、マップのスクロールなどの
# 機能を持っています。このクラスのインスタンスは $game_player で参照されます。
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :scroll_flag 
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @vehicle_type = -1
    @vehicle_getting_on = false     # 乗る動作の途中フラグ
    @vehicle_getting_off = false    # 降りる動作の途中フラグ
    @transferring = false           # 場所移動フラグ
    @new_map_id = 0                 # 移動先 マップ ID
    @new_x = 0                      # 移動先 X 座標
    @new_y = 0                      # 移動先 Y 座標
    @new_direction = 0              # 移動後の向き
    @walking_bgm = nil              # 歩行時の BGM 記憶用
    @scroll_flag = ""               # カメラの固定
  end
  #--------------------------------------------------------------------------
  # ● スクロール処理
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    return if @scroll_flag == "all"
    ax1 = $game_map.adjust_x(last_real_x)
    ay1 = $game_map.adjust_y(last_real_y)
    ax2 = $game_map.adjust_x(@real_x)
    ay2 = $game_map.adjust_y(@real_y)
    unless @scroll_flag == "vertical"
      if ay2 > ay1 and ay2 > CENTER_Y
        $game_map.scroll_down(ay2 - ay1)
      end
      if ay2 < ay1 and ay2 < CENTER_Y
        $game_map.scroll_up(ay1 - ay2)
      end
    end
    unless @scroll_flag == "horizontal"
      if ax2 < ax1 and ax2 < CENTER_X
        $game_map.scroll_left(ax1 - ax2)
      end
      if ax2 > ax1 and ax2 > CENTER_X
        $game_map.scroll_right(ax2 - ax1)
      end
    end
  end
end