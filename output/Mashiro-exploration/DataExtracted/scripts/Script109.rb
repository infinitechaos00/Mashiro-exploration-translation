#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 装備拡張 - KGC_EquipExtension ◆ VX ◆
#_/    ◇ Last update : 2009/08/18 ◇
#_/----------------------------------------------------------------------------
#_/  装備関連の機能を拡張します。
#_/============================================================================
#_/ 【メニュー】≪拡張装備画面≫ より下に導入してください。
#_/ 【スキル】≪パッシブスキル≫ より上に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#~ 防具種別の作成

#~ # ◆ 拡張装備種別
#~ EXTRA_EQUIP_KIND = ["足", "技能書"]

#~ カスタマイズ項目のこの部分で、新しく作成する装備種別を指定します。
#~ 例では「足」と「技能書」という種別を作成しています。
#~ 作成した種別の番号は、先頭から順に4, 5, 6, ...となります。
#~ （例の場合、「足」が4、「技能書」が5）

#~ カスタマイズ項目で設定した後、防具のメモ欄に <装備種別 名称> を追加します。
#~ memo
#~ この防具は「足」として扱われるようになります。
#~ 装備欄の変更

#~ # ◆ 装備箇所リスト
#~ EQUIP_TYPE = [0, 1, 2, 4, 3, 3, 5]

#~ 装備欄を設定します。
#~ ここで指定した順で、武器の後に並びます。
#~ アクターを二刀流にした場合、先頭の装備欄が２本目の武器になります。
#~ （したがって、先頭は0にした方が良い）

#~ 指定できる数値は下表の通りです。
#~ 装備種別対応表
#~ 数値 	装備種別
#~ 0 	盾
#~ 1 	頭
#~ 2 	身体
#~ 3 	装飾品
#~ 4 以降 	EXTRA_EQUIP_KINDで定義

#~ 装備欄を変更した場合、イベントコマンド「装備の変更」が正常に機能しなくなります。
#~ （仕様上、武器だけは正常に使用できます）
#~ 装備を変更する場合はchange_actor_equipmentを使用してください。
#~ EP 制

#~ ≪スキルCP制≫ のように、装備品固有の EP を消費して武具を装備させる機能です。
#~ equip_extension01

#~ アクター名の右側に表示されているのが、現在の EP です。
#~ アイテム名の右側には、そのアイテムの消費 EP が青色で表示されます。
#~ equip_extension02
#~ 文字色は、カスタマイズ項目で変更できます。

#~ # ◆ EP (Equip Point) 制を使用する
#~ USE_EP_SYSTEM = true

#~ EP 制を使用する場合はtrueにします。
#~ falseにした場合、消費 EP に関係なく装備可能になります。

#~ # ◆ 消費 EP 0 は表示しない
#~ HIDE_ZERO_EP_COST = true

#~ trueにすると、消費 EP が0の場合、アイテム名に消費 EP を表示しなくなります。
#~ falseにすると、常に消費 EP を表示します。

#~ # ◆ 最大 EP 算出式
#~ EP_CALC_EXP = "level * 0.3 + 4"

#~ 最大 EP の値を算出する式を設定します。
#~ この式の結果は、自動的に整数に変換されます。

#~ # ◆ 消費 EP 値の色 (アイテム名の末尾に付く数値)
#~ EP_COST_COLOR        = 23
#~ # ◆ EP ゲージの色
#~ EP_GAUGE_START_COLOR = 28  # 開始色
#~ EP_GAUGE_END_COLOR   = 29  # 終了色

#~ アイテム名右側の消費 EP や EP ゲージの色を設定します。
#~ 開始色はゲージ左側の色、終了色はゲージ右側の色を表します。

#~ 色に数値を指定した場合、メッセージウィンドウの \C[n] で表示される色を使用します。
#~ 例えば、23なら \C[23] と同じ色になります。
#~ 数値以外に、直接 Color オブジェクトで指定することもできます。

#~ # ◆ EP ゲージの開始色
#~ #  青色にする
#~ EP_GAUGE_START_COLOR = Color.new(0, 0, 255)

#~ 慣れないうちは、あまりこの方法を使用しない方が良いかもしれません。

#~ # ◆ EP ゲージに汎用ゲージを使用する
#~ ENABLE_GENERIC_GAUGE = true
#~ # ◆ EP ゲージ設定
#~ GAUGE_IMAGE  = "GaugeEP"  # 画像
#~ GAUGE_OFFSET = [-23, -2]  # 位置補正 [x, y]
#~ GAUGE_LENGTH = -4         # 長さ補正
#~ GAUGE_SLOPE  = 30         # 傾き (-89 ～ 89)

