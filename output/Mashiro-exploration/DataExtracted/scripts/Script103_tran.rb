#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ スリップダメージ拡張 - KGC_SlipDamageExtension ◆ VX ◆
#_/    ◇ Last update : 2009/09/13 ◇
#_/----------------------------------------------------------------------------
#_/  スリップダメージの設定を詳細化します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ ステートのメモ欄に、<スリップ [HP|MP] n[%] [,n]> を追加します。

#~ [HP|MP]の部分は、HP または MP のどちらを対象とするかを記述します。
#~ 省略した場合は HP となります。

#~ １つ目のnには、ターンごとの回復・ダメージ量を記述します。
#~ 指定した値が正の場合は回復、負の場合はダメージとして扱われます。
#~ % を付けた場合は最大 HP or MP に対する割合になります。

#~ ２つ目のnには、マップ上で１歩歩いた際の回復・ダメージ量を記述します。
#~ こちらは % を付けることはできません。

#~ # HP が毎ターン MaxHP の 5% 分、歩くごとに 2 減少
#~ <スリップ HP -5%, -2>
#~ # MP が毎ターン MaxMP の 3% 分、歩くごとに 1 回復
#~ <スリップ MP 3%, 1>
#~ # MP が毎ターン MaxMP の 10% 分減少
#~ <スリップ MP -10%>

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module SlipDamageExtension
  # ◆ 歩行ダメージ時のフラッシュ色
  DAMAGE_FLASH_COLOR    = Color.new(255, 0, 0, 64)
  # ◆ 歩行ダメージ時のフラッシュ時間 (フレーム)
  DAMAGE_FLASH_DURATION = 4
  # ◆ 歩行ダメージで戦闘不能にする
  #  true  : HP 0 になる。
  #  false : HP 1 で止まる。
  DIE_MAP_DAMAGE = false
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["SlipDamageExtension"] = true

