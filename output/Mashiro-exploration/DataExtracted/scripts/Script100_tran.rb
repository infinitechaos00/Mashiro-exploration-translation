#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 多人数パーティ - KGC_LargeParty ◆ VX ◆
#_/    ◇ Last update : 2009/11/01 ◇
#_/----------------------------------------------------------------------------
#_/  ５人以上の大規模パーティを構築可能にします。
#_/============================================================================
#_/ 【特殊システム】≪パーティ編成画面２≫ より上に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize BEGIN ★
#==============================================================================

module KGC
module LargeParty
  # ◆ パーティ編成許可を表すスイッチ番号
  #  このスイッチの ON/OFF でパーティ編成の 許可/不許可 を切り替えます。
  PARTYFORM_SWITCH          = 511
  # ◆ 戦闘中のパーティ編成許可を表すスイッチ番号
  #  ↑と異なる番号を指定すると、戦闘中のみの入れ替え可否を設定できます。
  BATTLE_PARTYFORM_SWITCH   = 511
  # ◆ デフォルトの編成許可フラグ
  #  true にすると、「ニューゲーム」選択時に両方のパーティ編成許可スイッチが
  #  自動的に ON になります。
  DEFAULT_PARTYFORM_ENABLED = true

  # ◆ 戦闘メンバー最大数 (デフォルト値)
  #  5 以上にすると、戦闘画面のステータスがやや見辛くなります。
  MAX_BATTLE_MEMBERS = 4
  # ◆ パーティメンバー最大数
  #  Game_Party::MAX_MEMBERS を上書きします。
  #  100 以上にすると [Window_MenuStatus] がバグります。
  MAX_MEMBERS = 5

  # ◆ 固定メンバーの並び替えを禁止
  #  スクリプトからの操作以外では並び替えできなくなります。
  FORBID_CHANGE_SHIFT_FIXED = true

  # ◆ 待機メンバーの背景色
  #  色を変えない場合は  Color.new(0, 0, 0, 0)
  STAND_BY_COLOR = Color.new(0, 0, 0, 128)
  # ◆ 固定メンバーの背景色
  FIXED_COLOR    = Color.new(255, 128, 64, 96)
  # ◆ 並び替え時の背景色
  SELECTED_COLOR = Color.new(64, 255, 128, 128)

  # ◆ パーティ編成ボタン (メニュー画面用)
  #  メニュー画面でこのボタンを押すと、パーティ編成画面に移行します。
  #  使用しない場合は nil
  MENU_PARTYFORM_BUTTON      = Input::A
  # ◆ メニュー画面にパーティ編成コマンドを追加する
  #  追加する場所は、メニューコマンドの最下部です。
  #  他の部分に追加したければ、≪カスタムメニューコマンド≫ をご利用ください。
  USE_MENU_PARTYFORM_COMMAND = false
  # ◆ メニュー画面のパーティ編成コマンドの名称
  VOCAB_MENU_PARTYFORM       = "パーティ編成"

  # ◆ 戦闘中にパーティ編成コマンドを使用する
  #  追加する場所は、パーティコマンドの最下部（「逃げる」の下）です。
  USE_BATTLE_PARTYFORM   = false
  # ◆ 戦闘中のパーティ編成コマンドの名称
  VOCAB_BATTLE_PARTYFORM = "入れ替え"

  # ◆ 全滅時の自動出撃を使用する
  #   true  : 入れ替え可能なら生存者が出撃 (戦闘中の編成を許可する必要あり)
  #   false : 全滅したら終了
  ENABLE_DEFEAT_LAUNCH  = false
  # ◆ 全滅時の入れ替えメッセージ
  #  %s : 出撃者名
  DEFEAT_LAUNCH_MESSAGE = "%sが飛び出した！"

  # ◆ 編成画面のキャラクター描画サイズ [幅, 高さ]
  #  アクターの歩行グラフィックのサイズに応じて書き換えてください。
  PARTY_FORM_CHARACTER_SIZE   = [40, 48]
  # ◆ 編成画面の戦闘メンバーウィンドウの空欄に表示するテキスト
  BATTLE_MEMBER_BLANK_TEXT    = "EMPTY"
  # ◆ 編成画面のパーティメンバーウィンドウの最大行数
  #  ステータスウィンドウが画面からはみ出る場合は、
  #  この値を 1 にしてください。
  PARTY_MEMBER_WINDOW_ROW_MAX = 2
  # ◆ 編成画面のパーティメンバーウィンドウに戦闘メンバーを表示する
  SHOW_BATTLE_MEMBER_IN_PARTY = false
  # ◆ 編成画面のパーティメンバーウィンドウの空欄に表示するテキスト
  PARTY_MEMBER_BLANK_TEXT     = "－"

  # ◆ 編成画面のキャプションウィンドウの幅
  CAPTION_WINDOW_WIDTH  = 192
  # ◆ 編成画面の戦闘メンバーウィンドウのキャプション
  BATTLE_MEMBER_CAPTION = "戦闘メンバー"

  if SHOW_BATTLE_MEMBER_IN_PARTY
    # ◆ 編成画面のパーティメンバーウィンドウのキャプション
    #  SHOW_BATTLE_MEMBER_IN_PARTY = true のとき
    PARTY_MEMBER_CAPTION = "パーティメンバー"
  else
    # ◆ 編成画面のパーティメンバーウィンドウのキャプション
    #  SHOW_BATTLE_MEMBER_IN_PARTY = false のとき
    PARTY_MEMBER_CAPTION = "待機メンバー"
  end

  # ◆ 編成確認ウィンドウの幅
  CONFIRM_WINDOW_WIDTH    = 160
  # ◆ 編成確認ウィンドウの文字列
  #  ※コマンド数・順番を変更するとバグります。
  CONFIRM_WINDOW_COMMANDS = ["編成完了", "編成中止", "キャンセル"]

  # ◆ ショップ画面のステータスウィンドウスクロール時に使用するボタン
  #  このボタンを押している間、上下ボタンでスクロールできます。
  #  スクロールを無効にする場合は nil を指定。
  #  ≪ヘルプウィンドウ機能拡張≫ 併用時は、上に導入したものを優先。
  SHOP_STATUS_SCROLL_BUTTON = Input::A

  # ◆ 待機メンバー獲得経験値割合【単位：‰(千分率 1‰＝0.1％)】
  #  500 なら 50.0％ です。
  STAND_BY_EXP_RATE = 500
  # ◆ リザルト画面で待機メンバーのレベルアップを表示する
  #  true  : 待機メンバーのレベルアップを表示。
  #  false : 戦闘メンバーのみ表示。
  SHOW_STAND_BY_LEVEL_UP = false
  # ◆ 戦闘以外でも待機メンバーを表示する
  #  true  : 戦闘以外では常に全員を表示。
  #  false : 入れ替え時以外は、待機メンバーをいないものとして扱う。
  SHOW_STAND_BY_MEMBER_NOT_IN_BATTLE = false
end
end

#==============================================================================
# ☆ カスタマイズ項目終了 - Customize END ☆
#==============================================================================

