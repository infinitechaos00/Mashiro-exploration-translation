#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ スキル習得装備 - KGC_EquipLearnSkill ◆ VX ◆
#_/    ◇ Last update : 2009/09/26 ◇
#_/----------------------------------------------------------------------------
#_/  スキルを習得する装備品を作成します。
#_/============================================================================
#_/ 【スキル】≪スキルCP制≫ より上に導入してください。
#_/ 【メニュー】≪拡張装備画面≫ より上に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ スキルを習得する装備品の作成

#~ 武器・防具の「メモ」欄に <スキル習得 n> を追加します。
#~ nには、装備時に習得するスキルの ID を半角で入力します。
#~ スキルIDは、, で区切って複数指定することもできます。
#~ memo
#~ このアイテムを装備すると、ID60と62のスキルが使用可能になります。

#~ <スキル習得 n> の代わりに <learn_skill n> を使用することもできます。

$data_system = load_data("Data/System.rvdata") if $data_system == nil

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module EquipLearnSkill
  # ◆ AP の名称
  #  ゲーム中の表記のみ変化。
  VOCAB_AP     = "AP"
  # ◆ AP のデフォルト値
  #  所持 AP を指定しなかったエネミーの AP。
  DEFAULT_AP   = 0
  # ◆ 装備しただけでは習得しない
  #  true  : AP が溜まるまで使用不能
  #  false : 装備するだけで使用可能
  NEED_FULL_AP = false

  # ◆ リザルト画面での獲得 AP の表示
  #  %s : 獲得した AP
  VOCAB_RESULT_OBTAIN_AP         = "#{VOCAB_AP} を %s 獲得！"
  # ◆ リザルト画面でスキルをマスターした際のメッセージ
  #  %s : アクター名
  VOCAB_RESULT_MASTER_SKILL      = "%sは"
  # ◆ リザルト画面でマスターしたスキルの表示
  #  %s : マスターしたスキルの名前
  VOCAB_RESULT_MASTER_SKILL_NAME = "%sをマスターした！"

  # ◆ メニュー画面に「AP ビューア」コマンドを追加する
  #  追加する場所は、メニューコマンドの最下部です。
  #  他の部分に追加したければ、≪カスタムメニューコマンド≫ をご利用ください。
  USE_MENU_AP_VIEWER_COMMAND = false
  # ◆ メニュー画面の「AP ビューア」コマンドの名称
  VOCAB_MENU_AP_VIEWER       = "#{VOCAB_AP} ビューア"

  # ◆ マスター（完全習得）したスキルの AP 欄
  VOCAB_MASTER_SKILL      = "- MASTER -"
  # ◆ 蓄積 AP が 0 のスキルも AP ビューアに表示
  SHOW_ZERO_AP_SKILL      = false
  # ◆ 蓄積 AP が 0 のスキルの名前を隠す
  MASK_ZERO_AP_SKILL_NAME = true
  # ◆ 蓄積 AP が 0 のスキルに表示する名前
  #  １文字だけ指定すると、スキル名と同じ長さに拡張されます。
  ZERO_AP_NAME_MASK       = "？"
  # ◆ 蓄積 AP が 0 のスキルのヘルプを隠す
  HIDE_ZERO_AP_SKILL_HELP = true
  # ◆ 蓄積 AP が 0 のスキルに表示するヘルプ
  ZERO_AP_SKILL_HELP      = "？？？？？？？？"

  # ◆ 除外装備品配列
  #  配列の添字がアクター ID に対応。
  #  習得装備から除外する武器・防具の ID を配列に格納。
  EXCLUDE_WEAPONS = []  # 武器
  EXCLUDE_ARMORS  = []  # 防具
  # ここから下に定義。
  #  <例>
  #  アクターID:1 は、武器ID:50 と 70 のスキルを習得できない。
  # EXCLUDE_WEAPONS[1] = [50, 70]

  # ◆ 除外スキル配列
  #  配列の添字がアクター ID と対応。
  #  装備では習得不可能にするスキル ID を配列に格納。
  EXCLUDE_SKILLS = []
  #  <例>
  #  アクターID:1 は、スキルID:30 を装備品で習得することはできない。
  # EXCLUDE_SKILLS[1] = [30]
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["EquipLearnSkill"] = true

