#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ オーバードライブ - KGC_OverDrive ◆ VX ◆
#_/    ◇ Last update : 2009/11/01 ◇
#_/----------------------------------------------------------------------------
#_/  専用のゲージを消費して使用するスキルを作成します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize BEGIN ★
#==============================================================================

module KGC
module OverDrive
  # ◆ ドライブゲージ最大値
  #  普通はこのままでOK。微調整したい場合に変更。
  GAUGE_MAX = 1000
  # ◆ ドライブゲージ増加量
  #  高いほどゲージが溜まりやすい。
  #  マイナス値を指定すると減少。
  #  「被ダメージ」は、受けたダメージの最大 HP に対する割合で増加量を算出。
  #  (500 だと、最大 HP 相当のダメージで 500 溜まる)
  GAIN_RATE = [
     80,  # 攻撃
    500,  # 被ダメージ
    200,  # 勝利
    100,  # 逃走
    160,  # 孤独
     40,  # 行動
    160,  # 瀕死
     50,  # 防御
  ]  # ← この ] は消さないこと！

  # ◆ ゲージの初期本数
  DEFAULT_GAUGE_NUMBER = 1

  # ◆ デフォルトドライブタイプ
  #   0..攻撃  1..被ダメージ  2..勝利  3..逃走  4..孤独  5..行動
  #   6..瀕死  7..防御
  DEFAULT_ACTOR_DRIVE_TYPE = [0, 1, 6]        # アクター
  DEFAULT_ENEMY_DRIVE_TYPE = [0, 1, 4, 5, 6]  # 敵

  # ◆ ドライブゲージの色
  #  数値  : \C[n] と同じ色。
  #  Color : 指定した色。 ( Color.new(255, 128, 128) など )
  GAUGE_NORMAL_START_COLOR = 14  # 通常時開始色
  GAUGE_NORMAL_END_COLOR   =  6  # 通常時終了色
  GAUGE_MAX_START_COLOR    = 10  # 最大時開始色
  GAUGE_MAX_END_COLOR      =  2  # 最大時終了色

  # ◆ ドライブゲージに汎用ゲージを使用する
  #  ≪汎用ゲージ描画≫ 導入時のみ有効。
  ENABLE_GENERIC_GAUGE = true
  # ◆ ドライブゲージ設定
  #  画像は "Graphics/System" から読み込む。
  GAUGE_IMAGE     = "GaugeOD"     # 通常時画像
  GAUGE_MAX_IMAGE = "GaugeODMax"  # 最大時画像
  GAUGE_OFFSET    = [-23, -2]     # 位置補正 [x, y]
  GAUGE_LENGTH    = -4            # 長さ補正
  GAUGE_SLOPE     = 30            # 傾き (-89 ～ 89)

  # ◆ ドライブゲージの Y 座標補正値
  #  汎用ゲージ未使用の場合に使用。
  #  -8 にすると、HP/MP ゲージと同じ位置になります。
  GAUGE_OFFSET_Y = -8
  # ◆ ゲージ蓄積量の数値表記
  #   0 .. なし  ※ゲージが 2 本以上の場合は非推奨
  #   1 .. 即値 (蓄積量そのまま)
  #   2 .. 割合 --> x%
  #   3 .. 割合 (詳細１) --> x.x%
  #   4 .. 割合 (詳細２) --> x.xx%
  #   5 .. 蓄積済み本数
  GAUGE_VALUE_STYLE = 2
  # ◆ ゲージ蓄積量のフォントサイズ
  #  大きくしすぎると名前に被ります。
  GAUGE_VALUE_FONT_SIZE = 14

  # ◆ 死亡（HP 0）時にドライブゲージを 0 にする
  EMPTY_ON_DEAD = true

  # ◆ ドライブゲージを表示しないアクター
  #  ゲージを隠すアクターのIDを配列に格納。
  HIDE_GAUGE_ACTOR = []
  # ◆ 非戦闘時はドライブゲージを隠す
  HIDE_GAUGE_NOT_IN_BATTLE = false
  # ◆ オーバードライブスキル未修得ならゲージを隠す
  HIDE_GAUGE_NO_OD_SKILLS  = true
  # ◆ ゲージを隠している場合はゲージを増加させない
  NOT_GAIN_GAUGE_HIDING    = true

  # ◆ ゲージ不足のときはオーバードライブスキルを隠す
  HIDE_SKILL_LACK_OF_GAUGE = false

  # ◆ ドライブゲージ名
  GAUGE_NAME = "ドライブゲージ"
  # ◆ ドライブゲージ変動アイテム使用時のメッセージ
  OD_GAIN_MESSAGE = {
    :drain_a   => "%sは%sを奪われた！",  # 吸収: アクター
    :drain_e   => "%sの%sを奪った！",    # 吸収: 敵
    :loss_a    => "%sの%sが減った！",    # 減少: アクター
    :loss_e    => "%sの%sが減った！",    # 減少: 敵
    :recover_a => "%sの%sが増えた！",    # 増加: アクター
    :recover_e => "%sの%sが増えた！",    # 増加: 敵
  }
