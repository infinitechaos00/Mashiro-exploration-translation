#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 装備品オプション追加 - KGC_AddEquipmentOptions ◆ VX ◆
#_/    ◇ Last update : 2008/04/01 ◇
#_/----------------------------------------------------------------------------
#_/  装備品のオプションを追加します。
#_/============================================================================
#_/  正常に反映されない場合は、導入位置を移動してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#~ n 回攻撃
#~ 武器・防具のメモ欄に <n回攻撃> を追加します。
#~ nには、通常攻撃を行う回数を半角で記入します。
#~ # （対象は単体だが）常時剣の舞状態
#~ <4回攻撃>
#~ 複数の装備品に <n回攻撃> がある場合は、最も攻撃回数が多いものが採用されます。

#~ HP/MP 自動回復
#~ 武器・防具のメモ欄に <HP自動回復 n%> または <MP自動回復 n%> を追加します。
#~ nには、自動回復する HP/MP の割合を半角で入力します。
#~ % を書かなかった場合、nがそのまま回復量になります。
#~ 回復量を省略した場合は5%です（カスタマイズ項目で変更可能）。
#~ このアイテムを装備していると、ターン終了時に HP が最大値の10%、
#~ MP が最大値の5%回復します。
#~ <HP自動回復 n%> <MP自動回復 n%> の代わりに <auto_hp_recover n%> <auto_mp_recover n%> を使用することもできます。

#~ 属性耐性の詳細設定
#~ 武器・防具のメモ欄に、以下の <・・・> という文字列を追加すると、右側に示した効果が得られます。
#~ <弱点属性 n> → 属性IDnのダメージが 1.5 倍
#~ <半減属性 n> → 属性IDnのダメージが半減
#~ <無効属性 n> → 属性IDnを無効化
#~ <吸収属性 n> → 属性IDnを吸収
#~ 属性IDは、<弱点属性 1,2,3> のように , で区切って複数指定することもできます。
#~ 効果の強さは、
#~ 無効 ＞ 吸収 ＞ 半減 ＝ 弱点
#~ となります。
#~ 「無効」以外は、すべて効果が重複します。
#~ （「弱点 + 半減 + 吸収」の場合、1.5 * 0.5 = 0.75 倍の量を吸収）
#~ <弱点属性 n> <半減属性 n> <無効属性 n> <吸収属性 n> は、それぞれ
#~ <weak_element n> <guard_element n> <invalid_element n> <absorb_element n>
#~ を使用することもできます。
#~ 上の記法はダメージ倍率が固定ですが、<属性耐性 n:x> を使用すると、属性IDnの耐性を細かく設定することができます。
#~ x > 0 → ダメージが通常のx%
#~ x = 0 → ダメージが0（無効化）
#~ x < 0 → ダメージのx%分回復（吸収）
#~ xの後に % を付けて <属性耐性 n:x%> と書いても構いません。
#~ 同じ属性が複数存在する場合、それぞれから100を引いた値の総和に100を加算して最終的な耐性とします。
#~ （<弱点属性 n> などとは計算が異なります）
#~     1:120（弱点）と1:-50（吸収）
#~     → (120 - 100) + (-50 - 100) + 100 = -30、つまり30%吸収
#~     1:250（弱点）と1:30（軽減）と1:-60（吸収）
#~     → (250 - 100) + (30 - 100) + (-60 - 100) + 100 = 20、つまり通常の20%
#~ このように、すべての方式を併用することもできます。
#~ <属性耐性 n:x> の代わりに <element_resistance n:x> を使用することもできます。

#~ ステート耐性の詳細設定
#~ 武器・防具のメモ欄に <ステート耐性 n:x> を記述すると、ステートIDnの耐性を細かく設定することができます。
#~ x > 0 → 付加率が通常のx%
#~ x = 0 → 付加率が0%（無効化）
#~ xの後に % を付けて <ステート耐性 n:x%> と書いても構いません。
#~ x%は、アクター本来のステート耐性に対する付加率です。
#~ 例えば、アクターの耐性がC (60%)で <ステート耐性 n:50%> のアイテムを装備した場合、
#~ ステート付加率は60% * 50% = 30%となります。
#~ 同じ耐性が複数存在する場合、それぞれから100を引いた値の総和に100を加算して最終的な耐性とします。
#~     1:250と1:30
#~     → (250 - 100) + (30 - 100) + 100 = 180、つまり通常より付加率が80%高い
#~ <ステート耐性 n:x> の代わりに <state_resistance n:x> を使用することもできます。

