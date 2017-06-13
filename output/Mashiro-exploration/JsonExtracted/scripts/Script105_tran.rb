#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ アイテム合成 - KGC_ComposeItem ◆ VX ◆
#_/    ◇ Last update : 2008/11/02 ◇
#_/----------------------------------------------------------------------------
#_/  複数のアイテムを合成し、新たなアイテムを作り出す機能を作成します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module ComposeItem
  # ◆ 合成画面呼び出しフラグを表すスイッチ番号
  #  このスイッチを ON にすると、通常のショップの代わりに合成屋が開きます。
  COMPOSE_CALL_SWITCH = 181

  # ◆ 合成レシピ
  #  [費用, "タイプ:ID,個数", ...]
  #  【 費用 】合成費用
  #  【タイプ】合成素材の種類 (I..アイテム  W..武器  A..防具)
  #  【  ID  】合成素材のID (↑と対応)
  #  【 個数 】合成素材の必要数
  #  "タイプ:ID,個数" はいくつでも指定できます。
  #  個数を省略して "タイプ:ID" と書いた場合、個数は 1 扱いとなります。
  #  個数を 0 にした場合、1 個以上持っていれば何度でも合成できます。
  #  レシピ配列は、添字がアイテム・武器・防具IDに対応しています。
  RECIPE_ITEM   = []  # アイテム
  RECIPE_WEAPON = []  # 武器
  RECIPE_ARMOR  = []  # 防具
  # ここから下に合成レシピを定義。
  RECIPE_ITEM[20] = [0, "I:10,3", "I:11,4", "I:12,4"]  #  <設定例>
  #  ムチン粘膜生成。２個３個３個。
  RECIPE_ITEM[22] = [0, "I:14,15", "I:10,12", "I:13,15", "I:30,1", "I:31,3"]  #  <設定例>
  #  疼く薬。ニノの薬が必要です。あと悶々液体も。
  #  
  #  アイテムID:8 の合成レシピ
  #  アイテムID 2, 4, 7 を 1 個ずつ消費。無料。
  RECIPE_ITEM[8] = [0, "I:2", "I:4", "I:7"]
  #  武器ID:16 の合成レシピ
  #  武器ID:10 を 1 個、アイテムID:16 を 2 個消費。800 G。
  RECIPE_WEAPON[16] = [800, "W:10", "I:16,2"]
  #  防具ID:29 の合成レシピ
  #  防具ID:25 を 1 個、アイテムID:8 を 3 個消費。2000 G。
  RECIPE_ARMOR[29] = [2000, "A:25", "I:8,3"]

  # ◆ 合成コマンド名
  #  "購入する" コマンドの位置に表示されます。
  #  ※ 他のコマンド名は [Vocab] で変更可能。
  VOCAB_COMPOSE_ITEM = "合成する"
  # ◆ 合成アイテム情報切り替えボタン
  #  「素材リスト <--> 能力値変化(装備品のみ)」を切り替えるボタン。
  #  使用しない場合は nil を指定。
  SWITCH_INFO_BUTTON = Input::X

  # ◆ 必要素材リストをコンパクトにする
  #  素材数が多い場合は true にしてください。
  COMPACT_MATERIAL_LIST = true
  # ◆ コマンドウィンドウを表示しない
  #  true  : XP 版と同様のスタイル
  #  false : VX 仕様
  HIDE_COMMAND_WINDOW   = false
  # ◆ 所持金ウィンドウを表示しない
  #  true  : 消える
  #  false : 表示
  #  HIDE_COMMAND_WINDOW が false のときは、常に false 扱いとなります。
  HIDE_GOLD_WINDOW      = false
  # ◆ 合成費用が 0 の場合、費用を表示しない
  #  true  : 表示しない
  #  false : 0 と表示
  HIDE_ZERO_COST        = true

  # ◆ 合成済みのレシピは常に表示する
  #  true  : 一度でも合成したことがあれば常にリストに表示
  #  false : 合成したことがあっても↓の条件に従う
  SHOW_COMPOSED_RECIPE      = true
  # ◆ 合成費用不足のレシピを隠す
  #  true  : 費用不足ならリストに表示しない
  #  false : 費用不足でも表示
  HIDE_SHORTAGE_COST        = false
  # ◆ 合成素材不足のレシピを隠す
  #  true  : 素材不足ならリストに表示しない
  #  false : 素材不足でも表示
  HIDE_SHORTAGE_MATERIAL    = false
  # ◆ 「判明・解禁・存在」機能を使用する
  #  true  : 判明・解禁・存在するまで表示しない
  #  false : 素材さえあれば合成可能
  #  true の場合、仕様上強制的に
  #   HIDE_SHORTAGE_COST     = false
  #   HIDE_SHORTAGE_MATERIAL = false
  #  という扱いになります。
  NEED_RECIPE_EXIST         = false

  # ◆ 合成したことがないレシピのアイテム名を隠す
  MASK_UNKNOWN_RECIPE_NAME     = false
  # ◆ 合成したことがないレシピに表示する名前
  #  １文字だけ指定すると、アイテム名と同じ文字数に拡張されます。
  UNKNOWN_NAME_MASK            = "？"
  # ◆ 合成したことがないレシピのヘルプを隠す
  HIDE_UNKNOWN_RECIPE_HELP     = false
  # ◆ 合成したことがないレシピに表示するヘルプ
  UNKNOWN_RECIPE_HELP          = "合成したことがありません。"
  # ◆ 判明・解禁していないレシピの素材を隠す
  #  NEED_RECIPE_EXIST = false の場合、常に false 扱いとなります。
  HIDE_UNKNOWN_RECIPE_MATERIAL = false
  # ◆ 素材を隠す場合の表示文字列
  UNKNOWN_RECIPE_MATERIAL      = "？？？？？？？？"
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["ComposeItem"] = true

