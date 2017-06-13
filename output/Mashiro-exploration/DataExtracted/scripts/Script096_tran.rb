#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 限界突破 - KGC_LimitBreak ◆ VX ◆
#_/    ◇ Last update : 2008/01/09 ◇
#_/----------------------------------------------------------------------------
#_/  ゲーム中の各種上限値を変更します。
#_/============================================================================
#_/  再定義が多いので、「素材」の最上部に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ 能力値算出

#~ # ◆能力値算出方式
#~ PARAMETER_CALC_METHOD = 0

#~ 能力値の算出方式を指定します。

#~ PARAMETER_CALC_METHOD = 0
#~     レベル99までは、データベースの値をそのまま使用します。
#~     レベル100以降は、

#~     # ◆レベル 100 以降の能力値計算式
#~     PARAMETER_CALC_EXP = "(param[99] - param[98]) * (level - 99)"

#~     ここで設定した計算式の結果をレベル99の値に加算したものを使用します。
#~     この計算式を書き換えなかった場合、レベル99と98の値の差に、
#~     現在のレベルから99を引いた値をかけて、レベル99の値に加算します。
#~ PARAMETER_CALC_METHOD = 1

#~     a = データベースのレベル 1 の値
#~     b = データベースのレベル 2 の値
#~     c = データベースのレベル 3 の値
#~     x = 現在のレベル

#~     として、ax2 + bx + cを用いて能力値を算出します。

#~       < 例 >
#~     レベル 1 の値 : 4
#~     レベル 2 の値 : 30
#~     レベル 3 の値 : 400
#~     のとき、レベル 50 での能力値は、
#~     (4 * 50 + 30) * 50 + 400 = 11900
#~     レベル 100 での能力値は、
#~     (4 * 100 + 30) * 100 + 400 = 43400

#~     レベル上限が高いほど激しいインフレを起こすので、注意して使用してください。
#~ PARAMETER_CALC_METHOD = 2

#~     b = データベースのレベル 2 の値
#~     c = データベースのレベル 3 の値
#~     x = 現在のレベル

#~     として、bx + cを用いて能力値を算出します。

#~       < 例 >
#~     レベル 2 の値 : 120
#~     レベル 3 の値 : 800
#~     のとき、レベル 50 での能力値は、
#~     120 * 50 + 800 = 6800
#~     レベル 100 での能力値は、
#~     120 * 100 + 800 = 12800

#~ レベル上限

#~ # ◆アクターのレベル上限
#~ ACTOR_FINAL_LEVEL = []  # ← これは消さないこと！

#~ ここでは、アクターのレベル上限を設定します。
#~ この下に、アクターごとのレベル上限を

#~ ACTOR_FINAL_LEVEL[アクターID] = 最終レベル

#~ という書式で入力してください。

#~ # ◆アクターのレベル上限
#~ ACTOR_FINAL_LEVEL = []  # ← これは消さないこと！
#~ # ～ ここから追加 ～
#~ # アクター 1 の最終レベル: 999
#~ ACTOR_FINAL_LEVEL[1] = 999
#~ # アクター 6 の最終レベル: 500
#~ ACTOR_FINAL_LEVEL[6] = 500

#~ 上限を指定しなかったアクターは、

#~ # ◆アクターのレベル上限 (デフォルト)
#~ ACTOR_FINAL_LEVEL_DEFAULT = 999

#~ この値をレベル上限として使用します。
#~ レベル上限を高くすると、それだけ経験値も多く必要になります。
#~ レベルが上限に達する前に経験値が上限に達する場合は、

#~ # ◆アクターの経験値上限
#~ ACTOR_EXP_LIMIT = 99999999

#~ ここを調整してください。

#~ ちなみに、レベル 100 以降は、次のレベルまでの経験値がほぼ一定になります。
#~ これはバグではなく、VX の経験値計算式の仕様です。
#~ （データベースとの整合性を保つため、このスクリプトでは計算式を変更していません）

