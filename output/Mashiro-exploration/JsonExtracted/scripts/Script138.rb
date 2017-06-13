#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 割合ダメージ - KGC_RateDamage ◆ VX ◆
#_/    ◇ Last update : 2008/08/28 ◇
#_/----------------------------------------------------------------------------
#_/  割合ダメージ機能を追加します。
#_/============================================================================
#_/ 【基本機能】≪攻撃属性設定≫ より上に導入してください。
#_/  ダメージ値がおかしい場合は、導入位置を移動してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

$imported = {} if $imported == nil
$imported["RateDamage"] = true

module KGC
module RateDamage
  module Regexp
    module UsableItem
      # ◆ 割合ダメージ
      RATE_DAMAGE = /<((?:MAX_|最大値))?(?:RATE_DAMAGE|割合ダメージ)>/i
    end
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 割合ダメージのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_rate_damage_cache
    @__rate_damage = false
    @__rate_damage_max = false

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::RateDamage::Regexp::UsableItem::RATE_DAMAGE
        # 割合ダメージ
        @__rate_damage = true
        @__rate_damage_max = ($1 != nil)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 割合ダメージか
  #--------------------------------------------------------------------------
  def rate_damage?
    create_rate_damage_cache if @__rate_damage == nil
    return @__rate_damage
  end
  #--------------------------------------------------------------------------
  # ○ 最大値割合ダメージか
  #--------------------------------------------------------------------------
  def rate_damage_max?
    create_rate_damage_cache if @__rate_damage_max == nil
    return @__rate_damage_max
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムによるダメージ計算
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  alias make_obj_damage_value_KGC_RateDamage make_obj_damage_value
  def make_obj_damage_value(user, obj)
    if obj == nil || !obj.rate_damage?
      # 割合ダメージでない
      return make_obj_damage_value_KGC_RateDamage(user, obj)
    end

    damage = obj.base_damage
    if obj.damage_to_mp
      value = (obj.rate_damage_max? ? maxmp : mp)
    else
      value = (obj.rate_damage_max? ? maxhp : hp)
    end
    damage = value * damage / 100
    damage = damage * elements_max_rate(obj.element_set) / 100  # 属性修正
    damage = apply_variance(damage, obj.variance)               # 分散
    damage = apply_guard(damage)                                # 防御修正
    if obj.damage_to_mp
      @mp_damage = damage
    else
      @hp_damage = damage
    end
  end
end
