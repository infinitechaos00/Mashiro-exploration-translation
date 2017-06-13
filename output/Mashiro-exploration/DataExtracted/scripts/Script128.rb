#==============================================================================
#
#　■ エネミー行動パターン改良　拡張スクリプト
#     行動条件追加：対象のステート □Ver1.51　□製作者：月紳士
#  
#　・RPGツクールVX用 RGSS2スクリプト
#
#    ●…書き換えメソッド(競合注意)　◎…メソッドのエイリアス　○…新規メソッド
#
#------------------------------------------------------------------------------
# 更新履歴
# Ver1.50 ○スクリプトの簡略化。
# Ver1.51 ○Ver1.50の簡略化に修正漏れあった為、再修正。
#------------------------------------------------------------------------------
=begin

  ※このスクリプトは月紳士の「エネミー行動パターン改良」に
  　新たな行動条件を追加する拡張スクリプトです。
 　 「エネミー行動パターン改良」(Ver5.50以降)が必要となります。
  　このスクリプトは「エネミー行動パターン改良」より下に挿入してください。
  
  ○ 新たな行動条件の追加。
　　エネミーの行動パターンに、さらなる行動条件を追加します。
　　追加できるのは
    ・特定のステートになっている者のみを対象とする行動条件
    ・特定のステートになっていない者のみを対象とする行動条件
    の二種類です。
    
    追加する行動条件の数は任意で、カスタマイズ項目にて
    行動条件にするステートを登録した後、
    登録した行動条件に合わせたスイッチを用意することで
    設定します。
    
    詳しくはカスタマイズ項目をご覧ください。
    
=end
#==============================================================================
# ■ エネミー行動パターン行動条件追加：対象のステート・モジュール
#==============================================================================
module Extension_Action_Condition_SC

 # カスタマイズ項目------------------------------------------------------------
  
  TOP_SWITCHE = 911 #油
       #↑# 「行動条件追加：対象のステート」に使用するスイッチ郡の、
          # 最初の番号をここで指定します。
          # 「エネミー行動パターン改良」の元もとのスイッチ郡と
          # つなげる必要はありません。
          # ゲーム中の判定に差し支えない番号にしてください。
          
  STATE_CONDITION = [17, -2]
       #↑# 行動条件追加にしたいステートをここで設定します。
          # 数字は行動条件にあげたいステートのIDです。
          # そのステートになっている者を対象とする行動条件を設定します。
          # “, ”(半角カンマと半角スペース)で区切ってください。
          # 数字に“-”(半角マイナス)をつけますと、
          # そのステートになっていない者を対象とする行動条件となります。
   TOP_SWITCHE = 915 #ターゲット
   
   STATE_CONDITION = [74, -2]
=begin

　ここで設定した順番、種類に対応させて、上記TOP_SWITCHEから順番に
　スイッチを用意してください。例をあげて説明しますと…

　毒ステート(ID:2)を行動条件にしたい場合で
　TOP_SWITCHE = 12
　STATE_CONDITION = [2, -2]
　と設定したのであれば、
　スイッチ12が「毒に犯された者を対象とする」行動条件、
　スイッチ13が「毒に犯されていない者を対象とする」行動条件となります。

　スイッチの名前は任意でかまいません。製作中にわかりやすい名前にしてください。
    
=end         
 # ----------------------------------------------------------------------------
end

#==============================================================================
# ■ Game_BattleAction
#------------------------------------------------------------------------------
# 　戦闘行動を扱うクラスです。このクラスは Game_Battler クラスの内部で使用され
# ます。
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # ○ 条件にあうターゲットグループの習得
  #--------------------------------------------------------------------------
  alias sc_conditions_targets conditions_targets
  def conditions_targets(arrays, skill)
    targets = sc_conditions_targets(arrays, skill)
    for array in arrays
      if not Extension_Action_Condition_SC::STATE_CONDITION.empty? and array[0] == 7
        condition = Extension_Action_Condition_SC::TOP_SWITCHE...(Extension_Action_Condition_SC::TOP_SWITCHE + Extension_Action_Condition_SC::STATE_CONDITION.size)
        if condition.include?(array[1])
          new_targets = []
          index = array[1] - Extension_Action_Condition_SC::TOP_SWITCHE
          state_id = Extension_Action_Condition_SC::STATE_CONDITION[index]
          if state_id > 0
            for target in targets
              next unless target.state?(state_id)
              new_targets.push(target)
            end
          elsif state_id < 0
            state_id = state_id.abs 
            for target in targets
              next if target.state?(state_id)
              new_targets.push(target)
            end
          end
          targets = new_targets
        end
      end
    end
    return targets
  end
end

#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。このクラスは Game_Troop クラス ($game_troop) の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ 新・行動条件のセット
  #--------------------------------------------------------------------------
  alias sc_set_new_condition_type set_new_condition_type
  def set_new_condition_type
    unless Extension_Action_Condition_SC::STATE_CONDITION.empty?
      for action in enemy.actions
        if action.condition_type == 6
          if action.condition_param1 >= Extension_Action_Condition_SC::TOP_SWITCHE
            if action.condition_param1 < Extension_Action_Condition_SC::TOP_SWITCHE + Extension_Action_Condition_SC::STATE_CONDITION.size
              action.condition_type = 7
            end
          end
        end
      end
    end
    sc_set_new_condition_type
  end
end