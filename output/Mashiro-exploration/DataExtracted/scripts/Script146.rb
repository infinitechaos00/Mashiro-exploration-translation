#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ カウンター - KGC_Counter ◆ VX ◆
#_/    ◇ Last update : 2009/09/13 ◇
#_/----------------------------------------------------------------------------
#_/  特定の行動に対するカウンターを作成します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ カウンター行動の設定
#~ 武器・防具・敵キャラ・ステートのいずれかのメモ欄に、次のような記述を追加します。

#~ <カウンター {種別}:{ID} [発動率%]>
#~ 発動条件
#~ </カウンター>

#~ <カウンター> から </カウンター> の間がカウンター条件の定義になります。
#~ （<counter> と </counter> でもOK）
#~ このアイテムを装備したり、ステートが付加されたりすると、カウンター判定の対象となります。
#~ 敵の場合は、常にカウンター判定を行います。
#~ それぞれの記述は、１行につき１つだけにしてください。
#~ 必ず最後に </カウンター> で閉じてください。

#~ {種別}には、カウンター行動の種別をA, S, Iのいずれかから指定します。
#~ Aは通常攻撃、Sはスキル、Iはアイテムです。
#~ SまたはIを指定した場合は、:{ID}の部分に発動するスキル・アイテムの ID を指定します。
#~ カウンターの発動率を設定する場合は、[発動率%]に % 単位で記入します。
#~ 発動率を省略した場合は100%となります。

#~ 「発動条件」では、どの攻撃に対してカウンターを行うかを指定します。
#~ 条件は必要な項目のみ指定でき、指定しなかった項目は条件なしとなります。
#~ （例えば、属性を指定しなければ全属性がカウンター対象となる）
#~ 条件を一切設定しないこともできます（無条件カウンター）。

#~ 「発動条件」には、次の条件を指定できます。
#~ 発動条件一覧
#~ 名称 	条件・効果
#~ KIND x
#~ 種別 x
#~ KIND x:id1,id2,...
#~ 種別 x:id1,id2,... 	攻撃の種別。
#~ xにはA, G, S, Iのいずれかを指定。
#~ Gは相手の防御行動に対応。
#~ （Gを使用する場合は「ターゲット無視」が必須）
#~ 特定の ID のスキル・アイテムのみを対象とするには、xの後に : を付けてから ID を , 区切りで記入。
#~ PHYSICAL_ATTACK
#~ 物理攻撃 	「物理攻撃」をチェックしたスキル、もしくは通常攻撃。
#~ MAGICAL_ATTACK
#~ 魔法攻撃 	「物理攻撃」をチェックしていないスキル。
#~ ELEMENT n1,n2,...
#~ 属性 n1,n2,... 	攻撃手段に含まれる属性。
#~ n1, n2, ...には、属性 ID を , 区切りで記入。
#~ ATK_F n
#~ 打撃関係度 n 以上 	打撃関係度n以上の攻撃。
#~ 通常攻撃は打撃関係度100として扱う。
#~ SPI_F n
#~ 精神関係度 n 以上 	精神関係度n以上の攻撃。
#~ 通常攻撃は精神関係度0として扱う。
#~ REMAIN_{HP|MP} n% {OVER|UNDER}
#~ 残存{HP|MP} n%{以上|以下} 	反撃時の残り HP/MP。
#~ 「残存HP50%以下」「残存MP30%以上」のように記述。
#~ IGNORE_TARGET
#~ ターゲット無視 	自分以外がターゲットの場合でもカウンターを行う。
#~ INTERRUPT
#~ ACTION_INTERRUPT
#~ 割り込み
#~ 行動割り込み 	カウンター条件を満たした際、相手の行動をキャンセルしてカウンターを発動する。
#~ 防御など、ターン開始時に効果が出ている行動はキャンセル不可。
#~ （割り込みは可能だが、ダメージは軽減される）

#~ 以下、設定例です。

#~ # 物理攻撃に対して通常攻撃で反撃
#~ <カウンター A>
#~ 物理攻撃
#~ </カウンター>

