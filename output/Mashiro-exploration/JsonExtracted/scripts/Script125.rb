#
#    アクターと敵キャラの複数回行動(RGSS2)
#　　(C)2008 TYPE74RX-T
#

#--------------------------------------------------------------------------
# ★ システムワードの登録：行動回数・連続スキル
#--------------------------------------------------------------------------
module RPG
  class BaseItem
    alias rx_rgss2b13_rx_extract_sys_str_from_note rx_extract_sys_str_from_note
    def rx_extract_sys_str_from_note
      rx_get_sys = RX_T.get_system_word_in_note(@note, "行動回数", true)
      unless rx_get_sys == ""
        @@rx_copy_str += rx_get_sys
        @note = @note.sub(rx_get_sys, "")
        @note = @note.sub("\r\n", "")
      end
      @rx_sys_str = @@rx_copy_str
      rx_get_sys = RX_T.get_system_word_in_note(@note, "連続スキル")
      unless rx_get_sys == ""
        @@rx_copy_str += rx_get_sys
        @note = @note.sub(rx_get_sys, "")
        @note = @note.sub("\r\n", "")
      end
      @rx_sys_str = @@rx_copy_str
      # メソッドを呼び戻す
      rx_rgss2b13_rx_extract_sys_str_from_note
    end
  end
end
#--------------------------------------------------------------------------
# ★ システムワードの登録：行動回数・連続スキル
#--------------------------------------------------------------------------
module RPG
  class State
    alias rx_rgss2b13_rx_extract_sys_str_from_note rx_extract_sys_str_from_note
    def rx_extract_sys_str_from_note
      rx_get_sys = RX_T.get_system_word_in_note(@note, "行動回数", true)
      unless rx_get_sys == ""
        @@rx_copy_str += rx_get_sys
        @note = @note.sub(rx_get_sys, "")
        @note = @note.sub("\r\n", "")
      end
      @rx_sys_str = @@rx_copy_str
      rx_get_sys = RX_T.get_system_word_in_note(@note, "連続スキル")
      unless rx_get_sys == ""
        @@rx_copy_str += rx_get_sys
        @note = @note.sub(rx_get_sys, "")
        @note = @note.sub("\r\n", "")
      end
      @rx_sys_str = @@rx_copy_str
      # メソッドを呼び戻す
      rx_rgss2b13_rx_extract_sys_str_from_note
    end
  end
end
#--------------------------------------------------------------------------
# ★ システムワードの登録：行動回数
#--------------------------------------------------------------------------
module RPG
  class Enemy
    alias rx_rgss2b13_rx_extract_sys_str_from_note rx_extract_sys_str_from_note
    def rx_extract_sys_str_from_note
      rx_get_sys = RX_T.get_system_word_in_note(@note, "行動回数", true)
      unless rx_get_sys == ""
        @@rx_copy_str += rx_get_sys
        @note = @note.sub(rx_get_sys, "")
        @note = @note.sub("\r\n", "")
      end
      @rx_sys_str = @@rx_copy_str
      # メソッドを呼び戻す
      rx_rgss2b13_rx_extract_sys_str_from_note
    end
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :rx_current_actions       # ★ 行動回数（ステート用）
  attr_accessor :rx_max_act_times         # ★ 最大行動回数
  attr_accessor :rx_current_skills        # ★ 連続スキル可能フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_initialize initialize
  def initialize
    # メソッドを呼び戻す
    rx_rgss2b13_initialize
    # ★ 上から行動回数（ステート）、最大行動回数、連続スキル可能フラグ
    @rx_max_act_times = 1
    @rx_current_actions = 1
    @rx_current_skills = false
  end
  #--------------------------------------------------------------------------
  # ★ 行動回数の取得（ステート・装備物の中で最大のものを選ぶ）
  #--------------------------------------------------------------------------
  def rx_get_act_times
    @rx_max_act_times = 0
    a = 0
    b = 0
    # 装備物から行動回数を取得
    if actor?
      a = RX_T.get_numeric_of_system_word_in_equip(rx_sys_str, "行動回数")
    else
      a = RX_T.get_numeric_of_system_word_in_sys_str($data_enemies[@enemy_id], "行動回数")
    end
    # ステートから行動回数を取得
    b = @rx_current_actions
    # どちらか多い方を採用
    @rx_max_act_times = (a < b ? b : a)
    return @rx_max_act_times
  end
  #--------------------------------------------------------------------------
  # ★ 連続スキル可能フラグ
  #--------------------------------------------------------------------------
  def rx_current_skills
    return true if @rx_current_skills
    @rx_current_skills = RX_T.check_system_word_in_equip(rx_sys_str, "連続スキル")
    return @rx_current_skills
  end
  #--------------------------------------------------------------------------
  # ★ 暴走・混乱のいずれかになっているか
  #--------------------------------------------------------------------------
  def rx_go_go_attack?
    return (self.berserker? or self.confusion?)
  end
  #--------------------------------------------------------------------------
  # ★ 行動回数増加判定
  #--------------------------------------------------------------------------
  def get_rx_current_actions
    @rx_current_actions = 0
    for state in states
      # ステートごとに行動回数を取得
      rx_get = RX_T.get_numeric_of_system_word_in_equip(state.rx_sys_str, "行動回数")
      # 取得した行動回数が現在値よりも大きければ
      if rx_get > @rx_current_actions
        # 行動回数を代入
        @rx_current_actions = rx_get
      end
    end
    return @rx_current_actions
  end
  #--------------------------------------------------------------------------
  # ★ 連続スキル攻撃判定
  #--------------------------------------------------------------------------
  def get_rx_current_skills
    @rx_current_skills = false
    for state in states
      @rx_current_skills = true if state.rx_sys_str.include?("連続スキル")
    end
    return @rx_current_skills
  end
  #--------------------------------------------------------------------------
  # ● 制約の取得
  #    現在付加されているステートから最大の restriction を取得する。
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_restriction restriction
  def restriction
    # ★ 行動回数増加判定
    get_rx_current_actions
    # ★ 連続スキル攻撃判定
    get_rx_current_skills
    # メソッドを呼び戻す
    rx_rgss2b13_restriction
  end
