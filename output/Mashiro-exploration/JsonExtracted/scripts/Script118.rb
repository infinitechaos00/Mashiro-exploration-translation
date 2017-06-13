=begin
      ★ウィンドウスキン変更★
      
      ゲーム中にウィンドウスキンの変更を可能にします。
      
      ● 使い方 ●========================================================
      設定箇所にて指定した変数を変更することにより、
      ゲーム中にウィンドウスキンを変更できます。
      --------------------------------------------------------------------
      "0"が格納されている場合はデフォルトのウィンドウスキンが適用され、
      それ以外の数値が格納されている場合は、その数値に対応した
      ウィンドウスキンが適用されます。
      --------------------------------------------------------------------
      変更する(デフォルトでない)ウィンドウスキンのファイル名は、
      Window_nとしてください。nには0以外の適当な数値を入れます。
      
      例 : 変数に4が格納されている場合、
         : Window_4というファイル名のウィンドウスキンが適用されます。
      --------------------------------------------------------------------
      デフォルトのウィンドウスキンのファイル名は「Window」のままでOKです。
      ====================================================================
      
      ● おまけ ●========================================================
      イベントコマンドより下記のスクリプトを実行すると、
      プレイヤーが任意にウィンドウスキンを変更することのできるシーンに移行します。
        call_skin_selection
      --------------------------------------------------------------------
      マップ上から呼び出されることを想定しています。
      ====================================================================
      
      ver2.30
      
      Last Update : 2012/05/13
      05/13 : 設定項目の追加＆バグの修正をいくつか
      ----------------------2012--------------------------
      12/14 : ソースコードの見直し
      ----------------------2011--------------------------
      07/02 : updateメソッドが呼ばれているウィンドウならば、
      　　　: 変数を変更した瞬間にスキンが変わるようにした。
      ----------------------2010--------------------------
      04/21 : 記述の一部をスッキリ
            : 適当すぎたウィンドウデザインを、微妙に変更
      03/03 : 導入状況の判定を追加（動作に変更はありません）
      02/28 : スクリプトの仕様を色々と変更。
            : ５つ以上のウィンドウスキンを変更できるようになり、
            : 使用方法も変わりました。
            : おまけ機能を追加。
      01/07 : 新規
      ----------------------2009--------------------------

      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

#===================================
#  ●設定箇所
#===================================
module Rokan
module Change_Window
  # ウィンドウスキン変更に使用する変数番号
  WINDOW_V = 100
  
  # ウィンドウスキン毎の詳細設定
  # ここに設定のないスキンにはデフォルトの値が利用されます
  #【形式】
  #   ① => [②, ③, ④],
  #     ① 対象のスキンに対応する番号
  #     ② ウィンドウ背景の透明度(0-255)
  #     ③ 描画する文字に影をつけるか(true/ false)
  #     ④ 基本文字色の設定(スキンに依存)
  WINDOW_P = {
    1 => [200, true, 0], # デフォルト
  }
  
  # ウィンドウスキンに名前を設定する(スキン変更シーンを利用しない場合は設定不要)
  #【形式】
  #   ① => ②,
  #     ① 対象のスキンに対応する番号(数値)
  #     ② ウィンドウスキンの名前(文字列)
  WSN = {
    0 => "デフォルト",   
  }
end
end
#===================================
#  ここまで
#===================================

$rsi ||= {}
$rsi["ウィンドウスキン変更"] = true

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● ウィンドウ選択シーンへ移行
  #--------------------------------------------------------------------------
  def call_skin_selection
    $scene = Scene_Select_Window.new
  end
end