#~ # 属性 ID:8 、精神関係度 50 以上の魔法に対して
#~ # スキル ID:60 で反撃
#~ <カウンター S:60>
#~ 魔法攻撃
#~ 属性 8
#~ 精神関係度 50 以上
#~ </カウンター>

#~ # スキル ID:62 と 66 に対してスキル ID:70 で反撃
#~ <カウンター S:70>
#~ 種別 S:62,66
#~ </カウンター>

#~ # あらゆる攻撃に対してスキル ID:50 で反撃
#~ # 発動率：80%
#~ <カウンター S:50 80%>
#~ </カウンター>

#~ # HPが半分以下になったら通常攻撃で反撃
#~ <カウンター A>
#~ 残存HP50%以下
#~ </カウンター>

#~ # ア イ テ ム な ぞ 使 っ て ん じ ゃ ね え ！
#~ # （アイテムを使っても無効化される鬼畜仕様）
#~ <カウンター S:82>
#~ 種別 I
#~ ターゲット無視
#~ 割り込み
#~ </カウンター>

#~ # 縮こまってんじゃねえ！
#~ <カウンター S:81>
#~ 種別 G
#~ ターゲット無視
#~ </カウンター>

#~ 行動不能、MP 不足などの理由でカウンター行動を実行できない場合、
#~ カウンターは発動しません。
#~ 割り込みメッセージの設定

#~ # ◆ 割り込みカウンターのメッセージ
#~ VOCAB_INTERRUPT_COUNTER = "\\Cは\\Nの行動に割り込んだ！"

#~ カスタマイズ項目のこの部分で、割り込みカウンター発動時のメッセージを指定します。
#~ メッセージ内では、以下の制御文字を使用できます。
#~ 割り込みメッセージ用制御文字
#~ 制御文字 	表示内容
#~ \\N 	行動者（カウンターを受ける側）の名前
#~ \\C 	カウンター発動者の名前
#~ \\A 	カウンターで割り込む（カウンターを受ける側の）行動の名前
#~ メモ欄の <カウンター> から </カウンター> の間に

#~ 割り込みメッセージ "メッセージ本文"

#~ を追加すると、割り込み時のメッセージを個別に指定できます。
#~ メッセージ本文は "" 内であれば改行することができます。
#~ 途中で改行した場合は、途中の改行と行頭の空白は無視されます。

#~ # 一行で書いても良い
#~ <カウンター A 50%>
#~ 種別 S
#~ 割り込み
#~ 割り込みメッセージ "\\Cの割り込み！"
#~ </カウンター>

#~ # 複数行でも OK
#~ <カウンター A 50%>
#~ 種別 S
#~ 割り込み
#~ 割り込みメッセージ "\\Cの
#~   割り込み！"
#~ </カウンター>

#~ どちらも表示されるメッセージは同一です。
#~ ※ メモ欄での記述に限り、\ は一つでも動作します（\C など）。
#~ カスタマイズ項目

#~ # ◆ カウンター回数を制限する
#~ RESTRICT_COUNTER = true

#~ trueにすると、1回のアクションにつきカウンターが1回しか発動しなくなります。
#~ （例えば、連続攻撃を受けてもカウンターは1回）
#~ falseにすると、攻撃を受けた回数だけカウンターが発動します。
#~ （連続攻撃を受ければカウンターも2回）

#~ # ◆ 通常攻撃カウンターのメッセージ
#~ VOCAB_COUNTER_ATTACK = "%sの反撃！"

#~ 通常攻撃でカウンターを行う際のメッセージを指定します。
#~ %sには、攻撃者の名前が入ります。

#==============================================================================
# ★ カスタマイズ項目 - Customize BEGIN ★
#==============================================================================

module KGC
module Counter
  # ◆ カウンター回数を制限する
  #  true  : カウンターは 1 回のアクションにつき 1 回のみ。
  #  false : 条件を満たした数だけカウンター発動。
  RESTRICT_COUNTER = true

  # ◆ 通常攻撃カウンターのメッセージ
  #  %s : 攻撃者の名前
  VOCAB_COUNTER_ATTACK = "%sの反撃！"

  # ◆ 割り込みカウンターのメッセージ
  #   \\N : 行動者の名前
  #   \\C : カウンター発動者の名前
  #   \\A : 割り込む行動の名前
  #  '～' で指定する場合、\ は一つで OK。
  #  カウンター定義内で指定した場合は、そちらを優先。
  VOCAB_INTERRUPT_COUNTER = '\Cは\Nの行動に割り込んだ！'
