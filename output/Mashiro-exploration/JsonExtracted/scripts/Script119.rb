=begin
生者・死者両方に使えるアイテム・スキル
201100310 tamura製作。
配布元：http://tamurarpgvx.blog137.fc2.com/

【使い方】
スクリプトエディタを開き、左のリストを下にスクロール。
（ここに追加）の下で右クリック・挿入。
空白のファイルが新しく出来るので、
右の広い空白の部分にこのファイルを貼り付けます。

【概要】
効果範囲が「味方単体（戦闘不能）」もしくは「味方全体（戦闘不能）」と設定された
アイテム・スキルを用意します。
次に、そのアイテム・スキルのメモ欄に　<生者にも効果>　と記述します。
すると、このアイテム・スキルは、戦闘不能でない者にも使用できるようになります。

【使用例】
・死者に使うと戦闘不能解除、生者に使うと全ステート解除。

【更新履歴】
２０１１０５２３　戦闘中に使えなかった不具合を修正。

=end

#==============================================================================
# ■ Game_Unit
#==============================================================================
class Game_Unit
  #--------------------------------------------------------------------------
  # ● ターゲットの決定。問答無用で選んだキャラを返す。
  #--------------------------------------------------------------------------
  def smooth_dead_or_alive_target(index)
    member = members[index]
    return member if member != nil
    return existing_members[0]
  end
end

#==============================================================================
# ■ Game_BattleAction
#==============================================================================
class Game_BattleAction
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムのターゲット作成
  #     obj : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def make_obj_targets(obj)
    targets = []
    if obj.for_opponent?
      if obj.for_random?
        if obj.for_one?         # 敵単体 ランダム
          number_of_targets = 1
        elsif obj.for_two?      # 敵二体 ランダム
          number_of_targets = 2
        else                    # 敵三体 ランダム
          number_of_targets = 3
        end
        number_of_targets.times do
          targets.push(opponents_unit.random_target)
        end
      elsif obj.dual?           # 敵単体 連続
        targets.push(opponents_unit.smooth_target(@target_index))
        targets += targets
      elsif obj.for_one?        # 敵単体
        targets.push(opponents_unit.smooth_target(@target_index))
      else                      # 敵全体
        targets += opponents_unit.existing_members
      end
    elsif obj.for_user?         # 使用者
      targets.push(battler)
    elsif obj.for_dead_friend?
      if obj.for_one?           # 味方単体 (戦闘不能)
        if /<生者にも効果>/ =~ obj.note
          targets.push(friends_unit.smooth_dead_or_alive_target(@target_index))
        else
          targets.push(friends_unit.smooth_dead_target(@target_index))
        end
      else                      # 味方全体 (戦闘不能)
        if /<生者にも効果>/ =~ obj.note
          targets += friends_unit.members #全メンバーを返す。
        else
          targets += friends_unit.dead_members
        end
      end
    elsif obj.for_friend?
      if obj.for_one?           # 味方単体
        targets.push(friends_unit.smooth_target(@target_index))
      else                      # 味方全体
        targets += friends_unit.existing_members
      end
    end
    return targets.compact
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
class Game_Battler
  #--------------------------------------------------------------------------
  # ● スキルの適用可能判定
  #     user  : スキルの使用者
  #     skill : スキル
  #--------------------------------------------------------------------------
  def skill_effective?(user, skill)
    if /<生者にも効果>/ =~ skill.note and skill.for_dead_friend?
    elsif skill.for_dead_friend? != dead?
      return false
    end
    if not $game_temp.in_battle and skill.for_friend?
      return skill_test(user, skill)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アイテムの適用可能判定
  #     user : アイテムの使用者
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_effective?(user, item)
    if /<生者にも効果>/ =~ item.note and item.for_dead_friend?
    elsif item.for_dead_friend? != dead?
      return false
    end
    if not $game_temp.in_battle and item.for_friend?
      return item_test(user, item)
    end
    return true
  end
end