#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 200x/XP 機能再現 - KGC_ReproduceFunctions ◆ VX ◆
#_/    ◇ Last update : 2008/05/09 ◇
#_/----------------------------------------------------------------------------
#_/  200x/XP の機能を再現します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ 特定の武器属性がないと使用できないスキル

#~ # ◆「武器属性」と見なす属性の範囲
#~ WEAPON_ELEMENTS = [1..6]
#~ スキル使用時に「武器属性」として扱う属性のIDを入力します。
#~ デフォルトでは、属性の1～6番を「武器属性」として扱うように設定してあります。
#~ ここで指定した属性をスキルにセットすると、セットした属性を持った武器を装備していない場合は
#~ そのスキルが使用できなくなります。
#~ （例: 「斬撃」属性のスキルは、「斬撃」属性を持つ武器を装備しないと使えない）
#~ 素手状態は属性1（格闘）として扱われます。

#~ 複数回使用可能なアイテム
#~ アイテムの「メモ」欄に <使用回数 n> を追加します。
#~ nには、使用回数を半角で入力します。
#~ このアイテムは3回使うと1個消費するようになります。
#~ <使用回数 n> の代わりに <multi_usable n> を使用することもできます。

#~ スキル発動アイテム
#~ アイテムの「メモ」欄に <スキル発動 n> を追加します。
#~ nには、発動するスキルの ID を半角で入力します。
#~ このアイテムは使用時に ID6のスキルを発動するようになります。
#~ <スキル発動 n> の代わりに <exec_skill n> を使用することもできます。

#~ 通常攻撃時に MP を消費
#~ 武器・防具の「メモ」欄に <消費MP n> を追加します。
#~ nには、消費する MP を半角で入力します。
#~ このアイテムを装備して通常攻撃すると MP を10消費します。
#~ （MP が無くなっても攻撃は可能です。これは 200x と同じ仕様です）
#~ <消費MP n> の代わりに <mp_cost n> を使用することもできます。

#~ 全体攻撃
#~ 武器・防具の「メモ」欄に <全体攻撃> を追加します。
#~ このアイテムを装備して通常攻撃すると、敵全体がターゲットになります。
#~ 「２回攻撃 + 全体攻撃」を二刀流で装備させれば、完全なネタキャラと化します。
#~ <全体攻撃> の代わりに <whole_attack> を使用することもできます。

#~ 回避率無視
#~ 武器・防具の「メモ」欄に <回避率無視> を追加します。
#~ このアイテムを装備して攻撃した際、敵の回避率を無視するようになります。
#~ 命中率は変化しないため、攻撃が外れることはあります。
#~ <回避率無視> の代わりに <ignore_eva> を使用することもできます。

#~ 装備品のクリティカル率修正
#~ 武器・防具の「メモ」欄に <クリティカル率 n> を追加します。
#~ nには、クリティカル率の修正値を半角整数で入力します。
#~ このアイテムを装備して攻撃した際のクリティカル率が20%上昇します。
#~ マイナス値も指定可能です。
#~ <クリティカル率 n> の代わりに <critical n> を使用することもできます。

#~ エネミー半透明表示
#~ エネミーの「メモ」欄に <半透明> を追加します。
#~ これで、戦闘時のエネミーグラフィックが半透明表示になります。
#~ <半透明> の代わりに <translucent> を使用することもできます。

#~ エネミーのクリティカル率設定
#~ エネミーの「クリティカルあり」をオンにして、「メモ」欄に <クリティカル率 n> を追加します。
#~ nには、クリティカル発生率を半角整数で入力します。
#~ このエネミーは20%の確率でクリティカルヒットを出すようになります。
#~ <クリティカル率 n> の代わりに <critical n> を使用することもできます。

#~ オートステート
#~ 武器・防具の「メモ」欄に <オートステート n> を追加します。
#~ nには、付加するステートの ID を半角で入力します。
#~ <オートステート 1,2,3> のように , で区切って複数指定することもできます。
#~ このアイテムを装備している間、ID9, 10, 11のステートが付加されます。
#~ <オートステート n> の代わりに <auto_state n> を使用することもできます。

#~ ステートの最大HP/MP修正
#~ ステートの「メモ」欄に <最大HP n%> または <最大MP n%> を追加します。
#~ nには、最大HP/MP の割合を半角で入力します。
#~ このステートにかかると、最大HPが1.5倍、最大MPが1/2になります。
#~ <最大HP n%>、<最大MP n%> の代わりに <maxhp_rate n%>、
#~ <maxmp_rate n%> を使用することもできます。