$imported = {} if $imported == nil
$imported["LargeParty"] = true

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ KGC::Commands
#==============================================================================

module KGC
module Commands
  # メンバーのソート形式
  SORT_BY_ID    = 0  # ID順
  SORT_BY_NAME  = 1  # 名前順
  SORT_BY_LEVEL = 2  # レベル順

  module_function
  #--------------------------------------------------------------------------
  # ○ パーティ編成画面の呼び出し
  #--------------------------------------------------------------------------
  def call_partyform
    return if $game_temp.in_battle
    $game_temp.next_scene = :partyform
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー最大数を設定
  #     value : 人数 (省略した場合はデフォルト値を使用)
  #--------------------------------------------------------------------------
  def set_max_battle_member_count(value = nil)
    $game_party.max_battle_member_count = value
  end
  #--------------------------------------------------------------------------
  # ○ 全メンバー数取得
  #     variable_id : 取得した値を代入する変数の ID
  #--------------------------------------------------------------------------
  def get_all_member_count(variable_id = 0)
    n = $game_party.all_members.size
    if variable_id > 0
      $game_variables[variable_id] = n
      $game_map.need_refresh = true
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー数取得
  #     variable_id : 取得した値を代入する変数の ID
  #--------------------------------------------------------------------------
  def get_battle_member_count(variable_id = 0)
    n = $game_party.battle_members.size
    if variable_id > 0
      $game_variables[variable_id] = n
      $game_map.need_refresh = true
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ 待機メンバー数取得
  #     variable_id : 取得した値を代入する変数の ID
  #--------------------------------------------------------------------------
  def get_stand_by_member_count(variable_id = 0)
    n = $game_party.stand_by_members.size
    if variable_id > 0
      $game_variables[variable_id] = n
      $game_map.need_refresh = true
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ パーティ人数が一杯か
  #--------------------------------------------------------------------------
  def party_full?
    return $game_party.full?
  end
  #--------------------------------------------------------------------------
  # ○ パーティ編成可否を設定
  #     enabled : 有効フラグ (省略時 : true) 
  #--------------------------------------------------------------------------
  def permit_partyform(enabled = true)
    $game_switches[KGC::LargeParty::PARTYFORM_SWITCH] = enabled
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘中のパーティ編成可否を設定
  #     enabled : 有効フラグ (省略時 : true) 
  #--------------------------------------------------------------------------
  def permit_battle_partyform(enabled = true)
    $game_switches[KGC::LargeParty::BATTLE_PARTYFORM_SWITCH] = enabled
  end
  #--------------------------------------------------------------------------
  # ○ アクターの固定状態を設定
  #     actor_id : アクター ID
  #     fixed    : 固定フラグ (省略時 : true) 
  #--------------------------------------------------------------------------
  def fix_actor(actor_id, fixed = true)
    $game_party.fix_actor(actor_id, fixed)
  end
  #--------------------------------------------------------------------------
  # ○ 並び替え
  #    メンバーの index1 番目と index2 番目を入れ替える
  #--------------------------------------------------------------------------
  def change_party_shift(index1, index2)
    $game_party.change_shift(index1, index2)
  end
  #--------------------------------------------------------------------------
  # ○ メンバー整列 (昇順)
  #     sort_type : ソート形式 (SORT_BY_xxx)
  #     reverse   : true だと降順
  #--------------------------------------------------------------------------
  def sort_party_member(sort_type = SORT_BY_ID, reverse = false)
    $game_party.sort_member(sort_type, reverse)
  end
  #--------------------------------------------------------------------------
  # ○ 待機メンバーの ID を取得
  #--------------------------------------------------------------------------
  def get_stand_by_member_ids
    result = []
    $game_party.stand_by_members.each { |actor| result << actor.id }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ アクターが待機メンバーか
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def stand_by_member?(actor_id)
    return get_stand_by_member_ids.include?(actor_id)
  end
  #--------------------------------------------------------------------------
  # ○ アクターを戦闘メンバーに加える
  #     actor_id : アクター ID
  #     index    : 追加位置 (省略時は最後尾)
  #--------------------------------------------------------------------------
  def add_battle_member(actor_id, index = nil)
    $game_party.add_battle_member(actor_id, index)
  end
  #--------------------------------------------------------------------------
  # ○ アクターを戦闘メンバーから外す
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def remove_battle_member(actor_id)
    $game_party.remove_battle_member(actor_id)
  end
  #--------------------------------------------------------------------------
  # ○ 固定アクター以外を戦闘メンバーから外す
  #--------------------------------------------------------------------------
  def remove_all_battle_member
    $game_party.remove_all_battle_member
  end
  #--------------------------------------------------------------------------
  # ○ ランダム出撃
  #--------------------------------------------------------------------------
  def random_launch
    new_battle_members = $game_party.fixed_members
    candidates = $game_party.all_members - new_battle_members
    num = [$game_party.max_battle_member_count - new_battle_members.size,
      candidates.size].min
    return if num <= 0

    # ランダムに選ぶ
    ary = (0...candidates.size).to_a.sort_by { rand }
    ary[0...num].each { |i| new_battle_members << candidates[i] }
    $game_party.set_battle_member(new_battle_members)
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
  # 全滅時の入れ替えメッセージ
  DefeatLaunch = KGC::LargeParty::DEFEAT_LAUNCH_MESSAGE

  # 「パーティ編成」コマンド名 (メニュー)
  def self.partyform
    return KGC::LargeParty::VOCAB_MENU_PARTYFORM
  end

  # 「パーティ編成」コマンド名 (戦闘)
  def self.partyform_battle
    return KGC::LargeParty::VOCAB_BATTLE_PARTYFORM
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Actor
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ○ パーティ内インデックス取得
  #--------------------------------------------------------------------------
  def party_index
    return $game_party.all_members.index(self)
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバーか判定
  #--------------------------------------------------------------------------
  def battle_member?
    return $game_party.battle_members.include?(self)
  end
  #--------------------------------------------------------------------------
  # ○ 固定メンバーか判定
  #--------------------------------------------------------------------------
  def fixed_member?
    return $game_party.fixed_members.include?(self)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  MAX_MEMBERS = KGC::LargeParty::MAX_MEMBERS  # 最大パーティ人数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_LargeParty initialize
  def initialize
    initialize_KGC_LargeParty

    @max_battle_member_count = nil
    @battle_member_count = 0
    @fixed_actors = []
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー最大数取得
  #--------------------------------------------------------------------------
  def max_battle_member_count
    if @max_battle_member_count == nil
      return KGC::LargeParty::MAX_BATTLE_MEMBERS
    else
      return @max_battle_member_count
    end
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー最大数変更
  #--------------------------------------------------------------------------
  def max_battle_member_count=(value)
    if value.is_a?(Integer)
      value = [value, 1].max
    end
    @max_battle_member_count = value
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー数取得
  #--------------------------------------------------------------------------
  def battle_member_count
    if @battle_member_count == nil
      @battle_member_count = @actors.size
    end
    @battle_member_count =
      [@battle_member_count, @actors.size, max_battle_member_count].min
    return @battle_member_count
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー数設定
  #--------------------------------------------------------------------------
  def battle_member_count=(value)
    @battle_member_count = [[value, 0].max,
      @actors.size, max_battle_member_count].min
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得
  #--------------------------------------------------------------------------
  alias members_KGC_LargeParty members
  def members
    if $game_temp.in_battle ||
        !KGC::LargeParty::SHOW_STAND_BY_MEMBER_NOT_IN_BATTLE
      return battle_members
    else
      return members_KGC_LargeParty
    end
  end
  #--------------------------------------------------------------------------
  # ○ 全メンバーの取得
  #--------------------------------------------------------------------------
  def all_members
    return members_KGC_LargeParty
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバーの取得
  #--------------------------------------------------------------------------
  def battle_members
    result = []
    battle_member_count.times { |i| result << $game_actors[@actors[i]] }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ 待機メンバーの取得
  #--------------------------------------------------------------------------
  def stand_by_members
    return (all_members - battle_members)
  end
  #--------------------------------------------------------------------------
  # ○ 固定メンバーの取得
  #--------------------------------------------------------------------------
  def fixed_members
    result = []
    @fixed_actors.each { |i| result << $game_actors[i] }
    return result
  end
  #--------------------------------------------------------------------------
  # ● 初期パーティのセットアップ
  #--------------------------------------------------------------------------
  alias setup_starting_members_KGC_LargeParty setup_starting_members
  def setup_starting_members
    setup_starting_members_KGC_LargeParty

    self.battle_member_count = @actors.size
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト用パーティのセットアップ
  #--------------------------------------------------------------------------
  alias setup_battle_test_members_KGC_LargeParty setup_battle_test_members
  def setup_battle_test_members
    setup_battle_test_members_KGC_LargeParty

    self.battle_member_count = @actors.size
  end
  #--------------------------------------------------------------------------
  # ○ メンバーの新規設定
  #     new_member : 新しいメンバー
  #--------------------------------------------------------------------------
  def set_member(new_member)
    @actors = []
    new_member.each { |actor| @actors << actor.id }
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバーの新規設定
  #     new_member : 新しい戦闘メンバー
  #--------------------------------------------------------------------------
  def set_battle_member(new_member)
    new_battle_member = []
    new_member.each { |actor|
      @actors.delete(actor.id)
      new_battle_member << actor.id
    }
    @actors = new_battle_member + @actors
    self.battle_member_count = new_member.size
  end
  #--------------------------------------------------------------------------
  # ○ パーティ編成を許可しているか判定
  #--------------------------------------------------------------------------
  def partyform_enable?
    return $game_switches[KGC::LargeParty::PARTYFORM_SWITCH]
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘中のパーティ編成を許可しているか判定
  #--------------------------------------------------------------------------
  def battle_partyform_enable?
    return false unless partyform_enable?
    return $game_switches[KGC::LargeParty::BATTLE_PARTYFORM_SWITCH]
  end
  #--------------------------------------------------------------------------
  # ○ メンバーが一杯か判定
  #--------------------------------------------------------------------------
  def full?
    return (@actors.size >= MAX_MEMBERS)
  end
  #--------------------------------------------------------------------------
  # ○ 出撃中か判定
  #     actor_id : 判定するアクターの ID
  #--------------------------------------------------------------------------
  def actor_launched?(actor_id)
    return battle_members.include?($game_actors[actor_id])
  end
  #--------------------------------------------------------------------------
  # ○ 固定アクターか判定
  #     actor_id : 判定するアクターの ID
  #--------------------------------------------------------------------------
  def actor_fixed?(actor_id)
    return @fixed_actors.include?(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● アクターを加える
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  alias add_actor_KGC_LargeParty add_actor
  def add_actor(actor_id)
    last_size = @actors.size

    add_actor_KGC_LargeParty(actor_id)

    if last_size < @actors.size
      self.battle_member_count += 1
    end
  end
  #--------------------------------------------------------------------------
  # ○ アクターを戦闘メンバーに加える
  #     actor_id : アクター ID
  #     index    : 追加位置 (省略時は最後尾)
  #--------------------------------------------------------------------------
  def add_battle_member(actor_id, index = nil)
    return unless @actors.include?(actor_id)  # パーティにいない
    if index == nil
      return if battle_members.include?($game_actors[actor_id])  # 出撃済み
      return if battle_member_count == max_battle_member_count   # 人数が最大
      index = battle_member_count
    end

    @actors.delete(actor_id)
    @actors.insert(index, actor_id)
    self.battle_member_count += 1
  end
  #--------------------------------------------------------------------------
  # ○ アクターを戦闘メンバーから外す
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def remove_battle_member(actor_id)
    return unless @actors.include?(actor_id)  # パーティにいない
    return if actor_fixed?(actor_id)          # 固定済み
    return unless actor_launched?(actor_id)   # 待機中

    @actors.delete(actor_id)
    @actors.push(actor_id)
    self.battle_member_count -= 1
  end
  #--------------------------------------------------------------------------
  # ○ アクターの固定状態を設定
  #     actor_id : アクター ID
  #     fixed    : 固定フラグ (省略時 : false) 
  #--------------------------------------------------------------------------
  def fix_actor(actor_id, fixed = false)
    return unless @actors.include?(actor_id)  # パーティにいない

    if fixed
      # 固定
      unless @fixed_actors.include?(actor_id)
        @fixed_actors << actor_id
        unless battle_members.include?($game_actors[actor_id])
          self.battle_member_count += 1
        end
      end
      # 強制出撃
      apply_force_launch
    else
      # 固定解除
      @fixed_actors.delete(actor_id)
    end
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ○ 強制出撃適用
  #--------------------------------------------------------------------------
  def apply_force_launch
    while (fixed_members - battle_members).size > 0
      # 固定状態でないメンバーを適当に持ってきて入れ替え
      actor1 = stand_by_members.find { |a| @fixed_actors.include?(a.id) }
      actor2 = battle_members.reverse.find { |a| !@fixed_actors.include?(a.id) }
      index1 = @actors.index(actor1.id)
      index2 = @actors.index(actor2.id)
      @actors[index1], @actors[index2] = @actors[index2], @actors[index1]

      # 戦闘メンバーが全員固定されたら戻る (無限ループ防止)
      all_fixed = true
      battle_members.each { |actor|
        unless actor.fixed_member?
          all_fixed = false
          break
        end
      }
      break if all_fixed
    end
  end
  #--------------------------------------------------------------------------
  # ○ 固定アクター以外を戦闘メンバーから外す
  #--------------------------------------------------------------------------
  def remove_all_battle_member
    all_members.each { |actor|
      remove_battle_member(actor.id) if actor_launched?(actor.id)
    }
  end
  #--------------------------------------------------------------------------
  # ○ メンバー整列 (昇順)
  #     sort_type : ソート形式 (SORT_BY_xxx)
  #     reverse   : true だと降順
  #--------------------------------------------------------------------------
  def sort_member(sort_type = KGC::Commands::SORT_BY_ID,
                  reverse = false)
    # バッファを準備
    b_actors = battle_members
    actors   = all_members - b_actors
    f_actors = fixed_members
    # 固定キャラはソートしない
    if KGC::LargeParty::FORBID_CHANGE_SHIFT_FIXED
      actors   -= f_actors
      b_actors -= f_actors
    end

    # ソート
    case sort_type
    when KGC::Commands::SORT_BY_ID     # ID順
      actors.sort!   { |a, b| a.id <=> b.id }
      b_actors.sort! { |a, b| a.id <=> b.id }
    when KGC::Commands::SORT_BY_NAME   # 名前順
      actors.sort!   { |a, b| a.name <=> b.name }
      b_actors.sort! { |a, b| a.name <=> b.name }
    when KGC::Commands::SORT_BY_LEVEL  # レベル順
      actors.sort!   { |a, b| a.level <=> b.level }
      b_actors.sort! { |a, b| a.level <=> b.level }
    end
    # 反転
    if reverse
      actors.reverse!
      b_actors.reverse!
    end

    # 固定キャラを先頭に持ってくる
    if KGC::LargeParty::FORBID_CHANGE_SHIFT_FIXED
      actors   = f_actors + actors
      b_actors = f_actors + b_actors
    end

    # 復帰
    set_member(actors)
    set_battle_member(b_actors)

    apply_force_launch
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ○ 並び替え
  #    戦闘メンバーの index1 番目と index2 番目を入れ替える
  #--------------------------------------------------------------------------
  def change_shift(index1, index2)
    size = @actors.size
    if index1 >= size || index2 >= size
      return
    end
    buf = @actors[index1]
    @actors[index1] = @actors[index2]
    @actors[index2] = buf
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ● 戦闘用ステートの解除 (戦闘終了時に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_battle
    (1...$data_actors.size).each { |i|
      $game_actors[i].remove_states_battle
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Command
#==============================================================================

class Window_Command < Window_Selectable
  unless method_defined?(:add_command)
  #--------------------------------------------------------------------------
  # ○ コマンドを追加
  #    追加した位置を返す
  #--------------------------------------------------------------------------
  def add_command(command)
    @commands << command
    @item_max = @commands.size
    item_index = @item_max - 1
    refresh_command
    draw_item(item_index)
    return item_index
  end
  #--------------------------------------------------------------------------
  # ○ コマンドをリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_command
    buf = self.contents.clone
    self.height = [self.height, row_max * WLH + 32].max
    create_contents
    self.contents.blt(0, 0, buf, buf.rect)
    buf.dispose
  end
  #--------------------------------------------------------------------------
  # ○ コマンドを挿入
  #--------------------------------------------------------------------------
  def insert_command(index, command)
    @commands.insert(index, command)
    @item_max = @commands.size
    refresh_command
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ コマンドを削除
  #--------------------------------------------------------------------------
  def remove_command(command)
    @commands.delete(command)
    @item_max = @commands.size
    refresh
  end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_MenuStatus
#==============================================================================

class Window_MenuStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  STATUS_HEIGHT = 96  # ステータス一人分の高さ
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32,
      [height - 32, row_max * STATUS_HEIGHT].max)
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の取得
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / STATUS_HEIGHT
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の設定
  #     row : 先頭に表示する行
  #--------------------------------------------------------------------------
  def top_row=(row)
    super(row)
    self.oy = self.oy / WLH * STATUS_HEIGHT
  end
  #--------------------------------------------------------------------------
  # ● 1 ページに表示できる行数の取得
  #--------------------------------------------------------------------------
  def page_row_max
    return (self.height - 32) / STATUS_HEIGHT
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.height = STATUS_HEIGHT
    rect.y = index / @column_max * STATUS_HEIGHT
    return rect
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_max = $game_party.members.size
    create_contents
    fill_stand_by_background
    draw_member
  end
  #--------------------------------------------------------------------------
  # ○ パーティメンバー描画
  #--------------------------------------------------------------------------
  def draw_member
    for actor in $game_party.members
      draw_actor_face(actor, 2, actor.party_index * 96 + 2, 92)
      x = 104
      y = actor.party_index * 96 + WLH / 2
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 120, y)
      draw_actor_level(actor, x, y + WLH * 1)
      draw_actor_state(actor, x, y + WLH * 2)
      draw_actor_hp(actor, x + 120, y + WLH * 1)
      draw_actor_mp(actor, x + 120, y + WLH * 2)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 待機メンバーの背景色を塗る
  #--------------------------------------------------------------------------
  def fill_stand_by_background
    color = KGC::LargeParty::STAND_BY_COLOR
    dy = STATUS_HEIGHT * $game_party.battle_members.size
    dh = STATUS_HEIGHT * $game_party.stand_by_members.size
    if dh > 0
      self.contents.fill_rect(0, dy, self.width - 32, dh, color)
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    if @index < 0               # カーソルなし
      self.cursor_rect.empty
    elsif @index < @item_max    # 通常
      super
    elsif @index >= 100         # 自分
      self.cursor_rect.set(0, (@index - 100) * STATUS_HEIGHT,
        contents.width, STATUS_HEIGHT)
    else                        # 全体
      self.cursor_rect.set(0, 0, contents.width, @item_max * STATUS_HEIGHT)
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_ShopStatus
#==============================================================================

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32,
      WLH * ($game_party.members.size + 1) * 2)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32,
      [WLH * $game_party.members.size, height - 32].max)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  alias refresh_KGC_LargeParty refresh
  def refresh
    create_contents

    refresh_KGC_LargeParty
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormCaption
#------------------------------------------------------------------------------
# 　パーティ編成画面でウィンドウのキャプションを表示するウィンドウです。
#==============================================================================

