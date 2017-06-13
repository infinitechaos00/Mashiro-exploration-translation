#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ マップ軽量化 - KGC_MapLightening ◆ VX ◆
#_/    ◇ Last update : 2008/01/30 ◇
#_/----------------------------------------------------------------------------
#_/  マップの各種処理を軽量化します。
#_/============================================================================
#_/  再定義が多いので、できるだけ「素材」の上部に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module MapLightening
  # ◆ マップ上のスプライトを更新する範囲の割合
  #  マップ上のイベントグラフィックを描画する範囲を指定します。
  #   値が小さい ==> 動作が軽い・大きなキャラがバグる
  #   値が大きい ==> 動作が重い・大きなキャラもバグらない
  #  普通は 70～100 程度で問題ないでしょう。
  MAP_SPRITE_UPDATE_RANGE = 250
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["MapLightening"] = true

#==============================================================================
# ◆ Graphics
#==============================================================================

module Graphics
  #--------------------------------------------------------------------------
  # ● ゲーム画面のサイズを変更
  #--------------------------------------------------------------------------
  unless method_defined?(:resize_screen_KGC_MapLightening)
  class << Graphics
    alias resize_screen_KGC_MapLightening resize_screen
  end
  def self.resize_screen(width, height)
    resize_screen_KGC_MapLightening(width, height)

    if $game_temp != nil
      $game_temp.setup_lightening_value
    end
  end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :valid_common_event_check # コモンイベントの有効状態判定フラグ
  attr_reader   :display_center_x         # 画面中心 X 座標 (*256)
  attr_reader   :display_center_y         # 画面中心 Y 座標 (*256)
  attr_reader   :map_sprite_update_width  # スプライト更新を行う幅   (*256)
  attr_reader   :map_sprite_update_height # スプライト更新を行う高さ (*256)
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_MapLightening initialize
  def initialize
    initialize_KGC_MapLightening

    @valid_common_event_check = true

    setup_lightening_value
  end
  #--------------------------------------------------------------------------
  # ○ 軽量化用変数設定
  #--------------------------------------------------------------------------
  def setup_lightening_value
    @display_center_x = Graphics.width / 2
    @display_center_y = Graphics.height / 2
    @map_sprite_update_width = Graphics.width *
      KGC::MapLightening::MAP_SPRITE_UPDATE_RANGE / 100
    @map_sprite_update_height = Graphics.height *
      KGC::MapLightening::MAP_SPRITE_UPDATE_RANGE / 100
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Switches
#==============================================================================

class Game_Switches
  #--------------------------------------------------------------------------
  # ● スイッチの設定
  #     switch_id : スイッチ ID
  #     value     : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  alias indexer_equal_KGC_MapLightening []=
  def []=(switch_id, value)
    indexer_equal_KGC_MapLightening(switch_id, value)

    $game_temp.valid_common_event_check = true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  alias setup_KGC_MapLightening setup
  def setup(map_id)
    setup_KGC_MapLightening(map_id)

    update_valid_common_event_list
  end
  #--------------------------------------------------------------------------
  # ○ 有効なコモンイベントのリストを更新
  #--------------------------------------------------------------------------
  def update_valid_common_event_list
    @valid_common_events = {}
    # 有効なコモンイベントのリストを作成
    @common_events.each { |event_id, event|
      if event.trigger == 2 && $game_switches[event.switch_id]
        @valid_common_events[event_id] = event
      end
    }
    $game_temp.valid_common_event_check = false
  end
  #--------------------------------------------------------------------------
  # ● イベントの更新
  #--------------------------------------------------------------------------
  def update_events
    for event in @events.values
      event.update
    end
    if $game_temp.valid_common_event_check
      update_valid_common_event_list
    end
    for common_event in @valid_common_events.values
      common_event.update
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Interpreter
#==============================================================================

class Game_Interpreter
  @@_auto_start_common_event_list = nil
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  alias clear_KGC_MapLightening clear
  def clear
    clear_KGC_MapLightening

    if @@_auto_start_common_event_list == nil
      create_auto_start_common_event_list
    end
  end
  #--------------------------------------------------------------------------
  # ○ 自動起動のコモンイベントのリストを作成
  #--------------------------------------------------------------------------
  def create_auto_start_common_event_list
    @@_auto_start_common_event_list = []
    $data_common_events.compact.each { |event|
      # トリガーが自動実行のイベントのみ登録
      @@_auto_start_common_event_list << event if event.trigger == 1
    }
  end
  #--------------------------------------------------------------------------
  # ● 起動中イベントのセットアップ
  #--------------------------------------------------------------------------
  def setup_starting_event
    if $game_map.need_refresh             # 必要ならマップをリフレッシュ
      $game_map.refresh
    end
    if $game_temp.common_event_id > 0     # コモンイベントの呼び出し予約？
      setup($data_common_events[$game_temp.common_event_id].list)
      $game_temp.common_event_id = 0
      return
    end
    for event in $game_map.events.values  # マップイベント
      if event.starting                   # 起動中のイベントが見つかった場合
        event.clear_starting              # 起動中フラグをクリア
        setup(event.list, event.id)       # イベントをセットアップ
        return
      end
    end
    for event in @@_auto_start_common_event_list  # 自動起動のコモンイベント
      if $game_switches[event.switch_id]    # 条件スイッチが ON の場合
        setup(event.list)                 # イベントをセットアップ
      end
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Sprite_Character
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ○ 更新範囲内か判定
  #--------------------------------------------------------------------------
  def within_update_range?
    sx = @character.screen_x - $game_temp.display_center_x
    sy = @character.screen_y - $game_temp.display_center_y
    return (sx.abs <= $game_temp.map_sprite_update_width &&
      sy.abs <= $game_temp.map_sprite_update_height)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの更新
  #--------------------------------------------------------------------------
  def update_characters
    for sprite in @character_sprites
      sprite.update if sprite.within_update_range?
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    $game_map.interpreter.update      # インタプリタを更新
    $game_map.update                  # マップを更新
    $game_player.update               # プレイヤーを更新
    $game_system.update               # タイマーを更新
    @spriteset.update                 # スプライトセットを更新
    @message_window.update            # メッセージウィンドウを更新
    unless $game_message.visible      # メッセージ表示中以外
      update_transfer_player
      update_encounter
      update_call_menu
      update_call_debug
      if $game_temp.next_scene != nil  # 次のシーンがある場合のみ
        update_scene_change            # シーン変更
      end
    end
  end
end