class Window_Base < Window
  @@ws_index = 0
  def self.skin_id_change(value)
    @@ws_index = value
  end
  #--------------------------------------------------------------------------
  # ● インクルード Rokan::Change_Window
  #--------------------------------------------------------------------------
  include Rokan::Change_Window
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias change_skin initialize
  def initialize(x, y, width, height)
    change_skin(x, y, width, height)
    change_window_skin
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias observation_change_window update
  def update
    observation_change_window
    update_skin
  end
  #--------------------------------------------------------------------------
  # ● スキンの更新（変更がある場合、全てのウィンドウに対して処理を行う）
  #--------------------------------------------------------------------------
  def update_skin
    if @@ws_index != $game_variables[WINDOW_V]
      @@ws_index = $game_variables[WINDOW_V]
      ObjectSpace.each_object(Window_Base){|window|
        window.change_window_skin unless window.disposed?
      }
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウスキンの適用
  #--------------------------------------------------------------------------
  def change_window_skin
    self.windowskin = Cache.system(@@ws_index.zero? ? "Window" : "Window_#{@@ws_index}")
    if WINDOW_P.has_key?(@@ws_index)
      self.back_opacity = WINDOW_P[@@ws_index][0]
      self.contents.font.shadow = WINDOW_P[@@ws_index][1]
      @skin_nomalcolor = WINDOW_P[@@ws_index][2]
    elsif WINDOW_P.has_key?(0)
      self.back_opacity = WINDOW_P[0][0]
      self.contents.font.shadow = WINDOW_P[0][1]
      @skin_nomalcolor = WINDOW_P[0][2]
    else
      self.back_opacity = 200
      self.contents.font.shadow = Font.default_shadow
      @skin_nomalcolor = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 文字色取得
  #--------------------------------------------------------------------------
  alias skin_color text_color
  def text_color(n)
    n.zero? ? skin_color(@skin_nomalcolor) : skin_color(n)
  end
end

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  alias selectable_update_skin create_contents
  def create_contents
    selectable_update_skin
    change_window_skin
  end
end

class Window_Type_Select < Window_Base
  #--------------------------------------------------------------------------
  # ● インクルード Rokan::Change_Window
  #--------------------------------------------------------------------------
  include Rokan::Change_Window
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 350, 100)
    self.x = 544 / 2 - self.width / 2
    self.y = 416 / 2 - self.height / 2
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = system_color
    self.contents.draw_text(0, 5, self.width - 32, WLH, "ウィンドウスキンを選択してください", 1)
    self.contents.font.color = normal_color
    self.contents.font.size = 23
    self.contents.font.italic = true
    self.contents.draw_text(0, WLH + 10, self.width - 32, WLH, "- #{WSN[$game_variables[WINDOW_V]]} -", 1)
    self.contents.font.italic = false
    self.contents.font.bold = true
    self.contents.draw_text(0, WLH + 10, self.width - 32, WLH, "<<", 0)
    self.contents.draw_text(0, WLH + 10, self.width - 32, WLH, ">>", 2)
    self.contents.font.size = 20
    self.contents.font.bold = false
  end
end

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● インクルード Rokan::Change_Window
  #--------------------------------------------------------------------------
  include Rokan::Change_Window
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias ini_skin create_game_objects
  def create_game_objects
    ini_skin
    Window_Base.skin_id_change($game_variables[WINDOW_V])
  end
end

class Scene_Select_Window < Scene_Base
  #--------------------------------------------------------------------------
  # ● インクルード Rokan::Change_Window
  #--------------------------------------------------------------------------
  include Rokan::Change_Window
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    create_window
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @type_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_window
    @type_window = Window_Type_Select.new
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @type_window.update
    if Input.trigger?(Input::B)
      Sound.play_cancel
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::RIGHT)
      Sound.play_decision
      list = WSN.keys.sort
      $game_variables[WINDOW_V] = list[list.index($game_variables[WINDOW_V]).next]
      $game_variables[WINDOW_V] = list.first unless $game_variables[WINDOW_V]
      @type_window.update
      @type_window.refresh
    elsif Input.trigger?(Input::LEFT)
      Sound.play_decision
      list = WSN.keys.sort
      $game_variables[WINDOW_V] = list[list.index($game_variables[WINDOW_V]) - 1]
      $game_variables[WINDOW_V] = list.last unless $game_variables[WINDOW_V]
      @type_window.update
      @type_window.refresh
    end
  end
end