#~ ≪汎用ゲージ描画≫ 導入時に、汎用ゲージを EP ゲージとして使用します。
#~ 汎用ゲージの仕様は ≪汎用ゲージ描画≫ を参照してください。

#~ EP ゲージ用のサンプル画像です。
#~ 画像は "Graphics/System" に保存してください。
#~ Gauge
#~ 装備品の消費 EP 設定

#~ 武器・防具のメモ欄に <EP n> を追加します。
#~ nには、装備する際に必要な EP を半角で入力します。
#~ memo
#~ このアイテムは、EP が5ないと装備できません。
#~ イベント用コマンド

#~ 各コマンドは、イベントコマンド「スクリプト」に記述して使用します。

#~ set_actor_equip_type(actor_id[, equip_type])

#~     アクターactor_idの装備欄をequip_typeに変更します。
#~     equip_typeには、装備欄をカスタマイズ項目と同じ形式で指定します。
#~     equip_typeを省略するかnilを指定すると、カスタマイズ項目で設定した装備欄に戻ります。

#~     # アクターID:2 の装備欄を「盾, 身体, 装飾品, 装飾品, 装飾品」にする
#~     set_actor_equip_type(2, [0, 2, 3, 3, 3])

#~     # アクターID:2 の装備欄を戻す
#~     # (どちらの方法でも同じ)
#~     set_actor_equip_type(2, nil)
#~     set_actor_equip_type(2)

#~ get_actor_own_ep(actor_id[, variable_id])
#~     アクターID:actor_idの MaxEP 補正値をvariable_id番の変数に取得します。
#~     取得後、取得した値を戻り値として返します。
#~     variable_idを省略した場合、変数への取得は行われません。

#~     # アクターID:1 の MaxEP 補正値を変数 5 番に取得
#~     get_actor_own_ep(1, 5)

#~ set_actor_own_ep(actor_id, value)
#~     アクターID:actor_idの MaxEP 補正値をvalueにします。
#~     カスタマイズ項目で設定した上限・下限を超えることはできません。

#~     # アクターID:1 の EP を通常より 10 多くする
#~     set_actor_own_ep(1, 10)
#~     # アクターID:2 の EP を通常より 5 少なくする
#~     set_actor_own_ep(2, -5)

#~ gain_actor_ep(actor_id, value)
#~     アクターID:actor_idの MaxEP 補正値をvalue増加させます。
#~     カスタマイズ項目で設定した上限・下限を超えることはできません。

#~     # アクターID:1 の EP を 3 増やす
#~     gain_actor_ep(1, 3)
#~     # アクターID:2 の EP を 1 減らす
#~     gain_actor_ep(2, -1)

#~ change_actor_equipment(actor_id, index, item_id[, force_gain])

#~     アクターactor_idの装備欄indexの装備品をitem_idに変更します。
#~     indexには、武器を0、最初の防具欄を1とした番号を指定します。
#~     item_idには、変更後の武器 or 防具の ID を指定します。
#~     force_gainにtrueを指定すると、変更後の装備品を所持していなくても変更が可能になり、
#~     falseを指定すると、変更後の装備品を所持していない場合は変更できなくなります。
#~     force_gain省略時はfalse扱いとなります。

#~     装備を解除する場合は、item_idに0を指定します。

