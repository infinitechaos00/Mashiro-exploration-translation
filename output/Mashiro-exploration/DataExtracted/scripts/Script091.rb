#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ BGM 継続 - KGC_ContinueBGM ◆ VX ◆
#_/    ◇ Last update : 2008/08/31 ◇
#_/----------------------------------------------------------------------------
#_/  マップ BGM のまま戦闘に突入する演出などを可能にする機能を追加します。
#_/============================================================================
#_/  他のスクリプトに影響を与える可能性があるため、できるだけ「素材」の最上部に
#_/ 導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

$imported = {} if $imported == nil
$imported["ContinueBGM"] = true

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::AudioFile
#==============================================================================

class RPG::AudioFile
  #--------------------------------------------------------------------------
  # ○ 一致判定
  #--------------------------------------------------------------------------
  def eql?(obj)
    return false unless obj.is_a?(RPG::AudioFile)
    return false if self.name   != obj.name
    return false if self.volume != obj.volume
    return false if self.pitch  != obj.pitch

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 等値演算子
  #--------------------------------------------------------------------------
  def ==(obj)
    return self.eql?(obj)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● バトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_battle
    @spriteset.update
    Graphics.update
    $game_player.make_encounter_count
    $game_player.straighten
    $game_temp.map_bgm = RPG::BGM.last
    $game_temp.map_bgs = RPG::BGS.last

    if $game_temp.map_bgm != $game_system.battle_bgm
      RPG::BGM.stop
      RPG::BGS.stop
    end

    Sound.play_battle_start
    $game_system.battle_bgm.play
    $game_temp.next_scene = nil
    $scene = Scene_Battle.new
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 勝利の処理
  #--------------------------------------------------------------------------
  def process_victory
    @info_viewport.visible  = false
    @message_window.visible = true
    unless $game_system.battle_end_me.name.empty?
      RPG::BGM.stop
      $game_system.battle_end_me.play
    end
    unless $BTEST
      $game_temp.map_bgm.play
      $game_temp.map_bgs.play
    end
    display_exp_and_gold
    display_drop_items
    display_level_up
    battle_end(0)
  end
end
