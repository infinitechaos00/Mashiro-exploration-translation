#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 無敵ステート - KGC_Invincible ◆ VX ◆
#_/    ◇ Last update : 2009/09/13 ◇
#_/----------------------------------------------------------------------------
#_/  無敵状態になるステートを作成します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#~ 完全無敵
#~ ステートのメモ欄に <無敵> を追加します。
#~ このステートが付与されている間は、以下の攻撃をすべて無効化します。
#~     通常攻撃
#~     対象が「敵」のスキル/アイテム

#~ 物理無敵
#~ ステートのメモ欄に <物理無敵> を追加します。
#~ このステートが付与されている間は、物理攻撃を無効化します。
#~ 物理攻撃は、次のものが該当します。
#~     通常攻撃
#~     次を満たすスキル/アイテム
#~         対象が「敵」
#~         「物理攻撃」がチェックされている
#~         「無敵タイプ」が設定されていない

#~ 魔法無敵
#~ ステートのメモ欄に <魔法無敵> を追加します。
#~ このステートが付与されている間は、魔法攻撃を無効化します。
#~ 魔法攻撃は、次のものが該当します。

#~     次を満たすスキル/アイテム
#~         対象が「敵」
#~         「物理攻撃」がチェックされていない
#~         「無敵タイプ」が設定されていない

#~ 無敵タイプ
#~ スキル/アイテムおよびステートのメモ欄に <無敵タイプ x> を追加します。
#~ このステートが付与されている間は、同じ無敵タイプが設定されたスキル/アイテムを無効化します。
#~ 無敵タイプが設定されたスキル/アイテムは、物理無敵と魔法無敵では無効化されなくなります。

$imported = {} if $imported == nil
$imported["Invincible"] = true

