#==============================================================================
# ■ コモンイベント優先
#   @version 0.10 09/06/19
#   @author さば缶
#------------------------------------------------------------------------------
# 　スキル、アイテムにコモンイベントを設定している時に、
# コモンイベントを先に処理できます。
# 
# スキル、アイテムのメモ欄に、
# <コモンイベント優先>
# と書いてください。
#==============================================================================
module Saba
  module Common
    MEMO_TEXT = "<コモンイベント優先>"
  end
end

class RPG::BaseItem
  def common_event_first?
    return note.include?(Saba::Common::MEMO_TEXT)
  end
end

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : スキル
  #--------------------------------------------------------------------------
  alias saba_common_execute_action_skill execute_action_skill
  def execute_action_skill
    skill = @active_battler.action.skill
    if skill.common_event_first?
      $game_temp.common_event_id = skill.common_event_id
      process_battle_event
    end
    saba_common_execute_action_skill
    if skill.common_event_first?
      $game_temp.common_event_id = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : アイテム
  #--------------------------------------------------------------------------
  alias saba_common_execute_action_item execute_action_item
  def execute_action_item
    item = @active_battler.action.item
    if item.common_event_first?
      $game_temp.common_event_id = item.common_event_id
      process_battle_event
    end
    saba_common_execute_action_item
    if item.common_event_first?
      $game_temp.common_event_id = 0
    end
  end
end
