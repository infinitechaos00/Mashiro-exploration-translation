#==============================================================================
# ★ ExMenu_IncreaseSaveFile
#------------------------------------------------------------------------------
# 　セーブファイル数の上限を設定できるようにするスクリプト素材です。
#==============================================================================

# セーブファイルの最大数。
# デフォルトは 4 です。
EXMNU_INCSF_FILE_MAX = 50

# セーブファイルウィンドウの高さ。
# デフォルトは 90 です。通常は変更する必要はありません。
# セーブファイルウィンドウをカスタマイズする際には、この数値を変更すれば
# 各ウィンドウの配置を調節したうえでスクロールに対応させることができます。
EXMNU_INCSF_WINDOW_HEIGHT = 90

#------------------------------------------------------------------------------

class Window_SaveFile
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化 (再定義)
  #     file_index : セーブファイルのインデックス (0～3)
  #     filename   : ファイル名
  #--------------------------------------------------------------------------
  def initialize(file_index, filename)
    wh = EXMNU_INCSF_WINDOW_HEIGHT
    super(0, 56 + file_index % EXMNU_INCSF_FILE_MAX * wh, 544, wh)
    @file_index = file_index
    @filename = filename
    load_gamedata
    refresh
    @selected = false
  end
end

class Scene_File
  alias _exmincrsv_start start
  #--------------------------------------------------------------------------
  # ○ 開始処理 (追加定義)
  #--------------------------------------------------------------------------
  def start
    @file_max = EXMNU_INCSF_FILE_MAX
    _exmincrsv_start
    wh = EXMNU_INCSF_WINDOW_HEIGHT
    adj = (416 - @help_window.height) % wh
    @help_window.height += adj
    @page_file_max = ((416 - @help_window.height) / wh).truncate
    for i in 0...@file_max
      window = @savefile_windows[i]
      if @index > @page_file_max - 1
        if @index < @file_max - @page_file_max - 1
          @top_row = @index
          window.y -= @index * window.height
        elsif @index >= @file_max - @page_file_max
          @top_row = @file_max - @page_file_max
          window.y -= (@file_max - @page_file_max) * window.height
        else
          @top_row = @index
          window.y -= @index * window.height
        end
      end
      window.y += adj
      window.visible = (window.y >= @help_window.height and 
        window.y < @help_window.height + @page_file_max * window.height)
    end
  end
  #--------------------------------------------------------------------------
  # ○ セーブファイルウィンドウの作成 (再定義)
  #--------------------------------------------------------------------------
  def create_savefile_windows
    @top_row = 0
    @savefile_windows = []
    for i in 0...@file_max
      @savefile_windows.push(Window_SaveFile.new(i, make_filename(i)))
    end
  end
  #--------------------------------------------------------------------------
  # ○ カーソルを下に移動 (再定義)
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    if @index < @file_max - 1 or wrap
      @index = (@index + 1) % @file_max
      for i in 0...@file_max
        window = @savefile_windows[i]
        if @index == 0
          @top_row = 0
          window.y = @help_window.height + i % @file_max * window.height
        elsif @index - @top_row > @page_file_max - 1
          window.y -= window.height
        end
        window.visible = (window.y >= @help_window.height and 
          window.y < @help_window.height + @page_file_max * window.height)
      end
      if @index - @top_row > @page_file_max - 1
        @top_row += 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ カーソルを上に移動 (再定義)
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    if @index > 0 or wrap
      @index = (@index - 1 + @file_max) % @file_max
      for i in 0...@file_max
        window = @savefile_windows[i]
        if @index == @file_max - 1
          @top_row = @file_max - @page_file_max
          window.y = @help_window.height + i % @file_max * window.height
          window.y -= (@file_max - @page_file_max) * window.height
        elsif @index - @top_row < 0
          window.y += window.height
        end
        window.visible = (window.y >= @help_window.height and 
          window.y < @help_window.height + @page_file_max * window.height)
      end
      if @index - @top_row < 0
        @top_row -= 1
      end
    end
  end
end

