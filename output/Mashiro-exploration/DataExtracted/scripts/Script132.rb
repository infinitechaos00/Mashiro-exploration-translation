# ▽▽▽ XRXSv44. ベーシック・セッティング ▽▽▽
#
# publish 2010/ 4/23
# update  - 11/ 1/22a
#
# ※素材セクション指定 - 特殊効果詰め合わせシリーズより上
#
#~ 　標準のRGSS内で、能力値やダメージ計算に関わるものを
#~ 　あらかた上書きして土台を設定するための素材です。

#~ 　このスクリプトを導入すると魔法防御力、魔法回避率、器用さ、MP軽減力、幸運と
#~ 　エネミーのレベルは設定に関わらず、あるものとして扱われます。

#~ 　　ただし、
#~ 　弓などでは器用さを攻撃力の代わりに使用しますが、デフォルトで「器用さ＝攻撃力」で、
#~ 　魔法防御力は、デフォルトで「＝精神力」なので結局同じだったり、
#~ 　魔法回避率は、デフォルトで０なので、

#~ 　結局はVX標準どおりに働き、値を意識させない感じになります。

#~ 専用機能
#~ 　\cri[n]
#~ 　　スキルのメモに書くことで、そのスキルでのクリティカル発生確率が n アップします。
#~ 　\vrc[n]
#~ 　　武器・エネミーのメモに書くことで、通常攻撃の分散度が n になります。
#~ 　\atk_f[n]
#~ 　　スキル・アイテムのメモに書くことで、打撃関係度が n 増加します。
#~ 　\spi_f[n]
#~ 　　スキル・アイテムのメモに書くことで、精神関係度が n 増加します。
#~ 魔法防御力MND
#~ 装備品では\mnd[]で上昇。
#~ 魔法回避率MEVA
#~ 装備品では\meva[]で上昇。
#~ 器用さDEX
#~ 装備品では\dex[]で上昇。
#~ MP軽減力MPR
#~ 装備品では\mpr[]で上昇。
#~ 幸運LCK
#~ 装備品では\lck[]で上昇。
#~ 命中率HIT
#~ 装備品では\hit[]で上昇。
#~ 必殺率CRI
#~ 装備品では\cri[]で上昇。
#==============================================================================
# カスタマイズポイント
#==============================================================================
module Vocab
  def self.mnd
    return "魔法防御"
  end
  def self.meva
    return "魔法回避"
  end
  def self.dex
    return "器用さ"
  end
  def self.mpr
    return "消費軽減"
  end
  def self.lck
    return "幸運"
  end
  def self.str
    return "STR"
  end
  def self.vit
    return "VIT"
  end
  def self.int
    return "INT"
  end
  def self.mnd_base
    return "MND"
  end
  def self.agi_base
    return "AGI"
  end
  def self.equip_atk
    return "装備攻撃力"
  end
  def self.equip_def
    return "装備防御力"
  end
  def self.equip_spi
    return "装備魔法力"
  end