#~ 打撃/精神関係度でスキルを封印
#~ ステートの「メモ」欄に <打撃関係度 n 以上封印> または <精神関係度 n 以上封印> を追加します。
#~ nには、封印する関係度を半角で入力します。
#~ このステートにかかると、打撃関係度が80以上のスキルと、
#~ 精神関係度が20以上のスキルは使用できなくなります。
#~ <打撃関係度 n 以上封印> または <精神関係度 n 以上封印> の代わりに
#~ <seal_atk_f n>、<seal_spi_f n> を使用することもできます。

#~ 同時に付加するステート
#~ ステートの「メモ」欄に <付加ステート n> を追加します。
#~ nには、付加するステートの ID を半角で入力します。
#~ <付加ステート 1,2,3> のように , で区切って複数指定することもできます。
#~ このステートにかかると、同時に9, 10, 11のステートも付加されます。
#~ ただし、オートステートには適用されません。
#~ <付加ステート n> の代わりに <plus_state n> を使用することもできます。
#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module ReproduceFunctions
  # ◆ MP 消費武器使用時、消費した MP を表示する
  SHOW_WEAPON_MP_COST_ON_ATTACK = true

  # ◆ 「武器属性」と見なす属性の範囲
  #  この属性を持つスキルは、同じ属性を持つ武器を装備していないと
  #  使用できなくなります。
  #   ※素手は 1（格闘）扱いです。
  #  範囲オブジェクト（1..6 など）または整数の配列で指定します。
  WEAPON_ELEMENTS = []
  # [1..6] は [1, 2, 3, 4, 5, 6] と書いてもOK。
  # [1..4, 5, 6] のように、両方が混ざってもOK。
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["ReproduceFunctions"] = true