#~ 経験値計算式はスクリプトを書き換えれば変更できますが、自己責任でお願いします。
#~ パラメータ上限

#~ # ◆アクターの MaxHP 上限
#~ ACTOR_MAXHP_LIMIT     = 99999
#~ # ◆アクターの MaxMP 上限
#~ ACTOR_MAXMP_LIMIT     = 99999
#~ # ◆アクターの攻撃力、防御力、精神力、敏捷性上限
#~ ACTOR_PARAMETER_LIMIT = 9999

#~ # ◆エネミーの MaxHP 上限
#~ ENEMY_MAXHP_LIMIT     = 9999999
#~ # ◆エネミーの MaxMP 上限
#~ ENEMY_MAXMP_LIMIT     = 9999999
#~ # ◆エネミーの攻撃力、防御力、精神力、敏捷性上限
#~ ENEMY_PARAMETER_LIMIT = 9999

#~ アクター・エネミーの能力値上限を設定します。
#~ エネミーには「レベル」という概念がないので、パラメータをデータベースの値より大きくする場合は、

#~ #--------------------------------------------------------------------------
#~ # ● 敵能力値直接指定
#~ #     ここで、敵の MaxHP などを直接指定することができます。
#~ #     データベースに入りきらない数値を指定する場合に使用してください。
#~ #--------------------------------------------------------------------------
#~ def set_enemy_parameters
#~   # ...
#~ end

#~ この中で直接設定してください。

#~ # 設定例
#~ def set_enemy_parameters
#~   # ID:10 の敵の MaxHP を 2000000 にする
#~   $data_enemies[10].maxhp = 2000000
#~   # ID:16 の敵の攻撃力を 5000 にする
#~   $data_enemies[16].atk = 5000
#~   # ID:20 の敵の防御力を２倍にする
#~   $data_enemies[20].def *= 2
#~ end

#~ アイテム所持数上限

#~ アイテム・武器・防具の「メモ」欄に <所持数上限 n> を追加します。
#~ nには、アイテムを所持できる数を半角で入力します。
#~ memo
#~ このアイテムは、30個までしか持つことができなくなります。

#~ <所持数上限 n> の代わりに <number_limit n> を使用することもできます。
#~ 所持数上限を指定しなかったアイテムは、

#~ # ◆アイテム所持数上限
#~ ITEM_NUMBER_LIMIT = 99