end
end

#==============================================================================
# ☆ カスタマイズ項目終了 - Customize END ☆
#==============================================================================

$imported = {} if $imported == nil
$imported["OverDrive"] = true

module KGC::OverDrive
  # ドライブタイプ
  module Type
    ATTACK  = 0  # 攻撃
    DAMAGE  = 1  # 被ダメージ
    VICTORY = 2  # 勝利
    ESCAPE  = 3  # 逃走
    ALONE   = 4  # 孤独
    ACTION  = 5  # 行動
    FATAL   = 6  # 瀕死
    GUARD   = 7  # 防御
  end

  # 蓄積量表記
  module ValueStyle
    NONE         = 0  # なし
    IMMEDIATE    = 1  # 即値
    RATE         = 2  # 割合
    RATE_DETAIL1 = 3  # 割合 (詳細１)
    RATE_DETAIL2 = 4  # 割合 (詳細２)
    NUMBER       = 5  # 蓄積済み本数
  end

  module Regexp
    module UsableItem
      # ドライブゲージ増加
      OD_GAIN = /<(?:OD_GAIN|(?:OD|ドライブ)ゲージ増加)\s*([\+\-]?\d+)>/i
    end

    module Skill
      # オーバードライブ
      OVER_DRIVE = /<(?:OVER_DRIVE|オーバードライブ)\s*(\d+)?(\+)?>/i
      # ゲージ増加率
      OD_GAIN_RATE =
        /<(?:OD_GAIN_RATE|(?:OD|ドライブ)ゲージ増加率)\s*(\d+)[%％]?>/i
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
  # ○ アクターのドライブゲージの増減
  #     actor_id : アクター ID (-1 : パーティ全体)
  #     value    : 増加量 (マイナスも可)
  #--------------------------------------------------------------------------
  def gain_actor_od_gauge(actor_id, value)
    if actor_id == -1
      # 生存メンバー全員のゲージを操作
      $game_party.existing_members.each { |actor|
        next unless actor.can_gain_overdrive?
        actor.overdrive += value
      }
    else
      actor = $game_actors[actor_id]
      actor.overdrive += value if actor != nil && actor.exist?
    end
  end
  #--------------------------------------------------------------------------
  # ○ エネミーのドライブゲージの増減
  #     enemy_index : エネミー index (-1 : 全体)
  #     value       : 増加量 (マイナスも可)
  #--------------------------------------------------------------------------
  def gain_enemy_od_gauge(enemy_index, value)
    if enemy_index == -1
      # 生存エネミー全員のゲージを操作
      $game_troop.existing_members.each { |enemy|
        enemy.overdrive += value
      }
    else
      enemy = $game_troop.members[enemy_index]
      enemy.overdrive += value if enemy != nil && enemy.exist?
    end
  end
  #--------------------------------------------------------------------------
  # ○ アクターのドライブゲージの取得
  #     actor_id    : アクター ID
  #     variable_id : 戻り値を格納する変数 ID
  #--------------------------------------------------------------------------
  def get_actor_od_gauge(actor_id, variable_id = 0)
    actor = $game_actors[actor_id]
    n = (actor != nil ? actor.overdrive : 0)
    if variable_id > 0
      $game_variables[variable_id] = n
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ エネミーのドライブゲージの取得
  #     enemy_index : エネミー index
  #     variable_id : 戻り値を格納する変数 ID
  #--------------------------------------------------------------------------
  def get_enemy_od_gauge(enemy_index, variable_id = 0)
    enemy = $game_troop.members[enemy_index]
    n = (enemy != nil ? enemy.overdrive : 0)
    if variable_id > 0
      $game_variables[variable_id] = n
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ アクターのドライブゲージの本数を設定
  #     actor_id : アクター ID (-1 : パーティ全体)
  #     number   : ゲージ本数
  #--------------------------------------------------------------------------
  def set_actor_od_gauge_number(actor_id, number)
    if actor_id == -1
      # メンバー全員の本数を設定
      $game_party.members.each { |actor|
        actor.drive_gauge_number = number
      }
    else
      actor = $game_actors[actor_id]
      actor.drive_gauge_number = number if actor != nil
    end
  end
  #--------------------------------------------------------------------------
  # ○ エネミーのドライブゲージの本数を設定
  #     enemy_index : エネミー index (-1 : 全体)
  #     number   : ゲージ本数
  #--------------------------------------------------------------------------
  def set_enemy_od_gauge_number(enemy_index, number)
    if enemy_index == -1
      # 生存エネミー全員の本数を設定
      $game_troop.members.each { |enemy|
        enemy.drive_gauge_number = number
      }
    else
      enemy = $game_troop.members[enemy_index]
      enemy.drive_gauge_number = number if enemy != nil
    end
  end
  #--------------------------------------------------------------------------
  # ○ アクターのドライブゲージが最大か判定
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def actor_od_gauge_max?(actor_id)
    actor = $game_actors[actor_id]
    return false if actor == nil
    return actor.overdrive == actor.max_overdrive
  end
  #--------------------------------------------------------------------------
  # ○ エネミーのドライブゲージが最大か判定
  #     enemy_index : エネミー index
  #--------------------------------------------------------------------------
  def enemy_od_gauge_max?(enemy_index)
    enemy = $game_troop.members[enemy_index]
    return false if enemy == nil
    return enemy.overdrive == enemy.max_overdrive
  end
  #--------------------------------------------------------------------------
  # ○ アクターのドライブタイプの変更
  #     actor_id : アクター ID (-1 : パーティ全体)
  #     types    : ドライブタイプの配列 (省略時 : 初期化)
  #--------------------------------------------------------------------------
  def set_actor_drive_type(actor_id, types = nil)
    if actor_id == -1
      # メンバー全員のドライブタイプを変更
      $game_party.members.each { |actor|
        actor.drive_type = types
      }
    else
      actor = $game_actors[actor_id]
      actor.drive_type = types if actor != nil
    end
  end
  #--------------------------------------------------------------------------
  # ○ エネミーのドライブタイプの変更
  #     enemy_index : エネミー index (-1 : 全体)
  #     types       : ドライブタイプの配列 (省略時 : 初期化)
  #--------------------------------------------------------------------------
  def set_enemy_drive_type(enemy_index, types = nil)
    if enemy_index == -1
      # エネミー全員のドライブタイプを変更
      $game_troop.members.each { |enemy|
        enemy.drive_type = types
      }
    else
      enemy = $game_troop.members[enemy_index]
      enemy.drive_type = types if enemy != nil
    end
  end