#~ 受けたダメージに比例した MP 回復 （MP転換）
#~ 武器・防具のメモ欄に <MP転換 n%> を記述すると、受けたダメージのn%に
#~ 相当する量の MP が回復します。
#~ （ダメージがなくなるわけではありません）
#~ n%を省略した場合の転換量はカスタマイズ項目で指定できます。

#~ 属性攻撃を MP として吸収 （MP吸収）
#~ 武器・防具のメモ欄に <MP吸収 n%> を記述すると、属性攻撃を吸収した際に
#~ HP ではなく MP が回復するようになります。
#~ （HP は回復しません）
#~ 回復量は、本来の HP 回復量のn%です。
#~ n%を省略した場合の回復量はカスタマイズ項目で指定できます。

#~ 武器のオプション
#~ 武器のメモ欄に <クリティカル防止> <消費MP半分> <取得経験値2倍> を追加すると、
#~ 防具の同名のオプションと同じ効果を得ることができます。
#~ <クリティカル防止> <消費MP半分> <取得経験値2倍> の代わりに
#~ <prevent_critical> <half_mp_cost> <double_exp_gain> を使用することもできます。

#~ 防具のオプション
#~ 防具のメモ欄に <ターン内先制> <連続攻撃> <クリティカル頻発> を追加すると、
#~ 武器の同名のオプションと同じ効果を得ることができます。
#~ <ターン内先制> <連続攻撃> <クリティカル頻発> の代わりに
#~ <fast_attack> <dual_attack> <critical_bonus> を使用することもできます。

#~ 防具の攻撃属性
#~ 防具のメモ欄に <攻撃属性 n> を追加します。
#~ nには、攻撃時に持たせる属性の ID を半角で入力します。
#~ <攻撃属性 1,2,3> のように , で区切って複数指定することもできます。
#~ この防具を装備している間、通常攻撃時に9, 10, 11番の属性が付加されます。
#~ <攻撃属性 n> の代わりに <attack_element n> を使用することもできます。

#~ 防具の攻撃時付加ステート
#~ 防具のメモ欄に <付加ステート n> を追加します。
#~ nには、攻撃時に付加するステートの ID を半角で入力します。
#~ <付加ステート 1,2,3> のように , で区切って複数指定することもできます。
#~ この防具を装備している間、通常攻撃時に2, 3, 4番のステートが付加されます。
#~ （付加確率は、対象のステート耐性に依存します）
#~ <付加ステート n> の代わりに <plus_state n> を使用することもできます。
#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module AddEquipmentOptions
  # ◆ <HP自動回復> で回復量を指定しなかった場合の回復量 [%]
  DEFAULT_RECOVER_HP_RATE = 5
  # ◆ <MP自動回復> で回復量を指定しなかった場合の回復量 [%]
  DEFAULT_RECOVER_MP_RATE = 5

  # ◆ <MP転換> で転換率を指定しなかった場合の転換率 [%]
  DEFAULT_CONVERT_MP_RATE = 1
  # ◆ <MP吸収> で吸収率を指定しなかった場合の吸収率 [%]
  DEFAULT_ABSORB_MP_RATE  = 5
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["AddEquipmentOptions"] = true

