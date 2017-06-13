#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ ヘルプウィンドウ機能拡張 - KGC_HelpExtension ◆ VX ◆
#_/    ◇ Last update : 2007/12/19 ◇
#_/----------------------------------------------------------------------------
#_/  ヘルプウィンドウの機能を強化します。
#_/============================================================================
#_/  VX用≪書式指定文字描画[DrawFormatText]≫が必要
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#~ [Window_Help]の機能を拡張するスクリプトです。
#~     複数行表示可能。| (縦線) または \n を入れるとそこで改行。
#~     制御文字 \C[x] \G \N[x] \V[x] を使用可能。
#~     \G はゴールドウィンドウではなく、所持金を文字列として表示。
#~     Window_Help#row_max に行数を代入するだけで行数を変更可能。
#==============================================================================
# ★ カスタマイズ項目 ★
#==============================================================================

module KGC
module HelpExtension
  # ◆ヘルプウィンドウの行数
  ROW_MAX = 2

  # ◆ショップ画面のステータスウィンドウスクロール時に使用するボタン
  SHOP_STATUS_SCROLL_BUTTON = Input::A
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["HelpExtension"] = true

#==============================================================================
# ■ Window_Help
#==============================================================================

class Window_Help < Window_Base
  attr_reader :row_max
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_HelpExtension initialize
  def initialize
    @row_max = 1

    initialize_KGC_HelpExtension
  end
  #--------------------------------------------------------------------------
  # ● 行数設定
  #--------------------------------------------------------------------------
  def row_max=(value)
    @row_max = [value, 1].max
    self.height = WLH * @row_max + 32
    create_contents

    # 内容修復
    text = @text
    align = @align
    @text = @align = nil
    set_text(text, align)
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text, align = 0)
    if text != @text or align != @align
      self.contents.clear
      self.contents.font.color = normal_color
      font_buf = self.contents.font.clone
      # \N[x] を改行と見なさないように変換
      buf = text.gsub(/\\N(\[\d+\])/i) { "\\__#{$1}" }
      lines = buf.split(/(?:[|]|\\n)/i)
      lines.each_with_index { |l, i|
        # 変換した \N[x] を戻して描画
        l.gsub!(/\\__(\[\d+\])/i) { "\\N#{$1}" }
        self.contents.draw_format_text(4, i * WLH, self.width - 40, WLH, l, align)
      }
      self.contents.font = font_buf
      @text = text
      @align = align
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Item
#==============================================================================
class Scene_Item < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_HelpExtension start
  def start
    start_KGC_HelpExtension

    adjust_window_size
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウサイズ調整
  #--------------------------------------------------------------------------
  def adjust_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @item_window.y = @help_window.height
    @item_window.height = Graphics.height - @help_window.height
    @item_window.refresh
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Skill
#==============================================================================

class Scene_Skill < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_HelpExtension start
  def start
    start_KGC_HelpExtension

    adjust_window_size
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウサイズ調整
  #--------------------------------------------------------------------------
  def adjust_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @status_window.y = @help_window.height
    dy = @help_window.height + @status_window.height
    @skill_window.y = dy
    @skill_window.height = Graphics.height - dy
    @skill_window.refresh
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Equip
#==============================================================================

class Scene_Equip < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_HelpExtension start
  def start
    start_KGC_HelpExtension

    adjust_window_size
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウサイズ調整
  #--------------------------------------------------------------------------
  def adjust_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @equip_window.y = @help_window.height
    @status_window.y = @help_window.height
    resize_item_windows
  end
  #--------------------------------------------------------------------------
  # ● アイテムウィンドウのサイズ変更
  #--------------------------------------------------------------------------
  def resize_item_windows
    @item_windows.each { |w|
      dy = @help_window.height + @equip_window.height
      w.y = dy
      w.height = Graphics.height - dy
      w.refresh
    }
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Shop
#==============================================================================

class Scene_Shop < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias start_KGC_HelpExtension start
  def start
    start_KGC_HelpExtension

    adjust_window_size
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウサイズ調整
  #--------------------------------------------------------------------------
  def adjust_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @command_window.y = @help_window.height
    @gold_window.y = @help_window.height
    dy = @help_window.height + @command_window.height
    @dummy_window.y = @buy_window.y = @sell_window.y =
      @number_window.y = @status_window.y = dy
    @dummy_window.height = @buy_window.height =
      @sell_window.height = @number_window.height =
      @status_window.height = Graphics.height - dy
    @dummy_window.create_contents
    @number_window.create_contents
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias udpate_KGC_HelpExtension update
  def update
    if !@command_window.active &&
        Input.press?(KGC::HelpExtension::SHOP_STATUS_SCROLL_BUTTON)
      super
      update_menu_background
      update_scroll_status
      return
    else
      @status_window.cursor_rect.empty
    end

    udpate_KGC_HelpExtension
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウのスクロール処理
  #--------------------------------------------------------------------------
  def update_scroll_status
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

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Battle
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● スキル選択の開始
  #--------------------------------------------------------------------------
  alias start_skill_selection_KGC_HelpExtension start_skill_selection
  def start_skill_selection
    start_skill_selection_KGC_HelpExtension

    adjust_skill_window_size
  end
  #--------------------------------------------------------------------------
  # ● スキルウィンドウのサイズ調整
  #--------------------------------------------------------------------------
  def adjust_skill_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @skill_window.y = @help_window.height
    @skill_window.height = Graphics.height -
      (@help_window.height + @status_window.height)
    @skill_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の開始
  #--------------------------------------------------------------------------
  alias start_item_selection_KGC_HelpExtension start_item_selection
  def start_item_selection
    start_item_selection_KGC_HelpExtension

    adjust_item_window_size
  end
  #--------------------------------------------------------------------------
  # ● アイテムウィンドウのサイズ調整
  #--------------------------------------------------------------------------
  def adjust_item_window_size
    @help_window.row_max = KGC::HelpExtension::ROW_MAX
    @item_window.y = @help_window.height
    @item_window.height = Graphics.height -
      (@help_window.height + @status_window.height)
    @item_window.refresh
  end
end
