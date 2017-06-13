=begin
■必中スキル＆ステート RGSS2 DAIpage■ v1.0

●機能●
　メモ欄に"必中"の文字列が含まれるスキルは対象の回避率や設定した命中率に関係な
　く必ず命中します。
　同様にメモ欄に"必中"の文字列が含まれるステートが付加されているキャラの行動は
　全て命中します。
　クリティカルスキルのお供にどうでしょうか。

●再定義している箇所●
　Game_Battlerをエイリアス
　※同じ箇所を変更するスクリプトと併用した場合は競合する可能性があります。

●更新履歴●
08/09/16：公開

=end
#==============================================================================
# ■ カスタマイズポイント
#==============================================================================
module DAI_INSIDE_HIT
  
  # 暗闇状態の時は必中スキル・ステートでも1/4（25%）にする。（ true / false )
  REDUCE = true
  
  # 判別用文字列（スキル）
  SK_WORD = "必中"
  
  # 判別用文字列（ステート）
  ST_WORD = "必中"
  
end
#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler
  #--------------------------------------------------------------------------
  # ● 最終命中率の計算
  #--------------------------------------------------------------------------
  alias dai_inside_calc_hit calc_hit
  def calc_hit(user, obj = nil)
    for state in user.states
      if state.note.include?(DAI_INSIDE_HIT::ST_WORD)
        hit = 100
        hit /= 4 if DAI_INSIDE_HIT::REDUCE && user.reduce_hit_ratio?
        return hit
      end
    end
    if obj.is_a?(RPG::Skill)
      if obj.note.include?(DAI_INSIDE_HIT::SK_WORD)
        hit = 100
        hit /= 4 if DAI_INSIDE_HIT::REDUCE && user.reduce_hit_ratio?
        return hit
      else
        dai_inside_calc_hit(user, obj)
      end
    else
      dai_inside_calc_hit(user, obj)
    end
  end
  #--------------------------------------------------------------------------
  # ● 最終回避率の計算
  #--------------------------------------------------------------------------
  alias dai_inside_calc_eva calc_eva #回避率の計算をする時
  def calc_eva(user, obj = nil) #
    for state in user.states
      return 0 if state.note.include?(DAI_INSIDE_HIT::ST_WORD)
    end
    if !obj.nil? #通常、!（エクスクラメーションマーク１つ）の場合は否定(Not)になります。
      if obj.note.include?(DAI_INSIDE_HIT::SK_WORD)
        return 0
      else
        dai_inside_calc_eva(user, obj)
      end
    else
      dai_inside_calc_eva(user, obj)
    end
  end
end
#~ nilは存在しないという意味。
#~ 対して　""は「何も無い」が存在している。空白の存在。
#~ book.nil?
#~ もしbook自体が存在しないなら、上記はtrueを返す。