#~     # アクターID:1 の最初の防具（デフォルトでは「盾」）を防具ID:5 に変更
#~     change_actor_equipment(1, 1, 5)
#~     # アクターID:2 の３番目の防具（デフォルトでは「身体」）を防具ID:21 に変更
#~     # 所持していなくても OK
#~     change_actor_equipment(2, 3, 21, true)
#~     # アクターID:3 の武器を外す
#~     change_actor_equipment(3, 0, 0)

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module EquipExtension
  # ◆ 拡張装備種別
  #  先頭から順に 4, 5, 6, ... が割り当てられる。
  EXTRA_EQUIP_KIND = ["足"]

  # ◆ 装備箇所リスト
  #  武器の後に、ここで指定した順番で並ぶ。
  #  ※ 装備箇所が最低一つないと、二刀流がバグる可能性があります。
  #   ** 装備種別一覧 **
  #  0..盾  1..頭  2..身体  3..装飾品  4～..↑で定義
  EQUIP_TYPE = [0, 1, 2, 4, 3]

  # ◆ EP (Equip Point) 制を使用する
  #  true  : EP で装備品を制限。
  #  false : 通常の装備システム。
  USE_EP_SYSTEM  = false
  # ◆ EP の名前
  VOCAB_EP       = "ＥＰ"
  # ◆ EP の名前 (略)
  VOCAB_EP_A     = "Ｅ"
  # ◆ ステータス画面に EP を表示する
  SHOW_STATUS_EP = false

  # ◆ 消費 EP 既定値
  #  消費 EP が指定されていない装備品で使用。
  DEFAULT_EP_COST   = 1
  # ◆ 消費 EP 0 は表示しない
  HIDE_ZERO_EP_COST = true

  # ◆ EP 上限
  EP_MAX = 20
  # ◆ EP 下限
  EP_MIN = 5
  # ◆ 最大 EP 算出式
  #   level..アクターのレベル
  #  自動的に整数変換されるので、結果が小数になってもOK。
  EP_CALC_EXP = "level * 0.3 + 4"
  # ◆ アクター毎の最大 EP 算出式
  PERSONAL_EP_CALC_EXP = []
  #  ここから下に、アクターごとの最大 EP を
  #   PERSONAL_EP_CALC_EXP[アクター ID] = "計算式"
  #  という書式で指定。
  #  計算式は EP_CALC_EXP と同様の書式。
  #  指定しなかったアクターは EP_CALC_EXP を使用。
  #   <例> ラルフだけ優遇
  # PERSONAL_EP_CALC_EXP[1] = "level * 0.5 + 5"

  # ◆ 消費 EP 値の色 (アイテム名の末尾に付く数値)
  #  数値  : \C[n] と同じ色。
  #  Color : 指定した色。 ( Color.new(128, 255, 255) など )
  EP_COST_COLOR        = 23
  # ◆ EP ゲージの色
  EP_GAUGE_START_COLOR = 28  # 開始色
  EP_GAUGE_END_COLOR   = 29  # 終了色

  # ◆ EP ゲージに汎用ゲージを使用する
  #  ≪汎用ゲージ描画≫ 導入時のみ有効。
  ENABLE_GENERIC_GAUGE = true
  # ◆ EP ゲージ設定
  #  画像は "Graphics/System" から読み込む。
  GAUGE_IMAGE  = "GaugeEP"  # 画像
  GAUGE_OFFSET = [-23, -2]  # 位置補正 [x, y]
  GAUGE_LENGTH = -4         # 長さ補正
  GAUGE_SLOPE  = 30         # 傾き (-89 ～ 89)
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["EquipExtension"] = true

module KGC::EquipExtension
  # EP 制を使用しない場合の設定
  unless USE_EP_SYSTEM
    SHOW_STATUS_EP = false
    HIDE_ZERO_EP_COST = true
  end

  # 正規表現
  module Regexp
    # ベースアイテム
    module BaseItem
      # 消費 EP
      EP_COST = /<EP\s*(\d+)>/i
      # 装備タイプ
      EQUIP_TYPE = /<(?:EQUIP_TYPE|装備タイプ)\s*(\d+(?:\s*,\s*\d+)*)>/
    end

    # 防具
    module Armor
      # 装備種別
      EQUIP_KIND = /<(?:EQUIP_KIND|装備種別)\s*(.+)>/i
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ KGC::Commands
#==============================================================================

module KGC
module Commands
  module_function
  #--------------------------------------------------------------------------
  # ○ アクターの装備を修復
  #--------------------------------------------------------------------------
  def restore_equip
    (1...$data_actors.size).each { |i|
      actor = $game_actors[i]
      actor.restore_equip
    }
  end
  #--------------------------------------------------------------------------
  # ○ アクターの装備タイプを設定
  #     actor_id   : アクター ID
  #     equip_type : 装備タイプ
  #--------------------------------------------------------------------------
  def set_actor_equip_type(actor_id, equip_type = nil)
    actor = $game_actors[actor_id]
    return if actor == nil
    actor.equip_type = equip_type
  end
  #--------------------------------------------------------------------------
  # ○ アクターの MaxEP 補正値の取得
  #     actor_id    : アクター ID
  #     variable_id : 取得した値を代入する変数の ID
  #--------------------------------------------------------------------------
  def get_actor_own_ep(actor_id, variable_id = 0)
    value = $game_actors[actor_id].maxep_plus
    $game_variables[variable_id] = value if variable_id > 0
    return value
  end
  #--------------------------------------------------------------------------
  # ○ アクターの MaxEP 補正値の変更
  #     actor_id : アクター ID
  #     value    : MaxEP 補正値
  #--------------------------------------------------------------------------
  def set_actor_own_ep(actor_id, value)
    $game_actors[actor_id].maxep_plus = value
  end
  #--------------------------------------------------------------------------
  # ○ アクターの MaxEP 補正値の増加
  #     actor_id : アクター ID
  #     value    : 増加量
  #--------------------------------------------------------------------------
  def gain_actor_ep(actor_id, value)
    $game_actors[actor_id].maxep_plus += value
  end
  #--------------------------------------------------------------------------
  # ○ アクターの装備を変更
  #     actor_id   : アクター ID
  #     index      : 装備部位 (0～)
  #     item_id    : 武器 or 防具 ID (0 で解除)
  #     force_gain : 未所持なら取得 (true or false)
  #--------------------------------------------------------------------------
  def change_actor_equipment(actor_id, index, item_id, force_gain = false)
    actor = $game_actors[actor_id]
    return if actor == nil

    item = (index == 0 ? $data_weapons[item_id] : $data_armors[item_id])
    if actor.two_swords_style && index == 1
      item = $data_weapons[item_id]
    end
    if force_gain && $game_party.item_number(item) == 0
      $game_party.gain_item(item, 1)
    end
    actor.change_equip_by_id(index, item_id)
  end