module KGC::ComposeItem
  unless NEED_RECIPE_EXIST
    HIDE_UNKNOWN_RECIPE_MATERIAL = false
  end

  module Regexp
    # レシピ
    RECIPE = /([IWA])\s*:\s*(\d+)(\s*,\s*\d+)?/i
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
  # ○ レシピ判明フラグを設定
  #     type    : レシピのタイプ (0..アイテム  1..武器  2..防具)
  #     id      : アイテムの ID
  #     enabled : true..判明  false..未判明
  #--------------------------------------------------------------------------
  def set_recipe_cleared(type, id, enabled = true)
    item = nil
    case type
    when 0, :item    # アイテム
      item = $data_items[id]
    when 1, :weapon  # 武器
      item = $data_weapons[id]
    when 2, :armor   # 防具
      item = $data_armors[id]
    end

    $game_party.set_recipe_cleared(item, enabled) if item != nil
  end
  #--------------------------------------------------------------------------
  # ○ レシピ解禁フラグを設定
  #     type    : レシピのタイプ (0..アイテム  1..武器  2..防具)
  #     id      : アイテムの ID
  #     enabled : true..解禁  false..未解禁
  #--------------------------------------------------------------------------
  def set_recipe_opened(type, id, enabled = true)
    item = nil
    case type
    when 0, :item    # アイテム
      item = $data_items[id]
    when 1, :weapon  # 武器
      item = $data_weapons[id]
    when 2, :armor   # 防具
      item = $data_armors[id]
    end

    $game_party.set_recipe_opened(item, enabled) if item != nil
  end
  #--------------------------------------------------------------------------
  # ○ レシピ存在フラグを設定
  #     type    : レシピのタイプ (0..アイテム  1..武器  2..防具)
  #     id      : アイテムの ID
  #     enabled : true or false
  #--------------------------------------------------------------------------
  def set_recipe_exist(type, id, enabled = true)
    item = nil
    case type
    when 0, :item    # アイテム
      item = $data_items[id]
    when 1, :weapon  # 武器
      item = $data_weapons[id]
    when 2, :armor   # 防具
      item = $data_armors[id]
    end

    $game_party.set_recipe_exist(item, enabled) if item != nil
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
  # 合成画面
  ComposeItem = KGC::ComposeItem::VOCAB_COMPOSE_ITEM
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::BaseItem
#==============================================================================

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ クラス変数
  #--------------------------------------------------------------------------
  @@__masked_name =
    KGC::ComposeItem::UNKNOWN_NAME_MASK  # マスク名
  @@__expand_masked_name = false         # マスク名拡張表示フラグ

  if @@__masked_name != nil
    @@__expand_masked_name = (@@__masked_name.scan(/./).size == 1)
  end
  #--------------------------------------------------------------------------
  # ○ アイテム合成のキャッシュ生成
  #--------------------------------------------------------------------------
  def create_compose_item_cache
    @__compose_cost = 0
    @__compose_materials = []

    # レシピ取得
    recipe = nil
    case self
    when RPG::Item    # アイテム
      recipe = KGC::ComposeItem::RECIPE_ITEM[self.id]
    when RPG::Weapon  # 武器
      recipe = KGC::ComposeItem::RECIPE_WEAPON[self.id]
    when RPG::Armor   # 防具
      recipe = KGC::ComposeItem::RECIPE_ARMOR[self.id]
    end
    return if recipe == nil
    recipe = recipe.dup

    @__compose_cost = recipe.shift
    # 素材リストを作成
    recipe.each { |r|
      if r =~ KGC::ComposeItem::Regexp::RECIPE
        material = Game_ComposeMaterial.new
        material.kind = $1.upcase                    # 素材の種類を取得
        material.id = $2.to_i                        # 素材の ID を取得
        if $3 != nil
          material.number = [$3[/\d+/].to_i, 0].max  # 必要数を取得
        end
        @__compose_materials << material
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ マスク名
  #--------------------------------------------------------------------------
  def masked_name
    if @@__expand_masked_name
      # マスク名を拡張して表示
      return @@__masked_name * self.name.scan(/./).size
    else
      return @@__masked_name
    end
  end
  #--------------------------------------------------------------------------
  # ○ 合成用費用
  #--------------------------------------------------------------------------
  def compose_cost
    create_compose_item_cache if @__compose_cost == nil
    return @__compose_cost
  end
  #--------------------------------------------------------------------------
  # ○ 合成用素材リスト
  #--------------------------------------------------------------------------
  def compose_materials
    create_compose_item_cache if @__compose_materials == nil
    return @__compose_materials
  end
  #--------------------------------------------------------------------------
  # ○ 合成アイテムか
  #--------------------------------------------------------------------------
  def is_compose?
    return !compose_materials.empty?
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ○ 合成済みフラグをクリア
  #--------------------------------------------------------------------------
  def clear_composed_flag
    @item_composed = {}
    @weapon_composed = {}
    @armor_composed = {}
  end
  #--------------------------------------------------------------------------
  # ○ レシピ判明フラグをクリア
  #--------------------------------------------------------------------------
  def clear_recipe_cleared_flag
    @item_recipe_cleared = {}
    @weapon_recipe_cleared = {}
    @armor_recipe_cleared = {}
  end
  #--------------------------------------------------------------------------
  # ○ レシピ解禁フラグをクリア
  #--------------------------------------------------------------------------
  def clear_recipe_opened_flag
    @item_recipe_opened = {}
    @weapon_recipe_opened = {}
    @armor_recipe_opened = {}
  end
  #--------------------------------------------------------------------------
  # ○ レシピ存在フラグをクリア
  #--------------------------------------------------------------------------
  def clear_recipe_exist_flag
    @item_recipe_exist = {}
    @weapon_recipe_exist = {}
    @armor_recipe_exist = {}
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの合成済みフラグを設定
  #     item : アイテム
  #     flag : true..合成済み  false..未合成
  #--------------------------------------------------------------------------
  def set_item_composed(item, flag = true)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 合成済みフラグを格納するハッシュを作成
    clear_composed_flag if @item_composed == nil

    # 合成済みフラグをセット
    case item
    when RPG::Item    # アイテム
      @item_composed[item.id] = flag
    when RPG::Weapon  # 武器
      @weapon_composed[item.id] = flag
    when RPG::Armor   # 防具
      @armor_composed[item.id] = flag
    end
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの合成済み判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_composed?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 合成済みフラグを格納するハッシュを作成
    clear_composed_flag if @item_composed == nil

    # 合成済み判定
    case item
    when RPG::Item    # アイテム
      return @item_composed[item.id]
    when RPG::Weapon  # 武器
      return @weapon_composed[item.id]
    when RPG::Armor   # 防具
      return @armor_composed[item.id]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの合成済みフラグを設定
  #     item : アイテム
  #     flag : true..合成済み  false..未合成
  #--------------------------------------------------------------------------
  def set_item_composed(item, flag = true)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 合成済みフラグを格納するハッシュを作成
    clear_composed_flag if @item_composed == nil

    # 合成済みフラグをセット
    case item
    when RPG::Item    # アイテム
      @item_composed[item.id] = flag
    when RPG::Weapon  # 武器
      @weapon_composed[item.id] = flag
    when RPG::Armor   # 防具
      @armor_composed[item.id] = flag
    end
  end
  #--------------------------------------------------------------------------
  # ○ レシピ判明判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def recipe_cleared?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 判明フラグを格納するハッシュを作成
    clear_recipe_cleared_flag if @item_recipe_cleared == nil

    # 判定
    case item
    when RPG::Item    # アイテム
      return @item_recipe_cleared[item.id]
    when RPG::Weapon  # 武器
      return @weapon_recipe_cleared[item.id]
    when RPG::Armor   # 防具
      return @armor_recipe_cleared[item.id]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの判明フラグを設定
  #     item : アイテム
  #     flag : true..判明  false..未判明
  #--------------------------------------------------------------------------
  def set_recipe_cleared(item, flag = true)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 判明フラグを格納するハッシュを作成
    clear_recipe_cleared_flag if @item_recipe_cleared == nil

    # 判明フラグをセット
    case item
    when RPG::Item    # アイテム
      @item_recipe_cleared[item.id] = flag
    when RPG::Weapon  # 武器
      @weapon_recipe_cleared[item.id] = flag
    when RPG::Armor   # 防具
      @armor_recipe_cleared[item.id] = flag
    end
  end
  #--------------------------------------------------------------------------
  # ○ レシピ解禁判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def recipe_opened?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 解禁フラグを格納するハッシュを作成
    clear_recipe_opened_flag if @item_recipe_opened == nil

    # 判定
    case item
    when RPG::Item    # アイテム
      return @item_recipe_opened[item.id]
    when RPG::Weapon  # 武器
      return @weapon_recipe_opened[item.id]
    when RPG::Armor   # 防具
      return @armor_recipe_opened[item.id]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの解禁フラグを設定
  #     item : アイテム
  #     flag : true..解禁  false..未解禁
  #--------------------------------------------------------------------------
  def set_recipe_opened(item, flag = true)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 解禁フラグを格納するハッシュを作成
    clear_recipe_opened_flag if @item_recipe_opened == nil

    # 解禁フラグをセット
    case item
    when RPG::Item    # アイテム
      @item_recipe_opened[item.id] = flag
    when RPG::Weapon  # 武器
      @weapon_recipe_opened[item.id] = flag
    when RPG::Armor   # 防具
      @armor_recipe_opened[item.id] = flag
    end
  end
  #--------------------------------------------------------------------------
  # ○ レシピ存在判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def recipe_exist?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 存在フラグを格納するハッシュを作成
    clear_recipe_exist_flag if @item_recipe_exist == nil

    # 判定
    case item
    when RPG::Item    # アイテム
      return @item_recipe_exist[item.id]
    when RPG::Weapon  # 武器
      return @weapon_recipe_exist[item.id]
    when RPG::Armor   # 防具
      return @armor_recipe_exist[item.id]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの存在フラグを設定
  #     item : アイテム
  #     flag : true..存在  false..存在しない
  #--------------------------------------------------------------------------
  def set_recipe_exist(item, flag = true)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    # 存在フラグを格納するハッシュを作成
    clear_recipe_exist_flag if @item_recipe_exist == nil

    # 存在フラグをセット
    case item
    when RPG::Item    # アイテム
      @item_recipe_exist[item.id] = flag
    when RPG::Weapon  # 武器
      @weapon_recipe_exist[item.id] = flag
    when RPG::Armor   # 防具
      @armor_recipe_exist[item.id] = flag
    end
  end
  #--------------------------------------------------------------------------
  # ○ アイテム名マスク判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_name_mask?(item)
    return false unless KGC::ComposeItem::MASK_UNKNOWN_RECIPE_NAME
    return false if item_composed?(item)   # 合成済み
    return false if recipe_cleared?(item)  # 判明済み

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 素材非表示判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_compose_material_mask?(item)
    return false unless KGC::ComposeItem::HIDE_UNKNOWN_RECIPE_MATERIAL
    return false if item_composed?(item)   # 合成済み
    return false if recipe_cleared?(item)  # 判明済み
    return false if recipe_opened?(item)   # 解禁済み

    return true
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの合成可能判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_can_compose?(item)
    return false unless item_compose_cost_satisfy?(item)
    return false unless item_compose_material_satisfy?(item)

    return true
  end
  #--------------------------------------------------------------------------
  # ○ 合成アイテムの資金充足判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_compose_cost_satisfy?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    return (gold >= item.compose_cost)
  end
  #--------------------------------------------------------------------------
  # ○ 合成アイテムの素材充足判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_compose_material_satisfy?(item)
    return false unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return false unless item.is_compose?           # 合成アイテム以外

    item.compose_materials.each { |material|
      num = item_number(material.item)
      return false if num < material.number || num == 0  # 素材不足
    }
    return true
  end
  #--------------------------------------------------------------------------
  # ○ アイテムの合成可能数を取得
  #     item : アイテム
  #--------------------------------------------------------------------------
  def number_of_composable(item)
    return 0 unless item.is_a?(RPG::BaseItem)  # アイテム以外
    return 0 unless item.is_compose?           # 合成アイテム以外

    number = ($imported["LimitBreak"] ? item.number_limit : 99)
    if item.compose_cost > 0
      number = [number, gold / item.compose_cost].min
    end
    # 素材数判定
    item.compose_materials.each { |material|
      next if material.number == 0  # 必要数 0 は無視
      n = item_number(material.item) / material.number
      number = [number, n].min
    }
    return number
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Game_ComposeMaterial
#------------------------------------------------------------------------------
#   合成素材の情報を格納するクラスです。
#==============================================================================

class Game_ComposeMaterial
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :kind                     # アイテムの種類 (/[IWA]/)
  attr_accessor :id                       # アイテムの ID
  attr_accessor :number                   # 必要数
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @kind = "I"
    @id = 0
    @number = 1
  end
  #--------------------------------------------------------------------------
  # ○ アイテム取得
  #--------------------------------------------------------------------------
  def item
    case @kind
    when "I"  # アイテム
      return $data_items[@id]
    when "W"  # 武器
      return $data_weapons[@id]
    when "A"  # 防具
      return $data_armors[@id]
    else
      return nil
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Base
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ○ マスク済みアイテム名の描画
  #     item    : アイテム (スキル、武器、防具でも可)
  #     x       : 描画先 X 座標
  #     y       : 描画先 Y 座標
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_masked_item_name(item, x, y, enabled = true)
    return if item == nil

    draw_icon(item.icon_index, x, y, enabled)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x + 24, y, 172, WLH, item.masked_name)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_ComposeNumber