module KGC::ReproduceFunctions
  #--------------------------------------------------------------------------
  # ○ 武器属性を整数配列に変換
  #--------------------------------------------------------------------------
  def self.create_weapon_element_list
    result = []
    WEAPON_ELEMENTS.each { |e|
      if e.is_a?(Range)
        result |= e.to_a
      elsif e.is_a?(Integer)
        result |= [e]
      end
    }
    return result.sort
  end

  # 武器属性配列
  WEAPON_ELEMENT_ID_LIST = create_weapon_element_list

  # 正規表現を定義
  module Regexp
    # ベースアイテム
    module BaseItem
      # オートステート
      AUTO_STATE = /<(?:AUTO_STATE|オートステート)\s*(\d+(?:\s*,\s*\d+)*)>/i
      # 全体攻撃
      WHOLE_ATTACK = /<(?:WHOLE_ATTACK|全体攻撃)>/i
      # 回避率無視
      IGNORE_EVA = /<(?:IGNORE_EVA|回避率無視)>/i
      # 消費MP
      MP_COST = /<(?:MP_COST|消費MP)\s*(\d+)>/i
      # クリティカル率
      CRITICAL = /<(?:CRITICAL|クリティカル率)\s*(\-?\d+)>/i
    end

    # アイテム
    module Item
      # アイテム使用回数
      MULTI_USABLE = /<(?:MULTI_USABLE|使用回数)\s*(\d+)>/i
      # スキル発動アイテム
      EXEC_SKILL = /<(?:EXEC_SKILL|スキル発動)\s*(\d+)>/i
      # 回避率無視
      IGNORE_EVA = /<(?:IGNORE_EVA|回避率無視)>/i
    end

    # エネミー
    module Enemy
      # 半透明
      TRANSLUCENT = /<(?:TRANSLUCENT|半透明)>/i
      # クリティカル率
      CRITICAL = /<(?:CRITICAL|クリティカル率)\s*(\d+)>/i
    end

    # ステート
    module State
      # パラメータ名
      PARAMETER_NAME = {
        "maxhp"=>"MAXHP_RATE|最大HP",
        "maxmp"=>"MAXMP_RATE|最大MP"
      }
      # 打撃関係度で封印 (日本語)
      SEAL_ATK_F_JP = /<打撃関係度\s*(\d+)\s*以上封印>/
      # 打撃関係度で封印 (英語)
      SEAL_ATK_F_EN = /<SEAL_ATK_F\s*(\d+)>/i
      # 精神関係度で封印 (日本語)
      SEAL_SPI_F_JP = /<精神関係度\s*(\d+)\s*以上封印>/
      # 精神関係度で封印 (英語)
      SEAL_SPI_F_EN = /<SEAL_SPI_F\s*(\d+)>/i
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
  # ○ 再現機能のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_reproduce_functions_cache
    @__whole_attack = false
    @__ignore_eva = false
    @__mp_cost = 0
    @__cri = 0

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::ReproduceFunctions::Regexp::BaseItem::WHOLE_ATTACK
        # 全体攻撃
        @__whole_attack = true
      when KGC::ReproduceFunctions::Regexp::BaseItem::IGNORE_EVA
        # 回避率無視
        @__ignore_eva = true
      when KGC::ReproduceFunctions::Regexp::BaseItem::MP_COST
        # 通常攻撃消費 MP
        @__mp_cost += $1.to_i
      when KGC::ReproduceFunctions::Regexp::BaseItem::CRITICAL
        # クリティカル修正
        @__cri += $1.to_i
      end
    }

    create_auto_state_cache
  end
  #--------------------------------------------------------------------------
  # ○ オートステートのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_auto_state_cache
    # ID のキャッシュ生成
    @__auto_state_ids = []
    @__auto_state_ids_battle = []
    self.note.split(/[\r\n]+/).each { |line|
      next unless line =~ KGC::ReproduceFunctions::Regexp::BaseItem::AUTO_STATE
      $1.scan(/\d+/).each { |num|
        if (state = $data_states[num.to_i]) != nil
          @__auto_state_ids_battle << state.id
          unless state.battle_only
            @__auto_state_ids << state.id
          end
        end
      }
    }

    # オブジェクトのキャッシュ作成
    @__auto_states = []
    @__auto_state_ids.each { |i|
      @__auto_states << $data_states[i]
    }
    @__auto_states_battle = []
    @__auto_state_ids_battle.each { |i|
      @__auto_states_battle << $data_states[i]
    }
  end
  #--------------------------------------------------------------------------
  # ○ 全体攻撃判定
  #--------------------------------------------------------------------------
  def whole_attack
    create_reproduce_functions_cache if @__whole_attack == nil
    return @__whole_attack
  end
  #--------------------------------------------------------------------------
  # ○ 回避無視判定
  #--------------------------------------------------------------------------
  def ignore_eva
    create_reproduce_functions_cache if @__ignore_eva == nil
    return @__ignore_eva
  end
  #--------------------------------------------------------------------------
  # ○ 通常攻撃消費 MP
  #--------------------------------------------------------------------------
  def mp_cost
    create_reproduce_functions_cache if @__mp_cost == nil
    return @__mp_cost
  end
  #--------------------------------------------------------------------------
  # ○ クリティカル修正
  #--------------------------------------------------------------------------
  def cri
    create_reproduce_functions_cache if @__cri == nil
    return @__cri
  end
  #--------------------------------------------------------------------------
  # ○ オートステート ID
  #--------------------------------------------------------------------------
  def auto_state_ids
    return ($game_temp.in_battle ? auto_state_ids_battle : auto_state_ids_always)
  end
  #--------------------------------------------------------------------------
  # ○ オートステート ID (常時)
  #--------------------------------------------------------------------------
  def auto_state_ids_always
    create_reproduce_functions_cache if @__auto_state_ids == nil
    return @__auto_state_ids
  end
  #--------------------------------------------------------------------------
  # ○ オートステート ID (戦闘時)
  #--------------------------------------------------------------------------
  def auto_state_ids_battle
    create_reproduce_functions_cache if @__auto_state_ids_battle == nil
    return @__auto_state_ids_battle
  end
  #--------------------------------------------------------------------------
  # ○ オートステート
  #--------------------------------------------------------------------------
  def auto_states
    return ($game_temp.in_battle ? auto_states_battle : auto_states_always)
  end
  #--------------------------------------------------------------------------
  # ○ オートステート (常時)
  #--------------------------------------------------------------------------
  def auto_states_always
    create_reproduce_functions_cache if @__auto_states == nil
    return @__auto_states
  end
  #--------------------------------------------------------------------------
  # ○ オートステート (戦闘時)
  #--------------------------------------------------------------------------
  def auto_states_battle
    create_reproduce_functions_cache if @__auto_states_battle == nil
    return @__auto_states_battle
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Item
#==============================================================================