module KGC
module Invincible
  module Regexp
    # 無敵タイプ
    INV_TYPE = /<(?:INVINCIBLE_TYPE|無敵タイプ)\s*([^>]+)>/i

    module State
      # 無敵
      INVINCIBLE = /<(物理|魔法)?(?:INVINCIBLE|無敵)(_PHYSIC|_MAGIC)?>/i
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
  # ○ 無敵ステートのキャッシュを生成
  #--------------------------------------------------------------------------
  def create_invincible_cache
    @__inv_type = nil

    self.note.each_line { |line|
      if line =~ KGC::Invincible::Regexp::INV_TYPE
        @__inv_type = $1
      end
    }

    @__inv_cached = true
  end
  #--------------------------------------------------------------------------
  # ○ 無敵タイプ
  #--------------------------------------------------------------------------
  def invincible_type
    create_invincible_cache unless @__inv_cached
    return @__inv_type
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # ○ 無敵ステートのキャッシュを生成
  #--------------------------------------------------------------------------
  def create_invincible_cache
    @__inv_all    = false
    @__inv_physic = false
    @__inv_magic  = false
    @__inv_type   = nil

    self.note.each_line { |line|
      if line =~ KGC::Invincible::Regexp::INV_TYPE
        @__inv_type = $1
      end
      if line =~ KGC::Invincible::Regexp::State::INVINCIBLE
        valid = false
        if $1 == "物理" || ($2 && $2.upcase == "_PHYSIC")
          @__inv_physic = true
          valid = true
        end
        if $1 == "魔法" || ($2 && $2.upcase == "_MAGIC")
          @__inv_magic = true
          valid = true
        end
        @__inv_all = true unless valid
      end
    }

    @__inv_cached = true
  end
  #--------------------------------------------------------------------------
  # ○ 無敵ステートか
  #--------------------------------------------------------------------------
  def is_invincible?
    return (all_invincible? ||
      physic_invincible? ||
      magic_invincible? ||
      invincible_type != nil
    )
  end
  #--------------------------------------------------------------------------
  # ○ 無敵タイプ
  #--------------------------------------------------------------------------
  def invincible_type
    create_invincible_cache unless @__inv_cached
    return @__inv_type
  end
  #--------------------------------------------------------------------------
  # ○ 完全無敵
  #--------------------------------------------------------------------------
  def all_invincible
    create_invincible_cache if @__inv_all == nil
    return @__inv_all
  end
  alias all_invincible? all_invincible
  #--------------------------------------------------------------------------
  # ○ 物理無敵
  #--------------------------------------------------------------------------
  def physic_invincible
    create_invincible_cache if @__inv_physic == nil
    return @__inv_physic
  end
  alias physic_invincible? physic_invincible
  #--------------------------------------------------------------------------
  # ○ 魔法無敵
  #--------------------------------------------------------------------------
  def magic_invincible
    create_invincible_cache if @__inv_magic == nil
    return @__inv_magic
  end
  alias magic_invincible? magic_invincible
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :invincible               # 無敵判定フラグ
  #--------------------------------------------------------------------------
  # ● 行動効果の保持用変数をクリア
  #--------------------------------------------------------------------------
  alias clear_action_results_KGC_Invincible clear_action_results
  def clear_action_results
    clear_action_results_KGC_Invincible

    @invincible = false
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の効果適用
  #     attacker : 攻撃者
  #--------------------------------------------------------------------------
  alias attack_effect_KGC_Invincible attack_effect
  def attack_effect(attacker)
    invincible_effect(attacker)
    return if @skipped

    attack_effect_KGC_Invincible(attacker)
  end
  #--------------------------------------------------------------------------
  # ● スキルの効果適用
  #     user  : スキルの使用者
  #     skill : スキル
  #--------------------------------------------------------------------------
  alias skill_effect_KGC_Invincible skill_effect
  def skill_effect(user, skill)
    invincible_effect(user, skill)
    return if @skipped

    skill_effect_KGC_Invincible(user, skill)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの効果適用
  #     user : アイテムの使用者
  #     item : アイテム
  #--------------------------------------------------------------------------
  alias item_effect_KGC_Invincible item_effect
  def item_effect(user, item)
    invincible_effect(user, item)
    return if @skipped

    item_effect_KGC_Invincible(user, item)
  end
  #--------------------------------------------------------------------------
  # ○ 無敵効果の適用
  #     user : 行動者
  #     obj  : スキル/アイテム (nil なら通常攻撃)
  #--------------------------------------------------------------------------
  def invincible_effect(user, obj = nil)
    @invincible = false
    clear_action_results
    return unless invincible?(user, obj)

    @skipped    = true
    @invincible = true
  end
  #--------------------------------------------------------------------------
  # ○ 無敵判定
  #     user : 行動者
  #     obj  : スキル/アイテム (nil なら通常攻撃)
  #--------------------------------------------------------------------------
  def invincible?(user, obj = nil)
    if !(actor? ^ user.actor?) && obj != nil
      return false if obj.for_friend?         # 味方なら無効化しない
    end

    physic = (obj == nil ? true : obj.physical_attack)  # 物理フラグ
    type   = (obj == nil ? nil  : obj.invincible_type)  # 無敵タイプ

    states.each { |state|
      next unless state.is_invincible?

      return true if state.all_invincible?
      if type != nil
        # 無敵タイプ指定あり
        return true if state.invincible_type == type
      else
        # 無敵タイプ指定なし
        return true if  physic && state.physic_invincible?
        return true if !physic && state.magic_invincible?
      end
    }
    return false
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 行動結果の表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  alias display_action_effects_KGC_Invincible display_action_effects
  def display_action_effects(target, obj = nil)
    display_action_effects_KGC_Invincible(target, obj)

    display_invincible(target, obj) if target.invincible
  end
  #--------------------------------------------------------------------------
  # ○ 無敵時のメッセージを表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_invincible(target, obj)
    line_number = @message_window.line_number
    display_failure(target, obj)
    @message_window.back_to(line_number)
  end
end