end
module XRXSV44
  #
  # ダメージ計算式タイプとダメージレート
  #    0 : ＶＸタイプ　(レート4.0)
  #        2000タイプ　(レート1.0)
  #        ＤＱタイプ　(レート0.5)
  #    1 : FFタイプ
  #    2 : ポケモンタイプ
  #　　3 : シレンＤタイプ
  #    4 : パワー減算　(レート無視、分散度0固定します)
  #
  DamageValueType = 0
  DamageValueRate = 4.0
  #
  # [パワー減算]常に50の倍数にする？
  #
  DamageValueMultiHalfHundredize = false
  #
  # 器用さ(DEX)攻撃とするアイコンインデックス
  #
  DEXWeaponIconIndexes = [16,17,22,23,24,25]
  #
  # 魔法防御力を攻撃に使用する属性ID(例 : 神聖)
  #
  MentalSkillElementID = 15
  #
  # クリティカル時のダメージ倍率
  #
  CriticalRate = 3.0
  #
  #              0 : 精神力 (VX標準)
  # [魔法防御力] 1 : 元々の精神力
  #              2 : （元々の防御力＋元々の精神力）÷２
  #　　　　　　　3 : （防御力＋精神力）÷２
  TypeMND = 0
  #
  #              0 : 常に0 (VX標準)
  # [魔法回避率] 1 : 物理回避と常に同じ(あるいは n で割る)
  #                  (1で割る事で常に同じに)
  #
  TypeMEVA  = 1
  TypeMEVAn = 2
  #
  #              0 : 攻撃力 (VX標準)
  # [器用さ]     1 : 素早さ
  #              2 : （攻撃力＋素早さ）÷２
  #
  TypeDEX = 0
  RateDEX = 1.0
  #
  #              0 : 常に0 (VX標準)
  # [MP軽減力]   1 : 精神力
  #
  TypeMPR = 0
  RateMPR = 0.1
  #
  #              0 : 常に0 (VX標準)
  # [幸運] 　　  1 : １～レベルランダム
  #
  #
  TypeLCK = 0
  #
  # 器用さ→命中率レート
  # 器用さ→必殺率レート
  # 素早さ→回避率レート
  # 幸運　→　〃　レート
  #
  DEXtoHITRate = 0.0
  DEXtoCRIRate = 0.0
  AGItoEVARate = 0.0
  LCKRate      = 0.0
  #
  # 基本能力値倍率
  #
  PowerRate = 1.0
  #
  # 通常攻撃の[分散度] (VX標準 : 20)
  #
  AttackVariance = 15
  #
  # エネミーパラメータのぶれ幅 [単位:％] (VX標準 : 0)
  #
  EnemyPowerBlur = 0
  #
  # 3倍体の出現率(フリーエンカウントでのみ発生します) [単位:%]
  #
  MultiplyEnemyProbability = 0
  MultiplyEnemyNameSuffix  = "！"
  #
  # クリティカル発生確率タイプ
  #    0 : 固定 (VX標準)
  #    1 : 相手との素早さ差× Rate ％発生率がアップする
  #
  CriticalType = 0
  CriticalTypeRate = 0.1
  #
  # スキルのクリティカルタイプ
  #    0 : スキルはクリティカルしない (VX標準)
  #    1 : [物理攻撃]スキルのみクリティカル
  #    2 : [基本ダメージ]が1以上のスキルのみクリティカルする
  #    3 : 回復系含む、なんでもクリティカルする
  #
  SkillCriticalType = 2
  #
  # 分散度 0 はクリティカルを禁止する？(固定ダメージへの配慮)
  #
  FixDamageCriticalBan = true
  #
  # エネミーのレベルタイプ
  #     0 : データベースのエネミーIDをそのままレベルとして扱う
  #     1 : データベースで設定された攻撃力を 8 で割った値をレベルとして扱う
  #     2 : データベースのMPの下２ケタをレベルとして扱う。
  #
  EnemyLevelType   = 0
  EnemyLevelType1D = 8  # ←タイプ1の時、割る値
  #
  #
  #
end
class Game_Actor < Game_Battler
  def maxhp_limit
    return 9999999   # 最大HP限界
  end
  def maxmp_limit
    return 9999999   # 最大MP限界
  end
  def base_hit
    return 95     # 素手のときの命中率
  end
  def base_eva
    return 5      # 何も装備してない時の基本回避率
  end
  def base_cri
    return 4      # 何も装備してない時の基本クリティカル率
  end
  def cri_bonus
    return 4      # オプション「クリティカル頻発」によるクリティカル率上昇値
  end
  def odds
    return 4 - self.class.position # 「狙われやすさ」式
  end
end
class Game_Enemy < Game_Battler
  def base_cri
    return 10     # 「クリティカルあり」の場合の基本クリティカル率
  end
end
class Game_Battler
  def power_limit
    return 999999 # 各パラメーターの限界
  end
end
#==============================================================================
# ガード記述への対応
#==============================================================================
class RPG::UsableItem
  def for_guard?
    return self.note[/\\guard/]
  end