module KGC::AddEquipmentOptions
  # 正規表現
  module Regexp
    # ベースアイテム (武器・防具共用）
    module BaseItem
      # n回攻撃
      MULTI_ATTACK = /<(\d+)\s*(?:TIMES_ATTACK|回攻撃)>/i
      # HP自動回復
      AUTO_HP_RECOVER = /<(?:AUTO_HP_RECOVER|HP自動回復)(\s*(\d+)([%％])?)?>/i
      # MP自動回復
      AUTO_MP_RECOVER = /<(?:AUTO_MP_RECOVER|MP自動回復)(\s*(\d+)([%％])?)?>/i
      # MP転換
      CONVERT_MP = /<(?:CONVERT_MP|MP転換)\s*(\d+)?[%％]?>/i
      # MP吸収
      ABSORB_MP = /<(?:ABSORB_MP|MP吸収)\s*(\d+)?[%％]?>/i

      # 属性耐性
      ELEMENT_RESISTANCE =
        /<(?:ELEMENT_RESISTANCE|属性耐性)\s*(\d+):(\-?\d+)[%％]?>/i
      # 弱点属性
      WEAK_ELEMENT =
        /<(?:WEAK_ELEMENT|弱点属性)\s*(\d+(?:\s*,\s*\d+)*)>/i
      # 半減する属性
      GUARD_ELEMENT =
        /<(?:GUARD_ELEMENT|半減属性)\s*(\d+(?:\s*,\s*\d+)*)>/i
      # 無効化する属性
      INVALID_ELEMENT =
        /<(?:INVALID_ELEMENT|無効属性)\s*(\d+(?:\s*,\s*\d+)*)>/i
      # 吸収する属性
      ABSORB_ELEMENT =
        /<(?:ABSORB_ELEMENT|吸収属性)\s*(\d+(?:\s*,\s*\d+)*)>/i

      # ステート耐性
      STATE_RESISTANCE =
        /<(?:STATE_RESISTANCE|ステート耐性)\s*(\d+):(\d+)[%％]?>/i
    end

    # 武器
    module Weapon
      # クリティカル防止
      PREVENT_CRITICAL = /<(?:PREVENT_CRITICAL|クリティカル防止)>/i
      # 消費MP半分
      HALF_MP_COST = /<(?:HALF_MP_COST|消費MP半分)>/i
      # 取得経験値2倍
      DOUBLE_EXP_GAIN = /<(?:DOUBLE_EXP_GAIN|取得経験値[2２]倍)>/i
    end

    # 防具
    module Armor
      # ターン内先制
      FAST_ATTACK = /<(?:FAST_ATTACK|ターン内先制)>/i
      # 連続攻撃
      DUAL_ATTACK = /<(?:DUAL_ATTACK|連続攻撃)>/i
      # クリティカル頻発
      CRITICAL_BONUS = /<(?:CRITICAL_BONUS|クリティカル頻発)>/i
      # 攻撃属性
      ATTACK_ELEMENT =
        /<(?:ATTACK_ELEMENT|攻撃属性)\s*(\d+(?:\s*,\s*\d+)*)>/i
      # 付加ステート
      PLUS_STATE = /<(?:PLUS_STATE|付加ステート)\s*(\d+(?:\s*,\s*\d+)*)>/i
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 追加オプションのキャッシュを作成
  #--------------------------------------------------------------------------
  def create_add_equipment_options_cache
    @__multi_attack_count = 1
    @__auto_hp_recover = false
    @__auto_hp_recover_value = 0
    @__auto_hp_recover_rate = 0
    @__auto_mp_recover = false
    @__auto_mp_recover_value = 0
    @__auto_mp_recover_rate = 0
    @__convert_mp_rate = 0
    @__absorb_mp_rate = 0

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::AddEquipmentOptions::Regexp::BaseItem::MULTI_ATTACK
        # n回攻撃
        @__multi_attack_count = [$1.to_i, 1].max
      when KGC::AddEquipmentOptions::Regexp::BaseItem::AUTO_HP_RECOVER
        # HP自動回復
        @__auto_hp_recover = true
        next if $1 == nil
        if $3 != nil
          @__auto_hp_recover_rate += $2.to_i
        else
          @__auto_hp_recover_value += $2.to_i
        end
      when KGC::AddEquipmentOptions::Regexp::BaseItem::AUTO_MP_RECOVER
        # MP自動回復
        @__auto_mp_recover = true
        next if $1 == nil
        if $3 != nil
          @__auto_mp_recover_rate += $2.to_i
        else
          @__auto_mp_recover_value += $2.to_i
        end
      when KGC::AddEquipmentOptions::Regexp::BaseItem::CONVERT_MP
        # MP転換
        @__convert_mp_rate = ($1 != nil ?
          $1.to_i : KGC::AddEquipmentOptions::DEFAULT_CONVERT_MP_RATE)
      when KGC::AddEquipmentOptions::Regexp::BaseItem::ABSORB_MP
        # MP吸収
        @__absorb_mp_rate = ($1 != nil ?
          $1.to_i : KGC::AddEquipmentOptions::DEFAULT_ABSORB_MP_RATE)
      end
    }

    create_resistance_cache
  end
  #--------------------------------------------------------------------------
  # ○ 耐性のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_resistance_cache
    @__element_resistance = []
    @__weak_element_set = []
    @__guard_element_set = []
    @__invalid_element_set = []
    @__absorb_element_set = []

    @__state_resistance = []

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::AddEquipmentOptions::Regexp::BaseItem::ELEMENT_RESISTANCE
        # 属性耐性
        element_id = $1.to_i
        value = $2.to_i
        if @__element_resistance[element_id] == nil
          @__element_resistance[element_id] = 100
        end
        @__element_resistance[element_id] -= (100 - value)
      when KGC::AddEquipmentOptions::Regexp::BaseItem::WEAK_ELEMENT
        # 弱点属性
        $1.scan(/\d+/).each { |num|
          @__weak_element_set << num.to_i
        }
      when KGC::AddEquipmentOptions::Regexp::BaseItem::GUARD_ELEMENT
        # 半減属性
        $1.scan(/\d+/).each { |num|
          @__guard_element_set << num.to_i
        }
      when KGC::AddEquipmentOptions::Regexp::BaseItem::INVALID_ELEMENT
        # 無効属性
        $1.scan(/\d+/).each { |num|
          @__invalid_element_set << num.to_i
        }
      when KGC::AddEquipmentOptions::Regexp::BaseItem::ABSORB_ELEMENT
        # 吸収属性
        $1.scan(/\d+/).each { |num|
          @__absorb_element_set << num.to_i
        }
      when KGC::AddEquipmentOptions::Regexp::BaseItem::STATE_RESISTANCE
        # ステート耐性
        state_id = $1.to_i
        value = $2.to_i
        if @__state_resistance[state_id] == nil
          @__state_resistance[state_id] = 100
        end
        @__state_resistance[state_id] -= (100 - value)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃回数
  #--------------------------------------------------------------------------
  def multi_attack_count
    create_add_equipment_options_cache if @__multi_attack_count == nil
    return @__multi_attack_count
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [HP自動回復]
  #--------------------------------------------------------------------------
  def auto_hp_recover
    create_add_equipment_options_cache if @__auto_hp_recover == nil
    return @__auto_hp_recover
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [MP自動回復]
  #--------------------------------------------------------------------------
  def auto_mp_recover
    create_add_equipment_options_cache if @__auto_mp_recover == nil
    return @__auto_mp_recover
  end
  #--------------------------------------------------------------------------
  # ○ HP 自動回復量 (即値)
  #--------------------------------------------------------------------------
  def auto_hp_recover_value
    create_add_equipment_options_cache if @__auto_hp_recover_value == nil
    return @__auto_hp_recover_value
  end
  #--------------------------------------------------------------------------
  # ○ HP 自動回復量 (割合)
  #--------------------------------------------------------------------------
  def auto_hp_recover_rate
    create_add_equipment_options_cache if @__auto_hp_recover_rate == nil
    return @__auto_hp_recover_rate
  end
  #--------------------------------------------------------------------------
  # ○ MP 自動回復量 (即値)
  #--------------------------------------------------------------------------
  def auto_mp_recover_value
    create_add_equipment_options_cache if @__auto_mp_recover_value == nil
    return @__auto_mp_recover_value
  end
  #--------------------------------------------------------------------------
  # ○ MP 自動回復量 (割合)
  #--------------------------------------------------------------------------
  def auto_mp_recover_rate
    create_add_equipment_options_cache if @__auto_mp_recover_rate == nil
    return @__auto_mp_recover_rate
  end
  #--------------------------------------------------------------------------
  # ○ MP 転換率
  #--------------------------------------------------------------------------
  def convert_mp_rate
    create_add_equipment_options_cache if @__convert_mp_rate == nil
    return @__convert_mp_rate
  end
  #--------------------------------------------------------------------------
  # ○ MP 吸収率
  #--------------------------------------------------------------------------
  def absorb_mp_rate
    create_add_equipment_options_cache if @__absorb_mp_rate == nil
    return @__absorb_mp_rate
  end
  #--------------------------------------------------------------------------
  # ○ 属性耐性
  #--------------------------------------------------------------------------
  def element_resistance
    create_add_equipment_options_cache if @__element_resistance == nil
    return @__element_resistance
  end
  #--------------------------------------------------------------------------
  # ○ 弱点属性
  #--------------------------------------------------------------------------
  def weak_element_set
    create_add_equipment_options_cache if @__weak_element_set == nil
    return @__weak_element_set
  end
  #--------------------------------------------------------------------------
  # ○ 半減属性
  #--------------------------------------------------------------------------
  def guard_element_set
    create_add_equipment_options_cache if @__guard_element_set == nil
    return @__guard_element_set
  end
  #--------------------------------------------------------------------------
  # ○ 無効属性
  #--------------------------------------------------------------------------
  def invalid_element_set
    create_add_equipment_options_cache if @__invalid_element_set == nil
    return @__invalid_element_set
  end
  #--------------------------------------------------------------------------
  # ○ 吸収属性
  #--------------------------------------------------------------------------
  def absorb_element_set
    create_add_equipment_options_cache if @__absorb_element_set == nil
    return @__absorb_element_set
  end
  #--------------------------------------------------------------------------
  # ○ ステート耐性
  #--------------------------------------------------------------------------
  def state_resistance
    create_add_equipment_options_cache if @__state_resistance == nil
    return @__state_resistance
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Weapon
#==============================================================================