#~ ここで設定した数まで持つことができます。

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module LimitBreak
  # ◆ 能力値算出方式
  #   0..データベース通り。
  #      (100以降は計算式として PARAMETER_CALC_EXP を使用)
  #
  #   1..データベースを用いた２次関数。
  #        a:レベル1の値  b:レベル2の値  c:レベル3の値  x:現レベル
  #      として、
  #        ax^2 + bx + c
  #      を用いて能力値を算出。
  #
  #   2..データベースを用いた１次関数。
  #        b:レベル2の値  c:レベル3の値  x:現レベル
  #      として、
  #        bx + c
  #      を用いて能力値を算出。
  #      (レベル 2 と 3 の値を使うのは、２次関数方式との使い分けを楽にするため)
  PARAMETER_CALC_METHOD = 0

  # ◆ レベル 100 以降の能力値計算式
  #  PARAMETER_CALC_METHOD = 0 のときに使用します。
  #  【 level..現レベル  param[x]..レベル x の能力値 】
  #  この計算結果をレベル 99 の能力値に加算します。
  PARAMETER_CALC_EXP = "(param[99] - param[97]) * (level - 99)"

  # ◆ アクターのレベル上限
  ACTOR_FINAL_LEVEL = []  # ← これは消さないこと！
  # ここから下に、アクターごとの最終レベルを
  #   ACTOR_FINAL_LEVEL[アクターID] = 最終レベル
  # という形式で設定します。
  # <例> ↓ アクター 1 の最終レベル 999
  ACTOR_FINAL_LEVEL[18] = 5400
  ACTOR_FINAL_LEVEL[19] = 2700
  ACTOR_FINAL_LEVEL[16] = 850
  # ◆ アクターのレベル上限 (デフォルト)
  #  上限を指定しなかった場合は、この値を最終レベルとして使用します。
  ACTOR_FINAL_LEVEL_DEFAULT = 220
  # ◆ アクターの経験値上限
  ACTOR_EXP_LIMIT = 7800000000

  # ◆ アクターの MaxHP 上限
  ACTOR_MAXHP_LIMIT     = 9999999
  # ◆ アクターの MaxMP 上限
  ACTOR_MAXMP_LIMIT     = 9999999
  # ◆ アクターの攻撃力、防御力、精神力、敏捷性上限
  ACTOR_PARAMETER_LIMIT = 9999999

  # ◆ エネミーの MaxHP 上限
  ENEMY_MAXHP_LIMIT     = 999999999
  # ◆ エネミーの MaxMP 上限
  ENEMY_MAXMP_LIMIT     = 999999999
  # ◆ エネミーの攻撃力、防御力、精神力、敏捷性上限
  ENEMY_PARAMETER_LIMIT = 999999

  # ◆ エネミーの能力値補正
  #  エネミーの各種能力値をデータベースの ○％ にします。
  #  データベース通りにする場合は 100 にしてください。
  ENEMY_MAXHP_RATE = 1000  # MaxHP
  ENEMY_MAXMP_RATE = 1000  # MaxMP
  ENEMY_ATK_RATE   = 1000  # 攻撃力
  ENEMY_DEF_RATE   = 1000  # 防御力
  ENEMY_SPI_RATE   = 1000  # 精神力
  ENEMY_AGI_RATE   = 1000  # 敏捷性

  # ◆ 所持金上限
  GOLD_LIMIT = 99999999

  # ◆ アイテム所持数上限
  ITEM_NUMBER_LIMIT = 99

  module_function
  #--------------------------------------------------------------------------
  # ○ 敵能力値直接指定
  #     ここで、敵の MaxHP などを直接指定することができます。
  #     データベースに入りきらない数値を指定する場合に使用してください。
  #--------------------------------------------------------------------------
  def set_enemy_parameters
    #  <例> ID:10 の敵の MaxHP を 2000000 にする場合
    # $data_enemies[10].maxhp = 2000000
    #  <例> ID:16 の敵の攻撃力を 5000 にする場合
    # $data_enemies[16].atk = 5000
    #  <例> ID:20 の敵の防御力を２倍にする場合
    # $data_enemies[20].def *= 2
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["LimitBreak"] = true