class RPG::Item < RPG::UsableItem
  #--------------------------------------------------------------------------
  # ○ 再現機能のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_reproduce_functions_cache
    super
    @__usable_count = 1
    @__skill_id = 0
    @__ignore_eva = false

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::ReproduceFunctions::Regexp::Item::MULTI_USABLE
        # 使用可能回数
        @__usable_count = $1.to_i
      when KGC::ReproduceFunctions::Regexp::Item::EXEC_SKILL
        # 発動スキル ID
        @__skill_id = $1.to_i
      when KGC::ReproduceFunctions::Regexp::Item::IGNORE_EVA
        # 回避率無視
        @__ignore_eva = true
      end
    }
  end
  #--------------------------------------------------------------------------
  # ● アニメーション ID
  #--------------------------------------------------------------------------
  def animation_id
    if exec_skill?
      return $data_skills[skill_id].animation_id
    else
      return @animation_id
    end
  end
  #--------------------------------------------------------------------------
  # ○ 使用可能回数
  #--------------------------------------------------------------------------
  def usable_count
    create_reproduce_functions_cache if @__usable_count == nil
    return @__usable_count
  end
  #--------------------------------------------------------------------------
  # ○ スキル発動判定
  #--------------------------------------------------------------------------
  def exec_skill?
    return (skill_id > 0)
  end
  #--------------------------------------------------------------------------
  # ○ 発動スキル ID
  #--------------------------------------------------------------------------
  def skill_id
    create_reproduce_functions_cache if @__skill_id == nil
    return @__skill_id
  end
  #--------------------------------------------------------------------------
  # ○ 回避無視判定
  #--------------------------------------------------------------------------
  def ignore_eva
    create_reproduce_functions_cache if @__ignore_eva == nil
    return @__ignore_eva
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # ○ 再現機能のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_reproduce_functions_cache
    super

    @__weapon_element_set =
      self.element_set & KGC::ReproduceFunctions::WEAPON_ELEMENT_ID_LIST
  end
  #--------------------------------------------------------------------------
  # ○ 使用時に必要な武器属性を取得
  #--------------------------------------------------------------------------
  def weapon_element_set
    create_reproduce_functions_cache if @__weapon_element_set == nil
    return @__weapon_element_set
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy
  #--------------------------------------------------------------------------
  # ○ 再現機能のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_reproduce_functions_cache
    @__translucent = false
    @__cri = 0

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::ReproduceFunctions::Regexp::Enemy::TRANSLUCENT
        # 半透明
        @__translucent = true
      when KGC::ReproduceFunctions::Regexp::Enemy::CRITICAL
        # クリティカル修正
        @__cri += $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 半透明
  #--------------------------------------------------------------------------
  def translucent?
    create_reproduce_functions_cache if @__translucent == nil
    return @__translucent
  end
  #--------------------------------------------------------------------------
  # ○ クリティカル修正
  #--------------------------------------------------------------------------
  def cri
    create_reproduce_functions_cache if @__cri == nil
    return @__cri
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # ○ 再現機能のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_reproduce_functions_cache
    @__seal_atk_f = 999
    @__seal_spi_f = 999
    @__plus_state_set = []

    self.note.split(/[\r\n]+/).each { |line|
      case line
      when KGC::ReproduceFunctions::Regexp::State::SEAL_ATK_F_JP,
           KGC::ReproduceFunctions::Regexp::State::SEAL_ATK_F_EN
        # 封印するスキルの打撃関係度
        @__seal_atk_f = $1.to_i
      when KGC::ReproduceFunctions::Regexp::State::SEAL_SPI_F_JP,
           KGC::ReproduceFunctions::Regexp::State::SEAL_SPI_F_EN
        # 封印するスキルの精神関係度
        @__seal_spi_f = $1.to_i
      when KGC::ReproduceFunctions::Regexp::State::PLUS_STATE
        # 付加ステート
        $1.scan(/\d+/).each { |num|
          if (state = $data_states[num.to_i]) != nil
            @__plus_state_set << state.id
          end
        }
      end
    }

    create_parameter_rate_cache
  end
  #--------------------------------------------------------------------------
  # ○ パラメータ修正値のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_parameter_rate_cache
    @__parameter_rate = {}
    # 初期化
    KGC::ReproduceFunctions::Regexp::State::PARAMETER_NAME.each_key { |k|
      @__parameter_rate[k] = 100
    }
    # メモ反映
    self.note.split(/[\r\n]+/).each { |line|
      KGC::ReproduceFunctions::Regexp::State::PARAMETER_NAME.each { |k, v|
        if line =~ /<(?:#{v})[ ]*(\d+)[%％]>/i
          @__parameter_rate[k] = @__parameter_rate[k] * $1.to_i / 100
          break
        end
      }
    }
  end
  #--------------------------------------------------------------------------
  # ○ MaxHP 修正
  #--------------------------------------------------------------------------
  def maxhp_rate
    create_reproduce_functions_cache if @__parameter_rate == nil
    return @__parameter_rate["maxhp"]
  end
  #--------------------------------------------------------------------------
  # ○ MaxMP 修正
  #--------------------------------------------------------------------------
  def maxmp_rate
    create_reproduce_functions_cache if @__parameter_rate == nil
    return @__parameter_rate["maxmp"]
  end
  #--------------------------------------------------------------------------
  # ○ 封印するスキルの打撃関係度
  #--------------------------------------------------------------------------
  def seal_atk_f
    create_reproduce_functions_cache if @__seal_atk_f == nil
    return @__seal_atk_f
  end
  #--------------------------------------------------------------------------
  # ○ 封印するスキルの精神関係度
  #--------------------------------------------------------------------------
  def seal_spi_f
    create_reproduce_functions_cache if @__seal_spi_f == nil
    return @__seal_spi_f
  end
  #--------------------------------------------------------------------------
  # ○ 付加ステート
  #--------------------------------------------------------------------------
  def plus_state_set
    create_reproduce_functions_cache if @__plus_state_set == nil
    return @__plus_state_set
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Temp
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :exec_skill_on_item       # アイテムによるスキル発動フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_ReproduceFunctions initialize
  def initialize
    initialize_KGC_ReproduceFunctions

    @exec_skill_on_item = false
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  alias maxhp_KGC_ReproduceFunctions maxhp
  def maxhp
    n = maxhp_KGC_ReproduceFunctions
    states.each { |state| n *= state.maxhp_rate / 100.0 }
    return [[Integer(n), 1].max, maxhp_limit].min
  end
  #--------------------------------------------------------------------------
  # ● MaxMP の取得
  #--------------------------------------------------------------------------
  alias maxmp_KGC_ReproduceFunctions maxmp
  def maxmp
    n = maxmp_KGC_ReproduceFunctions
    states.each { |state| n *= state.maxmp_rate / 100.0 }
    limit = (defined?(maxmp_limit) ? maxmp_limit : 9999)
    return [[Integer(n), 0].max, limit].min
  end
  #--------------------------------------------------------------------------
  # ● 現在のステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  alias states_KGC_ReproduceFunctions states
  def states
    result = states_KGC_ReproduceFunctions + auto_states
    result.sort! { |a, b| b.priority <=> a.priority }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ オートステートの ID を取得
  #--------------------------------------------------------------------------
  def auto_state_ids
    return auto_states(true)
  end
  #--------------------------------------------------------------------------
  # ○ オートステートの配列を取得
  #     id_only : ID のみを取得
  #--------------------------------------------------------------------------
  def auto_states(id_only = false)
    return []
  end
  #--------------------------------------------------------------------------
  # ● ステートの検査
  #     state_id : ステート ID
  #    該当するステートが付加されていれば true を返す。
  #--------------------------------------------------------------------------
  alias state_KGC_ReproduceFunctions? state?
  def state?(state_id)
    return (state_KGC_ReproduceFunctions?(state_id) || auto_state?(state_id))
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  alias add_state_KGC_ReproduceFunctions add_state
  def add_state(state_id)
    last_states = @states.dup

    add_state_KGC_ReproduceFunctions(state_id)

    if (@states - last_states).include?(state_id)  # ステートが付加された場合
      state = $data_states[state_id]
      # [付加するステート] を適用
      state.plus_state_set.each { |i|
        add_state(i)
      }
    end
  end
  #--------------------------------------------------------------------------
  # ○ オートステートの検査
  #     state_id : ステート ID
  #    該当するステートが付加されていれば true を返す。
  #--------------------------------------------------------------------------
  def auto_state?(state_id)
    return auto_state_ids.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # ● ステートの解除
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  alias remove_state_KGC_ReproduceFunctions remove_state
  def remove_state(state_id)
    if auto_state?(state_id)  # オートステートは解除しない
      return
    end

    remove_state_KGC_ReproduceFunctions(state_id)
  end
  #--------------------------------------------------------------------------
  # ○ 半透明化判定
  #--------------------------------------------------------------------------
  def translucent?
    # エネミーの場合は Game_Enemy で再定義
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [全体攻撃] の取得
  #--------------------------------------------------------------------------
  def whole_attack
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [回避無視] の取得
  #--------------------------------------------------------------------------
  def ignore_eva
    return false
  end
  #--------------------------------------------------------------------------
  # ○ MP ダメージ加算
  #     value : 加算する値
  #--------------------------------------------------------------------------
  def add_mp_damage(value)
    @mp_damage += value
  end
  #--------------------------------------------------------------------------
  # ○ 通常攻撃の消費 MP 計算
  #--------------------------------------------------------------------------
  def calc_attack_mp_cost
    return 0
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  alias skill_can_use_KGC_ReproduceFunctions? skill_can_use?
  def skill_can_use?(skill)
    return false unless skill.is_a?(RPG::Skill)
    return false if skill_seal?(skill)
    return false unless skill_satisfied_weapon_element?(skill)

    return skill_can_use_KGC_ReproduceFunctions?(skill)
  end
  #--------------------------------------------------------------------------
  # ○ スキル封印判定
  #--------------------------------------------------------------------------
  def skill_seal?(skill)
    return (seal_atk_f <= skill.atk_f || seal_spi_f <= skill.spi_f)
  end
  #--------------------------------------------------------------------------
  # ○ 封印する打撃関係度を取得
  #--------------------------------------------------------------------------
  def seal_atk_f
    n = 999
    states.each { |state| n = [n, state.seal_atk_f].min }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 封印する精神関係度を取得
  #--------------------------------------------------------------------------
  def seal_spi_f
    n = 999
    states.each { |state| n = [n, state.seal_spi_f].min }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 必要な武器属性を満たしているか判定
  #--------------------------------------------------------------------------
  def skill_satisfied_weapon_element?(skill)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 最終回避率の計算
  #     user : 攻撃者、スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム (通常攻撃の場合は nil)
  #--------------------------------------------------------------------------
  alias calc_eva_KGC_ReproduceFunctions calc_eva
  def calc_eva(user, obj = nil)
    eva = calc_eva_KGC_ReproduceFunctions(user, obj)

    if obj == nil && user.ignore_eva  # 通常攻撃かつ回避無視の場合
      eva = 0
    end
    return eva
  def calc_eva(user, obj)
    eva = calc_eva_KGC_ReproduceFunctions(user, obj)

    if obj == obj.ignore_eva  # 通常攻撃かつ回避無視の場合
      eva = 0
    end
    return eva
  end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの効果適用
  #     user : アイテムの使用者
  #     item : アイテム
  #--------------------------------------------------------------------------
  alias item_effect_KGC_ReproduceFunctions item_effect
  def item_effect(user, item)
    # スキル発動判定
    if item.exec_skill?
      $game_temp.exec_skill_on_item = true
      skill_effect(user, $data_skills[item.skill_id])
      $game_temp.exec_skill_on_item = false
    else
      item_effect_KGC_ReproduceFunctions(user, item)
    end
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
  alias make_attack_targets_KGC_ReproduceFunctions make_attack_targets
  def make_attack_targets
    unless battler.whole_attack  # 全体攻撃でない
      return make_attack_targets_KGC_ReproduceFunctions
    end

    targets = []
    if battler.confusion?
      targets += friends_unit.existing_members
    else
      targets += opponents_unit.existing_members
    end
    if battler.dual_attack      # 連続攻撃
      targets += targets
    end
    return targets.compact
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias cri_KGC_ReproduceFunctions cri
  def cri
    n = cri_KGC_ReproduceFunctions

    equips.compact.each { |item| n += item.cri }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ オートステートの配列を取得
  #     id_only : ID のみを取得
  #--------------------------------------------------------------------------
  def auto_states(id_only = false)
    result = []
    equips.compact.each { |item|
      result |= (id_only ? item.auto_state_ids : item.auto_states)
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [全体攻撃] の取得
  #--------------------------------------------------------------------------
  def whole_attack
    equips.compact.each { |item|
      return true if item.whole_attack
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 装備オプション [回避無視] の取得
  #--------------------------------------------------------------------------
  def ignore_eva
    equips.compact.each { |item|
      return true if item.ignore_eva
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 通常攻撃の消費 MP 計算
  #--------------------------------------------------------------------------
  def calc_attack_mp_cost
    n = 0
    equips.compact.each { |item|
      n += item.mp_cost
    }
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 必要な武器属性を満たしているか判定
  #--------------------------------------------------------------------------
  def skill_satisfied_weapon_element?(skill)
    elements = skill.weapon_element_set
    return (self.element_set & elements) == elements
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ 半透明化判定
  #--------------------------------------------------------------------------
  def translucent?
    return enemy.translucent?
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias cri_KGC_ReproduceFunctions cri
  def cri
    n = cri_KGC_ReproduceFunctions
    if enemy.has_critical && enemy.cri != 0
      n += enemy.cri - 10
    end
    return n
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_ReproduceFunctions initialize
  def initialize
    initialize_KGC_ReproduceFunctions

    @item_use_count = {}  # 所持品使用回数ハッシュ (アイテム ID)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの減少
  #     item          : アイテム
  #     n             : 個数
  #     include_equip : 装備品も含める
  #--------------------------------------------------------------------------
  alias lose_item_KGC_ReproduceFunctions lose_item
  def lose_item(item, n, include_equip = false)
    lose_item_KGC_ReproduceFunctions(item, n, include_equip)

    # アイテムが無くなったら使用回数をリセット
    if item.is_a?(RPG::Item) && item.consumable && item_number(item) == 0
      @item_use_count[item.id] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの消耗
  #     item : アイテム
  #--------------------------------------------------------------------------
  alias consume_item_KGC_ReproduceFunctions consume_item
  def consume_item(item)
    if item.is_a?(RPG::Item) && item.consumable
      update_use_count(item)

      # 使用回数が 0 の場合のみ消耗
      if @item_use_count[item.id] == 0
        consume_item_KGC_ReproduceFunctions(item)
      end
    else
      consume_item_KGC_ReproduceFunctions(item)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 使用回数の更新
  #     item : アイテム
  #    指定アイテムの使用回数を 1 増やす。
  #    使用後に消耗する場合は、使用回数を 0 にする。
  #--------------------------------------------------------------------------
  def update_use_count(item)
    if @item_use_count == nil
      @item_use_count = {}
    end

    unless @item_use_count.has_key?(item.id)
      @item_use_count[item.id] = 0
    end
    @item_use_count[item.id] += 1
    # 使用可能回数に達したら、使用回数を 0 にする
    if @item_use_count[item.id] >= item.usable_count
      @item_use_count[item.id] = 0
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  alias update_effect_KGC_ReproduceFunctions update_effect
  def update_effect
    # エフェクト実行前に半透明化判定をしておく
    trans_flag = (@effect_duration > 0 && @battler.translucent?)

    update_effect_KGC_ReproduceFunctions

    if trans_flag
      self.opacity /= 2
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 対象敵キャラ選択の開始
  #--------------------------------------------------------------------------
  alias start_target_enemy_selection_KGC_ReproduceFunctions start_target_enemy_selection
  def start_target_enemy_selection
    # 全体通常攻撃なら選択をスキップ
    if @active_battler.action.kind == 0 &&
        @active_battler.action.basic == 0 &&
        @active_battler.whole_attack
      next_actor
      return
    end

    start_target_enemy_selection_KGC_ReproduceFunctions
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 攻撃
  #--------------------------------------------------------------------------
  alias execute_action_attack_KGC_ReproduceFunctions execute_action_attack
  def execute_action_attack
    execute_action_attack_KGC_ReproduceFunctions

    # 攻撃者の MP 消費
    mp_cost = @active_battler.calc_attack_mp_cost
    return if mp_cost == 0
    @active_battler.mp -= mp_cost
    if KGC::ReproduceFunctions::SHOW_WEAPON_MP_COST_ON_ATTACK
      @active_battler.add_mp_damage(mp_cost)
      display_mp_damage(@active_battler)
    end
  end
end