class Window_PartyFormCaption < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     caption : 表示するキャプション
  #--------------------------------------------------------------------------
  def initialize(caption = "")
    super(0, 0, KGC::LargeParty::CAPTION_WINDOW_WIDTH, WLH + 32)
    @caption = caption
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(0, 0, width - 32, WLH, @caption)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormMember
#------------------------------------------------------------------------------
# 　パーティ編成画面でメンバーを表示するウィンドウです。
#==============================================================================

class Window_PartyFormMember < Window_Selectable
  #--------------------------------------------------------------------------
  # ○ 定数
  #--------------------------------------------------------------------------
  DRAW_SIZE = KGC::LargeParty::PARTY_FORM_CHARACTER_SIZE
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :selected_index           # 選択済みインデックス
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x       : ウィンドウの X 座標
  #     y       : ウィンドウの Y 座標
  #     width   : ウィンドウの幅
  #     height  : ウィンドウの高さ
  #     spacing : 横に項目が並ぶときの空白の幅
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, spacing = 8)
    super(x, y, width, height, spacing)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32,
      [height - 32, row_max * DRAW_SIZE[1]].max)
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の取得
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / DRAW_SIZE[1]
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の設定
  #     row : 先頭に表示する行
  #--------------------------------------------------------------------------
  def top_row=(row)
    super(row)
    self.oy = self.oy / WLH * DRAW_SIZE[1]
  end
  #--------------------------------------------------------------------------
  # ● 1 ページに表示できる行数の取得
  #--------------------------------------------------------------------------
  def page_row_max
    return (self.height - 32) / DRAW_SIZE[1]
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.width = DRAW_SIZE[0]
    rect.height = DRAW_SIZE[1]
    rect.y = index / @column_max * DRAW_SIZE[1]
    return rect
  end
  #--------------------------------------------------------------------------
  # ○ 選択アクター取得
  #--------------------------------------------------------------------------
  def actor
    return @actors[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    restore_member_list
    draw_member
  end
  #--------------------------------------------------------------------------
  # ○ メンバーリスト修復
  #--------------------------------------------------------------------------
  def restore_member_list
    # 継承先で定義
  end
  #--------------------------------------------------------------------------
  # ○ メンバー描画
  #--------------------------------------------------------------------------
  def draw_member
    # 継承先で定義
  end
  #--------------------------------------------------------------------------
  # ○ 空欄アクター描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_empty_actor(index)
    # 継承先で定義
  end
  #--------------------------------------------------------------------------
  # ○ 固定キャラ背景描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_fixed_back(index)
    rect = item_rect(index)
    self.contents.fill_rect(rect, KGC::LargeParty::FIXED_COLOR)
  end
  #--------------------------------------------------------------------------
  # ○ 選択中キャラ背景描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_selected_back(index)
    rect = item_rect(index)
    self.contents.fill_rect(rect, KGC::LargeParty::SELECTED_COLOR)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormBattleMember
#------------------------------------------------------------------------------
# 　パーティ編成画面で戦闘メンバーを表示するウィンドウです。
#==============================================================================

class Window_PartyFormBattleMember < Window_PartyFormMember
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :selected_index           # 選択済みインデックス
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 64, DRAW_SIZE[1] + 32)
    column_width = DRAW_SIZE[0] + @spacing
    nw = [column_width * $game_party.max_battle_member_count + 32,
      Graphics.width].min
    self.width = nw

    @item_max = $game_party.max_battle_member_count
    @column_max = width / column_width
    @selected_index = nil
    create_contents
    refresh
    self.active = true
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ○ メンバーリスト修復
  #--------------------------------------------------------------------------
  def restore_member_list
    @actors = $game_party.battle_members
  end
  #--------------------------------------------------------------------------
  # ○ メンバー描画
  #--------------------------------------------------------------------------
  def draw_member
    @item_max.times { |i|
      actor = @actors[i]
      if actor == nil
        draw_empty_actor(i)
      else
        if i == @selected_index
          draw_selected_back(i)
        elsif $game_party.actor_fixed?(actor.id)
          draw_fixed_back(i)
        end
        rect = item_rect(i)
        draw_actor_graphic(actor,
          rect.x + DRAW_SIZE[0] / 2,
          rect.y + DRAW_SIZE[1] - 4)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 空欄アクター描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_empty_actor(index)
    rect = item_rect(index)
    self.contents.font.color = system_color
    self.contents.draw_text(rect, KGC::LargeParty::BATTLE_MEMBER_BLANK_TEXT, 1)
    self.contents.font.color = normal_color
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormAllMember
#------------------------------------------------------------------------------
# 　パーティ編成画面で全メンバーを表示するウィンドウです。
#==============================================================================

class Window_PartyFormAllMember < Window_PartyFormMember
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 64, 64)
    restore_member_list
    @item_max = $game_party.all_members.size

    # 各種サイズ計算
    column_width = DRAW_SIZE[0] + @spacing
    sw = [@item_max * column_width + 32, Graphics.width].min
    @column_max = (sw - 32) / column_width
    sh = ([@item_max - 1, 0].max / @column_max + 1) * DRAW_SIZE[1] + 32
    sh = [sh, DRAW_SIZE[1] * KGC::LargeParty::PARTY_MEMBER_WINDOW_ROW_MAX + 32].min

    # 座標・サイズ調整
    self.y += DRAW_SIZE[1] + 32
    self.width = sw
    self.height = sh

    create_contents
    refresh
    self.active = false
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ○ 選択しているアクターのインデックス取得
  #--------------------------------------------------------------------------
  def actor_index
    return @index_offset + self.index
  end
  #--------------------------------------------------------------------------
  # ○ メンバーリスト修復
  #--------------------------------------------------------------------------
  def restore_member_list
    if KGC::LargeParty::SHOW_BATTLE_MEMBER_IN_PARTY
      @actors = $game_party.all_members
      @index_offset = 0
    else
      @actors = $game_party.stand_by_members
      @index_offset = $game_party.battle_members.size
    end
  end
  #--------------------------------------------------------------------------
  # ○ メンバー描画
  #--------------------------------------------------------------------------
  def draw_member
    @item_max.times { |i|
      actor = @actors[i]
      if actor == nil
        draw_empty_actor(i)
        next
      end

      if $game_party.actor_fixed?(actor.id)
        draw_fixed_back(i)
      end
      rect = item_rect(i)
      opacity = ($game_party.battle_members.include?(actor) ? 96 : 255)
      draw_actor_graphic(actor,
        rect.x + DRAW_SIZE[0] / 2,
        rect.y + DRAW_SIZE[1] - 4,
        opacity)
    }
  end
  #--------------------------------------------------------------------------
  # ● アクターの歩行グラフィック描画
  #     actor   : アクター
  #     x       : 描画先 X 座標
  #     y       : 描画先 Y 座標
  #     opacity : 不透明度
  #--------------------------------------------------------------------------
  def draw_actor_graphic(actor, x, y, opacity = 255)
    draw_character(actor.character_name, actor.character_index, x, y, opacity)
  end
  #--------------------------------------------------------------------------
  # ● 歩行グラフィックの描画
  #     character_name  : 歩行グラフィック ファイル名
  #     character_index : 歩行グラフィック インデックス
  #     x               : 描画先 X 座標
  #     y               : 描画先 Y 座標
  #     opacity         : 不透明度
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index, x, y, opacity = 255)
    return if character_name == nil
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign != nil and sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    self.contents.blt(x - cw / 2, y - ch, bitmap, src_rect, opacity)
  end
  #--------------------------------------------------------------------------
  # ○ 空欄アクター描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_empty_actor(index)
    rect = item_rect(index)
    self.contents.font.color = system_color
    self.contents.draw_text(rect, KGC::LargeParty::PARTY_MEMBER_BLANK_TEXT, 1)
    self.contents.font.color = normal_color
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormStatus
#------------------------------------------------------------------------------
# 　パーティ編成画面でアクターのステータスを表示するウィンドウです。
#==============================================================================