#------------------------------------------------------------------------------
#   合成画面で、合成するアイテムの個数を入力するウィンドウです。
#==============================================================================

class Window_ComposeNumber < Window_ShopNumber
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :sell_flag                # 売却フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  alias initialize_KGC_ComposeItem initialize unless $@
  def initialize(x, y)
    @sell_flag = false

    initialize_KGC_ComposeItem(x, y)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    y = 96
    self.contents.clear
    if @sell_flag || !$game_party.item_name_mask?(@item)
      draw_item_name(@item, 0, y)
    else
      draw_masked_item_name(@item, 0, y)
    end
    self.contents.font.color = normal_color
    self.contents.draw_text(212, y, 20, WLH, "×")
    self.contents.draw_text(248, y, 20, WLH, @number, 2)
    self.cursor_rect.set(244, y, 28, WLH)
    if !KGC::ComposeItem::HIDE_ZERO_COST || @price > 0
      draw_currency_value(@price * @number, 4, y + WLH * 2, 264)
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_ComposeItem
#------------------------------------------------------------------------------
#   合成画面で、合成できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_ComposeItem < Window_ShopBuy
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for goods_item in @shop_goods
      case goods_item[0]
      when 0
        item = $data_items[goods_item[1]]
      when 1
        item = $data_weapons[goods_item[1]]
      when 2
        item = $data_armors[goods_item[1]]
      end
      # 合成アイテムのみ追加
      @data.push(item) if include?(item)
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ○ アイテムをリストに含めるかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def include?(item)
    return false if item == nil           # アイテムが nil なら含めない
    return false unless item.is_compose?  # 合成アイテム以外は含めない

    # 合成済みなら表示
    if KGC::ComposeItem::SHOW_COMPOSED_RECIPE
      return true if $game_party.item_composed?(item)
    end
    # 判明 or 解禁 or 存在済みなら表示
    exist_flag = $game_party.recipe_cleared?(item) ||
      $game_party.recipe_opened?(item) || $game_party.recipe_exist?(item)
    if KGC::ComposeItem::NEED_RECIPE_EXIST && exist_flag
      return true
    end
    # 費用不足なら隠す
    if KGC::ComposeItem::HIDE_SHORTAGE_COST
      return false unless $game_party.item_compose_cost_satisfy?(item)
    end
    # 素材不足なら隠す
    if KGC::ComposeItem::HIDE_SHORTAGE_MATERIAL
      return false unless $game_party.item_compose_material_satisfy?(item)
    end

    if KGC::ComposeItem::NEED_RECIPE_EXIST
      # 判明 or 解禁 or 存在していない
      return false unless exist_flag
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ○ アイテムを許可状態で表示するかどうか
  #     item : アイテム
  #--------------------------------------------------------------------------
  def enable?(item)
    return $game_party.item_can_compose?(item)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    number = $game_party.item_number(item)
    limit = ($imported["LimitBreak"] ? item.number_limit : 99)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    if $game_party.item_name_mask?(item)
      draw_masked_item_name(item, rect.x, rect.y, enable?(item))
    else
      draw_item_name(item, rect.x, rect.y, enable?(item))
    end
    # 費用を描画
    if !KGC::ComposeItem::HIDE_ZERO_COST || item.compose_cost > 0
      rect.width -= 4
      self.contents.draw_text(rect, item.compose_cost, 2)
    end
  end

  if KGC::ComposeItem::HIDE_UNKNOWN_RECIPE_HELP
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    item = (index >= 0 ? @data[index] : nil)
    if item == nil || !$game_party.item_name_mask?(item)
      # アイテムが nil or マスクなしなら [Window_ShopBuy] に任せる
      super
    else
      @help_window.set_text(KGC::ComposeItem::UNKNOWN_RECIPE_HELP)
    end
  end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Window_ComposeStatus