module KGC::SlipDamageExtension
  # 正規表現
  module Regexp
    # ステート
    module State
      # スリップダメージ
      SLIP_DAMAGE = /<(?:SLIP|スリップ)\s*([HM]P)?\s*([\-\+]?\d+)([%％])?
        (?:\s*,\s*([\-\+]?\d+))?\s*>/ix
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # ○ 「スリップダメージ拡張」のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_slip_damage_extension_cache
    @__slip_damage = false
    @__slip_damage_hp_rate  = 0
    @__slip_damage_hp_value = 0
    @__slip_damage_hp_map   = 0
    @__slip_damage_mp_rate  = 0
    @__slip_damage_mp_value = 0
    @__slip_damage_mp_map   = 0

    self.note.each_line { |line|
      case line
      when KGC::SlipDamageExtension::Regexp::State::SLIP_DAMAGE
        # スリップダメージ
        @__slip_damage = true
        analyse_slip_damage($~)
      end
    }

    # デフォルトのスリップダメージ量を設定
    unless @__slip_damage
      @__slip_damage_hp_rate = 10
      @__slip_damage_hp_map = 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ スリップダメージの解析
  #--------------------------------------------------------------------------
  def analyse_slip_damage(match)
    # タイプ判定
    if match[1] == nil
      type = :hp
    else
      if match[1] =~ /MP/i
        type = :mp
      else
        type = :hp
      end
    end
    # ダメージ量取得
    n = match[2].to_i
    # 即値 or 割合判定
    is_rate = (match[3] != nil)
    # マップダメージ取得
    map_n = (match[4] != nil ? match[4].to_i : 0)

    # スリップダメージ値加算
    case type
    when :hp
      if is_rate
        @__slip_damage_hp_rate -= n
      else
        @__slip_damage_hp_value -= n
      end
      @__slip_damage_hp_map -= map_n
    when :mp
      if is_rate
        @__slip_damage_mp_rate -= n
      else
        @__slip_damage_mp_value -= n
      end
      @__slip_damage_mp_map -= map_n
    end
  end
  #--------------------------------------------------------------------------
  # ● スリップダメージ
  #--------------------------------------------------------------------------
  unless method_defined?(:slip_damage_KGC_SlipDamageExtension)
    alias slip_damage_KGC_SlipDamageExtension slip_damage
  end
  def slip_damage
    create_slip_damage_extension_cache if @__slip_damage == nil
    return (@__slip_damage || slip_damage_KGC_SlipDamageExtension)
  end
  #--------------------------------------------------------------------------
  # ○ HP スリップダメージ (割合)
  #--------------------------------------------------------------------------
  def slip_damage_hp_rate
    create_slip_damage_extension_cache if @__slip_damage_hp_rate == nil
    return @__slip_damage_hp_rate
  end
  #--------------------------------------------------------------------------
  # ○ HP スリップダメージ (即値)
  #--------------------------------------------------------------------------
  def slip_damage_hp_value
    create_slip_damage_extension_cache if @__slip_damage_hp_value == nil
    return @__slip_damage_hp_value
  end
  #--------------------------------------------------------------------------
  # ○ HP スリップダメージ (マップ)
  #--------------------------------------------------------------------------
  def slip_damage_hp_map
    create_slip_damage_extension_cache if @__slip_damage_hp_map == nil
    return @__slip_damage_hp_map
  end
  #--------------------------------------------------------------------------
  # ○ MP スリップダメージ (割合)
  #--------------------------------------------------------------------------
  def slip_damage_mp_rate
    create_slip_damage_extension_cache if @__slip_damage_mp_rate == nil
    return @__slip_damage_mp_rate
  end
  #--------------------------------------------------------------------------
  # ○ MP スリップダメージ (即値)
  #--------------------------------------------------------------------------
  def slip_damage_mp_value
    create_slip_damage_extension_cache if @__slip_damage_mp_value == nil
    return @__slip_damage_mp_value
  end
  #--------------------------------------------------------------------------
  # ○ MP スリップダメージ (マップ)
  #--------------------------------------------------------------------------
  def slip_damage_mp_map
    create_slip_damage_extension_cache if @__slip_damage_mp_map == nil
    return @__slip_damage_mp_map
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● スリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect
    return unless slip_damage?

    slip_damage_effect_hp
    slip_damage_effect_mp
  end
  #--------------------------------------------------------------------------
  # ○ HP スリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect_hp
    return if dead?

    n = 0
    self.states.each { |state|
      next unless state.slip_damage
      n += self.maxhp * state.slip_damage_hp_rate / 100
      n += state.slip_damage_hp_value
    }
    return if n == 0

    @hp_damage = [n, self.hp - 1].min
    self.hp -= @hp_damage
  end
  #--------------------------------------------------------------------------
  # ○ MP スリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect_mp
    return if dead?

    n = 0
    self.states.each { |state|
      next unless state.slip_damage
      n += self.maxmp * state.slip_damage_mp_rate / 100
      n += state.slip_damage_mp_value
    }
    return if n == 0

    @mp_damage = [n, self.mp].min
    self.mp -= @mp_damage
  end
  #--------------------------------------------------------------------------
  # ○ 歩行時のスリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect_on_walk
    last_hp = self.hp
    last_mp = self.mp
    self.states.each { |state|
      next unless state.slip_damage
      hp_damage = state.slip_damage_hp_map
      unless KGC::SlipDamageExtension::DIE_MAP_DAMAGE
        hp_damage = [hp_damage, self.hp - 1].min
      end
      self.hp -= hp_damage
      self.mp -= state.slip_damage_mp_map
    }
    # ダメージを受けた場合はフラッシュ
    if self.hp < last_hp || self.mp < last_mp
      $game_map.screen.start_flash(
        KGC::SlipDamageExtension::DAMAGE_FLASH_COLOR,
        KGC::SlipDamageExtension::DAMAGE_FLASH_DURATION)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 歩行時の自動回復の実行
  #--------------------------------------------------------------------------
  def do_auto_recovery_on_walk
    return if dead?

    if auto_hp_recover
      self.hp += 1
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● プレイヤーが 1 歩動いたときの処理
  #--------------------------------------------------------------------------
  def on_player_walk
    for actor in members
      if actor.slip_damage?
        actor.slip_damage_effect_on_walk
      end
      actor.do_auto_recovery_on_walk
    end
  end
end
