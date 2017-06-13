#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 昼夜切り替え - KGC_DayNight ◆ VX ◆
#_/    ◇ Last update : 2009/08/11 ◇
#_/----------------------------------------------------------------------------
#_/  ゲーム中に昼夜の概念を作成します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize BEGIN ★
#==============================================================================

module KGC
module DayNight
  # ◆ 昼夜切り替え方式
  #   0..時間経過  1..歩数  2..現実時間(微妙)
  METHOD = 0

  # ◆ フェーズを保存する変数の番号
  # ここで指定した変数に、現在のフェーズを格納します。
  PHASE_VARIABLE     = 86
  # ◆ 日数を保存する変数の番号
  #  ここで指定した変数に、経過した日数を格納します。
  PASS_DAYS_VARIABLE = 87

  # ◆ イベント中はフェーズを変更しない
  STOP_ON_EVENT = true
  # ◆ 戦闘時に色調を適用する範囲
  #   0..なし  1..背景のみ  2..背景 + 敵
  #  ※ 通常はマップ自体を背景として使用するため、0 を指定しても背景のみ色調が
  #     適用されているように見えます。
  BG_TONE_IN_BATTLE = 0

  # ◆ 各フェーズの設定
  #  各フェーズを
  #   ["名称", 色調(Tone), 切り替え時間],
  #  という書式で作成。
  #  フェーズを増やすこともできますが、慣れないうちはおすすめしません。
  #
  #  [名称]
  #    フェーズの名前。
  #    名前自体に意味はありません。
  #  [色調]
  #    画面全体の色。
  #    よく分からない場合は変更しないでください。
  #  [切り替え時間]
  #    次のフェーズに移るまでの時間。
  #    切り替え方式が時間経過の場合は秒、歩数の場合は歩数そのまま。
  #    現実時間の場合、次の状態へ切り替える時刻 (24時間方式)。
  PHASE = [
    ["昼",   Tone.new(   0,    0,   0), 300],  # フェーズ 0
    ["夕方", Tone.new( -32,  -96, -96), 100],  # フェーズ 1
    ["夜",   Tone.new(-112, -112, -32), 100],  # フェーズ 2
    ["朝",   Tone.new( -48,  -48, -16), 100],  # フェーズ 3
  ]  # ← これは消さないこと！

  # 現実時間のときは、
  #  ["昼",   Tone.new(  0,   0,   0), 16],  # フェーズ 0 (16時に夕方)
  #  ["夕方", Tone.new(  0, -96, -96), 20],  # フェーズ 1 (20時に夜)
  #  ["夜",   Tone.new(-96, -96, -64),  6],  # フェーズ 2 (6時に朝)
  #  ["朝",   Tone.new(-48, -48, -16), 10],  # フェーズ 3 (10時に昼)
  # このような感じ。

  # ◆ 日付が変わるフェーズ
  #  ここで指定したフェーズになったとき、日数を加算する。
  #  初期状態の場合  0..昼  1..夕方  2..夜  3..朝
  # ※ 現実時間の場合、現実と同じ日数にはならないので注意。
  PASS_DAY_PHASE = 3

  # ◆ 状態切り替え時のフェード時間 (フレーム)
  #  省略時もこの値を使用します。
  PHASE_DURATION = 60

  # ◆ 曜日名
  #  初日は先頭から始まり、最後の曜日まで行くと最初の曜日に戻る。
  #  曜日自体に意味はありません。
  #  曜日名を追加（削除）すれば、曜日を増やす（減らす）こともできます。
  # ※ 現実時間を使用する場合は 7 個にしてください。
  WEEK_NAME = ["日", "月", "火", "水", "木", "金", "土"]
end
end

#==============================================================================
# ☆ カスタマイズ項目終了 - Customize END ☆
#==============================================================================

$imported = {} if $imported == nil
$imported["DayNight"] = true

if $data_mapinfos == nil
  $data_mapinfos = load_data("Data/MapInfos.rvdata")
end