#------------------------------------------------------------------------------
# 　合成画面で、素材の所持数や必要数を表示するウィンドウです。
#==============================================================================

class Window_ComposeStatus < Window_ShopStatus
  #--------------------------------------------------------------------------
  # ○ 表示モード
  #--------------------------------------------------------------------------
  MODE_MATERIAL = 0  # 素材リスト
  MODE_STATUS   = 1  # パーティのステータス
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @mode = MODE_MATERIAL
    super(x, y)
  end
  #--------------------------------------------------------------------------
  # ○ モード変更
  #--------------------------------------------------------------------------
  def change_mode
    case @mode
    when MODE_MATERIAL
      @mode = MODE_STATUS
    when MODE_STATUS
      @mode = MODE_MATERIAL
    end
    self.oy = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    if @mode == MODE_STATUS
      super
      return
    end

    self.contents.dispose
    ch = height - 32
    if @item != nil
      mag = (KGC::ComposeItem::COMPACT_MATERIAL_LIST ? 1 : 2)
      ch = [ch, WLH * (mag + @item.compose_materials.size * mag)].max
    end
    self.contents = Bitmap.new(width - 32, ch)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    self.contents.font.size = Font.default_size
    case @mode
    when MODE_MATERIAL
      draw_material_list
    when MODE_STATUS
      super
    end
  end
  #--------------------------------------------------------------------------
  # ○ 素材リストを描画
  #--------------------------------------------------------------------------
  def draw_material_list
    return if @item == nil

    number = $game_party.item_number(@item)
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 200, WLH, Vocab::Possession)
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 0, 200, WLH, number, 2)

    # 不明な素材を隠す
    if $game_party.item_compose_material_mask?(@item)
      self.contents.draw_text(4, WLH * 2, 200, WLH,
        KGC::ComposeItem::UNKNOWN_RECIPE_MATERIAL, 1)
      return
    end

    self.contents.font.size = 16 if KGC::ComposeItem::COMPACT_MATERIAL_LIST
    mag = (KGC::ComposeItem::COMPACT_MATERIAL_LIST ? 1 : 2)
    @item.compose_materials.each_with_index { |material, i|
      y = WLH * (mag + i * mag)
      draw_material_info(0, y, material)
    }
  end
  #--------------------------------------------------------------------------
  # ○ 素材情報を描画
  #--------------------------------------------------------------------------
  def draw_material_info(x, y, material)
    m_item = material.item
    return if m_item == nil
    number = $game_party.item_number(m_item)
    enabled = (number > 0 && number >= material.number)
    draw_item_name(m_item, x, y, enabled)
    if KGC::ComposeItem::COMPACT_MATERIAL_LIST
      m_number = (material.number == 0 ? "-" : sprintf("%d", material.number))
      self.contents.draw_text(x, y, width - 32, WLH,
        sprintf("%s/%d", m_number, number), 2)
    else
      m_number = (material.number == 0 ? "-" : sprintf("%2d", material.number))
      self.contents.draw_text(x, y + WLH, width - 32, WLH,
        sprintf("%2s/%2d", m_number, number), 2)
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Map
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● ショップ画面への切り替え
  #--------------------------------------------------------------------------
  alias call_shop_KGC_ComposeItem call_shop
  def call_shop
    # 合成画面を呼び出した場合
    if $game_switches[KGC::ComposeItem::COMPOSE_CALL_SWITCH]
      # 合成画面に移行
      $game_temp.next_scene = nil
      $game_switches[KGC::ComposeItem::COMPOSE_CALL_SWITCH] = false
      $scene = Scene_ComposeItem.new
    else
      call_shop_KGC_ComposeItem
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ Scene_ComposeItem
#------------------------------------------------------------------------------
# 　合成画面の処理を行うクラスです。(Scene_Shop を流用)
#==============================================================================