end
end

#==============================================================================
# ☆ カスタマイズ項目終了 - Customize END ☆
#==============================================================================

$imported = {} if $imported == nil
$imported["Counter"] = true

module KGC
module Counter
  module Regexp
    # カウンター定義開始
    BEGIN_COUNTER = /<(?:COUNTER|カウンター)\s*([ASI])?(\s*\:\s*\d+)?
                     (\s+\d+[%％])?(\s*\/)?>/ix
    # カウンター定義終了
    END_COUNTER = /<\/(?:COUNTER|カウンター)>/i

    # ～ カウンター条件 ～
    # 行動種別
    KIND = /^\s*(?:KIND|種別)\s*([AGSI])(\s*\:\s*\d+(?:\s*,\s*\d+)*)?/i
    # 攻撃タイプ
    ATTACK_TYPE = /^\s*(PHYSICAL|MAGICAL|物理|魔法)(?:_ATTACK|攻撃)/i
    # 属性
    ELEMENT = /^\s*(?:ELEMENT|属性)\s*(\d+(?:\s*,\s*\d+)*)/i
    # 打撃関係度
    ATK_F = /^\s*(?:ATK_F|打撃関係度)\s*(\d+)(?:\s*以上)?/i
    # 精神関係度
    SPI_F = /^\s*(?:SPI_F|精神関係度)\s*(\d+)(?:\s*以上)?/i
    # 残存 HP/MP
    REMAIN_HPMP = /^\s*(?:REMAIN_|残存)?(HP|MP)\s*(\d+)(?:\s*[%％]\s*)
                   (OVER|UNDER|以上|以下)/ix
    # ターゲット無視
    IGNORE_TARGET = /^\s*(?:IGNORE_TARGET|ターゲット無視)/i
    # 行動割り込み
    INTERRUPT = /^\s*(?:ACTION_|行動)?(?:INTERRUPT|割り?込み)\s*$/i

    # ～ メッセージ ～
    INTERRUPT_MESSAGE = /^\s*(?:INTERRUPT_MESSAGE|割り?込みメッセージ)\s*\"
                         ([^\"]*)(\")?/ix
  end

  KIND_ALL   = -1  # 種別 : ALL
  KIND_BASIC =  0  # 種別 : 基本
  KIND_SKILL =  1  # 種別 : スキル
  KIND_ITEM  =  2  # 種別 : アイテム

  BASIC_ATTACK = 0  # 基本行動 : 攻撃
  BASIC_GUARD  = 1  # 基本行動 : 防御

  TYPE_ALL      = -1  # 攻撃タイプ : ALL
  TYPE_PHYSICAL =  0  # 攻撃タイプ : 物理
  TYPE_MAGICAL  =  1  # 攻撃タイプ : 魔法

  REMAIN_TYPE_OVER  = 0  # 残存 : x 以上
  REMAIN_TYPE_UNDER = 1  # 残存 : x 以下

  # 種別変換表
  COUNTER_KINDS = {
    "A" => KIND_BASIC,
    "G" => KIND_BASIC,
    "S" => KIND_SKILL,
    "I" => KIND_ITEM,
  }

  # 基本行動変換表
  COUNTER_BASIC = {
    "A" => BASIC_ATTACK,
    "G" => BASIC_GUARD
  }

  # 攻撃タイプ変換表
  COUNTER_TYPES = {
    "PHYSICAL" => TYPE_PHYSICAL,
    "物理"     => TYPE_PHYSICAL,
    "MAGICAL"  => TYPE_MAGICAL,
    "魔法"     => TYPE_MAGICAL
  }

  #--------------------------------------------------------------------------
  # ○ カウンター行動リストの作成
  #     note : メモ欄
  #--------------------------------------------------------------------------
  def self.create_counter_action_list(note)
    result = []

    counter_flag = false
    action = nil

    interrupt_message = ""
    define_interrupt_message = false
    note.each_line { |line|
      if line =~ KGC::Counter::Regexp::BEGIN_COUNTER
        match = $~.clone
        # カウンター定義開始
        action = Game_CounterAction.new
        if match[1] != nil
          action.kind = COUNTER_KINDS[match[1].upcase]
        end
        case action.kind
        when KIND_SKILL
          next if match[2] == nil
          action.skill_id = match[2][/\d+/].to_i
        when KIND_ITEM
          next if match[2] == nil
          action.item_id = match[2][/\d+/].to_i
        end
        if match[3] != nil
          action.execute_prob = match[3][/\d+/].to_i
        end
        counter_flag = true
        if match[4] != nil
          # そのまま定義終了
          result << action
          counter_flag = false
        end
      end

      next unless counter_flag

      # 割り込みメッセージ定義中
      if define_interrupt_message
        if line =~ /\s*([^\"]*)(\")?/
          action.interrupt_message += $1.chomp
          define_interrupt_message = ($2 == nil)
        end
        next
      end

      case line
      when KGC::Counter::Regexp::END_COUNTER
        # カウンター定義終了
        result << action
        counter_flag = false

      when KGC::Counter::Regexp::KIND
        # 行動種別
        match = $~.clone
        action.condition.kind = COUNTER_KINDS[match[1].upcase]
        if action.condition.kind == KIND_BASIC
          action.condition.basic = COUNTER_BASIC[match[1].upcase]
          if action.condition.basic == nil
            action.condition.basic = KGC::Counter::BASIC_ATTACK
          end
        end
        if match[2] != nil
          ids = []
          match[2].scan(/\d+/).each { |num| ids << num.to_i }
          case action.condition.kind
          when KIND_SKILL
            action.condition.skill_ids = ids
          when KIND_ITEM
            action.condition.item_ids = ids
          end
        end

      when KGC::Counter::Regexp::ATTACK_TYPE
        # 攻撃タイプ
        action.condition.type = COUNTER_TYPES[$1.upcase]

      when KGC::Counter::Regexp::ELEMENT
        # 属性
        elements = []
        $1.scan(/\d+/).each { |num| elements << num.to_i }
        action.condition.element_set |= elements

      when KGC::Counter::Regexp::ATK_F
        # 打撃関係度
        action.condition.atk_f = $1.to_i

      when KGC::Counter::Regexp::SPI_F
        # 精神関係度
        action.condition.spi_f = $1.to_i

      when KGC::Counter::Regexp::REMAIN_HPMP
        type = REMAIN_TYPE_OVER
        case $3.upcase
        when "UNDER", "以下"
          type = REMAIN_TYPE_UNDER
        end
        case $1.upcase
        when "HP"  # 残存 HP
          action.condition.remain_hp = $2.to_i
          action.condition.remain_hp_type = type
        when "MP"  # 残存 MP
          action.condition.remain_mp = $2.to_i
          action.condition.remain_mp_type = type
        end

      when KGC::Counter::Regexp::IGNORE_TARGET
        # ターゲット無視
        action.condition.ignore_target = true

      when KGC::Counter::Regexp::INTERRUPT
        # 行動割り込み
        action.condition.interrupt = true

      when KGC::Counter::Regexp::INTERRUPT_MESSAGE
        # 割り込みメッセージ
        define_interrupt_message = true
        action.interrupt_message += $1.chomp
        define_interrupt_message = ($2 == nil)
      end
    }
    return result
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  # カウンター関連メッセージ
  CounterAttack = KGC::Counter::VOCAB_COUNTER_ATTACK
  InterruptCounter = KGC::Counter::VOCAB_INTERRUPT_COUNTER
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ カウンター行動リスト
  #--------------------------------------------------------------------------
  def counter_actions
    if @__counter_actions == nil
      @__counter_actions = KGC::Counter.create_counter_action_list(self.note)
    end
    return @__counter_actions
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy
  #--------------------------------------------------------------------------
  # ○ カウンター行動リスト
  #--------------------------------------------------------------------------
  def counter_actions
    if @__counter_actions == nil
      @__counter_actions = KGC::Counter.create_counter_action_list(self.note)
    end
    return @__counter_actions
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::State
#==============================================================================

class RPG::State
  #--------------------------------------------------------------------------
  # ○ カウンター行動リスト
  #--------------------------------------------------------------------------
  def counter_actions
    if @__counter_actions == nil
      @__counter_actions = KGC::Counter.create_counter_action_list(self.note)
    end
    return @__counter_actions
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_BattleAction
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :made_targets             # 作成済みターゲット
  #--------------------------------------------------------------------------
  # ● ターゲットの配列作成
  #--------------------------------------------------------------------------
  alias make_targets_KGC_Counter make_targets
  def make_targets
    if @made_targets == nil
      @made_targets = make_targets_KGC_Counter
    end
    return @made_targets
  end
  #--------------------------------------------------------------------------
  # ○ アクション名
  #--------------------------------------------------------------------------
  def action_name
    case kind
    when 0  # 基本
      case basic
      when 0  # 攻撃
        return Vocab.attack
      when 1  # 防御
        return Vocab.guard
      when 2  # 逃走
        return Vocab.escape
      when 3  # 待機
        return Vocab.wait
      end
    when 1  # スキル
      return skill.name
    when 2  # アイテム
      return item.name
    end
    return ""
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Game_CounterAction
#------------------------------------------------------------------------------
#   カウンター行動を扱うクラスです。
#==============================================================================

class Game_CounterAction
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :kind                     # 種別 (基本 / スキル / アイテム)
  attr_accessor :basic                    # 基本 (攻撃 / 防御 / 逃走 / 待機)
  attr_accessor :skill_id                 # スキル ID
  attr_accessor :item_id                  # アイテム ID
  attr_accessor :execute_prob             # 発動確率
  attr_accessor :condition                # 発動条件
  attr_accessor :interrupt_message        # 割り込みメッセージ
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    clear
  end
  #--------------------------------------------------------------------------
  # ○ クリア
  #--------------------------------------------------------------------------
  def clear
    @kind              = KGC::Counter::KIND_BASIC
    @basic             = KGC::Counter::BASIC_ATTACK
    @skill_id          = 0
    @item_id           = 0
    @execute_prob      = 100
    @condition         = Game_CounterCondition.new
    @interrupt_message = ""
  end
  #--------------------------------------------------------------------------
  # ○ 有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #--------------------------------------------------------------------------
  def valid?(attacker, defender)
    return false unless attacker.actor? ^ defender.actor?  # 相手が味方

    return condition.valid?(attacker, defender)
  end
  #--------------------------------------------------------------------------
  # ○ 発動判定
  #--------------------------------------------------------------------------
  def exec?
    return (execute_prob > rand(100))
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Game_CounterCondition
#------------------------------------------------------------------------------
#   カウンター条件を扱うクラスです。
#==============================================================================

class Game_CounterCondition
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :kind                     # 種別 (ALL / 基本 / スキル / アイテム)
  attr_accessor :basic                    # 基本 (攻撃 / 防御 / 逃走 / 待機)
  attr_accessor :skill_ids                # スキル ID リスト
  attr_accessor :item_ids                 # アイテム ID リスト
  attr_accessor :type                     # 攻撃タイプ (ALL / 物理 / 魔法)
  attr_accessor :element_set              # 属性
  attr_accessor :atk_f                    # 打撃関係度
  attr_accessor :spi_f                    # 精神関係度
  attr_accessor :remain_hp                # 残存 HP
  attr_accessor :remain_hp_type           # 残存 HP の形式 (以上 / 以下)
  attr_accessor :remain_mp                # 残存 MP
  attr_accessor :remain_mp_type           # 残存 MP の形式 (以上 / 以下)
  attr_accessor :ignore_target            # ターゲット無視
  attr_accessor :interrupt                # 行動割り込み
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    clear
  end
  #--------------------------------------------------------------------------
  # ○ クリア
  #--------------------------------------------------------------------------
  def clear
    @kind           = KGC::Counter::KIND_ALL
    @basic          = KGC::Counter::BASIC_ATTACK
    @skill_ids      = []
    @item_ids       = []
    @type           = KGC::Counter::TYPE_ALL
    @element_set    = []
    @atk_f          = 0
    @spi_f          = 0
    @remain_hp      = 0
    @remain_hp_type = KGC::Counter::REMAIN_TYPE_OVER
    @remain_mp      = 0
    @remain_mp_type = KGC::Counter::REMAIN_TYPE_OVER
    @ignore_target  = false
    @interrupt      = false
  end
  #--------------------------------------------------------------------------
  # ○ 有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #--------------------------------------------------------------------------
  def valid?(attacker, defender)
    obj = nil
    if attacker.action.skill?
      obj = attacker.action.skill
    elsif attacker.action.item?
      obj = attacker.action.item
    end

    return false unless kind_valid?(attacker, defender, obj)
    return false unless attack_type_valid?(attacker, defender, obj)
    return false unless element_valid?(attacker, defender, obj)
    return false unless atk_f_valid?(attacker, defender, obj)
    return false unless spi_f_valid?(attacker, defender, obj)
    return false unless remain_hpmp_valid?(attacker, defender, obj)

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 種別有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def kind_valid?(attacker, defender, obj)
    return true  if @kind == KGC::Counter::KIND_ALL
    return false if @kind != attacker.action.kind

    case @kind
    when KGC::Counter::KIND_BASIC
      return (@basic == attacker.action.basic)
    when KGC::Counter::KIND_SKILL
      # スキル ID 判定
      return true if @skill_ids.empty?
      @skill_ids.each { |sid|
        return true if sid == attacker.action.skill_id
      }
      return false
    when KGC::Counter::KIND_ITEM
      # アイテム ID 判定
      return true if @item_ids.empty?
      @item_ids.each { |iid|
        return true if iid == attacker.action.item_id
      }
      return false
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃タイプ有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def attack_type_valid?(attacker, defender, obj)
    return true if @type == KGC::Counter::TYPE_ALL

    if obj == nil
      # 物理カウンターでない
      return false if @type != KGC::Counter::TYPE_PHYSICAL
    else
      # [物理攻撃] なら物理、そうでなければ魔法カウンター判定
      if @type != (obj.physical_attack ?
          KGC::Counter::TYPE_PHYSICAL : KGC::Counter::TYPE_MAGICAL)
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 属性有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def element_valid?(attacker, defender, obj)
    return true if @element_set.empty?

    if attacker.action.attack?
      elements = attacker.element_set
    else
      return false if obj == nil
      # 属性リスト取得
      if $imported["SetAttackElement"]
        elements = defender.get_inherited_element_set(attacker, obj)
      else
        elements = obj.element_set
      end
    end
    return !(@element_set & elements).empty?
  end
  #--------------------------------------------------------------------------
  # ○ 打撃関係度有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def atk_f_valid?(attacker, defender, obj)
    return true if @atk_f == 0

    n = (attacker.action.attack? ? 100 : (obj != nil ? obj.atk_f : 0) )
    return (@atk_f <= n)
  end
  #--------------------------------------------------------------------------
  # ○ 精神関係度有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def spi_f_valid?(attacker, defender, obj)
    return true if @spi_f == 0

    n = (attacker.action.attack? ? 0 : (obj != nil ? obj.spi_f : 0) )
    return (@spi_f <= n)
  end
  #--------------------------------------------------------------------------
  # ○ 残存 HP/MP 有効判定
  #     attacker : 攻撃者
  #     defender : 被攻撃者
  #     obj      : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def remain_hpmp_valid?(attacker, defender, obj)
    hp_rate = defender.hp * 100 / defender.maxhp
    case @remain_hp_type
    when KGC::Counter::REMAIN_TYPE_OVER
      return false unless (hp_rate >= @remain_hp)
    when KGC::Counter::REMAIN_TYPE_UNDER
      return false unless (hp_rate <= @remain_hp)
    end

    mp_rate = defender.mp * 100 / [defender.maxmp, 1].max
    case @remain_mp_type
    when KGC::Counter::REMAIN_TYPE_OVER
      return false unless (mp_rate >= @remain_mp)
    when KGC::Counter::REMAIN_TYPE_UNDER
      return false unless (mp_rate <= @remain_mp)
    end

    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Game_CounterInfo
#------------------------------------------------------------------------------
#   カウンター情報を扱うクラスです。
#==============================================================================

class Game_CounterInfo
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler                  # 行動者
  attr_accessor :action                   # カウンター行動
  attr_accessor :target_index             # 対象インデックス
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler      = nil
    @action       = nil
    @target_index = 0
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ○ カウンター行動リストの取得
  #--------------------------------------------------------------------------
  def counter_actions
    result = []
    states.each { |state| result += state.counter_actions }
    return result
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ○ カウンター行動リストの取得
  #--------------------------------------------------------------------------
  def counter_actions
    result = super
    equips.compact.each { |item| result += item.counter_actions }
    return result
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ カウンター行動リストの取得
  #--------------------------------------------------------------------------
  def counter_actions
    return (super + enemy.counter_actions)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_Counter start
  def start
    start_KGC_Counter

    @counter_added = false
    @counter_infos = []
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の処理
  #--------------------------------------------------------------------------
  alias process_action_KGC_Counter process_action
  def process_action
    process_action_KGC_Counter

    register_ignore_target_counter_action
    unset_counter_action
  end
  #--------------------------------------------------------------------------
  # ○ カウンター行動の解除
  #--------------------------------------------------------------------------
  def unset_counter_action
    return unless @counter_exec

    # 行動を元に戻す
    @active_battler.action.forcing      = @former_action.forcing
    @active_battler.action.kind         = @former_action.kind
    @active_battler.action.basic        = @former_action.basic
    @active_battler.action.skill_id     = @former_action.skill_id
    @active_battler.action.item_id      = @former_action.item_id
    @active_battler.action.target_index = @former_action.target_index
    @active_battler.action.made_targets = nil
    @active_battler.action.make_targets

    @former_action     = nil
    @counter_exec      = false
    @counter_interrupt = false
  end
  #--------------------------------------------------------------------------
  # ● 次に行動するべきバトラーの設定
  #--------------------------------------------------------------------------
  alias set_next_active_battler_KGC_Counter set_next_active_battler
  def set_next_active_battler
    set_counter_action

    unless @counter_exec
      set_next_active_battler_KGC_Counter
    end
  end
  #--------------------------------------------------------------------------
  # ○ カウンター行動の作成
  #--------------------------------------------------------------------------
  def set_counter_action
    @former_action     = nil
    @counter_exec      = false
    @counter_added     = false
    @counter_interrupt = false
    counter = @counter_infos.shift  # <-- Game_CounterInfo
    return if counter == nil

    last_active_battler = @active_battler
    @active_battler     = counter.battler
    # 元の行動を退避
    @former_action = @active_battler.action.clone
    @counter_exec  = true
    # カウンター行動を設定
    @active_battler.action.kind     = counter.action.kind
    @active_battler.action.basic    = counter.action.basic
    @active_battler.action.skill_id = counter.action.skill_id
    @active_battler.action.item_id  = counter.action.item_id

    # カウンター対象を設定
    target_index = counter.target_index
    # 対象が味方なら自分に対して発動
    if @active_battler.action.for_friend?
      target_index = @active_battler.index
    end
    @active_battler.action.target_index = target_index
    @active_battler.action.made_targets = nil
    @active_battler.action.make_targets

    unless @active_battler.action.valid?
      # カウンター発動不能ならキャンセル
      unset_counter_action
      @active_battler = last_active_battler
    else
      @active_battler.action.forcing = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行
  #--------------------------------------------------------------------------
  alias execute_action_KGC_Counter execute_action
  def execute_action
    unless @counter_exec
      register_interrupt_counter_action
    end

    if @counter_interrupt
      execute_interrupt_counter
    else
      execute_action_KGC_Counter
    end
    unset_counter_action
    @active_battler.action.made_targets = nil
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 攻撃
  #--------------------------------------------------------------------------
  alias execute_action_attack_KGC_Counter execute_action_attack
  def execute_action_attack
    if @counter_exec
      # 攻撃時メッセージを無理矢理書き換える
      old_DoAttack = Vocab::DoAttack
      Vocab.const_set(:DoAttack, Vocab::CounterAttack)
    end

    execute_action_attack_KGC_Counter

    if @counter_exec
      # 後始末
      Vocab.const_set(:DoAttack, old_DoAttack)
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動結果の表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  alias display_action_effects_KGC_Counter display_action_effects
  def display_action_effects(target, obj = nil)
    display_action_effects_KGC_Counter(target, obj)

    unless target.skipped
      register_counter_action(target)
    end
  end
  #--------------------------------------------------------------------------
  # ○ カウンター行動の登録
  #     target    : 被攻撃者
  #     interrupt : 割り込みフラグ
  #--------------------------------------------------------------------------
  def register_counter_action(target, interrupt = false)
    return unless can_counter?(target)

    # 有効なカウンター行動をセット
    target.counter_actions.each { |counter|
      break if counter_added?
      next  if counter.condition.ignore_target
      next  if counter.condition.interrupt ^ interrupt  # <-- if x != y
      judge_counter_action(@active_battler, target, counter)
    }
  end
  #--------------------------------------------------------------------------
  # ○ カウンター可否
  #     target : 被攻撃者
  #--------------------------------------------------------------------------
  def can_counter?(target = nil)
    return false if @counter_exec   # カウンターに対するカウンターは行わない
    return false if counter_added?  # カウンター済み
    if target != nil
      return false unless target.movable?  # 行動不能
    end

    if $imported["CooperationSkill"]
      # 連係スキルにはカウンターを適用しない
      return false if @active_battler.is_a?(Game_CooperationBattler)
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ カウンター登録済み判定
  #--------------------------------------------------------------------------
  def counter_added?
    return (KGC::Counter::RESTRICT_COUNTER && @counter_added)
  end
  #--------------------------------------------------------------------------
  # ○ カウンター判定
  #     attacker : 攻撃者
  #     target   : 被攻撃者
  #     counter  : カウンター行動
  #--------------------------------------------------------------------------
  def judge_counter_action(attacker, target, counter)
    return unless counter.valid?(attacker, target)
    return unless counter.exec?

    info = Game_CounterInfo.new
    info.battler = target
    info.action  = counter
    info.target_index = attacker.index
    @counter_infos << info
    @counter_added = true
  end
  #--------------------------------------------------------------------------
  # ○ ターゲット無視のカウンター行動の登録
  #     interrupt : 割り込み判定
  #--------------------------------------------------------------------------
  def register_ignore_target_counter_action(interrupt = false)
    return unless can_counter?
    return if @active_battler.nil?

    target_unit = (@active_battler.actor? ? $game_troop : $game_party).members
    target_unit.each { |battler|
      next unless can_counter?(battler)
      battler.counter_actions.each { |counter|
        break if counter_added?
        next  unless counter.condition.ignore_target
        next  if counter.condition.interrupt ^ interrupt  # <-- if x != y
        judge_counter_action(@active_battler, battler, counter)
      }
    }
  end
  #--------------------------------------------------------------------------
  # ○ 割り込みカウンター行動の登録
  #--------------------------------------------------------------------------
  def register_interrupt_counter_action
    return unless can_counter?

    # 自分が対象
    targets = @active_battler.action.make_targets
    if targets != nil
      targets.each { |t|
        break if counter_added?
        register_counter_action(t, true)
      }
    end

    # ターゲット無視
    register_ignore_target_counter_action(true) unless counter_added?

    @counter_interrupt = counter_added?
  end
    #--------------------------------------------------------------------------
    # ○ 割り込みカウンターの実行
    #--------------------------------------------------------------------------
    def execute_interrupt_counter
      counter = @counter_infos[0]
      text = counter.action.interrupt_message.clone
      text = Vocab::InterruptCounter.clone if text.empty?
      se = RPG::SE.new("Flash2", 80, 120).play
      se = RPG::SE.new("Ice7", 80, 100).play
      text.gsub!(/\\\\/, "\\")
      text.gsub!(/\\N([^\[]|$)/i) { "#{@active_battler.name}#{$1}" }
      text.gsub!(/\\C([^\[]|$)/i) { "#{counter.battler.name}#{$1}" }
      text.gsub!(/\\A([^\[]|$)/i) { "#{@active_battler.action.action_name}#{$1}" }
      @message_window.add_instant_text(text)
      wait(45)
    end
end