module KGC::DayNight
  BATTLE_TONE_NONE = 0  # 戦闘時の色調 : なし
  BATTLE_TONE_BG   = 1  # 戦闘時の色調 : 背景の身
  BATTLE_TONE_FULL = 2  # 戦闘時の色調 : 背景 + 敵

  METHOD_TIME  = 0  # 時間経過
  METHOD_STEP  = 1  # 歩数
  METHOD_RTIME = 2  # 現実時間

  module Regexp
    module MapInfo
      # 遷移を止める
      DAYNIGHT_STOP = /\[DN_STOP\]/i
      # 昼夜エフェクト無効
      DAYNIGHT_VOID = /\[DN_VOID\]/i
    end

    module Event
      # 発光
      LUMINOUS = /\[(?:LUMINOUS|発光)\]/i
    end

    module Troop
      # 出現フェーズ
      APPEAR_PHASE = /\[DN((?:\s*[\-]?\d+(?:\s*,)?)+)\]/i
    end
  end

  #--------------------------------------------------------------------------
  # ○ 敵グループ出現判定
  #     troop : 判定対象の敵グループ
  #     phase : 判定するフェーズ
  #--------------------------------------------------------------------------
  def self.troop_appear?(troop, phase = $game_system.daynight_phase)
    # 出現判定
    unless troop.appear_daynight_phase.empty?
      return false unless troop.appear_daynight_phase.include?(phase)
    end
    # 非出現判定
    unless troop.nonappear_daynight_phase.empty?
      return false if troop.nonappear_daynight_phase.include?(phase)
    end

    return true
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
  # ○ 昼夜切り替えを停止
  #--------------------------------------------------------------------------
  def stop_daynight
    $game_system.daynight_change_enabled = false
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えを起動
  #--------------------------------------------------------------------------
  def start_daynight
    $game_system.daynight_change_enabled = true
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズ名を取得
  #--------------------------------------------------------------------------
  def get_daynight_name
    return KGC::DayNight::PHASE[get_daynight_phase][0]
  end
  #--------------------------------------------------------------------------
  # ○ 現在の曜日を取得
  #     variable_id : 代入する変数 ID
  #--------------------------------------------------------------------------
  def get_daynight_week(variable_id = 0)
    if KGC::DayNight::METHOD == KGC::DayNight::METHOD_RTIME
      week = Time.now.wday
    else
      days = $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE]
      week = (days % KGC::DayNight::WEEK_NAME.size)
    end

    if variable_id > 0
      $game_variables[variable_id] = week
      $game_map.need_refresh = true
    end
    return week
  end
  #--------------------------------------------------------------------------
  # ○ 現在の曜日名を取得
  #--------------------------------------------------------------------------
  def get_daynight_week_name
    return KGC::DayNight::WEEK_NAME[get_daynight_week]
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ切り替え
  #     phase     : 切り替え後のフェーズ
  #     duration  : 切り替え時間(フレーム)
  #     pass_days : 経過させる日数  (省略時: 0)
  #--------------------------------------------------------------------------
  def change_daynight_phase(phase,
      duration = KGC::DayNight::PHASE_DURATION,
      pass_days = 0)
    $game_temp.manual_daynight_duration = duration
    $game_system.daynight_counter = 0
    $game_system.daynight_phase = phase
    $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE] += pass_days
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 次のフェーズへ遷移
  #     duration : 切り替え時間(フレーム)
  #--------------------------------------------------------------------------
  def transit_daynight_phase(duration = KGC::DayNight::PHASE_DURATION)
    $game_map.screen.transit_daynight_phase(duration)
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ デフォルトの色調に戻す
  #     duration : 切り替え時間(フレーム)
  #--------------------------------------------------------------------------
  def set_daynight_default(duration = KGC::DayNight::PHASE_DURATION)
    $game_map.screen.set_daynight_default(duration)
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを復元
  #     duration : 切り替え時間(フレーム)
  #--------------------------------------------------------------------------
  def restore_daynight_phase(duration = KGC::DayNight::PHASE_DURATION)
    $game_map.screen.restore_daynight_phase(duration)
    $game_map.need_refresh = true
  end
end
end

class Game_Interpreter
  include KGC::Commands
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::MapInfo
#==============================================================================

class RPG::MapInfo
  #--------------------------------------------------------------------------
  # ● マップ名取得
  #--------------------------------------------------------------------------
  def name
    return @name.gsub(/\[.*\]/) { "" }
  end
  #--------------------------------------------------------------------------
  # ○ オリジナルマップ名取得
  #--------------------------------------------------------------------------
  def original_name
    return @name
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替え停止
  #--------------------------------------------------------------------------
  def daynight_stop
    return @name =~ KGC::DayNight::Regexp::MapInfo::DAYNIGHT_STOP
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜エフェクト無効
  #--------------------------------------------------------------------------
  def daynight_void
    return @name =~ KGC::DayNight::Regexp::MapInfo::DAYNIGHT_VOID
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Area
#==============================================================================

unless $@
class RPG::Area
  #--------------------------------------------------------------------------
  # ○ エンカウントリストの取得
  #--------------------------------------------------------------------------
  alias encounter_list_KGC_DayNight encounter_list
  def encounter_list
    list = encounter_list_KGC_DayNight.clone

    # 出現条件判定
    list.each_index { |i|
      list[i] = nil unless KGC::DayNight.troop_appear?($data_troops[list[i]])
    }
    return list.compact
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Troop
#==============================================================================