class Window_PartyFormStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 384, 128)
    self.z = 1000
    @actor = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ アクター設定
  #--------------------------------------------------------------------------
  def set_actor(actor)
    if @actor != actor
      @actor = actor
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @actor == nil
      return
    end

    draw_actor_face(@actor, 0, 0)
    dx = 104
    draw_actor_name(@actor, dx, 0)
    draw_actor_level(@actor, dx, WLH * 1)
    draw_actor_hp(@actor, dx, WLH * 2)
    draw_actor_mp(@actor, dx, WLH * 3)
    4.times { |i|
      draw_actor_parameter(@actor, dx + 128, WLH * i, i, 120)
    }
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     type  : 能力値の種類 (0～3)
  #     width : 描画幅
  #--------------------------------------------------------------------------
  def draw_actor_parameter(actor, x, y, type, width = 156)
    case type
    when 0
      parameter_name = Vocab::atk
      parameter_value = actor.atk
    when 1
      parameter_name = Vocab::def
      parameter_value = actor.def
    when 2
      parameter_name = Vocab::spi
      parameter_value = actor.spi
    when 3
      parameter_name = Vocab::agi
      parameter_value = actor.agi
    end
    nw = width - 36
    self.contents.font.color = system_color
    self.contents.draw_text(x, y, nw, WLH, parameter_name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + nw, y, 36, WLH, parameter_value, 2)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_PartyFormControl