end

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス ($game_actors)
# の内部で使用され、Game_Party クラス ($game_party) からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :rx_actions               # ★ 行動内容（連続行動用）
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_setup setup
  def setup(actor_id)
    # メソッドを呼び戻す
    rx_rgss2b13_setup(actor_id)
    # ★ 行動内容（連続行動用）
    @rx_actions = []
  end
  #--------------------------------------------------------------------------
  # ★ アクターの行動を記録
  #--------------------------------------------------------------------------
  def rx_write_action
    @rx_actions.push(@action.dup)
  end
  #--------------------------------------------------------------------------
  # ★ アクターの行動を読み出す
  #--------------------------------------------------------------------------
  def rx_read_action(n)
    if @rx_actions[n] == nil
      # 突然行動回数が増えた時のバグ回避
      @action = Game_BattleAction.new(self)
      @action.kind = -1
      return
    end
    @action = @rx_actions[n]
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 次のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_next_actor next_actor
  def next_actor
    # ★ 連続スキル可能フラグを初期化
    @rx_current_skill = false
    # ★ 行動者情報が入っていて、行動を終えている（行動回数が 0 である）か
    if @rx_act_times < 1 and @active_battler != nil
      # 行動内容を初期化
      $game_party.members[@actor_index].rx_actions = []
      # 行動者の最大行動回数情報を取得
      @rx_act_times = $game_party.members[@actor_index].rx_get_act_times
    end
    # ★ １行動を終えているか
    if @actor_index != -1
      # 行動回数を減らす
      @rx_act_times -= 1
      # 連続スキル可能フラグがある時にスキル以外の行動をしたら
      if @active_battler.action.kind != 1 and @active_battler.rx_current_skills
        # 複数回行動を不能化
        @rx_act_times = 0
      end
      # まだ行動回数が残っている（残り行動回数が 1 以上）ならindexを次に送らない
      if @rx_act_times > 0
        @actor_index -= 1
        # アクターの連続スキル可能フラグがＯＮならこちらの同フラグをＯＮに
        @rx_current_skill = true if @active_battler.rx_current_skills
        # 連続スキル可能状態で、初回の行動にスキルを選ばなかった場合次に送る
        if @active_battler.rx_current_skills and
          not @actor_command_window.index == 1
          # 連続行動が可能な残り数だけ行動を無効化（１回行動のみとする）
          for i in 0...300
            # 連続行動の初回の行動が既に決まっている（連続行動の２度目以降）なら
            unless @active_battler.rx_get_act_times - @rx_act_times == 1
              # 行動を無効に
              @active_battler.action.kind = -1
            end
            # 行動内容を記録
            @active_battler.rx_write_action
            # 行動回数を減らす
            @rx_act_times -= 1
            # 連続スキル可能フラグをＯＦＦに
            @rx_current_skill = false
            # 行動回数が 0 なら 処理終了
            break if @rx_act_times < 1
          end
          @actor_index += 1
        end
      end
      # 行動内容を記録
      @active_battler.rx_write_action
    end
    # メソッドを呼び戻す
    rx_rgss2b13_next_actor
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_prior_actor prior_actor
  def prior_actor
    # ★ 行動内容を初期化
    $game_party.members[@actor_index - 1].rx_actions = []
    # ★ 行動者の最大行動回数を再取得し、連続スキル可能フラグを初期化
    @rx_act_times = $game_party.members[@actor_index - 1].rx_get_act_times
    @rx_current_skill = false
    # メソッドを呼び戻す
    rx_rgss2b13_prior_actor
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_start_party_command_selection start_party_command_selection
  def start_party_command_selection
    # ★ 行動回数を初期化
    @rx_act_times = 0
    # メソッドを呼び戻す
    rx_rgss2b13_start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の開始
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_start_actor_command_selection start_actor_command_selection
  def start_actor_command_selection
    # メソッドを呼び戻す
    rx_rgss2b13_start_actor_command_selection
    # ★ 連続スキル可能フラグがＯＮならスキル以外のコマンドを半透明表示する
    if @rx_current_skill
      @actor_command_window.draw_item(0, false)
      @actor_command_window.draw_item(2, false)
      @actor_command_window.draw_item(3, false)
    else
      @actor_command_window.draw_item(0, true)
      @actor_command_window.draw_item(2, true)
      @actor_command_window.draw_item(3, true)
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の更新
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_update_actor_command_selection update_actor_command_selection
  def update_actor_command_selection
    # ★ 連続スキル可能フラグがＯＮなら専用アクターコマンド画面に
    return rx_update_actor_command_selection if @rx_current_skill
    # メソッドを呼び戻す
    rx_rgss2b13_update_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の更新（連続スキル用）
  #--------------------------------------------------------------------------
  def rx_update_actor_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      prior_actor
    elsif Input.trigger?(Input::C)
      if @actor_command_window.index == 1
        Sound.play_decision
        start_skill_selection
      else
        Sound.play_buzzer
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行
  #--------------------------------------------------------------------------
  alias rx_rgss2b13_execute_action execute_action
  def execute_action
    # ★ 行動回数を初期化
    @rx_attack_times = 0 if @rx_attack_times == nil
    # ★ 行動者がアクターで、存在しているか
    if @active_battler.exist? and @active_battler.actor? and
      not @active_battler.berserker? and
      not @active_battler.confusion?
      # 自動戦闘キャラなら新しくアクションを自動作成
      if @active_battler.auto_battle
        @active_battler.make_action
      else
        # 新しく行動内容を作成
        @active_battler.rx_read_action(@rx_attack_times)
      end
    end
    # ★ アイテムや MP が足りないなどで使用不可能なら行動をスキップ
    unless @active_battler.action.valid?
      @active_battler.action.kind = 0
      @active_battler.action.basic = 4 # ０～３の範囲外なら処理がSKIPされる
    end
    # メソッドを呼び戻す
    rx_rgss2b13_execute_action
    # ★ 行動回数をカウント
    @rx_attack_times += 1
    # ★ 行動者がアクターでなく、存在しているか
    if @active_battler.exist? and not @active_battler.actor?
      # 行動回数が最大行動回数より小さければ
      if @rx_attack_times < @active_battler.rx_get_act_times
        # 前回行動分のコモンイベント呼び出し
        process_battle_event
        @message_window.clear
        # 新しく行動内容を作成
        @active_battler.make_action
        # 暴走か混乱なら通常攻撃に切り替え
        @active_battler.action.prepare
        # 戦闘行動の再実行
        execute_action
      end
    end
    # ★ 行動者がアクターで、存在しているか
    if @active_battler.exist? and @active_battler.actor? and not $game_troop.all_dead?
      # 行動者が連続スキル使用可能で混乱または暴走している場合
      if @active_battler.rx_current_skills and @active_battler.rx_go_go_attack?
        # 行動回数を最大行動回数と同じにし、一回攻撃のみとする
        @rx_attack_times = @active_battler.rx_get_act_times
      end
      # 行動回数が最大行動回数より小さければ
      if @rx_attack_times < @active_battler.rx_get_act_times
        # 前回行動分のコモンイベント呼び出し
        process_battle_event
        @message_window.clear
        # 戦闘行動の再実行
        execute_action
      end
    end
    # ★ 行動回数を初期化する
    @rx_attack_times = nil
  end
end