class Scene_ComposeItem < Scene_Shop
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # コマンドウィンドウ非表示
    if KGC::ComposeItem::HIDE_COMMAND_WINDOW
      @command_window.visible = false
      @gold_window.y = Graphics.height - @gold_window.height
      @gold_window.z = @status_window.z + 100
      @gold_window.visible = !KGC::ComposeItem::HIDE_GOLD_WINDOW

      @dummy_window.y = @command_window.y
      @dummy_window.height += @command_window.height
    end

    # [Scene_Shop] 再利用のため、合成リストに @buy_window を使用
    @buy_window.dispose
    @buy_window = Window_ComposeItem.new(0, @dummy_window.y)
    @buy_window.height = @dummy_window.height
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window

    # その他のウィンドウを再構成
    @number_window.dispose
    @number_window = Window_ComposeNumber.new(0, @buy_window.y)
    @number_window.height = @buy_window.height
    @number_window.create_contents
    @number_window.active = false
    @number_window.visible = false

    @status_window.dispose
    @status_window = Window_ComposeStatus.new(@buy_window.width, @buy_window.y)
    @status_window.height = @buy_window.height
    @status_window.create_contents
    @status_window.visible = false

    # コマンドウィンドウ非表示の場合、合成ウィンドウに切り替え
    if KGC::ComposeItem::HIDE_COMMAND_WINDOW
      @command_window.active = false
      @dummy_window.visible = false
      @buy_window.active = true
      @buy_window.visible = true
      @buy_window.update_help
      @status_window.visible = true
      @status_window.item = @buy_window.item
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::ComposeItem
    s2 = Vocab::ShopSell
    s3 = Vocab::ShopCancel
    @command_window = Window_Command.new(384, [s1, s2, s3], 3)
    @command_window.y = 56
    if $game_temp.shop_purchase_only
      @command_window.draw_item(1, false)
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if KGC::ComposeItem::SWITCH_INFO_BUTTON != nil &&
        Input.trigger?(KGC::ComposeItem::SWITCH_INFO_BUTTON)
      Sound.play_cursor
      @status_window.change_mode
    end
  end
  #--------------------------------------------------------------------------
  # ● 購入アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_buy_selection
    @number_window.sell_flag = false

    # コマンドウィンドウ非表示で B ボタンが押された場合
    if KGC::ComposeItem::HIDE_COMMAND_WINDOW && Input.trigger?(Input::B)
      Sound.play_cancel
      $scene = Scene_Map.new
      return
    end

    @status_window.item = @buy_window.item
    if Input.trigger?(Input::C)
      @item = @buy_window.item
      # アイテムが無効なら選択不可
      if @item == nil
        Sound.play_buzzer
        return
      end

      # 合成不可能 or 限界数まで所持している場合は選択不可
      number = $game_party.item_number(@item)
      limit = ($imported["LimitBreak"] ? @item.number_limit : 99)
      if !$game_party.item_can_compose?(@item) || number == limit
        Sound.play_buzzer
        return
      end

      # 個数入力に切り替え
      Sound.play_decision
      max = $game_party.number_of_composable(@item)
      max = [max, limit - number].min
      @buy_window.active = false
      @buy_window.visible = false
      @number_window.set(@item, max, @item.compose_cost)
      @number_window.active = true
      @number_window.visible = true
      return
    end

    super
  end
  #--------------------------------------------------------------------------
  # ● 売却アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_sell_selection
    @number_window.sell_flag = true
    super
  end
  #--------------------------------------------------------------------------
  # ● 個数入力の決定
  #--------------------------------------------------------------------------
  def decide_number_input
    if @command_window.index != 0  # 「合成する」以外
      super
      return
    end

    Sound.play_shop
    @number_window.active = false
    @number_window.visible = false
    # 合成処理
    operation_compose
    @gold_window.refresh
    @buy_window.refresh
    @status_window.refresh
    @buy_window.active = true
    @buy_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ○ 合成の処理
  #--------------------------------------------------------------------------
  def operation_compose
    $game_party.lose_gold(@number_window.number * @item.compose_cost)
    $game_party.gain_item(@item, @number_window.number)
    # 素材を減らす
    @item.compose_materials.each { |material|
      $game_party.lose_item(material.item,
        material.number * @number_window.number)
    }
    # 合成済みにする
    $game_party.set_item_composed(@item)
  end
end