class RPG::Weapon < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 追加オプションのキャッシュを作成
  #--------------------------------------------------------------------------
  def create_add_equipment_options_cache
    super
    @__prevent_critical = false
    @__half_mp_cost = false
    @__double_exp_gain = false

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::AddEquipmentOptions::Regexp::Weapon::PREVENT_CRITICAL
        # クリティカル防止
        @__prevent_critical = true
      when KGC::AddEquipmentOptions::Regexp::Weapon::HALF_MP_COST
        # 消費MP半分
        @__half_mp_cost = true
      when KGC::AddEquipmentOptions::Regexp::Weapon::DOUBLE_EXP_GAIN
        # 取得経験値2倍
        @__double_exp_gain = true
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [クリティカル防止]
  #--------------------------------------------------------------------------
  def prevent_critical
    create_add_equipment_options_cache if @__prevent_critical == nil
    return @__prevent_critical
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [消費MP半分]
  #--------------------------------------------------------------------------
  def half_mp_cost
    create_add_equipment_options_cache if @__half_mp_cost == nil
    return @__half_mp_cost
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [取得経験値2倍]
  #--------------------------------------------------------------------------
  def double_exp_gain
    create_add_equipment_options_cache if @__double_exp_gain == nil
    return @__double_exp_gain
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Armor
#==============================================================================