#------------------------------------------------------------------------------
# 　パーティ編成画面で操作方法を表示するウィンドウです。
#==============================================================================

class Window_PartyFormControl < Window_Base
  #--------------------------------------------------------------------------
  # ○ 定数
  #--------------------------------------------------------------------------
  MODE_BATTLE_MEMBER = 0
  MODE_SHIFT_CHANGE  = 1
  MODE_PARTY_MEMBER  = 2
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width - 384, 128)
    self.z = 1000
    @mode = MODE_BATTLE_MEMBER
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ モード変更
  #--------------------------------------------------------------------------
  def mode=(value)
    @mode = value
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    case @mode
    when MODE_BATTLE_MEMBER  # 戦闘メンバー
      buttons = [
        "A: 外す",
        "B: 終了",
        "C: 決定",
        "X: 並び替え"
      ]
    when MODE_SHIFT_CHANGE   # 並び替え
      buttons = [
        "B: キャンセル",
        "C: 決定",
        "X: 決定"
      ]
    when MODE_PARTY_MEMBER   # パーティメンバー
      buttons = [
        "B: キャンセル",
        "C: 決定"
      ]
    else
      return
    end

    buttons.each_with_index { |c, i|
      self.contents.draw_text(0, WLH * i, width - 32, WLH, c)
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias create_game_objects_KGC_LargeParty create_game_objects
  def create_game_objects
    create_game_objects_KGC_LargeParty

    if KGC::LargeParty::DEFAULT_PARTYFORM_ENABLED
      $game_switches[KGC::LargeParty::PARTYFORM_SWITCH] = true
      $game_switches[KGC::LargeParty::BATTLE_PARTYFORM_SWITCH] = true
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 画面切り替えの実行
  #--------------------------------------------------------------------------
  alias update_scene_change_KGC_LargeParty update_scene_change
  def update_scene_change
    return if $game_player.moving?    # プレイヤーの移動中？

    if $game_temp.next_scene == :partyform
      call_partyform
      return
    end

    update_scene_change_KGC_LargeParty
  end
  #--------------------------------------------------------------------------
  # ○ パーティ編成画面への切り替え
  #--------------------------------------------------------------------------
  def call_partyform
    $game_temp.next_scene = nil
    $scene = Scene_PartyForm.new(0, Scene_PartyForm::HOST_MAP)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_Base
  if KGC::LargeParty::USE_MENU_PARTYFORM_COMMAND
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_command_window_KGC_LargeParty create_command_window
  def create_command_window
    create_command_window_KGC_LargeParty

    return if $imported["CustomMenuCommand"]

    @__command_partyform_index =
      @command_window.add_command(Vocab.partyform)
    @command_window.draw_item(@__command_partyform_index,
      $game_party.partyform_enable?)
    if @command_window.oy > 0
      @command_window.oy -= Window_Base::WLH
    end
    @command_window.index = @menu_index
  end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  alias update_command_selection_KGC_LargeParty update_command_selection
  def update_command_selection
    current_menu_index = @__command_partyform_index
    call_partyform_flag = false

    if Input.trigger?(Input::C)
      case @command_window.index
      when @__command_partyform_index  # パーティ編成
        call_partyform_flag = true
      end
    # パーティ編成ボタン押下
    elsif KGC::LargeParty::MENU_PARTYFORM_BUTTON != nil &&
        Input.trigger?(KGC::LargeParty::MENU_PARTYFORM_BUTTON)
      call_partyform_flag = true
      current_menu_index = @command_window.index if current_menu_index == nil
    end

    # パーティ編成画面に移行
    if call_partyform_flag
      if $game_party.members.size == 0 || !$game_party.partyform_enable?
        Sound.play_buzzer
        return
      end
      Sound.play_decision
      $scene = Scene_PartyForm.new(current_menu_index)
      return
    end

    update_command_selection_KGC_LargeParty
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Shop
#==============================================================================

unless $imported["HelpExtension"]
class Scene_Shop < Scene_Base
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias udpate_KGC_LargeParty update
  def update
    # スクロール判定
    if !@command_window.active &&
        KGC::LargeParty::SHOP_STATUS_SCROLL_BUTTON != nil &&
        Input.press?(KGC::LargeParty::SHOP_STATUS_SCROLL_BUTTON)
      super
      update_menu_background
      update_scroll_status
      return
    else
      @status_window.cursor_rect.empty
    end

    udpate_KGC_LargeParty
  end
  #--------------------------------------------------------------------------
  # ○ ステータスウィンドウのスクロール処理
  #--------------------------------------------------------------------------
  def update_scroll_status
    # ステータスウィンドウにカーソルを表示
    @status_window.cursor_rect.width = @status_window.contents.width
    @status_window.cursor_rect.height = @status_window.height - 32
    @status_window.update

    if Input.press?(Input::UP)
      @status_window.oy = [@status_window.oy - 4, 0].max
    elsif Input.press?(Input::DOWN)
      max_pos = [@status_window.contents.height -
        (@status_window.height - 32), 0].max
      @status_window.oy = [@status_window.oy + 4, max_pos].min
    end
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Scene_PartyForm
#------------------------------------------------------------------------------
# 　パーティ編成画面の処理を行うクラスです。
#==============================================================================

class Scene_PartyForm < Scene_Base
  #--------------------------------------------------------------------------
  # ○ 定数
  #--------------------------------------------------------------------------
  CAPTION_OFFSET = 40  # キャプションウィンドウの位置補正
  HOST_MENU   = 0      # 呼び出し元 : メニュー
  HOST_MAP    = 1      # 呼び出し元 : マップ
  HOST_BATTLE = 2      # 呼び出し元 : 戦闘
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #     host_scene : 呼び出し元 (0..メニュー  1..マップ  2..戦闘)
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0, host_scene = HOST_MENU)
    @menu_index = menu_index
    @host_scene = host_scene
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background

    create_windows
    create_confirm_window
    adjust_window_location

    # 編成前のパーティを保存
    @battle_actors = $game_party.battle_members.dup
    @party_actors  = $game_party.all_members.dup
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_windows
    # 編成用ウィンドウを作成
    @battle_member_window = Window_PartyFormBattleMember.new
    @party_member_window  = Window_PartyFormAllMember.new
    @status_window        = Window_PartyFormStatus.new
    @status_window.set_actor(@battle_member_window.actor)

    # その他のウィンドウを作成
    @battle_member_caption_window =
      Window_PartyFormCaption.new(KGC::LargeParty::BATTLE_MEMBER_CAPTION)
    @party_member_caption_window =
      Window_PartyFormCaption.new(KGC::LargeParty::PARTY_MEMBER_CAPTION)
    @control_window = Window_PartyFormControl.new
  end
  #--------------------------------------------------------------------------
  # ○ 確認ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_confirm_window
    commands = KGC::LargeParty::CONFIRM_WINDOW_COMMANDS
    @confirm_window =
      Window_Command.new(KGC::LargeParty::CONFIRM_WINDOW_WIDTH, commands)
    @confirm_window.index    = 0
    @confirm_window.openness = 0
    @confirm_window.active   = false
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウの座標調整
  #--------------------------------------------------------------------------
  def adjust_window_location
    # 基準座標を計算
    base_x = [@battle_member_window.width, @party_member_window.width].max
    base_x = [(Graphics.width - base_x) / 2, 0].max
    base_y = @battle_member_window.height + @party_member_window.height +
      @status_window.height + CAPTION_OFFSET * 2
    base_y = [(Graphics.height - base_y) / 2, 0].max
    base_z = @menuback_sprite.z + 1000

    # 編成用ウィンドウの座標をセット
    @battle_member_window.x = base_x
    @battle_member_window.y = base_y + CAPTION_OFFSET
    @battle_member_window.z = base_z
    @party_member_window.x = base_x
    @party_member_window.y = @battle_member_window.y +
      @battle_member_window.height + CAPTION_OFFSET
    @party_member_window.z = base_z
    @status_window.x = 0
    @status_window.y = @party_member_window.y + @party_member_window.height
    @status_window.z = base_z

    # その他のウィンドウの座標をセット
    @battle_member_caption_window.x = [base_x - 16, 0].max
    @battle_member_caption_window.y = @battle_member_window.y - CAPTION_OFFSET
    @battle_member_caption_window.z = base_z + 500
    @party_member_caption_window.x = [base_x - 16, 0].max
    @party_member_caption_window.y = @party_member_window.y - CAPTION_OFFSET
    @party_member_caption_window.z = base_z + 500
    @control_window.x = @status_window.width
    @control_window.y = @status_window.y
    @control_window.z = base_z

    @confirm_window.x = (Graphics.width - @confirm_window.width) / 2
    @confirm_window.y = (Graphics.height - @confirm_window.height) / 2
    @confirm_window.z = base_z + 1000
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @battle_member_window.dispose
    @party_member_window.dispose
    @status_window.dispose
    @battle_member_caption_window.dispose
    @party_member_caption_window.dispose
    @control_window.dispose
    @confirm_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面系の背景作成
  #--------------------------------------------------------------------------
  def create_menu_background
    super
    @menuback_sprite.z = 20000
  end
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    case @host_scene
    when HOST_MENU
      $scene = Scene_Menu.new(@menu_index)
    when HOST_MAP
      $scene = Scene_Map.new
    when HOST_BATTLE
      $scene = Scene_Battle.new
    end
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    update_window
    if @battle_member_window.active
      update_battle_member
    elsif @party_member_window.active
      update_party_member
    elsif @confirm_window.active
      update_confirm
    end
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ更新
  #--------------------------------------------------------------------------
  def update_window
    @battle_member_window.update
    @party_member_window.update
    @status_window.update
    @battle_member_caption_window.update
    @party_member_caption_window.update
    @control_window.update
    @confirm_window.update
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ再描画
  #--------------------------------------------------------------------------
  def refresh_window
    @battle_member_window.refresh
    @party_member_window.refresh
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新 (戦闘メンバーウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_battle_member
    @status_window.set_actor(@battle_member_window.actor)
    if Input.trigger?(Input::A)
      if @battle_member_window.selected_index == nil  # 並び替え中でない
        actor = @battle_member_window.actor
        # アクターを外せない場合
        if actor == nil || $game_party.actor_fixed?(actor.id)
          Sound.play_buzzer
          return
        end
        # アクターを外す
        Sound.play_decision
        actors = $game_party.battle_members
        actors.delete_at(@battle_member_window.index)
        $game_party.set_battle_member(actors)
        refresh_window
      end
    elsif Input.trigger?(Input::B)
      if @battle_member_window.selected_index == nil  # 並び替え中でない
        # 確認ウィンドウに切り替え
        Sound.play_cancel
        show_confirm_window
      else                                            # 並び替え中
        # 並び替え解除
        Sound.play_cancel
        @battle_member_window.selected_index = nil
        @battle_member_window.refresh
        @control_window.mode = Window_PartyFormControl::MODE_BATTLE_MEMBER
      end
    elsif Input.trigger?(Input::C)
      if @battle_member_window.selected_index == nil  # 並び替え中でない
        actor = @battle_member_window.actor
        # アクターを外せない場合
        if actor != nil && $game_party.actor_fixed?(actor.id)
          Sound.play_buzzer
          return
        end
        # パーティメンバーウィンドウに切り替え
        Sound.play_decision
        @battle_member_window.active = false
        @party_member_window.active = true
        @control_window.mode = Window_PartyFormControl::MODE_PARTY_MEMBER
      else                                            # 並び替え中
        unless can_change_shift?(@battle_member_window.actor)
          Sound.play_buzzer
          return
        end
        # 並び替え実行
        Sound.play_decision
        index1 = @battle_member_window.selected_index
        index2 = @battle_member_window.index
        change_shift(index1, index2)
        @control_window.mode = Window_PartyFormControl::MODE_BATTLE_MEMBER
      end
    elsif Input.trigger?(Input::X)
      # 並び替え不可能な場合
      unless can_change_shift?(@battle_member_window.actor)
        Sound.play_buzzer
        return
      end
      if @battle_member_window.selected_index == nil  # 並び替え中でない
        # 並び替え開始
        Sound.play_decision
        @battle_member_window.selected_index = @battle_member_window.index
        @battle_member_window.refresh
        @control_window.mode = Window_PartyFormControl::MODE_SHIFT_CHANGE
      else                                            # 並び替え中
        # 並び替え実行
        Sound.play_decision
        index1 = @battle_member_window.selected_index
        index2 = @battle_member_window.index
        change_shift(index1, index2)
        @control_window.mode = Window_PartyFormControl::MODE_BATTLE_MEMBER
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 並び替え可否判定
  #--------------------------------------------------------------------------
  def can_change_shift?(actor)
    # 選択したアクターが存在しない、または並び替え不能な場合
    if actor == nil ||
        (KGC::LargeParty::FORBID_CHANGE_SHIFT_FIXED &&
         $game_party.actor_fixed?(actor.id))
      return false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 並び替え
  #--------------------------------------------------------------------------
  def change_shift(index1, index2)
    # 位置を入れ替え
    $game_party.change_shift(index1, index2)
    # 選択済みインデックスをクリア
    @battle_member_window.selected_index = nil
    refresh_window
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新 (パーティウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_party_member
    @status_window.set_actor(@party_member_window.actor)
    if Input.trigger?(Input::B)
      Sound.play_cancel
      # 戦闘メンバーウィンドウに切り替え
      @battle_member_window.active = true
      @party_member_window.active = false
        @control_window.mode = Window_PartyFormControl::MODE_BATTLE_MEMBER
    elsif Input.trigger?(Input::C)
      actor = @party_member_window.actor
      # アクターが戦闘メンバーに含まれる場合
      if $game_party.battle_members.include?(actor)
        Sound.play_buzzer
        return
      end
      # アクターを入れ替え
      Sound.play_decision
      actors = $game_party.all_members
      battle_actors = $game_party.battle_members
      if @battle_member_window.actor != nil
        actors[@party_member_window.actor_index] = @battle_member_window.actor
        actors[@battle_member_window.index] = actor
        $game_party.set_member(actors.compact)
      end
      battle_actors[@battle_member_window.index] = actor
      $game_party.set_battle_member(battle_actors.compact)
      refresh_window
      # 戦闘メンバーウィンドウに切り替え
      @battle_member_window.active = true
      @party_member_window.active = false
      @control_window.mode = Window_PartyFormControl::MODE_BATTLE_MEMBER
    end
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新 (確認ウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_confirm
    if Input.trigger?(Input::B)
      Sound.play_cancel
      hide_confirm_window
    elsif Input.trigger?(Input::C)
      case @confirm_window.index
      when 0  # 編成完了
        # パーティが無効の場合
        unless battle_member_valid?
          Sound.play_buzzer
          return
        end
        Sound.play_decision
        return_scene
      when 1  # 編成中断
        Sound.play_decision
        # パーティを編成前の状態に戻す
        $game_party.set_member(@party_actors)
        $game_party.set_battle_member(@battle_actors)
        return_scene
      when 2  # キャンセル
        Sound.play_cancel
        hide_confirm_window
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 戦闘メンバー有効判定
  #--------------------------------------------------------------------------
  def battle_member_valid?
    return false if $game_party.battle_members.size == 0  # 戦闘メンバーが空
    $game_party.battle_members.each { |actor|
      return true if actor.exist?  # 生存者がいればOK
    }
    return false
  end
  #--------------------------------------------------------------------------
  # ○ 確認ウィンドウの表示
  #--------------------------------------------------------------------------
  def show_confirm_window
    if @battle_member_window.active
      @last_active_window = @battle_member_window
    else
      @last_active_window = @party_member_window
    end
    @battle_member_window.active = false
    @party_member_window.active = false

    @confirm_window.draw_item(0, battle_member_valid?)
    @confirm_window.open
    @confirm_window.active = true
  end
  #--------------------------------------------------------------------------
  # ○ 確認ウィンドウの非表示
  #--------------------------------------------------------------------------
  def hide_confirm_window
    @confirm_window.active = false
    @confirm_window.close
    @last_active_window.active = true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  alias wait_for_message_KGC_LargeParty wait_for_message
  def wait_for_message
    return if @ignore_wait_for_message  # メッセージ終了までのウェイトを無視

    wait_for_message_KGC_LargeParty
  end
  #--------------------------------------------------------------------------
  # ● レベルアップの表示
  #--------------------------------------------------------------------------
  alias display_level_up_KGC_LargeParty display_level_up
  def display_level_up
    @ignore_wait_for_message = true

    display_level_up_KGC_LargeParty

    exp = $game_troop.exp_total * KGC::LargeParty::STAND_BY_EXP_RATE / 1000
    $game_party.stand_by_members.each { |actor|
      if actor.exist?
        actor.gain_exp(exp, KGC::LargeParty::SHOW_STAND_BY_LEVEL_UP)
      end
    }
    @ignore_wait_for_message = false
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  alias start_party_command_selection_KGC_LargeParty start_party_command_selection
  def start_party_command_selection
    if $game_temp.in_battle
      @status_window.index = 0
    end

    start_party_command_selection_KGC_LargeParty
  end

  if KGC::LargeParty::USE_BATTLE_PARTYFORM

  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの作成
  #--------------------------------------------------------------------------
  alias create_info_viewport_KGC_LargeParty create_info_viewport
  def create_info_viewport
    create_info_viewport_KGC_LargeParty

    @__command_partyform_index =
      @party_command_window.add_command(Vocab.partyform_battle)
    @party_command_window.draw_item(@__command_partyform_index,
      $game_party.battle_partyform_enable?)
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の更新
  #--------------------------------------------------------------------------
  alias update_party_command_selection_KGC_LargeParty update_party_command_selection
  def update_party_command_selection
    if Input.trigger?(Input::C)
      case @party_command_window.index
      when @__command_partyform_index  # パーティ編成
        unless $game_party.battle_partyform_enable?
          Sound.play_buzzer
          return
        end
        Sound.play_decision
        process_partyform
        return
      end
    end

    update_party_command_selection_KGC_LargeParty
  end
  #--------------------------------------------------------------------------
  # ○ パーティ編成の処理
  #--------------------------------------------------------------------------
  def process_partyform
    prev_party_command_active = @party_command_window.active
    @party_command_window.active = false
    Graphics.freeze
    snapshot_for_background
    $scene = Scene_PartyForm.new(0, Scene_PartyForm::HOST_BATTLE)
    $scene.main
    $scene = self
    @spriteset.update_actors
    @status_window.refresh
    @party_command_window.active = prev_party_command_active
    Window_Base.show_cursor_animation if $imported["CursorAnimation"]
    perform_transition
  end
  #--------------------------------------------------------------------------
  # ● 敗北の処理
  #--------------------------------------------------------------------------
  alias process_defeat_KGC_LargeParty process_defeat
  def process_defeat
    process_defeat_launch

    process_defeat_KGC_LargeParty if $game_party.all_dead?
  end
  #--------------------------------------------------------------------------
  # ○ 全滅時の入れ替え処理
  #--------------------------------------------------------------------------
  def process_defeat_launch
    while @spriteset.animation?
      update_basic
    end

    return unless KGC::LargeParty::ENABLE_DEFEAT_LAUNCH
    return unless $game_party.partyform_enable?

    exist = false
    $game_party.all_members.each { |actor| exist |= actor.exist? }
    return unless exist  # 生存者なし

    @info_viewport.visible  = false
    @message_window.visible = true

    # 戦闘可能者を出撃 (固定アクターは残す)
    $game_party.remove_all_battle_member
    max = $game_party.max_battle_member_count
    while ($game_party.battle_members.size < max)
      actor = $game_party.stand_by_members.find { |a| a.exist? }
      break if actor == nil
      $game_party.add_battle_member(actor.id)
      @status_window.refresh
      display_launch(actor)
    end

    @info_viewport.visible  = true
    @message_window.visible = false
    @message_window.clear
  end
  #--------------------------------------------------------------------------
  # ○ 出撃の表示
  #     target : 対象者 (アクター)
  #--------------------------------------------------------------------------
  def display_launch(target)
    text = sprintf(Vocab::DefeatLaunch, target.name)
    @message_window.add_instant_text(text)
    wait(40)
  end

  end  # <-- if KGC::LargeParty::USE_BATTLE_PARTYFORM
end