module KGC::LimitBreak
  # 正規表現を定義
  module Regexp
    # ベースアイテム
    module BaseItem
      # 所持数上限
      NUMBER_LIMIT = /<(?:NUMBER_LIMIT|所持数上限)[ ]*(\d+)>/i
    end
  end

  module_function
  #--------------------------------------------------------------------------
  # ○ 敵の能力補正を適用
  #--------------------------------------------------------------------------
  def revise_enemy_parameters
    (1...$data_enemies.size).each { |i|
      enemy = $data_enemies[i]
      enemy.maxhp = enemy.maxhp * ENEMY_MAXHP_RATE / 100
      enemy.maxmp = enemy.maxmp * ENEMY_MAXMP_RATE / 100
      enemy.atk = enemy.atk * ENEMY_ATK_RATE / 100
      enemy.def = enemy.def * ENEMY_DEF_RATE / 100
      enemy.spi = enemy.spi * ENEMY_SPI_RATE / 100
      enemy.agi = enemy.agi * ENEMY_AGI_RATE / 100
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ 限界突破のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_limit_break_cache
    @__number_limit = KGC::LimitBreak::ITEM_NUMBER_LIMIT

    self.note.split(/[\r\n]+/).each { |line|
      if line =~ KGC::LimitBreak::Regexp::BaseItem::NUMBER_LIMIT
        # 所持数上限
        @__number_limit = $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 所持数上限取得
  #--------------------------------------------------------------------------
  def number_limit
    create_limit_break_cache if @__number_limit == nil
    return @__number_limit
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● MaxHP の制限値取得
  #--------------------------------------------------------------------------
  def maxhp_limit
    return KGC::LimitBreak::ENEMY_MAXHP_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ MaxMP の制限値取得
  #--------------------------------------------------------------------------
  def maxmp_limit
    return KGC::LimitBreak::ENEMY_MAXMP_LIMIT
  end
  #--------------------------------------------------------------------------
  # ● MaxMP の取得
  #--------------------------------------------------------------------------
  def maxmp
    return [[base_maxmp + @maxmp_plus, 0].max, maxmp_limit].min
  end
  #--------------------------------------------------------------------------
  # ○ 各種パラメータの制限値取得
  #--------------------------------------------------------------------------
  def parameter_limit
    return KGC::LimitBreak::ENEMY_PARAMETER_LIMIT
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の取得
  #--------------------------------------------------------------------------
  def atk
    n = [base_atk + @atk_plus, 1].max
    states.each { |state| n *= state.atk_rate / 100.0 }
    n = [[Integer(n), 1].max, parameter_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 防御力の取得
  #--------------------------------------------------------------------------
  def def
    n = [base_def + @def_plus, 1].max
    states.each { |state| n *= state.def_rate / 100.0 }
    n = [[Integer(n), 1].max, parameter_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 精神力の取得
  #--------------------------------------------------------------------------
  def spi
    n = [base_spi + @spi_plus, 1].max
    states.each { |state| n *= state.spi_rate / 100.0 }
    n = [[Integer(n), 1].max, parameter_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 敏捷性の取得
  #--------------------------------------------------------------------------
  def agi
    n = [base_agi + @agi_plus, 1].max
    states.each { |state| n *= state.agi_rate / 100.0 }
    n = [[Integer(n), 1].max, parameter_limit].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の設定
  #     new_maxhp : 新しい MaxHP
  #--------------------------------------------------------------------------
  def maxhp=(new_maxhp)
    @maxhp_plus += new_maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -maxhp_limit].max, maxhp_limit].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● MaxMP の設定
  #     new_maxmp : 新しい MaxMP
  #--------------------------------------------------------------------------
  def maxmp=(new_maxmp)
    @maxmp_plus += new_maxmp - self.maxmp
    @maxmp_plus = [[@maxmp_plus, -maxmp_limit].max, maxmp_limit].min
    @mp = [@mp, self.maxmp].min
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の設定
  #     new_atk : 新しい攻撃力
  #--------------------------------------------------------------------------
  def atk=(new_atk)
    @atk_plus += new_atk - self.atk
    @atk_plus = [[@atk_plus, -parameter_limit].max, parameter_limit].min
  end
  #--------------------------------------------------------------------------
  # ● 防御力の設定
  #     new_def : 新しい防御力
  #--------------------------------------------------------------------------
  def def=(new_def)
    @def_plus += new_def - self.def
    @def_plus = [[@def_plus, -parameter_limit].max, parameter_limit].min
  end
  #--------------------------------------------------------------------------
  # ● 精神力の設定
  #     new_spi : 新しい精神力
  #--------------------------------------------------------------------------
  def spi=(new_spi)
    @spi_plus += new_spi - self.spi
    @spi_plus = [[@spi_plus, -parameter_limit].max, parameter_limit].min
  end
  #--------------------------------------------------------------------------
  # ● 敏捷性の設定
  #     agi : 新しい敏捷性
  #--------------------------------------------------------------------------
  def agi=(new_agi)
    @agi_plus += new_agi - self.agi
    @agi_plus = [[@agi_plus, -parameter_limit].max, parameter_limit].min
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 経験値計算
  #--------------------------------------------------------------------------
  def make_exp_list
    @exp_list = Array.new(final_level + 2)
    @exp_list[1] = @exp_list[final_level + 1] = 0
    m = actor.exp_basis
    n = 0.75 + actor.exp_inflation / 200.0
    (2..final_level).each { |i|
      @exp_list[i] = @exp_list[i-1] + Integer(m)
      m *= 1 + n
      n *= 0.9
    }
  end
  #--------------------------------------------------------------------------
  # ○ 最終レベルの取得
  #--------------------------------------------------------------------------
  def final_level
    n = KGC::LimitBreak::ACTOR_FINAL_LEVEL[self.id]
    return (n != nil ? n : KGC::LimitBreak::ACTOR_FINAL_LEVEL_DEFAULT)
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の制限値取得
  #--------------------------------------------------------------------------
  def maxhp_limit
    return KGC::LimitBreak::ACTOR_MAXHP_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ MaxMP の制限値取得
  #--------------------------------------------------------------------------
  def maxmp_limit
    return KGC::LimitBreak::ACTOR_MAXMP_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ 各種パラメータの制限値取得
  #--------------------------------------------------------------------------
  def parameter_limit
    return KGC::LimitBreak::ACTOR_PARAMETER_LIMIT
  end
  #--------------------------------------------------------------------------
  # ○ 経験値の制限値取得
  #--------------------------------------------------------------------------
  def exp_limit
    return KGC::LimitBreak::ACTOR_EXP_LIMIT
  end
  #--------------------------------------------------------------------------
  # ● 経験値の変更
  #     exp  : 新しい経験値
  #     show : レベルアップ表示フラグ
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    last_level = @level
    last_skills = skills
    @exp = [[exp, exp_limit].min, 0].max
    while @exp >= @exp_list[@level+1] && @exp_list[@level+1] > 0
      level_up
    end
    while @exp < @exp_list[@level]
      level_down
    end
    @hp = [@hp, maxhp].min
    @mp = [@mp, maxmp].min
    if show && @level > last_level
      display_level_up(skills - last_skills)
    end
  end
  #--------------------------------------------------------------------------
  # ● レベルの変更
  #     level : 新しいレベル
  #     show  : レベルアップ表示フラグ
  #--------------------------------------------------------------------------
  def change_level(level, show)
    level = [[level, final_level].min, 1].max
    change_exp(@exp_list[level], show)
  end
  #--------------------------------------------------------------------------
  # ○ 基本パラメータの取得
  #--------------------------------------------------------------------------
  def base_parameter(type)
    case KGC::LimitBreak::PARAMETER_CALC_METHOD
    when 0  # 数式定義
      if @level >= 100
        calc_text = KGC::LimitBreak::PARAMETER_CALC_EXP.dup
        calc_text.gsub!(/level/i) { "@level" }
        calc_text.gsub!(/param\[(\d+)\]/i) {
          "actor.parameters[type, #{$1.to_i}]"
        }
        return actor.parameters[type, 99] + eval(calc_text)
      end
    when 1  # 二次関数
      a = actor.parameters[type, 1]
      b = actor.parameters[type, 2]
      c = actor.parameters[type, 3]
      return ((a * @level + b) * @level + c)
    when 2  # 一次関数
      b = actor.parameters[type, 2]
      c = actor.parameters[type, 3]
      return (b * @level + c)
    end
    return actor.parameters[type, @level]
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxHP の取得
  #--------------------------------------------------------------------------
  def base_maxhp
    return base_parameter(0)
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxMP の取得
  #--------------------------------------------------------------------------
  def base_maxmp
    return base_parameter(1)
  end
  #--------------------------------------------------------------------------
  # ● 基本攻撃力の取得
  #--------------------------------------------------------------------------
  def base_atk
    n = base_parameter(2)
    equips.compact.each { |item| n += item.atk }
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本防御力の取得
  #--------------------------------------------------------------------------
  def base_def
    n = base_parameter(3)
    equips.compact.each { |item| n += item.def }
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本精神力の取得
  #--------------------------------------------------------------------------
  def base_spi 
    n = base_parameter(4)
    equips.compact.each { |item| n += item.spi }
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本敏捷性の取得
  #--------------------------------------------------------------------------
  def base_agi
    n = base_parameter(5)
    equips.compact.each { |item| n += item.agi }
    return n
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ○ 所持金の制限値取得
  #--------------------------------------------------------------------------
  def gold_limit
    return KGC::LimitBreak::GOLD_LIMIT
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの増加 (減少)
  #     n : 金額
  #--------------------------------------------------------------------------
  def gain_gold(n)
    @gold = [[@gold + n, 0].max, gold_limit].min
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増加 (減少)
  #     item          : アイテム
  #     n             : 個数
  #     include_equip : 装備品も含める
  #--------------------------------------------------------------------------
  def gain_item(item, n, include_equip = false)
    number = item_number(item)
    case item
    when RPG::Item
      @items[item.id] = [[number + n, 0].max, item.number_limit].min
    when RPG::Weapon
      @weapons[item.id] = [[number + n, 0].max, item.number_limit].min
    when RPG::Armor
      @armors[item.id] = [[number + n, 0].max, item.number_limit].min
    end
    n += number
    if include_equip && n < 0
      members.each { |actor|
        while n < 0 && actor.equips.include?(item)
          actor.discard_equip(item)
          n += 1
        end
      }
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_ShopBuy
#==============================================================================

class Window_ShopBuy < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    number = $game_party.item_number(item)
    enabled = (item.price <= $game_party.gold && number < item.number_limit)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    draw_item_name(item, rect.x, rect.y, enabled)
    rect.width -= 4
    self.contents.draw_text(rect, item.price, 2)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● データベースのロード
  #--------------------------------------------------------------------------
  alias load_database_KGC_LimitBreak load_database
  def load_database
    load_database_KGC_LimitBreak

    set_enemy_parameters
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト用データベースのロード
  #--------------------------------------------------------------------------
  alias load_bt_database_KGC_LimitBreak load_bt_database
  def load_bt_database
    load_bt_database_KGC_LimitBreak

    set_enemy_parameters
  end
  #--------------------------------------------------------------------------
  # ○ エネミーの能力値を設定
  #--------------------------------------------------------------------------
  def set_enemy_parameters
    KGC::LimitBreak.revise_enemy_parameters
    KGC::LimitBreak.set_enemy_parameters
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
  alias read_save_data_KGC_LimitBreak read_save_data
  def read_save_data(file)
    read_save_data_KGC_LimitBreak(file)

    (1...$data_actors.size).each { |i|
      actor = $game_actors[i]
      actor.make_exp_list
      # レベル上限チェック
      if actor.level > actor.final_level
        while actor.level > actor.final_level
          actor.level_down
        end
        # 減少した HP などを反映させるためのおまじない
        actor.change_level(actor.final_level, false)
      end
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Shop
#==============================================================================

class Scene_Shop < Scene_Base
  #--------------------------------------------------------------------------
  # ● 購入アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_buy_selection
    @status_window.item = @buy_window.item
    if Input.trigger?(Input::B)
      Sound.play_cancel
      @command_window.active = true
      @dummy_window.visible = true
      @buy_window.active = false
      @buy_window.visible = false
      @status_window.visible = false
      @status_window.item = nil
      @help_window.set_text("")
      return
    end
    if Input.trigger?(Input::C)
      @item = @buy_window.item
      number = $game_party.item_number(@item)
      if @item == nil || @item.price > $game_party.gold ||
          number == @item.number_limit
        Sound.play_buzzer
      else
        Sound.play_decision
        max = (@item.price == 0 ?
          @item.number_limit : $game_party.gold / @item.price)
        max = [max, @item.number_limit - number].min
        @buy_window.active = false
        @buy_window.visible = false
        @number_window.set(@item, max, @item.price)
        @number_window.active = true
        @number_window.visible = true
      end
    end
  end
end