end
end

class Game_Interpreter
  include KGC::Commands
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  # EP
  def self.ep
    return KGC::EquipExtension::VOCAB_EP
  end

  # EP (略)
  def self.ep_a
    return KGC::EquipExtension::VOCAB_EP_A
  end

  # 拡張防具欄
  def self.extra_armor(index)
    return KGC::EquipExtension::EXTRA_EQUIP_KIND[index]
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 装備拡張のキャッシュを作成
  #--------------------------------------------------------------------------
  def create_equip_extension_cache
    @__ep_cost = KGC::EquipExtension::DEFAULT_EP_COST
    @__equip_type = []

    self.note.each_line { |line|
      case line
      when KGC::EquipExtension::Regexp::BaseItem::EP_COST
        # 消費 EP
        @__ep_cost = $1.to_i
      when KGC::EquipExtension::Regexp::BaseItem::EQUIP_TYPE
        # 装備タイプ
        @__equip_type = []
        $1.scan(/\d+/) { |num|
          @__equip_type << num.to_i
        }
      end
    }

    # EP 制を使用しない場合は消費 EP = 0
    @__ep_cost = 0 unless KGC::EquipExtension::USE_EP_SYSTEM
  end
  #--------------------------------------------------------------------------
  # ○ 消費 EP
  #--------------------------------------------------------------------------
  def ep_cost
    create_equip_extension_cache if @__ep_cost == nil
    return @__ep_cost
  end
  #--------------------------------------------------------------------------
  # ○ 装備タイプ
  #--------------------------------------------------------------------------
  def equip_type
    create_equip_extension_cache if @__equip_type == nil
    return @__equip_type
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Armor
#==============================================================================

class RPG::Armor < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 装備拡張のキャッシュを作成
  #--------------------------------------------------------------------------
  def create_equip_extension_cache
    super
    @__kind = -1

    self.note.each_line { |line|
      if line =~ KGC::EquipExtension::Regexp::Armor::EQUIP_KIND
        # 装備種別
        e_index = KGC::EquipExtension::EXTRA_EQUIP_KIND.index($1)
        next if e_index == nil
        @__kind = e_index + 4
      end
    }
  end

unless $@
  #--------------------------------------------------------------------------
  # ○ 種別
  #--------------------------------------------------------------------------
  alias kind_KGC_EquipExtension kind
  def kind
    create_equip_extension_cache if @__kind == nil
    return (@__kind == -1 ? kind_KGC_EquipExtension : @__kind)
  end
end