class RPG::Troop
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えのキャッシュ生成
  #--------------------------------------------------------------------------
  def create_daynight_cache
    @__appear_daynight_phase = []
    @__nonappear_daynight_phase = []

    # 出現するフェーズ
    if @name =~ KGC::DayNight::Regexp::Troop::APPEAR_PHASE
      $1.scan(/[\-]?\d+/).each { |num|
        phase = num.to_i
        if phase < 0
          # 出現しない
          @__nonappear_daynight_phase << phase.abs
        else
          # 出現する
          @__appear_daynight_phase << phase
        end
      }
    end
  end
  #--------------------------------------------------------------------------
  # ○ 出現するフェーズ
  #--------------------------------------------------------------------------
  def appear_daynight_phase
    create_daynight_cache if @__appear_daynight_phase == nil
    return @__appear_daynight_phase
  end
  #--------------------------------------------------------------------------
  # ○ 出現しないフェーズ
  #--------------------------------------------------------------------------
  def nonappear_daynight_phase
    create_daynight_cache if @__nonappear_daynight_phase == nil
    return @__nonappear_daynight_phase
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
  attr_accessor :manual_daynight_duration # 手動フェーズ変更フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_DayNight initialize
  def initialize
    initialize_KGC_DayNight

    @manual_daynight_duration = nil
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_writer   :daynight_counter         # フェーズ遷移カウンタ
  attr_writer   :daynight_change_enabled  # 昼夜切り替え有効
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_DayNight initialize
  def initialize
    initialize_KGC_DayNight

    @daynight_counter = 0
    @daynight_change_enabled = true
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ遷移カウンタを取得
  #--------------------------------------------------------------------------
  def daynight_counter
    @daynight_counter = 0 if @daynight_counter == nil
    return @daynight_counter
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを取得
  #--------------------------------------------------------------------------
  def daynight_phase
    return $game_variables[KGC::DayNight::PHASE_VARIABLE]
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを変更
  #--------------------------------------------------------------------------
  def daynight_phase=(value)
    $game_variables[KGC::DayNight::PHASE_VARIABLE] = value
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替え有効フラグを取得
  #--------------------------------------------------------------------------
  def daynight_change_enabled
    @daynight_change_enabled = 0 if @daynight_change_enabled == nil
    return @daynight_change_enabled
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ進行
  #--------------------------------------------------------------------------
  def progress_daynight_phase
    self.daynight_phase += 1
    if self.daynight_phase >= KGC::DayNight::PHASE.size
      self.daynight_phase = 0
    end
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズオブジェクトを取得
  #--------------------------------------------------------------------------
  def daynight_phase_object
    return KGC::DayNight::PHASE[daynight_phase]
  end
  #--------------------------------------------------------------------------
  # ○ 以前のフェーズオブジェクトを取得
  #--------------------------------------------------------------------------
  def previous_daynight_phase_object
    return KGC::DayNight::PHASE[daynight_phase - 1]
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Screen
#==============================================================================