module KGC::EquipLearnSkill
  module Regexp
    module BaseItem
      # 習得スキル
      LEARN_SKILL = /<(?:LEARN_SKILL|スキル習得)\s*(\d+(?:\s*,\s*\d+)*)>/i
    end

    module Skill
      # 必要 AP
      NEED_AP = /<(?:NEED_AP|必要AP)\s*(\d+)>/i
    end

    module Enemy
      # 所持 AP
      AP = /<AP\s*(\d+)>/i
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
  # ○ AP の獲得
  #     actor_id : アクター ID
  #     ap       : 獲得 AP
  #     show     : マスター表示フラグ
  #--------------------------------------------------------------------------
  def gain_actor_ap(actor_id, ap, show = false)
    $game_actors[actor_id].gain_ap(ap, show)
  end
  #--------------------------------------------------------------------------
  # ○ AP の変更
  #     actor_id : アクター ID
  #     skill_id : スキル ID
  #     ap       : AP
  #--------------------------------------------------------------------------
  def change_actor_ap(actor_id, skill_id, ap)
    skill = $data_skills[skill_id]
    return if skill == nil
    $game_actors[actor_id].change_ap(skill, ap)

    $game_actors[actor_id].restore_passive_rev if $imported["PassiveSkill"]
  end
  #--------------------------------------------------------------------------
  # ○ AP ビューアの呼び出し
  #     actor_index : アクターインデックス
  #--------------------------------------------------------------------------
  def call_ap_viewer(actor_index = 0)
    return if $game_temp.in_battle
    $game_temp.next_scene = :ap_viewer
    $game_temp.next_scene_actor_index = actor_index
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
  # 戦闘終了メッセージ
  ObtainAP              = KGC::EquipLearnSkill::VOCAB_RESULT_OBTAIN_AP
  ResultFullAPSkill     = KGC::EquipLearnSkill::VOCAB_RESULT_MASTER_SKILL
  ResultFullAPSkillName = KGC::EquipLearnSkill::VOCAB_RESULT_MASTER_SKILL_NAME

  # AP
  def self.ap
    return KGC::EquipLearnSkill::VOCAB_AP
  end

  # マスターしたスキル
  def self.full_ap_skill
    return KGC::EquipLearnSkill::VOCAB_MASTER_SKILL
  end

  # AP ビューア
  def self.ap_viewer
    return KGC::EquipLearnSkill::VOCAB_MENU_AP_VIEWER
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ スキル習得装備のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_equip_learn_skill_cache
    @__learn_skills = []

    self.note.each_line { |line|
      if line =~ KGC::EquipLearnSkill::Regexp::BaseItem::LEARN_SKILL
        # スキル習得
        $1.scan(/\d+/).each { |num|
          skill_id = num.to_i
          # 存在するスキルならリストに加える
          @__learn_skills << skill_id if $data_skills[skill_id] != nil
        }
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 習得するスキル ID の配列
  #--------------------------------------------------------------------------
  def learn_skills
    create_equip_learn_skill_cache if @__learn_skills == nil
    return @__learn_skills
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Skill
#==============================================================================

class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # ○ クラス変数
  #--------------------------------------------------------------------------
  @@__masked_name =
    KGC::EquipLearnSkill::ZERO_AP_NAME_MASK  # マスク名
  @@__expand_masked_name = false             # マスク名拡張表示フラグ

  if @@__expand_masked_name != nil
    @@__expand_masked_name = (@@__masked_name.scan(/./).size == 1)
  end
  #--------------------------------------------------------------------------
  # ○ スキル習得装備のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_equip_learn_skill_cache
    @__need_ap = 0

    self.note.each_line { |line|
      if line =~ KGC::EquipLearnSkill::Regexp::Skill::NEED_AP  # 必要 AP
        @__need_ap = $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ マスク名
  #--------------------------------------------------------------------------
  def masked_name
    if KGC::EquipLearnSkill::MASK_ZERO_AP_SKILL_NAME
      if @@__expand_masked_name
        # マスク名を拡張して表示
        return @@__masked_name * self.name.scan(/./).size
      else
        return @@__masked_name
      end
    else
      return self.name
    end
  end
  #--------------------------------------------------------------------------
  # ○ 習得に必要な AP
  #--------------------------------------------------------------------------
  def need_ap
    create_equip_learn_skill_cache if @__need_ap == nil
    return @__need_ap
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Enemy
#==============================================================================

class RPG::Enemy
  #--------------------------------------------------------------------------
  # ○ スキル習得装備のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_equip_learn_skill_cache
    @__ap = KGC::EquipLearnSkill::DEFAULT_AP

    self.note.each_line { |line|
      if line =~ KGC::EquipLearnSkill::Regexp::Enemy::AP  # 所持 AP
        @__ap = $1.to_i
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ 所持 AP
  #--------------------------------------------------------------------------
  def ap
    create_equip_learn_skill_cache if @__ap == nil
    return @__ap
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Temp
#==============================================================================

unless $imported["CustomMenuCommand"]
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :next_scene_actor_index   # 次のシーンのアクターインデックス
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_EquipLearnSkill initialize
  def initialize
    initialize_KGC_EquipLearnSkill

    @next_scene_actor_index = 0
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
  alias setup_KGC_EquipLearnSkill setup
  def setup(actor_id)
    setup_KGC_EquipLearnSkill(actor_id)

    @skill_ap = []
  end
  #--------------------------------------------------------------------------
  # ○ 指定スキルの AP 取得
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_ap(skill_id)
    @skill_ap = [] if @skill_ap == nil
    return (@skill_ap[skill_id] != nil ? @skill_ap[skill_id] : 0)
  end
  #--------------------------------------------------------------------------
  # ○ AP 変更
  #     skill : スキル
  #     ap    : 新しい AP
  #--------------------------------------------------------------------------
  def change_ap(skill, ap)
    @skill_ap = [] if @skill_ap == nil
    @skill_ap[skill.id] = [[ap, skill.need_ap].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ○ マスターしたスキルの表示
  #     new_skills : 新しくマスターしたスキルの配列
  #--------------------------------------------------------------------------
  def display_full_ap_skills(new_skills)
    $game_message.new_page
    text = sprintf(Vocab::ResultFullAPSkill, name)
    $game_message.texts.push(text)
    new_skills.each { |skill|
      text = sprintf(Vocab::ResultFullAPSkillName, skill.name)
      $game_message.texts.push(text)
    }
  end
  #--------------------------------------------------------------------------
  # ○ AP 獲得
  #     ap   : AP の増加量
  #     show : マスタースキル表示フラグ
  #--------------------------------------------------------------------------
  def gain_ap(ap, show)
    last_full_ap_skills = full_ap_skills

    # 装備品により習得しているスキルに AP を加算
    equipment_skills(true).each { |skill|
      change_ap(skill, skill_ap(skill.id) + ap)
    }
    restore_passive_rev if $imported["PassiveSkill"]

    # マスターしたスキルを表示
    if show && last_full_ap_skills != full_ap_skills
      display_full_ap_skills(full_ap_skills - last_full_ap_skills)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルオブジェクトの配列取得
  #--------------------------------------------------------------------------
  alias skills_KGC_EquipLearnSkill skills
  def skills
    result = skills_KGC_EquipLearnSkill

    # 装備品と AP 蓄積済みのスキルを追加
    additional_skills = equipment_skills | full_ap_skills
    return (result | additional_skills).sort_by { |s| s.id }
  end
  #--------------------------------------------------------------------------
  # ○ 装備品の習得スキル取得
  #     all : 使用不可能なスキルも含める
  #--------------------------------------------------------------------------
  def equipment_skills(all = false)
    result = []
    equips.compact.each { |item|
      next unless include_learnable_equipment?(item)        # 除外装備は無視

      item.learn_skills.each { |i|
        skill = $data_skills[i]
        next unless include_equipment_skill?(skill)          # 除外スキルは無視
        if !all && KGC::EquipLearnSkill::NEED_FULL_AP        # 要蓄積の場合
          next unless skill.need_ap == 0 || ap_full?(skill)    # 未達成なら無視
        end
        result << skill
      }
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ スキル習得装備除外判定
  #     item : 判定装備
  #--------------------------------------------------------------------------
  def include_learnable_equipment?(item)
    return false unless item.is_a?(RPG::Weapon) || item.is_a?(RPG::Armor)
    return false unless equippable?(item)

    case item
    when RPG::Weapon  # 武器
      # 除外武器に含まれている場合
      if KGC::EquipLearnSkill::EXCLUDE_WEAPONS[id] != nil &&
          KGC::EquipLearnSkill::EXCLUDE_WEAPONS[id].include?(item.id)
        return false
      end
    when RPG::Armor   # 防具
      # 除外防具に含まれている場合
      if KGC::EquipLearnSkill::EXCLUDE_ARMORS[id] != nil &&
          KGC::EquipLearnSkill::EXCLUDE_ARMORS[id].include?(item.id)
        return false
      end
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 装備品による習得スキル除外判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  def include_equipment_skill?(skill)
    # 自身が除外されている場合
    if KGC::EquipLearnSkill::EXCLUDE_SKILLS[id] != nil &&
        KGC::EquipLearnSkill::EXCLUDE_SKILLS[id].include?(skill.id)
      return false
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ AP 蓄積済みのスキルを取得
  #--------------------------------------------------------------------------
  def full_ap_skills
    result = []
    (1...$data_skills.size).each { |i|
      skill = $data_skills[i]
      result << skill if ap_full?(skill) && include_equipment_skill?(skill)
    }
    return result
  end
  #--------------------------------------------------------------------------
  # ○ AP 蓄積可能なスキルを取得
  #--------------------------------------------------------------------------
  def can_gain_ap_skills
    result = []
    equips.compact.each { |item|
      next unless include_learnable_equipment?(item)  # 除外装備なら無視

      item.learn_skills.each { |i|
        skill = $data_skills[i]
        next unless include_equipment_skill?(skill)   # 除外スキルなら無視
        result << skill
      }
    }
    return (result - full_ap_skills)              # マスターしたものを除く
  end
  #--------------------------------------------------------------------------
  # ○ AP 蓄積済み判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  def ap_full?(skill)
    return false unless skill.is_a?(RPG::Skill)   # スキル以外
    return false if skill.need_ap == 0            # 必要 AP が 0
    return true  if @skills.include?(skill.id)    # 習得済み

    return (skill_ap(skill.id) >= skill.need_ap)
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  def skill_can_use?(skill)
    return super
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ AP の取得
  #--------------------------------------------------------------------------
  def ap
    return enemy.ap
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Troop
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # ○ AP の合計計算
  #--------------------------------------------------------------------------
  def ap_total
    ap = 0
    for enemy in dead_members
      ap += enemy.ap unless enemy.hidden
    end
    return ap
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
# □ Window_APViewer
#------------------------------------------------------------------------------
# 　AP ビューアでスキルを表示するウィンドウです。
#==============================================================================

class Window_APViewer < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #     actor  : アクター
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @actor = actor
    @can_gain_ap_skills = []
    @equipment_skills   = []
    self.index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ○ スキルの取得
  #--------------------------------------------------------------------------
  def skill
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    @can_gain_ap_skills = @actor.can_gain_ap_skills
    @equipment_skills   = @actor.equipment_skills(true)

    (1...$data_skills.size).each { |i|
      skill = $data_skills[i]
      @data << skill if include?(skill)
    }
    @item_max = @data.size
    create_contents
    @item_max.times { |i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # ○ 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    skill = @data[index]
    if skill != nil
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      if @actor.ap_full?(skill) || @actor.skill_learn?(skill)
        # マスター
        text = Vocab.full_ap_skill
      else
        # AP 蓄積中
        text = sprintf("%s %4d/%4d",
          Vocab.ap, @actor.skill_ap(skill.id), skill.need_ap)
      end
      # AP を描画
      self.contents.font.color = normal_color
      self.contents.draw_text(rect, text, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ○ スキルをリストに含めるか
  #     skill : スキル
  #--------------------------------------------------------------------------
  def include?(skill)
    return false if skill.need_ap == 0
    unless KGC::EquipLearnSkill::SHOW_ZERO_AP_SKILL
      # AP が 0 、かつ装備品で習得していない
      if @actor.skill_ap(skill.id) == 0 && !@equipment_skills.include?(skill)
        return false
      end
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ スキルを有効状態で表示するかどうか
  #     skill : スキル
  #--------------------------------------------------------------------------
  def enable?(skill)
    return true if @actor.skill_learn?(skill)           # 習得済み
    return true if @actor.ap_full?(skill)               # マスター
    return true if @can_gain_ap_skills.include?(skill)  # AP 蓄積可能

    return false
  end
  #--------------------------------------------------------------------------
  # ○ スキルをマスク表示するかどうか
  #     skill : スキル
  #--------------------------------------------------------------------------
  def mask?(skill)
    return false if @actor.skill_learn?(skill)           # 習得済み
    return false if @actor.skill_ap(skill.id) > 0        # AP が 1 以上
    return false if @can_gain_ap_skills.include?(skill)  # AP 蓄積可能

    return true
  end
  #--------------------------------------------------------------------------
  # ● アイテム名の描画
  #     item    : アイテム (スキル、武器、防具でも可)
  #     x       : 描画先 X 座標
  #     y       : 描画先 Y 座標
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true)
    draw_icon(item.icon_index, x, y, enabled)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x + 24, y, 172, WLH,
      mask?(item) ? item.masked_name : item.name)
  end
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
    last_index = @index
    super
    return unless self.active

    if Input.repeat?(Input::RIGHT)
      cursor_pagedown
    elsif Input.repeat?(Input::LEFT)
      cursor_pageup
    end
    if @index != last_index
      Sound.play_cursor
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    if KGC::EquipLearnSkill::HIDE_ZERO_AP_SKILL_HELP && mask?(skill)
      @help_window.set_text(KGC::EquipLearnSkill::ZERO_AP_SKILL_HELP)
    else
      @help_window.set_text(skill == nil ? "" : skill.description)
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
  alias update_scene_change_KGC_EquipLearnSkill update_scene_change
  def update_scene_change
    return if $game_player.moving?    # プレイヤーの移動中？

    if $game_temp.next_scene == :ap_viewer
      call_ap_viewer
      return
    end

    update_scene_change_KGC_EquipLearnSkill
  end
  #--------------------------------------------------------------------------
  # ○ AP ビューアへの切り替え
  #--------------------------------------------------------------------------
  def call_ap_viewer
    $game_temp.next_scene = nil
    $scene = Scene_APViewer.new($game_temp.next_scene_actor_index,
      0, Scene_APViewer::HOST_MAP)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Menu
#==============================================================================

class Scene_Menu < Scene_Base
  if KGC::EquipLearnSkill::USE_MENU_AP_VIEWER_COMMAND
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias create_command_window_KGC_EquipLearnSkill create_command_window
  def create_command_window
    create_command_window_KGC_EquipLearnSkill

    return if $imported["CustomMenuCommand"]

    @__command_ap_viewer_index = @command_window.add_command(Vocab.ap_viewer)
    if @command_window.oy > 0
      @command_window.oy -= Window_Base::WLH
    end
    @command_window.index = @menu_index
  end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  alias update_command_selection_KGC_EquipLearnSkill update_command_selection
  def update_command_selection
    call_ap_viewer_flag = false
    if Input.trigger?(Input::C)
      case @command_window.index
      when @__command_ap_viewer_index  # AP ビューア
        call_ap_viewer_flag = true
      end
    end

    # AP ビューアに移行
    if call_ap_viewer_flag
      if $game_party.members.size == 0
        Sound.play_buzzer
        return
      end
      Sound.play_decision
      start_actor_selection
      return
    end

    update_command_selection_KGC_EquipLearnSkill
  end
  #--------------------------------------------------------------------------
  # ● アクター選択の更新
  #--------------------------------------------------------------------------
  alias update_actor_selection_KGC_EquipLearnSkill update_actor_selection
  def update_actor_selection
    if Input.trigger?(Input::C)
      $game_party.last_actor_index = @status_window.index
      Sound.play_decision
      case @command_window.index
      when @__command_ap_viewer_index  # AP ビューア
        $scene = Scene_APViewer.new(@status_window.index,
          @__command_ap_viewer_index, Scene_APViewer::HOST_MENU)
        return
      end
    end

    update_actor_selection_KGC_EquipLearnSkill
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Scene_APViewer
#------------------------------------------------------------------------------
#   AP ビューアの処理を行うクラスです。
#==============================================================================

class Scene_APViewer < Scene_Base
  HOST_MENU   = 0
  HOST_MAP    = 1
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_index : アクターインデックス
  #     menu_index  : コマンドのカーソル初期位置
  #     host_scene  : 呼び出し元 (0..メニュー  1..マップ)
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, menu_index = 0, host_scene = HOST_MENU)
    @actor_index = actor_index
    @menu_index = menu_index
    @host_scene = host_scene
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @actor = $game_party.members[@actor_index]
    @help_window = Window_Help.new
    if $imported["HelpExtension"]
      @help_window.row_max = KGC::HelpExtension::ROW_MAX
    end
    @status_window = Window_SkillStatus.new(0, @help_window.height, @actor)
    dy = @help_window.height + @status_window.height
    @skill_window = Window_APViewer.new(0, dy,
      Graphics.width, Graphics.height - dy, @actor)
    @skill_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @help_window.dispose
    @status_window.dispose
    @skill_window.dispose
  end
  #--------------------------------------------------------------------------
  # ○ 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    case @host_scene
    when HOST_MENU
      $scene = Scene_Menu.new(@menu_index)
    when HOST_MAP
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ○ 次のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_APViewer.new(@actor_index, @menu_index, @host_scene)
  end
  #--------------------------------------------------------------------------
  # ○ 前のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_APViewer.new(@actor_index, @menu_index, @host_scene)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    @skill_window.update
    @status_window.update
    if @skill_window.active
      update_skill_selection
    end
  end
  #--------------------------------------------------------------------------
  # ○ スキル選択の更新
  #--------------------------------------------------------------------------
  def update_skill_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor
    end
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
  alias wait_for_message_KGC_EquipLearnSkill wait_for_message
  def wait_for_message
    return if @ignore_wait_for_message  # メッセージ終了までのウェイトを無視

    wait_for_message_KGC_EquipLearnSkill
  end
  #--------------------------------------------------------------------------
  # ● 獲得した経験値とお金の表示
  #--------------------------------------------------------------------------
  alias display_exp_and_gold_KGC_EquipLearnSkill display_exp_and_gold
  def display_exp_and_gold
    @ignore_wait_for_message = true

    display_exp_and_gold_KGC_EquipLearnSkill

    display_ap
    @ignore_wait_for_message = false
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● レベルアップの表示
  #--------------------------------------------------------------------------
  alias display_level_up_KGC_EquipLearnSkill display_level_up
  def display_level_up
    display_level_up_KGC_EquipLearnSkill

    display_master_equipment_skill
  end
  #--------------------------------------------------------------------------
  # ○ 獲得 AP の表示
  #--------------------------------------------------------------------------
  def display_ap
    ap = $game_troop.ap_total
    if ap > 0
      text = sprintf(Vocab::ObtainAP, ap)
      $game_message.texts.push('\.' + text)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ○ マスターしたスキルの表示
  #--------------------------------------------------------------------------
  def display_master_equipment_skill
    ap = $game_troop.ap_total
    $game_party.existing_members.each { |actor|
      last_skills = actor.skills
      actor.gain_ap(ap, true)
    }
    wait_for_message
  end
end