class RPG::Armor < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 追加オプションのキャッシュを作成
  #--------------------------------------------------------------------------
  def create_add_equipment_options_cache
    super
    @__fast_attack = false
    @__dual_attack = false
    @__critical_bonus = false
    @__attack_element_set = []
    @__plus_state_set = []

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::AddEquipmentOptions::Regexp::Armor::FAST_ATTACK
        # ターン内先制
        @__fast_attack = true
      when KGC::AddEquipmentOptions::Regexp::Armor::DUAL_ATTACK
        # 連続攻撃
        @__dual_attack = true
      when KGC::AddEquipmentOptions::Regexp::Armor::CRITICAL_BONUS
        # クリティカル頻発
        @__critical_bonus = true
      when KGC::AddEquipmentOptions::Regexp::Armor::ATTACK_ELEMENT
        # 攻撃属性
        $1.scan(/\d+/).each { |num|
          @__attack_element_set << num.to_i
        }
      when KGC::AddEquipmentOptions::Regexp::Armor::PLUS_STATE
        # 付加ステート
        $1.scan(/\d+/).each { |num|
          @__plus_state_set << num.to_i
        }
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [ターン内先制]
  #--------------------------------------------------------------------------
  def fast_attack
    create_add_equipment_options_cache if @__fast_attack == nil
    return @__fast_attack
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [連続攻撃]
  #--------------------------------------------------------------------------
  def dual_attack
    create_add_equipment_options_cache if @__dual_attack == nil
    return @__dual_attack
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [クリティカル頻発]
  #--------------------------------------------------------------------------
  def critical_bonus
    create_add_equipment_options_cache if @__critical_bonus == nil
    return @__critical_bonus
  end
  #--------------------------------------------------------------------------
  # ● 装備オプション [HP自動回復]
  #--------------------------------------------------------------------------
  def auto_hp_recover
    return (@auto_hp_recover || super)
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃属性
  #--------------------------------------------------------------------------
  def attack_element_set
    create_add_equipment_options_cache if @__attack_element_set == nil
    return @__attack_element_set
  end
  #--------------------------------------------------------------------------
  # ○ 付加ステート
  #--------------------------------------------------------------------------
  def plus_state_set
    create_add_equipment_options_cache if @__plus_state_set == nil
    return @__plus_state_set
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ○ 攻撃回数の取得
  #--------------------------------------------------------------------------
  def multi_attack_count
    return 1
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃によるダメージ計算
  #     attacker : 攻撃者
  #    結果は @hp_damage に代入する。
  #--------------------------------------------------------------------------
  alias make_attack_damage_value_KGC_AddEquipmentOptions make_attack_damage_value
  def make_attack_damage_value(attacker)
    make_attack_damage_value_KGC_AddEquipmentOptions(attacker)

    make_convert_mp_value(attacker)
    make_absorb_mp_value(attacker)
  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムによるダメージ計算
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  alias make_obj_damage_value_KGC_AddEquipmentOptions make_obj_damage_value
  def make_obj_damage_value(user, obj)
    make_obj_damage_value_KGC_AddEquipmentOptions(user, obj)

    make_convert_mp_value(user, obj)
    make_absorb_mp_value(user, obj)
  end
  #--------------------------------------------------------------------------
  # ○ MP 転換率の計算
  #--------------------------------------------------------------------------
  def calc_convert_mp_rate
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ MP 吸収率の計算
  #--------------------------------------------------------------------------
  def calc_absorb_mp_rate
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ MP 転換効果の適用
  #     user : 攻撃者
  #     obj  : スキルまたはアイテム (nil なら通常攻撃)
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  def make_convert_mp_value(user, obj = nil)
    return if @hp_damage <= 0  # 回復する場合は転換しない

    rate = calc_convert_mp_rate
    return if rate == 0        # 転換率が 0 なら転換しない

    @mp_damage -= [@hp_damage * rate / 100, 1].max
  end
  #--------------------------------------------------------------------------
  # ○ MP 吸収効果の適用
  #     user : 攻撃者
  #     obj  : スキルまたはアイテム (nil なら通常攻撃)
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  def make_absorb_mp_value(user, obj = nil)
    return unless mp_absorb?(user, obj)

    # HP ダメージを MP 回復値に変換
    rate = elements_max_rate( (obj == nil ? user : obj).element_set )
    rate = rate.abs * calc_absorb_mp_rate / 100
    @mp_damage -= [@hp_damage.abs * rate / 100, 1].max
    @hp_damage = 0
  end
  #--------------------------------------------------------------------------
  # ○ MP 吸収判定
  #     user : 攻撃者
  #     obj  : スキルまたはアイテム (nil なら通常攻撃)
  #--------------------------------------------------------------------------
  def mp_absorb?(user, obj = nil)
    if obj.is_a?(RPG::UsableItem)
      return false if obj.base_damage < 0     # 回復なら吸収しない
      if obj.is_a?(RPG::Item)
        # 回復アイテムなら吸収しない
        return false if obj.hp_recovery_rate > 0 || obj.hp_recovery > 0
      end
    end
    return false if calc_absorb_mp_rate == 0  # 吸収率が 0 なら吸収しない
    rate = elements_max_rate( (obj == nil ? user : obj).element_set )
    return false if rate >= 0                 # 有効な属性なら吸収しない

    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_BattleAction
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # ● 通常攻撃のターゲット作成
  #--------------------------------------------------------------------------
  alias make_attack_targets_KGC_AddEquipmentOptions make_attack_targets
  def make_attack_targets
    buf = make_attack_targets_KGC_AddEquipmentOptions
    targets = buf.clone

    # n 回攻撃
    (battler.multi_attack_count - 1).times { targets += buf }
    return targets
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 属性修正値の取得
  #     element_id : 属性 ID
  #--------------------------------------------------------------------------
  alias element_rate_KGC_AddEquipmentOptions element_rate
  def element_rate(element_id)
    result = element_rate_KGC_AddEquipmentOptions(element_id)

    # 耐性の適用
    result = result * element_resistance(element_id) / 100

    absorb_flag = (result < 0)
    result = result.abs
    equips.compact.each { |item|
      if item.invalid_element_set.include?(element_id)  # 無効
        result = 0
        break
      end
      if item.guard_element_set.include?(element_id)    # 半減
        result /= 2
      end
      if item.weak_element_set.include?(element_id)     # 弱点
        result = result * 3 / 2
      end
      absorb_flag |= item.absorb_element_set.include?(element_id)  # 吸収フラグ
    }
    result = -result if absorb_flag
    return result
  end
  #--------------------------------------------------------------------------
  # ○ 属性耐性の取得
  #     element_id : 属性 ID
  #--------------------------------------------------------------------------
  def element_resistance(element_id)
    n = 100
    equips.compact.each { |item|
      if item.element_resistance[element_id] != nil
        n += item.element_resistance[element_id] - 100
      end
    }
    return n
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加成功率の取得
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  alias state_probability_KGC_AddEquipmentOptions state_probability
  def state_probability(state_id)
    result = state_probability_KGC_AddEquipmentOptions(state_id)

    return result * state_resistance(state_id) / 100
  end
  #--------------------------------------------------------------------------
  # ○ ステート耐性の取得
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state_resistance(state_id)
    n = 100
    equips.compact.each { |item|
      if item.state_resistance[state_id] != nil
        n += item.state_resistance[state_id] - 100
      end
    }
    return [n, 0].max
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  alias element_set_KGC_AddEquipmentOptions element_set
  def element_set
    result = element_set_KGC_AddEquipmentOptions

    armors.compact.each { |armor|
      result |= armor.attack_element_set
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の追加効果 (ステート変化) 取得
  #--------------------------------------------------------------------------
  alias plus_state_set_KGC_AddEquipmentOptions plus_state_set
  def plus_state_set
    result = plus_state_set_KGC_AddEquipmentOptions

    armors.compact.each { |armor|
      result |= armor.plus_state_set
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias cri_KGC_AddEquipmentOptions cri
  def cri
    n = cri_KGC_AddEquipmentOptions

    armors.compact.each { |armor|
      n += 4 if armor.critical_bonus
    }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃回数の取得
  #--------------------------------------------------------------------------
  def multi_attack_count
    result = [1]
    equips.compact.each { |item|
      result << item.multi_attack_count
    }
    return result.max
  end
  #--------------------------------------------------------------------------
  # ● 武器オプション [ターン内先制] の取得
  #--------------------------------------------------------------------------
  alias fast_attack_KGC_AddEquipmentOptions fast_attack
  def fast_attack
    return true if fast_attack_KGC_AddEquipmentOptions

    armors.compact.each { |armor|
      return true if armor.fast_attack
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 武器オプション [連続攻撃] の取得
  #--------------------------------------------------------------------------
  alias dual_attack_KGC_AddEquipmentOptions dual_attack
  def dual_attack
    # ２回攻撃以上なら無視
    return false if multi_attack_count >= 2

    return true if dual_attack_KGC_AddEquipmentOptions

    armors.compact.each { |armor|
      return true if armor.dual_attack
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 防具オプション [クリティカル防止] の取得
  #--------------------------------------------------------------------------
  alias prevent_critical_KGC_AddEquipmentOptions prevent_critical
  def prevent_critical
    return true if prevent_critical_KGC_AddEquipmentOptions

    weapons.compact.each { |weapon|
      return true if weapon.prevent_critical
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 防具オプション [消費 MP 半分] の取得
  #--------------------------------------------------------------------------
  alias half_mp_cost_KGC_AddEquipmentOptions half_mp_cost
  def half_mp_cost
    return true if half_mp_cost_KGC_AddEquipmentOptions

    weapons.compact.each { |weapon|
      return true if weapon.half_mp_cost
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 防具オプション [取得経験値 2 倍] の取得
  #--------------------------------------------------------------------------
  alias double_exp_gain_KGC_AddEquipmentOptions double_exp_gain
  def double_exp_gain
    return true if double_exp_gain_KGC_AddEquipmentOptions

    weapons.compact.each { |weapon|
      return true if weapon.double_exp_gain
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 防具オプション [HP 自動回復] の取得
  #--------------------------------------------------------------------------
  alias auto_hp_recover_KGC_AddEquipmentOptions auto_hp_recover
  def auto_hp_recover
    return true if auto_hp_recover_KGC_AddEquipmentOptions

    weapons.compact.each { |weapon|
      return true if weapon.auto_hp_recover
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ● 装備オプション [MP 自動回復] の取得
  #--------------------------------------------------------------------------
  def auto_mp_recover
    equips.compact.each { |item|
      return true if item.auto_mp_recover
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ○ HP 自動回復量の取得
  #--------------------------------------------------------------------------
  def auto_hp_recover_value
    value = 0
    rate = 0
    equips.compact.each { |item|
      value += item.auto_hp_recover_value
      rate  += item.auto_hp_recover_rate
    }
    # 回復量を算出
    if value == 0 && rate == 0
      n = maxhp * KGC::AddEquipmentOptions::DEFAULT_RECOVER_HP_RATE / 100
    else
      n = value + (maxhp * rate / 100)
    end
    return [n, 1].max
  end
  #--------------------------------------------------------------------------
  # ○ MP 自動回復量の取得
  #--------------------------------------------------------------------------
  def auto_mp_recover_value
    value = 0
    rate = 0
    equips.compact.each { |item|
      value += item.auto_mp_recover_value
      rate  += item.auto_mp_recover_rate
    }
    # 回復量を算出
    if value == 0 && rate == 0
      n = maxmp * KGC::AddEquipmentOptions::DEFAULT_RECOVER_MP_RATE / 100
    else
      n = value + (maxmp * rate / 100)
    end
    return [n, 1].max
  end
  #--------------------------------------------------------------------------
  # ● 自動回復の実行 (ターン終了時に呼び出し)
  #--------------------------------------------------------------------------
  def do_auto_recovery
    return if dead?

    self.hp += auto_hp_recover_value if auto_hp_recover
    self.mp += auto_mp_recover_value if auto_mp_recover
  end
  #--------------------------------------------------------------------------
  # ○ MP 転換率の計算
  #--------------------------------------------------------------------------
  def calc_convert_mp_rate
    n = 0
    equips.compact.each { |item| n += item.convert_mp_rate }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ MP 吸収率の計算
  #--------------------------------------------------------------------------
  def calc_absorb_mp_rate
    n = 0
    equips.compact.each { |item| n += item.absorb_mp_rate }
    return n
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● HP ダメージ表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  alias display_hp_damage_KGC_AddEquipmentOptions display_hp_damage
  def display_hp_damage(target, obj = nil)
    if target.hp_damage == 0 && target.mp_damage < 0
      return if target.mp_absorb?(@active_battler, obj)  # MP 吸収
    end

    display_hp_damage_KGC_AddEquipmentOptions(target, obj)
  end
end