class Game_Screen
  DEFAULT_TONE = Tone.new(0, 0, 0)
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :daynight_tone            # 昼夜の色調
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  alias clear_KGC_DayNight clear
  def clear
    clear_KGC_DayNight

    clear_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替え用変数をクリア
  #--------------------------------------------------------------------------
  def clear_daynight
    @daynight_tone = DEFAULT_TONE.clone
    @daynight_x = 0
    @daynight_y = 0

    @frame_count = Graphics.frame_count
    @daynight_tone_duration = 0

    apply_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜の色調を適用
  #--------------------------------------------------------------------------
  def apply_daynight
    return if $game_map == nil
    if $game_temp.in_battle
      if KGC::DayNight::BG_TONE_IN_BATTLE == KGC::DayNight::BATTLE_TONE_NONE
        return
      end
    end

    # 切り替えを無効化するマップの場合
    if $game_map.daynight_void?
      if @daynight_tone_changed
        # 初期の色調に戻す
        @tone = DEFAULT_TONE.clone
        @daynight_tone_changed = false
      end
      @daynight_tone = @tone.clone
      return
    end

    # フェーズがおかしければ修復
    if $game_system.daynight_phase_object == nil
      $game_system.daynight_phase = 0
    end

    # 現在の色調を適用
    @tone = $game_system.daynight_phase_object[1].clone
    @daynight_tone = @tone.clone

    # 現実時間遷移の場合
    if KGC::DayNight::METHOD == KGC::DayNight::METHOD_RTIME
      time = Time.now
      # マッチするフェーズに遷移
      KGC::DayNight::PHASE.each_with_index { |phase, i|
        if phase[2] <= time.hour
          start_tone_change(phase[1], 1)
          $game_system.daynight_phase = i
          break
        end
      }
    end

    @daynight_tone_changed = true
  end
  #--------------------------------------------------------------------------
  # ○ 色調の取得
  #--------------------------------------------------------------------------
  def tone
    if $game_temp.in_battle
      if KGC::DayNight::BG_TONE_IN_BATTLE <= KGC::DayNight::BATTLE_TONE_BG
        return DEFAULT_TONE
      end
    end
    return @tone
  end
  #--------------------------------------------------------------------------
  # ● 色調変更の開始
  #     tone     : 色調
  #     duration : 時間
  #--------------------------------------------------------------------------
  alias start_tone_change_KGC_DayNight start_tone_change
  def start_tone_change(tone, duration)
    duration = [duration, 1].max
    start_tone_change_KGC_DayNight(tone, duration)

    @daynight_tone_target   = tone.clone
    @daynight_tone_duration = duration
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_DayNight update
  def update
    update_KGC_DayNight

    update_daynight_transit
  end
  #--------------------------------------------------------------------------
  # ● 色調の更新
  #--------------------------------------------------------------------------
  alias update_tone_KGC_DayNight update_tone
  def update_tone
    update_tone_KGC_DayNight

    if @daynight_tone_duration >= 1
      d = @daynight_tone_duration
      target = @daynight_tone_target
      @daynight_tone.red   = (@daynight_tone.red   * (d - 1) + target.red)   / d
      @daynight_tone.green = (@daynight_tone.green * (d - 1) + target.green) / d
      @daynight_tone.blue  = (@daynight_tone.blue  * (d - 1) + target.blue)  / d
      @daynight_tone.gray  = (@daynight_tone.gray  * (d - 1) + target.gray)  / d
      @daynight_tone_duration -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ フェーズ遷移の更新
  #--------------------------------------------------------------------------
  def update_daynight_transit
    # 手動切り替えが行われた場合
    if $game_temp.manual_daynight_duration
      start_tone_change($game_system.daynight_phase_object[1],
        $game_temp.manual_daynight_duration)
      $game_temp.manual_daynight_duration = nil
      @daynight_tone_changed = true
    end

    return unless $game_system.daynight_change_enabled  # 切り替えを
    return if $game_map.daynight_stop?                  # 停止中

    if KGC::DayNight::STOP_ON_EVENT
      interpreter = ($game_temp.in_battle ? $game_troop.interpreter :
        $game_map.interpreter)
      return if interpreter.running?                    # イベント実行中
    end

    case KGC::DayNight::METHOD
    when KGC::DayNight::METHOD_TIME   # 時間
      update_daynight_pass_time
    when KGC::DayNight::METHOD_STEP   # 歩数
      update_daynight_step
    when KGC::DayNight::METHOD_RTIME  # 現実時間
      update_daynight_real_time
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 時間経過
  #--------------------------------------------------------------------------
  def update_daynight_pass_time
    # カウント増加量計算
    inc_count = Graphics.frame_count - @frame_count
    # 加算量がおかしい場合は戻る
    if inc_count >= 100
      @frame_count = Graphics.frame_count
      return
    end
    # カウント加算
    $game_system.daynight_counter += inc_count
    @frame_count = Graphics.frame_count

    # 状態遷移判定
    count = $game_system.daynight_counter / Graphics.frame_rate
    if count >= $game_system.daynight_phase_object[2]
      transit_daynight_phase
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 歩数
  #--------------------------------------------------------------------------
  def update_daynight_step
    # 移動していなければ戻る
    return if @daynight_x == $game_player.x && @daynight_y == $game_player.y

    @daynight_x = $game_player.x
    @daynight_y = $game_player.y
    # カウント加算
    $game_system.daynight_counter += 1
    # 状態遷移判定
    count = $game_system.daynight_counter
    if count >= $game_system.daynight_phase_object[2]
      transit_daynight_phase
    end
  end
  #--------------------------------------------------------------------------
  # ○ 遷移 : 現実時間
  #--------------------------------------------------------------------------
  def update_daynight_real_time
    time = Time.now
    # 状態遷移判定
    time1 = $game_system.daynight_phase_object[2]
    transit = (time1 <= time.hour)
    if $game_system.previous_daynight_phase_object != nil
      time2 = $game_system.previous_daynight_phase_object[2]
      if time1 < time2
        transit &= (time.hour < time2)
      end
    end

    if transit
      transit_daynight_phase
    end
  end
  #--------------------------------------------------------------------------
  # ○ 次の状態へ遷移
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def transit_daynight_phase(duration = KGC::DayNight::PHASE_DURATION)
    $game_system.daynight_counter = 0
    $game_system.progress_daynight_phase
    # 日数経過判定
    if $game_system.daynight_phase == KGC::DayNight::PASS_DAY_PHASE
      $game_variables[KGC::DayNight::PASS_DAYS_VARIABLE] += 1
    end
    # 色調切り替え
    start_tone_change($game_system.daynight_phase_object[1], duration)
    @daynight_tone_changed = true
  end
  #--------------------------------------------------------------------------
  # ○ デフォルトの状態(0, 0, 0)に戻す
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def set_daynight_default(duration)
    start_tone_change(DEFAULT_TONE, duration)
  end
  #--------------------------------------------------------------------------
  # ○ 現在のフェーズを復元
  #     duration : 遷移時間
  #--------------------------------------------------------------------------
  def restore_daynight_phase(duration)
    start_tone_change($game_system.daynight_phase_object[1], duration)
    @daynight_tone_changed = true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  alias setup_KGC_DayNight setup
  def setup(map_id)
    setup_KGC_DayNight(map_id)

    @screen.apply_daynight
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えを停止するか
  #--------------------------------------------------------------------------
  def daynight_stop?
    info = $data_mapinfos[map_id]
    return false if info == nil
    return (info.daynight_stop || info.daynight_void)
  end
  #--------------------------------------------------------------------------
  # ○ 昼夜切り替えが無効か
  #--------------------------------------------------------------------------
  def daynight_void?
    info = $data_mapinfos[map_id]
    return false if info == nil
    return info.daynight_void
  end
  #--------------------------------------------------------------------------
  # ● エンカウントリストの取得
  #--------------------------------------------------------------------------
  alias encounter_list_KGC_DayNight encounter_list
  def encounter_list
    list = encounter_list_KGC_DayNight.clone

    # 出現条件判定
    list.each_index { |i|
      list[i] = nil unless KGC::DayNight.troop_appear?($data_troops[list[i]])
    }
    return list.compact
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Character
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ○ 発光するか
  #--------------------------------------------------------------------------
  def luminous?
    return false
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Event
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ○ 発光するか
  #--------------------------------------------------------------------------
  def luminous?
    return (@event.name =~ KGC::DayNight::Regexp::Event::LUMINOUS)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  alias create_viewports_KGC_DayNight create_viewports
  def create_viewports
    create_viewports_KGC_DayNight

    @viewport1_2 = Viewport.new(0, 0,
      @viewport1.rect.width, @viewport1.rect.height)
  end
  #--------------------------------------------------------------------------
  # ● キャラクタースプライトの作成
  #--------------------------------------------------------------------------
  alias create_characters_KGC_DayNight create_characters
  def create_characters
    create_characters_KGC_DayNight

    # 発光オブジェクトを @viewport1_2 に移動
    @character_sprites.each { |sprite|
      sprite.viewport = @viewport1_2 if sprite.character.luminous?
    }
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放
  #--------------------------------------------------------------------------
  alias dispose_viewports_KGC_DayNight dispose_viewports
  def dispose_viewports
    dispose_viewports_KGC_DayNight

    @viewport1_2.dispose
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの更新
  #--------------------------------------------------------------------------
  alias update_viewports_KGC_DayNight update_viewports
  def update_viewports
    update_viewports_KGC_DayNight

    @viewport1_2.ox = $game_map.screen.shake
    @viewport1_2.update
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

if KGC::DayNight::BG_TONE_IN_BATTLE == KGC::DayNight::BATTLE_TONE_BG

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● バトルバックスプライトの作成
  #--------------------------------------------------------------------------
  alias create_battleback_KGC_DayNight create_battleback
  def create_battleback
    create_battleback_KGC_DayNight

    if @battleback_sprite.wave_amp == 0
      @battleback_sprite.tone = $game_troop.screen.daynight_tone
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの作成
  #--------------------------------------------------------------------------
  alias create_battlefloor_KGC_DayNight create_battlefloor
  def create_battlefloor
    create_battlefloor_KGC_DayNight

    @battlefloor_sprite.tone = $game_troop.screen.daynight_tone
  end
end

end  # <== if KGC::DayNight::BG_TONE_IN_BATTLE == KGC::DayNight::BATTLE_TONE_BG

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_DayNight start
  def start
    $game_map.screen.clear_daynight

    start_KGC_DayNight
  end
end