end
end

class Game_Interpreter
  include KGC::Commands
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::UsableItem
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ オーバードライブのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_overdrive_cache
    @__od_gain = 0

    self.note.each_line { |line|
      case line
      when KGC::OverDrive::Regexp::UsableItem::OD_GAIN
        # ドライブゲージ増加
        @__od_gain = $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ増加量
  #--------------------------------------------------------------------------
  def od_gain
    create_overdrive_cache if @__od_gain == nil
    return @__od_gain
  end
  #--------------------------------------------------------------------------
  # ○ ドライブスキルであるか
  #--------------------------------------------------------------------------
  def overdrive
    return false
  end
  alias overdrive? overdrive
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # ○ オーバードライブのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_overdrive_cache
    super

    @__is_overdrive   = false
    @__od_cost        = KGC::OverDrive::GAUGE_MAX
    @__od_consume_all = false
    @__od_gain_rate   = 100

    self.note.each_line { |line|
      case line
      when KGC::OverDrive::Regexp::Skill::OVER_DRIVE
        # オーバードライブ
        @__is_overdrive   = true
        @__od_cost        = $1.to_i if $1 != nil
        @__od_consume_all = ($2 != nil)
      when KGC::OverDrive::Regexp::Skill::OD_GAIN_RATE
        # ゲージ増加率
        @__od_gain_rate = $1.to_i
      end
    }

    # ドライブスキルでなければ、ゲージ消費量 0
    unless @__is_overdrive
      @__od_cost = 0
    end
  end
  #--------------------------------------------------------------------------
  # ○ ドライブスキルであるか
  #--------------------------------------------------------------------------
  def overdrive
    create_overdrive_cache if @__is_overdrive == nil
    return @__is_overdrive
  end
  alias overdrive? overdrive
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ消費量
  #--------------------------------------------------------------------------
  def od_cost
    create_overdrive_cache if @__od_cost == nil
    return @__od_cost
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ全消費か
  #--------------------------------------------------------------------------
  def od_consume_all
    create_overdrive_cache if @__od_consume_all == nil
    return @__od_consume_all
  end
  alias od_consume_all? od_consume_all
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ増加率
  #--------------------------------------------------------------------------
  def od_gain_rate
    create_overdrive_cache if @__od_gain_rate == nil
    return @__od_gain_rate
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  # ドライブゲージ名
  def self.overdrive
    return KGC::OverDrive::GAUGE_NAME
  end

  # アクター側メッセージ
  ActorODDrain    = KGC::OverDrive::OD_GAIN_MESSAGE[:drain_a]
  ActorODLoss     = KGC::OverDrive::OD_GAIN_MESSAGE[:loss_a]
  ActorODRecovery = KGC::OverDrive::OD_GAIN_MESSAGE[:recover_a]

  # 敵側メッセージ
  EnemyODDrain    = KGC::OverDrive::OD_GAIN_MESSAGE[:drain_e]
  EnemyODLoss     = KGC::OverDrive::OD_GAIN_MESSAGE[:loss_e]
  EnemyODRecovery = KGC::OverDrive::OD_GAIN_MESSAGE[:recover_e]
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Battler
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_writer   :drive_type               # ドライブタイプ
  attr_reader   :od_damage                # 行動結果: ドライブダメージ
  #--------------------------------------------------------------------------
  # ● 行動効果の保持用変数をクリア
  #--------------------------------------------------------------------------
  alias clear_action_results_KGC_OverDrive clear_action_results
  def clear_action_results
    clear_action_results_KGC_OverDrive

    @od_damage = 0
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ量取得
  #--------------------------------------------------------------------------
  def overdrive
    @overdrive = 0 if @overdrive == nil
    return @overdrive
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの操作
  #--------------------------------------------------------------------------
  def overdrive=(value)
    @overdrive = [[value, max_overdrive].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ最大量取得
  #--------------------------------------------------------------------------
  def max_overdrive
    return KGC::OverDrive::GAUGE_MAX * drive_gauge_number
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ Max 判定
  #--------------------------------------------------------------------------
  def overdrive_max?
    return (overdrive == max_overdrive)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ本数取得
  #--------------------------------------------------------------------------
  def drive_gauge_number
    if @drive_gauge_number == nil
      @drive_gauge_number = KGC::OverDrive::DEFAULT_GAUGE_NUMBER
    end
    return @drive_gauge_number
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ本数の操作
  #--------------------------------------------------------------------------
  def drive_gauge_number=(value)
    @drive_gauge_number = [value, 1].max
  end
  #--------------------------------------------------------------------------
  # ○ ドライブタイプの取得
  #--------------------------------------------------------------------------
  def drive_type
    return []
  end
  #--------------------------------------------------------------------------
  # ○ ドライブスキル習得済み判定
  #--------------------------------------------------------------------------
  def overdrive_skill_learned?
    return true
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ表示判定
  #--------------------------------------------------------------------------
  def od_gauge_visible?
    return false
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ増加可否判定
  #--------------------------------------------------------------------------
  def can_gain_overdrive?
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃時増加判定
  #--------------------------------------------------------------------------
  def drive_attack?
    return drive_type.include?(KGC::OverDrive::Type::ATTACK)
  end
  #--------------------------------------------------------------------------
  # ○ 被ダメージ時増加判定
  #--------------------------------------------------------------------------
  def drive_damage?
    return drive_type.include?(KGC::OverDrive::Type::DAMAGE)
  end
  #--------------------------------------------------------------------------
  # ○ 勝利時増加判定
  #--------------------------------------------------------------------------
  def drive_victory?
    return drive_type.include?(KGC::OverDrive::Type::VICTORY)
  end
  #--------------------------------------------------------------------------
  # ○ 逃走時増加判定
  #--------------------------------------------------------------------------
  def drive_escape?
    return drive_type.include?(KGC::OverDrive::Type::ESCAPE)
  end
  #--------------------------------------------------------------------------
  # ○ 孤独時増加判定
  #--------------------------------------------------------------------------
  def drive_alone?
    return drive_type.include?(KGC::OverDrive::Type::ALONE)
  end
  #--------------------------------------------------------------------------
  # ○ 行動時増加判定
  #--------------------------------------------------------------------------
  def drive_action?
    return drive_type.include?(KGC::OverDrive::Type::ACTION)
  end
  #--------------------------------------------------------------------------
  # ○ 瀕死時増加判定
  #--------------------------------------------------------------------------
  def drive_fatal?
    return drive_type.include?(KGC::OverDrive::Type::FATAL)
  end
  #--------------------------------------------------------------------------
  # ○ 防御時増加判定
  #--------------------------------------------------------------------------
  def drive_guard?
    return drive_type.include?(KGC::OverDrive::Type::GUARD)
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  alias add_state_KGC_OverDrive add_state
  def add_state(state_id)
    add_state_KGC_OverDrive(state_id)

    reset_overdrive_on_dead if dead?
  end
  #--------------------------------------------------------------------------
  # ○ スキルの消費ドライブゲージ計算
  #     skill : スキル
  #--------------------------------------------------------------------------
  def calc_od_cost(skill)
    return 0 unless skill.is_a?(RPG::Skill)

    return skill.od_cost
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  alias skill_can_use_KGC_OverDrive? skill_can_use?
  def skill_can_use?(skill)
    return false unless skill_can_use_KGC_OverDrive?(skill)

    return false if calc_od_cost(skill) > overdrive
    return true
  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムによるダメージ計算
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  alias make_obj_damage_value_KGC_OverDrive make_obj_damage_value
  def make_obj_damage_value(user, obj)
    make_obj_damage_value_KGC_OverDrive(user, obj)

    apply_od_consume_all_for_damage(user, obj)
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ全消費時の効果の適用
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  def apply_od_consume_all_for_damage(user, obj)
    return unless obj.is_a?(RPG::Skill)
    return unless obj.overdrive? && obj.od_consume_all?

    # 余剰消費量に応じて強化 (例: 最低消費量 1000 でゲージが 1200 なら 1.2 倍)
    rate = [user.overdrive * 1000 / obj.od_cost, 1000].max
    @hp_damage = @hp_damage * rate / 1000
    @mp_damage = @mp_damage * rate / 1000
  end
  #--------------------------------------------------------------------------
  # ● ダメージの反映
  #     user : スキルかアイテムの使用者
  #    呼び出し前に @hp_damage、@mp_damage、@absorbed が設定されていること。
  #--------------------------------------------------------------------------
  alias execute_damage_KGC_OverDrive execute_damage
  def execute_damage(user)
    execute_damage_KGC_OverDrive(user)

    increase_overdrive(user)
    increase_overdrive_by_item(user)
  end
  #--------------------------------------------------------------------------
  # ○ 死亡時ドライブゲージ初期化処理
  #--------------------------------------------------------------------------
  def reset_overdrive_on_dead
    return unless KGC::OverDrive::EMPTY_ON_DEAD

    self.overdrive = 0
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ増加処理
  #     attacker : 攻撃者
  #--------------------------------------------------------------------------
  def increase_overdrive(attacker = nil)
    return unless attacker.is_a?(Game_Battler)  # 攻撃者がバトラーでない
    return unless actor? ^ attacker.actor?      # 攻撃側と防御側が同じ
    return if hp_damage == 0 && mp_damage == 0  # ダメージなし

    increase_attacker_overdrive(attacker)
    increase_defender_overdrive(attacker)
    reset_overdrive_on_dead if dead?
  end
  #--------------------------------------------------------------------------
  # ○ 攻撃側のドライブゲージ増加処理
  #     attacker : 攻撃者
  #--------------------------------------------------------------------------
  def increase_attacker_overdrive(attacker)
    return unless can_gain_overdrive?
    return unless attacker.drive_attack?  # ドライブタイプ「攻撃」なし

    od_gain = KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::ATTACK]
    if attacker.action.kind == 1
      rate = attacker.action.skill.od_gain_rate  # スキルの倍率を適用
      od_gain = od_gain * rate / 100
      if rate > 0
        od_gain = [od_gain, 1].max
      elsif rate < 0
        od_gain = [od_gain, -1].min
      end
    end
    attacker.overdrive += od_gain
  end
  #--------------------------------------------------------------------------
  # ○ 防御側のドライブゲージ増加処理
  #     attacker : 攻撃者
  #--------------------------------------------------------------------------
  def increase_defender_overdrive(attacker)
    return unless can_gain_overdrive?
    return unless self.drive_damage?  # ドライブタイプ「ダメージ」なし

    rate = KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::DAMAGE]
    od_gain = 0
    od_gain += hp_damage * rate / maxhp if hp_damage > 0
    od_gain += mp_damage * rate / maxmp if mp_damage > 0 && maxmp > 0
    if rate > 0
      od_gain = [od_gain, 1].max
    elsif rate < 0
      od_gain = [od_gain, -1].min
    end
    self.overdrive += od_gain
  end
  #--------------------------------------------------------------------------
  # ○ アイテムによるドライブゲージ増加処理
  #     user : 使用者
  #--------------------------------------------------------------------------
  def increase_overdrive_by_item(user = nil)
    return unless user.is_a?(Game_Battler)
    return unless can_gain_overdrive?

    if user.action.skill?
      obj = user.action.skill
    elsif user.action.item?
      obj = user.action.item
    else
      return
    end
    @od_damage = -obj.od_gain
    self.overdrive -= @od_damage
  end
  #--------------------------------------------------------------------------
  # ● スキルの効果適用
  #     user  : スキルの使用者
  #     skill : スキル
  #--------------------------------------------------------------------------
  alias skill_effect_KGC_OverDrive skill_effect
  def skill_effect(user, skill)
    skill_effect_KGC_OverDrive(user, skill)

    # アイテムでスキルを発動した場合はゲージ消費判定を無視
    if $imported["ReproduceFunctions"] && $game_temp.exec_skill_on_item
      return
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  alias setup_KGC_OverDrive setup
  def setup(actor_id)
    setup_KGC_OverDrive(actor_id)

    @overdrive  = 0
    @drive_type = nil
  end
  #--------------------------------------------------------------------------
  # ○ ドライブタイプの取得
  #--------------------------------------------------------------------------
  def drive_type
    unless @drive_type.is_a?(Array)
      return KGC::OverDrive::DEFAULT_ACTOR_DRIVE_TYPE
    end
    return @drive_type
  end
  #--------------------------------------------------------------------------
  # ○ ドライブスキル習得済み判定
  #--------------------------------------------------------------------------
  def overdrive_skill_learned?
    result = false
    # 一時的に戦闘中フラグを解除
    last_in_battle = $game_temp.in_battle
    $game_temp.in_battle = false

    self.skills.each { |skill|
      if skill.overdrive?
        result = true
        break
      end
    }
    $game_temp.in_battle = last_in_battle
    return result
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ増加可否判定
  #--------------------------------------------------------------------------
  def can_gain_overdrive?
    if KGC::OverDrive::NOT_GAIN_GAUGE_HIDING
      # 非表示
      return false unless od_gauge_visible_l?
    end
    if KGC::OverDrive::HIDE_GAUGE_NO_OD_SKILLS
      # 未修得
      return false unless overdrive_skill_learned?
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ表示判定
  #--------------------------------------------------------------------------
  def od_gauge_visible?
    return false unless od_gauge_visible_l?
    return false unless can_gain_overdrive?

    return true
  end
  #--------------------------------------------------------------------------
  # ○ ゲージ表示判定 (簡易版)
  #--------------------------------------------------------------------------
  def od_gauge_visible_l?
    # 戦闘中非表示
    if KGC::OverDrive::HIDE_GAUGE_NOT_IN_BATTLE && !$game_temp.in_battle
      return false
    end
    # 非表示
    return false if KGC::OverDrive::HIDE_GAUGE_ACTOR.include?(self.id)

    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     index    : 敵グループ内インデックス
  #     enemy_id : 敵キャラ ID
  #--------------------------------------------------------------------------
  alias initialize_KGC_OverDrive initialize
  def initialize(index, enemy_id)
    initialize_KGC_OverDrive(index, enemy_id)

    @overdrive  = 0
    @drive_type = nil
  end
  #--------------------------------------------------------------------------
  # ○ ドライブタイプの取得
  #--------------------------------------------------------------------------
  def drive_type
    unless @drive_type.is_a?(Array)
      return KGC::OverDrive::DEFAULT_ENEMY_DRIVE_TYPE
    end
    return @drive_type
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの通常時の色 1 の取得
  #--------------------------------------------------------------------------
  def od_gauge_normal_color1
    color = KGC::OverDrive::GAUGE_NORMAL_START_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの通常時の色 2 の取得
  #--------------------------------------------------------------------------
  def od_gauge_normal_color2
    color = KGC::OverDrive::GAUGE_NORMAL_END_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの最大時の色 1 の取得
  #--------------------------------------------------------------------------
  def od_gauge_max_color1
    color = KGC::OverDrive::GAUGE_MAX_START_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの最大時の色 2 の取得
  #--------------------------------------------------------------------------
  def od_gauge_max_color2
    color = KGC::OverDrive::GAUGE_MAX_END_COLOR
    return (color.is_a?(Integer) ? text_color(color) : color)
  end
  #--------------------------------------------------------------------------
  # ● 名前の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  alias draw_actor_name_KGC_OverDrive draw_actor_name
  def draw_actor_name(actor, x, y)
    draw_actor_od_gauge(actor, x, y, 108)

    draw_actor_name_KGC_OverDrive(actor, x, y)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 幅
  #--------------------------------------------------------------------------
  def draw_actor_od_gauge(actor, x, y, width = 120)
    return unless actor.od_gauge_visible?

    n = actor.overdrive % KGC::OverDrive::GAUGE_MAX
    n = KGC::OverDrive::GAUGE_MAX if actor.overdrive_max?

    if KGC::OverDrive::ENABLE_GENERIC_GAUGE && $imported["GenericGauge"]
      # 汎用ゲージ
      file = (actor.overdrive_max? ?
        KGC::OverDrive::GAUGE_MAX_IMAGE : KGC::OverDrive::GAUGE_IMAGE)
      draw_gauge(file,
        x, y, width, n, KGC::OverDrive::GAUGE_MAX,
        KGC::OverDrive::GAUGE_OFFSET,
        KGC::OverDrive::GAUGE_LENGTH,
        KGC::OverDrive::GAUGE_SLOPE)
    else
      # デフォルトゲージ
      gw = width * n / KGC::OverDrive::GAUGE_MAX
      gc1 = (gw == width ? od_gauge_max_color1 : od_gauge_normal_color1)
      gc2 = (gw == width ? od_gauge_max_color2 : od_gauge_normal_color2)
      self.contents.fill_rect(x, y + WLH + KGC::OverDrive::GAUGE_OFFSET_Y,
        width, 6, gauge_back_color)
      self.contents.gradient_fill_rect(
        x, y + WLH + KGC::OverDrive::GAUGE_OFFSET_Y, gw, 6, gc1, gc2)
    end

    draw_actor_od_gauge_value(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブゲージ蓄積量の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 幅
  #--------------------------------------------------------------------------
  def draw_actor_od_gauge_value(actor, x, y, width = 120)
    text = ""
    value = actor.overdrive * 100.0 / KGC::OverDrive::GAUGE_MAX
    case KGC::OverDrive::GAUGE_VALUE_STYLE
    when KGC::OverDrive::ValueStyle::IMMEDIATE
      text = actor.overdrive.to_s
    when KGC::OverDrive::ValueStyle::RATE
      text = sprintf("%d%%", actor.overdrive * 100 / KGC::OverDrive::GAUGE_MAX)
    when KGC::OverDrive::ValueStyle::RATE_DETAIL1
      text = sprintf("%0.1f%%", value)
    when KGC::OverDrive::ValueStyle::RATE_DETAIL2
      text = sprintf("%0.2f%%", value)
    when KGC::OverDrive::ValueStyle::NUMBER
      text = "#{actor.overdrive / KGC::OverDrive::GAUGE_MAX}"
    else
      return
    end

    last_font_size = self.contents.font.size
    new_font_size  = KGC::OverDrive::GAUGE_VALUE_FONT_SIZE
    self.contents.font.size = new_font_size
    self.contents.draw_text(
      x, y + WLH + KGC::OverDrive::GAUGE_OFFSET_Y - new_font_size / 2,
      width, new_font_size, text, 2)
    self.contents.font.size = last_font_size
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Skill
#==============================================================================

if KGC::OverDrive::HIDE_SKILL_LACK_OF_GAUGE

class Window_Skill < Window_Selectable
  #--------------------------------------------------------------------------
  # ○ スキルをリストに含めるかどうか
  #     skill : スキル
  #--------------------------------------------------------------------------
  unless $@
    alias include_KGC_OverDrive? include? if method_defined?(:include?)
  end
  def include?(skill)
    return false if skill == nil

    if defined?(include_KGC_OverDrive?)
      return false unless include_KGC_OverDrive?(skill)
    end

    if skill.overdrive?
      return (@actor.calc_od_cost(skill) <= @actor.overdrive)
    else
      return true
    end
  end

if method_defined?(:include_KGC_OverDrive?)
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for skill in @actor.skills
      next unless include?(skill)
      @data.push(skill)
      if skill.id == @actor.last_skill_id
        self.index = @data.size - 1
      end
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
end

end  # <-- class
end  # <-- if KGC::OverDrive::HIDE_SKILL_LACK_OF_GAUGE

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_Base
  #--------------------------------------------------------------------------
  # ● スキルの使用 (味方対象以外の使用効果を適用)
  #--------------------------------------------------------------------------
  alias use_skill_nontarget_KGC_OverDrive use_skill_nontarget
  def use_skill_nontarget
    consume_od_gauge

    use_skill_nontarget_KGC_OverDrive
  end
  #--------------------------------------------------------------------------
  # ○ スキル使用時のドライブゲージ消費
  #--------------------------------------------------------------------------
  def consume_od_gauge
    if @skill.od_consume_all?
      @actor.overdrive = 0
    else
      @actor.overdrive -= @actor.calc_od_cost(@skill)
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 戦闘終了
  #     result : 結果 (0:勝利 1:逃走 2:敗北)
  #--------------------------------------------------------------------------
  alias battle_end_KGC_OverDrive battle_end
  def battle_end(result)
    increase_overdrive_on_battle_end(result)

    battle_end_KGC_OverDrive(result)
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘終了時のドライブゲージ増加処理
  #     result : 結果 (0:勝利 1:逃走 2:敗北)
  #--------------------------------------------------------------------------
  def increase_overdrive_on_battle_end(result)
    case result
    when 0  # 勝利
      od_gain = KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::VICTORY]
      $game_party.existing_members.each { |actor|
        actor.overdrive += od_gain if actor.drive_victory?
      }
    when 1  # 逃走
      od_gain = KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::ESCAPE]
      $game_party.existing_members.each { |actor|
        actor.overdrive += od_gain if actor.drive_escape?
      }
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行
  #--------------------------------------------------------------------------
  alias execute_action_KGC_OverDrive execute_action
  def execute_action
    increase_overdrive_on_action

    execute_action_KGC_OverDrive
  end
  #--------------------------------------------------------------------------
  # ○ 行動時のドライブゲージ増加処理
  #--------------------------------------------------------------------------
  def increase_overdrive_on_action
    battler = @active_battler
    od_gain = 0
    unit = (battler.actor? ? $game_party : $game_troop)

    # 孤独戦闘
    if battler.drive_alone? && unit.existing_members.size == 1
      od_gain += KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::ALONE]
    end
    # 行動
    if battler.drive_action?
      od_gain += KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::ACTION]
    end
    # 瀕死
    if battler.drive_fatal? && battler.hp < battler.maxhp / 4
      od_gain += KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::FATAL]
    end
    # 防御
    if battler.drive_guard? && battler.action.kind == 0 &&
        battler.action.basic == 1
      od_gain += KGC::OverDrive::GAIN_RATE[KGC::OverDrive::Type::GUARD]
    end
    battler.overdrive += od_gain
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : スキル
  #--------------------------------------------------------------------------
  alias execute_action_skill_KGC_OverDrive execute_action_skill
  def execute_action_skill
    execute_action_skill_KGC_OverDrive

    consume_od_gauge
  end
  #--------------------------------------------------------------------------
  # ○ スキル使用時のドライブゲージ消費
  #--------------------------------------------------------------------------
  def consume_od_gauge
    return unless @active_battler.action.skill?

    skill = @active_battler.action.skill
    if skill.od_consume_all?
      @active_battler.overdrive = 0
    else
      @active_battler.overdrive -= @active_battler.calc_od_cost(skill)
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  alias display_damage_KGC_OverDrive display_damage
  def display_damage(target, obj = nil)
    display_damage_KGC_OverDrive(target, obj)

    return if target.missed || target.evaded
    display_od_damage(target, obj)
  end
  #--------------------------------------------------------------------------
  # ○ ドライブダメージ表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_od_damage(target, obj = nil)
    return if target.dead?
    return if target.od_damage == 0
    if target.absorbed                      # 吸収
      fmt = target.actor? ? Vocab::ActorODDrain : Vocab::EnemyODDrain
      text = sprintf(fmt, target.name, Vocab::overdrive)
    elsif target.od_damage > 0              # ダメージ
      fmt = target.actor? ? Vocab::ActorODLoss : Vocab::EnemyODLoss
      text = sprintf(fmt, target.name, Vocab::overdrive)
    else                                    # 回復
      fmt = target.actor? ? Vocab::ActorODRecovery : Vocab::EnemyODRecovery
      text = sprintf(fmt, target.name, Vocab::overdrive)
      Sound.play_recovery
    end
    @message_window.add_instant_text(text)
    wait(30)
  end
end