end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_writer   :equip_type               # 装備タイプ
  attr_writer   :maxep_plus               # MaxEP 補正値
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  alias setup_KGC_EquipExtension setup
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @extra_armor_id = []

    setup_KGC_EquipExtension(actor_id)

    @__last_equip_type = nil
    restore_equip
  end
  #--------------------------------------------------------------------------
  # ○ MaxEP 取得
  #--------------------------------------------------------------------------
  def maxep
    calc_exp = KGC::EquipExtension::PERSONAL_EP_CALC_EXP[self.id]
    if calc_exp == nil
      calc_exp = KGC::EquipExtension::EP_CALC_EXP
    end
    n = Integer(eval(calc_exp)) + maxep_plus
    return [[n, ep_limit].min, KGC::EquipExtension::EP_MIN].max
  end
  #--------------------------------------------------------------------------
  # ○ EP 取得
  #--------------------------------------------------------------------------
  def ep
    n = 0
    equips.compact.each { |item| n += item.ep_cost }
    return [maxep - n, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ EP 上限取得
  #--------------------------------------------------------------------------
  def ep_limit
    return KGC::EquipExtension::EP_MAX
  end
  #--------------------------------------------------------------------------
  # ○ MaxEP 補正値取得
  #--------------------------------------------------------------------------
  def maxep_plus
    @maxep_plus = 0 if @maxep_plus == nil
    return @maxep_plus
  end
  #--------------------------------------------------------------------------
  # ○ 防具欄の取得
  #--------------------------------------------------------------------------
  def equip_type
    if @equip_type.is_a?(Array)
      return @equip_type
    else
      return KGC::EquipExtension::EQUIP_TYPE
    end
  end
  #--------------------------------------------------------------------------
  # ○ 防具欄の数
  #--------------------------------------------------------------------------
  def armor_number
    return equip_type.size
  end
  #--------------------------------------------------------------------------
  # ○ 拡張防具欄の数
  #--------------------------------------------------------------------------
  def extra_armor_number
    return [armor_number - 4, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ 防具 ID リストの取得
  #--------------------------------------------------------------------------
  def extra_armor_id
    @extra_armor_id = [] if @extra_armor_id == nil
    return @extra_armor_id
  end
  #--------------------------------------------------------------------------
  # ● 防具オブジェクトの配列取得
  #--------------------------------------------------------------------------
  alias armors_KGC_EquipExtension armors
  def armors
    result = armors_KGC_EquipExtension

    # ５番目以降の防具を追加
    extra_armor_number.times { |i|
      armor_id = extra_armor_id[i]
      result << (armor_id == nil ? nil : $data_armors[armor_id])
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更 (オブジェクトで指定)
  #     equip_type : 装備部位
  #     item       : 武器 or 防具 (nil なら装備解除)
  #     test       : テストフラグ (戦闘テスト、または装備画面での一時装備)
  #--------------------------------------------------------------------------
  alias change_equip_KGC_EquipExtension change_equip
  def change_equip(equip_type, item, test = false)
    n = (item != nil ? $game_party.item_number(item) : 0)

    change_equip_KGC_EquipExtension(equip_type, item, test)

    # 拡張防具欄がある場合のみ
    if extra_armor_number > 0 && (item == nil || n > 0)
      item_id = item == nil ? 0 : item.id
      case equip_type
      when 5..armor_number  # 拡張防具欄
        @extra_armor_id = [] if @extra_armor_id == nil
        @extra_armor_id[equip_type - 5] = item_id
      end
    end

    restore_battle_skill if $imported["SkillCPSystem"]
  end
  #--------------------------------------------------------------------------
  # ● 装備の破棄
  #     item : 破棄する武器 or 防具
  #    武器／防具の増減で「装備品も含める」のとき使用する。
  #--------------------------------------------------------------------------
  alias discard_equip_KGC_EquipExtension discard_equip
  def discard_equip(item)
    last_armors = [@armor1_id, @armor2_id, @armor3_id, @armor4_id]

    discard_equip_KGC_EquipExtension(item)

    curr_armors = [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
    return unless item.is_a?(RPG::Armor)  # 防具でない
    return if last_armors != curr_armors  # 既に破棄された

    # 拡張防具欄を検索
    extra_armor_number.times { |i|
      if extra_armor_id[i] == item.id
        @extra_armor_id[i] = 0
        break
      end
    }

    restore_battle_skill if $imported["SkillCPSystem"]
  end
  #--------------------------------------------------------------------------
  # ● 職業 ID の変更
  #     class_id : 新しい職業 ID
  #--------------------------------------------------------------------------
  alias class_id_equal_KGC_EquipExtension class_id=
  def class_id=(class_id)
    class_id_equal_KGC_EquipExtension(class_id)

    return if extra_armor_number == 0  # 拡張防具欄がない

    # 装備できない拡張防具を外す
    for i in 5..armor_number
      change_equip(i, nil) unless equippable?(equips[i])
    end
  end
  #--------------------------------------------------------------------------
  # ○ EP 条件クリア判定
  #     equip_type : 装備部位
  #     item       : 武器 or 防具
  #--------------------------------------------------------------------------
  def ep_condition_clear?(equip_type, item)
    return true if item == nil  # nil は解除なので OK

    curr_item = equips[equip_type]
    offset = (curr_item != nil ? curr_item.ep_cost : 0)
    return false if self.ep < (item.ep_cost - offset)   # EP 不足

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 装備を修復
  #--------------------------------------------------------------------------
  def restore_equip
    return if @__last_equip_type == equip_type

    # 以前の装備品・パラメータを退避
    last_equips = equips
    last_hp = self.hp
    last_mp = self.mp
    if $imported["SkillCPSystem"]
      last_battle_skill_ids = battle_skill_ids.clone
    end

    # 全装備解除
    last_equips.each_index { |i| change_equip(i, nil) }

    # 装備品・パラメータを復元
    last_equips.compact.each { |item| equip_legal_slot(item) }
    self.hp = last_hp
    self.mp = last_mp
    if $imported["SkillCPSystem"]
      last_battle_skill_ids.each_with_index { |s, i| set_battle_skill(i, s) }
    end
    @__last_equip_type = equip_type.clone
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ○ 装備品を正しい箇所にセット
  #     item : 武器 or 防具
  #--------------------------------------------------------------------------
  def equip_legal_slot(item)
    if item.is_a?(RPG::Weapon)
      if @weapon_id == 0
        # 武器 1
        change_equip(0, item)
      elsif two_swords_style && @armor1_id == 0
        # 武器 2 (二刀流の場合)
        change_equip(1, item)
      end
    elsif item.is_a?(RPG::Armor)
      if !two_swords_style && item.kind == equip_type[0] && @armor1_id == 0
        # 先頭の防具 (二刀流でない場合)
        change_equip(1, item)
      else
        # 装備箇所リストを作成
        list = [-1, @armor2_id, @armor3_id, @armor4_id]
        list += extra_armor_id
        # 正しい、かつ空いている箇所にセット
        equip_type.each_with_index { |kind, i|
          if kind == item.kind && list[i] == 0
            change_equip(i + 1, item)
            break
          end
        }
      end
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ EP の文字色を取得
  #     actor : アクター
  #--------------------------------------------------------------------------
  def ep_color(actor)
    return knockout_color if actor.maxep > 0 && actor.ep == 0
    return normal_color
  end
  #--------------------------------------------------------------------------
  # ○ EP ゲージの色 1 の取得
  #--------------------------------------------------------------------------
  def ep_gauge_color1
    color = KGC::EquipExtension::EP_GAUGE_START_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ○ EP ゲージの色 2 の取得
  #--------------------------------------------------------------------------
  def ep_gauge_color2
    color = KGC::EquipExtension::EP_GAUGE_END_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ○ EP の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 幅
  #--------------------------------------------------------------------------
  def draw_actor_ep(actor, x, y, width = 120)
    draw_actor_ep_gauge(actor, x, y, width)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 30, WLH, Vocab::ep_a)
    self.contents.font.color = ep_color(actor)
    xr = x + width
    if width < 120
      self.contents.draw_text(xr - 40, y, 40, WLH, actor.ep, 2)
    else
      self.contents.draw_text(xr - 90, y, 40, WLH, actor.ep, 2)
      self.contents.font.color = normal_color
      self.contents.draw_text(xr - 50, y, 10, WLH, "/", 2)
      self.contents.draw_text(xr - 40, y, 40, WLH, actor.maxep, 2)
    end
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ○ EP ゲージの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 幅
  #--------------------------------------------------------------------------
  def draw_actor_ep_gauge(actor, x, y, width = 120)
    if KGC::EquipExtension::ENABLE_GENERIC_GAUGE && $imported["GenericGauge"]
      # 汎用ゲージ
      draw_gauge(KGC::EquipExtension::GAUGE_IMAGE,
        x, y, width, actor.ep, [actor.maxep, 1].max,
        KGC::EquipExtension::GAUGE_OFFSET,
        KGC::EquipExtension::GAUGE_LENGTH,
        KGC::EquipExtension::GAUGE_SLOPE)
    else
      # デフォルトゲージ
      gw = width * actor.ep / [actor.maxep, 1].max
      gc1 = ep_gauge_color1
      gc2 = ep_gauge_color2
      self.contents.fill_rect(x, y + WLH - 8, width, 6, gauge_back_color)
      self.contents.gradient_fill_rect(x, y + WLH - 8, gw, 6, gc1, gc2)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 消費 EP の描画
  #     item    : 武器 or 防具
  #     rect    : 描画する領域
  #     enabled : 許可状態
  #--------------------------------------------------------------------------
  def draw_equipment_ep_cost(item, rect, enabled = true)
    return if item == nil
    # 消費 EP 0 を表示しない場合
    return if KGC::EquipExtension::HIDE_ZERO_EP_COST && item.ep_cost == 0

    color = KGC::EquipExtension::EP_COST_COLOR
    self.contents.font.color = (color.is_a?(Integer) ?
      text_color(color) : color)
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(rect, item.ep_cost, 2)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Equip
#==============================================================================

class Window_Equip < Window_Selectable
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = @actor.equips.clone
    @item_max = [@data.size, @actor.armor_number + 1].min
    create_contents

    # 装備箇所を描画
    self.contents.font.color = system_color
    if @actor.two_swords_style
      self.contents.draw_text(4,       0, 92, WLH, Vocab::weapon1)
      self.contents.draw_text(4, WLH * 1, 92, WLH, Vocab::weapon2)
    else
      self.contents.draw_text(4,       0, 92, WLH, Vocab::weapon)
      name = armor_slot_name(@actor.equip_type[0])
      self.contents.draw_text(4, WLH * 1, 92, WLH, name)
    end
    for i in 1...@actor.armor_number
      name = armor_slot_name(@actor.equip_type[i])
      self.contents.draw_text(4, WLH * (i + 1), 92, WLH, name)
    end

    # 装備品を描画
    rect = Rect.new(92, 0, self.width - 128, WLH)
    @item_max.times { |i|
      rect.y = WLH * i
      draw_item_name(@data[i], rect.x, rect.y)
      draw_equipment_ep_cost(@data[i], rect)
    }
  end
  #--------------------------------------------------------------------------
  # ○ 防具欄の名称を取得
  #     kind : 種別
  #--------------------------------------------------------------------------
  def armor_slot_name(kind)
    case kind
    when 0..3
      return eval("Vocab.armor#{kind + 1}")
    else
      return Vocab.extra_armor(kind - 4)
    end
  end

unless $imported["ExtendedEquipScene"]
  #--------------------------------------------------------------------------
  # ● カーソルを 1 ページ後ろに移動
  #--------------------------------------------------------------------------
  def cursor_pagedown
    return if Input.repeat?(Input::R)
    super
  end
  #--------------------------------------------------------------------------
  # ● カーソルを 1 ページ前に移動
  #--------------------------------------------------------------------------
  def cursor_pageup
    return if Input.repeat?(Input::L)
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    return unless self.active

    if Input.repeat?(Input::RIGHT)
      cursor_pagedown
    elsif Input.repeat?(Input::LEFT)
      cursor_pageup
    end
  end
end

end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_EquipItem
#==============================================================================

class Window_EquipItem < Window_Item
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_enabled = []
    super
    @data.each { |item| @item_enabled << enable?(item) }
  end
  #--------------------------------------------------------------------------
  # ● アイテムをリストに含めるかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def include?(item)
    return true if item == nil
    if @equip_type == 0
      return false unless item.is_a?(RPG::Weapon)
    else
      return false unless item.is_a?(RPG::Armor)
      return false unless item.kind == @equip_type - 1
    end
    return @actor.equippable?(item)
  end
  #--------------------------------------------------------------------------
  # ● アイテムを許可状態で表示するかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def enable?(item)
    return false unless @actor.equippable?(item)                      # 装備不可
    return false unless @actor.ep_condition_clear?(@equip_type, item)  # EP 不足

    return true
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    super(index)    
    rect = item_rect(index)
    item = @data[index]

    # 個数表示分の幅を削る
    cw = self.contents.text_size(sprintf(":%2d", 0)).width
    rect.width -= cw + 4
    draw_equipment_ep_cost(item, rect, enable?(item))
  end
  #--------------------------------------------------------------------------
  # ○ 簡易リフレッシュ
  #     equip_type : 装備部位
  #--------------------------------------------------------------------------
  def simple_refresh(equip_type)
    # 一時的に装備部位を変更
    last_equip_type = @equip_type
    @equip_type = equip_type

    @data.each_with_index { |item, i|
      # 許可状態が変化した項目のみ再描画
      if enable?(item) != @item_enabled[i]
        draw_item(i)
        @item_enabled[i] = enable?(item)
      end
    }
    # 装備部位を戻す
    @equip_type = last_equip_type
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_EquipStatus
#==============================================================================

class Window_EquipStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_KGC_EquipExtension refresh
  def refresh
    refresh_KGC_EquipExtension

    draw_actor_ep(@actor, 120, 0, 56) if KGC::EquipExtension::USE_EP_SYSTEM
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Status
#==============================================================================

class Window_Status < Window_Base

if KGC::EquipExtension::SHOW_STATUS_EP
  #--------------------------------------------------------------------------
  # ● 基本情報の描画
  #     x : 描画先 X 座標
  #     y : 描画先 Y 座標
  #--------------------------------------------------------------------------
  alias draw_basic_info_KGC_EquipExtension draw_basic_info
  def draw_basic_info(x, y)
    draw_basic_info_KGC_EquipExtension(x, y)

    draw_actor_ep(@actor, x + 160, y + WLH * 4)
  end
end

  #--------------------------------------------------------------------------
  # ● 装備品の描画
  #     x : 描画先 X 座標
  #     y : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_equipments(x, y)
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, 120, WLH, Vocab::equip)

    item_number = [@actor.equips.size, @actor.armor_number + 1].min
    item_number.times { |i|
      draw_item_name(@actor.equips[i], x + 16, y + WLH * (i + 1))
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_ShopStatus
#==============================================================================

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● アクターの現装備と能力値変化の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_parameter_change(actor, x, y)
    return if @item.is_a?(RPG::Item)
    enabled = actor.equippable?(@item)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x, y, 200, WLH, actor.name)
    if @item.is_a?(RPG::Weapon)
      item1 = weaker_weapon(actor)
    elsif actor.two_swords_style and @item.kind == 0
      item1 = nil
    else
      index = actor.equip_type.index(@item.kind)
      item1 = (index != nil ? actor.equips[1 + index] : nil)
    end
    if enabled
      if @item.is_a?(RPG::Weapon)
        atk1 = item1 == nil ? 0 : item1.atk
        atk2 = @item == nil ? 0 : @item.atk
        change = atk2 - atk1
      else
        def1 = item1 == nil ? 0 : item1.def
        def2 = @item == nil ? 0 : @item.def
        change = def2 - def1
      end
      self.contents.draw_text(x, y, 200, WLH, sprintf("%+d", change), 2)
    end
    draw_item_name(item1, x, y + WLH, enabled)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Equip
#==============================================================================

class Scene_Equip < Scene_Base
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  EQUIP_TYPE_MAX = KGC::EquipExtension::EXTRA_EQUIP_KIND.size + 5
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_index : アクターインデックス
  #     equip_index : 装備インデックス
  #--------------------------------------------------------------------------
  alias initialize_KGC_EquipExtension initialize
  def initialize(actor_index = 0, equip_index = 0)
    initialize_KGC_EquipExtension(actor_index, equip_index)

    unit = ($imported["LargeParty"] ?
      $game_party.all_members : $game_party.members)
    actor = unit[actor_index]
    @equip_index = [@equip_index, actor.armor_number].min
  end
  #--------------------------------------------------------------------------
  # ● アイテムウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_item_windows_KGC_EquipExtension create_item_windows
  def create_item_windows
    create_item_windows_KGC_EquipExtension

    kind = equip_kind(@equip_index)
    EQUIP_TYPE_MAX.times { |i|
      @item_windows[i].visible = (kind == i)
    }
  end
  #--------------------------------------------------------------------------
  # ● アイテムウィンドウの更新
  #--------------------------------------------------------------------------
  def update_item_windows
    kind = equip_kind(@equip_window.index)
    for i in 0...EQUIP_TYPE_MAX
      @item_windows[i].visible = (kind == i)
      @item_windows[i].update
    end
    @item_window = @item_windows[kind]
    @item_window.simple_refresh(@equip_window.index)
  end
  #--------------------------------------------------------------------------
  # ○ 装備欄の種別を取得
  #     index : 装備欄インデックス
  #--------------------------------------------------------------------------
  def equip_kind(index)
    if index == 0
      return 0
    else
      return @actor.equip_type[index - 1] + 1
    end
  end

unless $imported["ExtendedEquipScene"]
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの更新
  #--------------------------------------------------------------------------
  def update_status_window
    if @equip_window.active
      @status_window.set_new_parameters(nil, nil, nil, nil)
    elsif @item_window.active
      temp_actor = Marshal.load(Marshal.dump(@actor))
      temp_actor.change_equip(@equip_window.index, @item_window.item, true)
      new_atk = temp_actor.atk
      new_def = temp_actor.def
      new_spi = temp_actor.spi
      new_agi = temp_actor.agi
      @status_window.set_new_parameters(new_atk, new_def, new_spi, new_agi)
    end
    @status_window.update
  end
end

  #--------------------------------------------------------------------------
  # ● アイテム選択の更新
  #--------------------------------------------------------------------------
  alias update_item_selection_KGC_EquipExtension update_item_selection
  def update_item_selection
    if Input.trigger?(Input::C)
      # 装備不可能な場合
      index = @equip_window.index
      item = @item_window.item
      unless item == nil ||
          (@actor.equippable?(item) && @actor.ep_condition_clear?(index, item))
        Sound.play_buzzer
        return
      end
    end

    update_item_selection_KGC_EquipExtension
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_File
#==============================================================================

class Scene_File < Scene_Base
  #--------------------------------------------------------------------------
  # ● セーブデータの読み込み
  #     file : 読み込み用ファイルオブジェクト (オープン済み)
  #--------------------------------------------------------------------------
  alias read_save_data_KGC_EquipExtension read_save_data
  def read_save_data(file)
    read_save_data_KGC_EquipExtension(file)

    KGC::Commands.restore_equip
    Graphics.frame_reset
  end
end