end
#==============================================================================
# 設定対応 - アクター/エネミー
#==============================================================================
class Game_Battler
  attr_accessor :power
  attr_accessor :power_skill
  attr_accessor :power_increase_turn
  attr_accessor :display_power_type
  attr_accessor :display_power_on
  attr_accessor :hp_damage
  def skills
    return []
  end
  #--------------------------------------------------------------------------
  # パワーの設定
  #--------------------------------------------------------------------------
  def power_type(obj)
    return 1 if obj.for_guard?
    return (obj.mental? ? 3 : (obj.magic? ? 2 : 0))
  end
  def power_set(obj)
    self.power_skill = obj
    pow  = (obj ? obj.base_damage : 0)
    pow += self.power_increase_turn.to_i
    self.power = pow
    obj = RPG::Attack.new if obj == nil
    self.display_power_type = power_type(obj)
    self.display_power_on = true
  end
  def power_refresh
    power_set(self.power_skill)
  end
  #--------------------------------------------------------------------------
  # 攻撃力の取得
  #--------------------------------------------------------------------------
  def evaluate_atk(user, obj)
    weapon = user.weapons[0]
    long_range_weapon = (weapon != nil and XRXSV44::DEXWeaponIconIndexes.include?(weapon.icon_index))
    long_range_action = false
    if obj.attack?
      long_range_action = long_range_weapon
    elsif obj.skill?
      long_range_action = (!obj.physical_attack or long_range_weapon)
    end
    patk = (long_range_action ? user.dex : user.atk)
    matk = (obj.mental?       ? user.mnd : user.spi)
    return patk, matk
  end
  #--------------------------------------------------------------------------
  # ダメージ計算式の設定
  #--------------------------------------------------------------------------
  def evaluate_damage(user, obj)
    patk,  matk  = evaluate_atk(user, obj)
    ignore_defense = (obj.base_damage <= 0 or obj.ignore_defense)
    pdef = (ignore_defense ? 0 : self.def)
    mdef = (ignore_defense ? 0 : self.mnd)
    damage  = evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
    damage  =  0 if damage < 0
    damage *= -1 if obj.base_damage < 0
    return damage
  end
  case XRXSV44::DamageValueType
  when 1 # FF
    def evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
      p_damage = ((user.level + patk) * (user.level * patk) / 1024 + patk) *
                 (256 - pdef) * obj.atk_f / 100 / 256
      m_damage = (user.level * 2 + matk) *
                 (256 - mdef) * obj.spi_f / 100 / 256
      damage = (p_damage + m_damage)
      damage  = (damage * XRXSV44::DamageValueRate).to_i
      damage += obj.base_damage.abs
      return damage
    end
  when 2 # ポケモン
    def evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
      if pdef == 0 or mdef== 0
        pdef = 1
        mdef = 1
        n = 1
      else
        n = (user.level + 10) * 2
      end
      p_damage = (n * patk / pdef) * obj.atk_f / 100
      m_damage = (n * matk / mdef) * obj.spi_f / 100
      damage = (p_damage + m_damage)
      damage  = (damage * XRXSV44::DamageValueRate).to_i
      damage += obj.base_damage.abs
      return damage
    end
  when 3 # シレンD
    def evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
      p_damage = (patk - pdef/2) * (16 + user.equip_atk) / 16 * obj.atk_f / 100
      m_damage = (matk - mdef/2) * (16 + user.equip_spi) / 16 * obj.spi_f / 100
      damage = p_damage + m_damage
      self.equip_def.times do
        damage = (damage * 15 / 16.0).ceil
      end
      damage  = (damage * XRXSV44::DamageValueRate).to_i
      damage += obj.base_damage.abs
      return damage
    end
  when 4 # パワー減算
    def evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
      if obj.base_damage <= -1
        damage = obj.base_damage.abs
      else
        damage = user.power.to_i - self.power.to_i
      end
      return damage
    end
  else # 0 :VX, 2000, DQ
    def evaluate_damage_power(user, obj, patk, matk, pdef, mdef)
      p_damage = (patk - pdef/2) * obj.atk_f / 100
      m_damage = (matk - mdef/2) * obj.spi_f / 200
      damage = (p_damage + m_damage)
      damage  = (damage * XRXSV44::DamageValueRate).to_i
      damage += obj.base_damage.abs
      return damage
    end
  end
  #--------------------------------------------------------------------------
  # ● 最終命中率の計算
  #--------------------------------------------------------------------------
  alias xrxsv44_calc_hit calc_hit
  def calc_hit(user, obj = nil)
    hit  = xrxsv44_calc_hit(user, obj)
    hit += (user.lck * XRXSV44::LCKRate).to_i
    return hit
  end
  #--------------------------------------------------------------------------
  # ● 最終回避率の計算 (101%以上の命中率により回避カット,+幸運)
  #--------------------------------------------------------------------------
  alias xrxsv44_calc_eva calc_eva
  def calc_eva(user, obj = nil)
    # 物理回避率
    eva = xrxsv44_calc_eva(user, obj)
    # 魔法回避率
    if obj and not obj.physical_attack and eva == 0 and parriable?
      eva = self.meva
    end
    # 幸運
    eva += (self.lck * XRXSV44::LCKRate).to_i
    # 命中と回避による計算
    hit = calc_hit(user, obj)
    if hit >= 101
      eva -= (hit - 100)
    end
    return eva
  end
  #--------------------------------------------------------------------------
  # クリティカル発生判定
  #--------------------------------------------------------------------------
  def evaluate_critical(user, obj)
    return  false if prevent_critical       # クリティカル防止？
    percent  = (user.cri + obj.cri)
    percent += (user.lck * XRXSV44::LCKRate).to_i
    if XRXSV44::CriticalType == 1
      percent += ((user.agi - self.agi) * XRXSV44::CriticalTypeRate).to_i
    end
    return (rand(100) < percent)
  end
  #--------------------------------------------------------------------------
  # ○ ダメージ計算の実行
  #--------------------------------------------------------------------------
  def make_damage_value(user, obj)
    damage = obj.base_damage                        # 基本ダメージを取得
    if damage != 0                                  # ダメージが0以外
      damage = evaluate_damage(user, obj)
      if obj.has_critical?
        @critical = evaluate_critical(user, obj)    # クリティカル判定
        if @critical                                # クリティカル修正
          damage = (damage * XRXSV44::CriticalRate).to_i
        end
      end
      if damage == 0 and obj.graze?                 # ダメージが 0
        damage = rand(2)                            # 1/2 の確率で 1 ダメージ
      end
      damage *= elements_max_rate(obj.element_set)    # 属性修正
      damage /= 100
      damage = apply_variance(damage, obj.variance) unless XRXSV44::DamageValueType == 4  # 分散
      damage = apply_guard(damage)                    # 防御修正
    end
    if obj.damage_to_mp
      @mp_damage = damage                           # MP にダメージ
    else
      @hp_damage = damage                           # HP にダメージ
    end
    return damage
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃によるダメージ計算
  #--------------------------------------------------------------------------
  def make_attack_damage_value(attacker)
    obj = RPG::Attack.new
    obj.element_set = attacker.element_set
    obj.variance    = attacker.attack_variance
    make_damage_value(attacker, obj)
  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムによるダメージ計算
  #--------------------------------------------------------------------------
  def make_obj_damage_value(user, obj)
    make_damage_value(user, obj)
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の取得
  #--------------------------------------------------------------------------
  def atk
    n = [[(base_atk * XRXSV44::PowerRate).to_i + @atk_plus, 1].max, power_limit].min
    for state in states do n *= state.atk_rate / 100.0 end
    n = [[Integer(n), 1].max, power_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 防御力の取得
  #--------------------------------------------------------------------------
  def def
    n = [[(base_def * XRXSV44::PowerRate).to_i  + @def_plus, 1].max, power_limit].min
    for state in states do n *= state.def_rate / 100.0 end
    n = [[Integer(n), 1].max, power_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 精神力の取得
  #--------------------------------------------------------------------------
  def spi
    n = [[(base_spi * XRXSV44::PowerRate).to_i  + @spi_plus, 1].max, power_limit].min
    for state in states do n *= state.spi_rate / 100.0 end
    n = [[Integer(n), 1].max, power_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 敏捷性の取得
  #--------------------------------------------------------------------------
  def agi
    n = [[(base_agi * XRXSV44::PowerRate).to_i  + @agi_plus, 1].max, power_limit].min
    for state in states do n *= state.agi_rate / 100.0 end
    n = [[Integer(n), 1].max, power_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 命中率の取得
  #--------------------------------------------------------------------------
  def hit
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ 回避率の取得
  #--------------------------------------------------------------------------
  def eva
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ クリティカル率の取得
  #--------------------------------------------------------------------------
  def cri
    return 0
  end
end
#==============================================================================
# 対応 - アクター
#==============================================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● MaxMP の取得
  #--------------------------------------------------------------------------
  def maxmp
    return [[base_maxmp + @maxmp_plus, 0].max, maxmp_limit].min
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  def hit
    if two_swords_style
      n1 = weapons[0] == nil ? base_hit : weapons[0].hit
      n2 = weapons[1] == nil ? base_hit : weapons[1].hit
      n = [n1, n2].min
    else
      n = weapons[0] == nil ? base_hit : weapons[0].hit
    end
    n += (XRXSV44::DEXtoHITRate * self.dex).to_i
    return n
  end
  #--------------------------------------------------------------------------
  # ● 回避率の取得
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for item in armors.compact do n += item.eva end
    n += (XRXSV44::AGItoEVARate * self.agi).to_i
    return n
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得 *
  #--------------------------------------------------------------------------
  def cri
    n = base_cri
    n += cri_bonus if actor.critical_bonus
    for weapon in weapons.compact
      n += cri_bonus if weapon.critical_bonus
    end
    n += (XRXSV44::DEXtoCRIRate * self.dex).to_i
    return n
  end
end
#==============================================================================
# 対応 - エネミー
#==============================================================================
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # レベルの取得
  #--------------------------------------------------------------------------
  case XRXSV44::EnemyLevelType
  when 0
    def level
      return @enemy_id
    end
  when 1
    def level
      return self.base_atk / XRXSV44::EnemyLevelType1D
    end
  when 2
    def level
      return self.maxmp % 100
    end
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得 *
  #--------------------------------------------------------------------------
  def hit
    return (enemy.hit + (XRXSV44::DEXtoHITRate * self.dex).to_i)
  end
  #--------------------------------------------------------------------------
  # ● 回避率の取得 *
  #--------------------------------------------------------------------------
  def eva
    return (enemy.eva + (XRXSV44::AGItoEVARate * self.agi).to_i)
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得 *
  #--------------------------------------------------------------------------
  def cri
    n = enemy.has_critical ? base_cri : 0
    n += (XRXSV44::DEXtoCRIRate * self.dex).to_i
    return n
  end
end
#==============================================================================
# 武器攻撃力の取得
#==============================================================================
class Game_Battler
  def equip_atk
    n = 0
    for item in equips.compact do n += item.atk end
    return n
  end
  def equip_def
    n = 0
    for item in equips.compact do n += item.def end
    return n
  end
  def equip_spi
    n = 0
    for item in equips.compact do n += item.spi end
    return n
  end
  def equips
    return []
  end
end
#==============================================================================
# 元々の能力の取得
#==============================================================================
class Game_Actor < Game_Battler
  def str
    return self.actor.parameters[2, @level] + @atk_plus
  end
  def vit
    return self.actor.parameters[3, @level] + @def_plus
  end
  def int
    return self.actor.parameters[4, @level] + @spi_plus
  end
  def agi_base
    return self.actor.parameters[5, @level] + @agi_plus
  end
end
class Game_Enemy < Game_Battler
  def str
    return self.base_atk
  end
  def vit
    return self.base_def
  end
  def int
    return self.base_spi
  end
  def agi_base
    return self.base_agi
  end
end
#==============================================================================
# 魔法防御力の基本値
#==============================================================================
class Game_Battler
  case XRXSV44::TypeMND
  when 0
    def mnd_base
      return self.int
    end
    def mnd
      return self.spi
    end
  when 1
    def mnd_base
      return [(self.int * XRXSV44::PowerRate).to_i, power_limit].min
    end
    def mnd
      return mnd_base
    end
  when 2
    def mnd_base
      return (self.vit + self.int) / 2
    end
    def mnd
      return [(mnd_base * XRXSV44::PowerRate).to_i, power_limit].min
    end
  when 3
    def mnd_base
      return (self.vit + self.int) / 2
    end
    def mnd
      return (self.def + self.spi) / 2
    end
  end
end
#==============================================================================
# 魔法回避率の基本値
#==============================================================================
class Game_Battler
  case XRXSV44::TypeMEVA
  when 0
    def meva
      return 0
    end
  when 1
    def meva
      return self.eva / XRXSV44::TypeMEVAn
    end
  end
end
#==============================================================================
# 器用さの基本値
#==============================================================================
class Game_Battler
  case XRXSV44::TypeDEX
  when 0
    def dex
      return (self.atk * XRXSV44::RateDEX).to_i
    end
  when 1
    def dex
      return (self.agi * XRXSV44::RateDEX).to_i
    end
  when 2
    def dex
      return ((self.atk + self.agi) * XRXSV44::RateDEX / 2).to_i
    end
  end
end
#==============================================================================
# MP軽減力の基本値
#==============================================================================
class Game_Battler
  case XRXSV44::TypeMPR
  when 1
    def mpr
      return (self.int * XRXSV44::RateMPR).to_i
    end
  else
    def mpr
      return 0
    end
  end
end
module XRXSV44_MPR
  def calc_mp_cost(skill)
    original_cost = super
    cost = (original_cost * (100 - self.mpr) / 100)
    cost = 1 if original_cost >= 1 and cost <= 0
    return cost
  end
end
class Game_Actor < Game_Battler
  include XRXSV44_MPR
end
class Game_Enemy < Game_Battler
  include XRXSV44_MPR
end
#==============================================================================
# 幸運の基本値
#==============================================================================
class Game_Temp
  attr_accessor :lcks
end
class Game_Battler
  def lck
    return 0
  end
end
module XRXSV44_LCKs
  def recover_all
    super
    if $game_temp.lcks
      $game_temp.lcks.delete(self.id)
    end
  end
  if XRXSV44::TypeLCK == 1
    def lck
      $game_temp.lcks = {} unless $game_temp.lcks
      unless $game_temp.lcks[self.id]
        $game_temp.lcks[self.id] = rand(self.level) + 1
      end
      return $game_temp.lcks[self.id] + super
    end
  end
end
class Game_Actor < Game_Battler
  include XRXSV44_LCKs
end
if XRXSV44::TypeLCK == 1
  class Game_Enemy < Game_Battler
    def lck
      @lck = rand(self.level) unless @lck
      return @lck + super
    end
  end
end
#==============================================================================
# 通常攻撃オブジェクト／神聖魔法／各種対応
#==============================================================================
module XRXSV44_RPG_UsableEX
  case XRXSV44::DamageValueType
  when 4
    def graze?
      return false
    end
  else
    def graze?
      return self.physical_attack
    end
  end
  def cri
    n = super
    self.note.gsub(/\\cri\[([0-9]+?)\]/) do
      n += $1.to_i
    end
    return n
  end
  def atk_f
    n = 0
    self.note.gsub(/\\atk_f\[([0-9]+?)\]/) do
      n += $1.to_i
    end
    return super + n
  end
  def spi_f
    n = 0
    self.note.gsub(/\\spi_f\[([0-9]+?)\]/) do
      n += $1.to_i
    end
    return super + n
  end
  case XRXSV44::SkillCriticalType
  when 0
    def has_critical?
      return false
    end
  when 1
    if XRXSV44::FixDamageCriticalBan
      def has_critical?
        return (self.physical_attack and (self.variance >= 1))
      end
    else
      def has_critical?
        return self.physical_attack
      end
    end
  when 2
    if XRXSV44::FixDamageCriticalBan
      def has_critical?
        return (self.base_damage >= 1 and (self.variance >= 1))
      end
    else
      def has_critical?
        return (self.base_damage >= 1)
      end
    end
  when 3
    if XRXSV44::FixDamageCriticalBan
      def has_critical?
        return (self.variance >= 1)
      end
    else
      def has_critical?
        return true
      end
    end
  end
end
module RPG
  class Skill < UsableItem
    include XRXSV44_RPG_UsableEX
    def skill?
      return true
    end
    def mental?
      return (self.base_damage <= -1 or
              self.element_set.include?(XRXSV44::MentalSkillElementID))
    end
    def magic?
      return (self.spi_f >= 1 and not self.physical_attack)
    end
  end
  class Item < UsableItem
    include XRXSV44_RPG_UsableEX
  end
  class Attack < UsableItem
    def initialize
      super
      @scope = 1
      @base_damage = 1
      @variance = 20
      @atk_f = 100
    end
    def graze?
      return true
    end
    def has_critical?
      return true
    end
    def attack?
      return true
    end
  end
  class UsableItem < BaseItem
    def graze?
      return false
    end
    def has_critical?
      return false
    end
    def cri
      return 0
    end
    def attack?
      return false
    end
    def skill?
      return false
    end
    def magic?
      return false
    end
    def mental?
      return false
    end
  end
end
#==============================================================================
# 特殊効果と対応
#==============================================================================
class Game_Battler
  def attack_variance
    n = XRXSV44::AttackVariance
    note_for_attack_variance.gsub(/\\vrc\[([0-9]+?)\]/) do
      n = $1.to_i
    end
    return n
  end
  def weapons
    return []
  end
end
class Game_Actor < Game_Battler
  def note_for_attack_variance
    note = ""
    for weapon in self.weapons.compact
      note += weapon.note
    end
    return note
  end
end
class Game_Enemy < Game_Battler
  def note_for_attack_variance
    return self.enemy.note
  end
end
#==============================================================================
# 可変エネミー情報 機能/ランダムステータス
#==============================================================================
module XRXSV_EnemyDataEX
  def data_enemy
    return $data_enemies[@enemy_id]
  end
  def enemy
    if @enemy == nil
      @enemy = data_enemy.dup
      @enemy.drop_item1    = @enemy.drop_item1.dup
      @enemy.drop_item2    = @enemy.drop_item2.dup
      @enemy.element_ranks = @enemy.element_ranks.dup
      @enemy.state_ranks   = @enemy.state_ranks.dup
      @enemy.actions       = @enemy.actions.dup
      n = XRXSV44::EnemyPowerBlur
      @enemy.maxhp = @enemy.maxhp * (100 - (n - 1)/2 + rand(n)) / 100
      @enemy.maxmp = @enemy.maxmp * (100 - (n - 1)/2 + rand(n)) / 100
      @enemy.atk = @enemy.atk * (100 - (n - 1)/2 + rand(n)) / 100
      @enemy.def = @enemy.def * (100 - (n - 1)/2 + rand(n)) / 100
      @enemy.spi = @enemy.spi * (100 - (n - 1)/2 + rand(n)) / 100
      @enemy.agi = @enemy.agi * (100 - (n - 1)/2 + rand(n)) / 100
    end
    return @enemy
  end
end
class Game_Enemy < Game_Battler
  include XRXSV_EnemyDataEX
  def enemy #*
    return super
  end
  alias xrxsv44_transform transform
  def transform(enemy_id)
    @enemy = nil
    xrxsv44_transform(enemy_id)
  end
  attr_accessor :original_name
end
#==============================================================================
# 幸運 - ドロップボーナス
#==============================================================================
class Game_Troop < Game_Unit
  alias xrxsv44_setup setup
  def setup(troop_id)
    xrxsv44_setup(troop_id)
    total_luck = 0
    for actor in $game_party.members
      total_luck += actor.lck
    end
    for enemy in @enemies
      for drop_item in [enemy.enemy.drop_item1, enemy.enemy.drop_item2]
        percent = (100.0 / drop_item.denominator) * (256 + total_luck) / 256
        drop_item.denominator = [(100 / percent).to_i, 1].max
      end
    end
  end
end
#==============================================================================
# 3倍体
#==============================================================================
class Scene_Map < Scene_Base
  alias xrxsv44_preemptive_or_surprise preemptive_or_surprise
  def preemptive_or_surprise
    xrxsv44_preemptive_or_surprise
    for game_enemy in $game_troop.members
      if rand(100) < XRXSV44::MultiplyEnemyProbability
        case rand(3)
        when 0
          game_enemy.enemy.maxhp *= 3
        when 1
          game_enemy.enemy.def *= 3
        when 2
          game_enemy.enemy.agi *= 3
        end
        game_enemy.enemy.exp *= 3
        game_enemy.original_name += XRXSV44::MultiplyEnemyNameSuffix
      end
    end
  end
end
