#~ fore開発室
#==============================================================================
# ■ Window_OrgCommand
#------------------------------------------------------------------------------
# 　自作コマンドウィンドウです。
#==============================================================================

class Window_OrgCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :variable             # 選んだコマンド番号を格納する変数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(menu_index,width,x,y,column_max,row_max,variable,commands)
    @contents_height = ((commands.size + column_max - 1) / column_max) * WLH
    super(width, commands, column_max,row_max)
    self.z = 200
    self.x = x
    self.y = y
    if menu_index >= 1 and menu_index <= commands.size then
      self.index = menu_index - 1
    end
    # コマンドが無効であれば半透明表示(superですでにdraw_item(i,true)がされている)
    for i in 0...commands.size             # commands.size -1 ではだめらしい
      if $orgmenu_temp.inactivities[i] == true
        draw_item(i, false)
      end
    end
    @variable = variable
    self.openness = 255
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, @contents_height)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    return if self.openness != 255      # ウィンドウが開き切ってから
    update_command_selection
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      $game_variables[@variable] = 0
      $orgmenu_temp.state = 3
      @help_window.dispose  if @help_window != nil      # ヘルプウィンドウ破棄
    elsif Input.trigger?(Input::C)
      if $orgmenu_temp.inactivities[@index] == true
        Sound.play_buzzer
        return
      end
      Sound.play_decision
      $game_variables[@variable] = @index + 1
      $orgmenu_temp.state = 3
      @help_window.dispose  if @help_window != nil      # ヘルプウィンドウ破棄
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの更新
  #--------------------------------------------------------------------------
  def call_update_help
    # カーソル位置に対応する自作ウィンドウIDを取得
    id = $orgmenu_temp.help_window_ids[@index]
    # ヘルプウィンドウ表示
    if (@help_window == nil) and (id != nil) then
      window = Fore_OrgWindow::search_window_data(id)
      @help_window = Window_Base_Org.new(window)  if window != nil
    end
    # ヘルプウィンドウ更新
    if (@help_window != nil) and (id != @help_window.id) then
      @help_window.dispose
      @help_window = nil               # disposeされてもインスタンスはnilではない
      return if id == nil
      window = Fore_OrgWindow::search_window_data(id)
      @help_window = Window_Base_Org.new(window)  if window != nil
    end
  end
end

#==============================================================================
# □ Fore_OrgMenu
#------------------------------------------------------------------------------
# 　イベントから呼び出す関数群
#==============================================================================

module Fore_OrgMenu

  module_function
  #--------------------------------------------------------------------------
  # ○ 自作メニューの設定
  #--------------------------------------------------------------------------
  def set(width,x,y,column_max,row_max,variable,commands)
    $orgmenu_temp.width = width
    $orgmenu_temp.x = x
    $orgmenu_temp.y = y
    $orgmenu_temp.column_max = column_max
    $orgmenu_temp.row_max = row_max
    $orgmenu_temp.variable = variable
    $orgmenu_temp.commands = commands
    $orgmenu_temp.help_window_ids = []
    $orgmenu_temp.inactivities = []
  end
  #--------------------------------------------------------------------------
  # ○ ヘルプウィンドウの設定
  #--------------------------------------------------------------------------
  def set_help(help_window_ids)
    $orgmenu_temp.help_window_ids = help_window_ids
  end
  #--------------------------------------------------------------------------
  # ○ ヘルプウィンドウの設定(個別)
  #--------------------------------------------------------------------------
  def set_help_one(index,help_window_id)
    $orgmenu_temp.help_window_ids[index - 1] = help_window_id
  end
  #--------------------------------------------------------------------------
  # ○ 自作メニュー画面の呼び出し
  #--------------------------------------------------------------------------
  def call(menu_index = 1)
    return if $game_temp.in_battle
    return if $game_player.moving?    # プレイヤーの移動中？
    $orgmenu_temp.menu_index = menu_index
    $orgmenu_temp.state = 1
    $game_temp.next_scene = 'orgmenu'    # インタプリタ停止用
  end
  #--------------------------------------------------------------------------
  # ○ コマンド追加
  #--------------------------------------------------------------------------
  def add_command(commands)
    $orgmenu_temp.commands.push(commands)
  end
  #--------------------------------------------------------------------------
  # ○ コマンド追加 / キャラ名
  #--------------------------------------------------------------------------
  def add_command_actor(id)
    if id <= 4                # パーティー隊列順 1～4
      actor = $game_party.members[id - 1]
    elsif id >= 101         # データベースのアクター番号
      actor = $game_actors[id - 100]
    end
    return if actor == nil
    $orgmenu_temp.commands.push(actor.name)
  end
  #--------------------------------------------------------------------------
  # ○ コマンド無効化
  #--------------------------------------------------------------------------
  def inactivate(index)
    $orgmenu_temp.inactivities[index - 1] = true
  end
  #--------------------------------------------------------------------------
  # ○ コマンド無効化解除
  #--------------------------------------------------------------------------
  def activate(index)
    $orgmenu_temp.inactivities[index - 1] = nil
  end
  #--------------------------------------------------------------------------
  # ○ 各種画面呼び出し
  #--------------------------------------------------------------------------
  def show_item
    $game_temp.next_scene = "org"
    $scene = Scene_OrgItem.new
  end
  def show_skill(index)
    $game_temp.next_scene = "org"
    $scene = Scene_OrgSkill.new(index-1)
  end
  def show_equip(index)
    $game_temp.next_scene = "org"
    $scene = Scene_OrgEquip.new(index-1)
  end
  def show_status(index)
    $game_temp.next_scene = "org"
    $scene = Scene_OrgStatus.new(index-1)
  end
  def show_end
    $game_temp.next_scene = "org"
    $scene = Scene_OrgEnd.new
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ OrgMenu_Temp
#------------------------------------------------------------------------------
# 　module,window,sceneの橋渡しをするクラス。
#==============================================================================

class OrgMenu_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :menu_index           # カーソルの位置
  attr_accessor   :width                # ウィンドウ幅
  attr_accessor   :x                    # 表示位置
  attr_accessor   :y
  attr_accessor   :column_max           # 列数
  attr_accessor   :row_max              # 行数
  attr_accessor   :variable             # 選んだコマンド番号を格納する変数
  attr_accessor   :commands             # コマンド名の配列
  attr_accessor   :help_window_ids      # ヘルプウィンドウとする自作ウィンドウのIDの配列
  attr_accessor   :inactivities         # コマンドが無効かどうかの配列
  attr_accessor   :state                # コマンドウィンドウの状態
  # 0:非表示 1:表示開始 2:表示中 3:表示終了
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @menu_index = 1
    @width = 100
    @x = 0
    @y = 0
    @column_max = 1
    @row_max = 0
    @variable = 0
    @commands = ['']
    @help_window_ids = []
    @inactivities = []
    @state = 0
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Titleクラスの再定義
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias :orig_create_game_objects :create_game_objects
  def create_game_objects
    orig_create_game_objects
    $orgmenu_temp = OrgMenu_Temp.new
    $orgwindow_temp = OrgWindow_Temp.new
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Mapクラスの再定義
#------------------------------------------------------------------------------
# 　マップ画面の処理を行うクラスです。
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 終了処理(自作ウィンドウ用)
  #--------------------------------------------------------------------------
  alias :orig_terminate :terminate
  def terminate
    orig_terminate
    Fore_OrgWindow::close_all
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias :orig_update :update
  def update
    if $orgmenu_temp.state != 0 then
      update_orgmenu                     # 自作メニューを更新
    elsif $orgwindow_temp.wait_id != nil then
      update_orgwindow                   # 自作ウィンドウを更新
    else
      orig_update
    end
  end
  #--------------------------------------------------------------------------
  # ● 自作メニュー更新
  #--------------------------------------------------------------------------
  def update_orgmenu
    return if $orgmenu_temp == nil
    # メニュー更新
    if $orgmenu_temp.state == 2
      @orgmenu.update
    end
    # メニュー作成
    if $orgmenu_temp.state == 1 then
      create_orgmenu
      $orgmenu_temp.state = 2
    end
    # メニュー解放
    if $orgmenu_temp.state == 3 then
      @orgmenu.dispose
      $orgmenu_temp.state = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 自作ウィンドウ更新
  #--------------------------------------------------------------------------
  def update_orgwindow
    # ウィンドウ更新
    if (Input.trigger?(Input::B)) or (Input.trigger?(Input::C))
      Sound.play_decision
      Fore_OrgWindow::close($orgwindow_temp.wait_id)      # ウィンドウ破棄
      $orgwindow_temp.wait_id = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_orgmenu
    # OrgMenu_Tempからデータを取り出す
    menu_index = $orgmenu_temp.menu_index
    width = $orgmenu_temp.width
    x = $orgmenu_temp.x
    y = $orgmenu_temp.y
    column_max = $orgmenu_temp.column_max
    row_max = $orgmenu_temp.row_max
    variable = $orgmenu_temp.variable
    commands = $orgmenu_temp.commands
    @orgmenu = Window_OrgCommand.new(menu_index,width,x,y,column_max,row_max,variable,commands)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_OrgItem/Skill/Equip/Status/End
#------------------------------------------------------------------------------
# 　自作メニュー用各種画面のクラスです。
#==============================================================================

class Scene_OrgItem < Scene_Item
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
end

class Scene_OrgSkill < Scene_Skill
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● 次のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgSkill.new(@actor_index)
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgSkill.new(@actor_index)
  end
end

class Scene_OrgEquip < Scene_Equip
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● 次のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgEquip.new(@actor_index, @equip_window.index)
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgEquip.new(@actor_index, @equip_window.index)
  end
end

class Scene_OrgStatus < Scene_Status
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene                    
    $scene = Scene_Map.new
  end
  #--------------------------------------------------------------------------
  # ● 次のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgStatus.new(@actor_index)
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターの画面に切り替え
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_OrgStatus.new(@actor_index)
  end
end

class Scene_OrgEnd < Scene_End
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene                    
    $scene = Scene_Map.new
  end
end

#==============================================================================
# □ Fore_OrgWindow
#------------------------------------------------------------------------------
# 　自作ウィンドウに関するモジュール
#==============================================================================

module Fore_OrgWindow
  
  module_function
  #--------------------------------------------------------------------------
  # ○ 指定したIDのOrgWindow_Dataを探す
  #--------------------------------------------------------------------------
  def search_window_data(id)
    result = nil
    $orgwindow_temp.data_array.each do |temp|
      if temp.id == id then
        result = temp
        break
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ○ 指定したIDのウィンドウオブジェクトを探す
  #--------------------------------------------------------------------------
  def search_window_object(id)
    result = nil
    $orgwindow_temp.object_array.each do |temp|
      if temp.id == id then
        result = temp
        break
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ○ 自作ウィンドウの設定
  #--------------------------------------------------------------------------
  def set(id,width,height,x,y, skin = 1)
    window = search_window_data(id)
    if window == nil then
      $orgwindow_temp.data_array.push(OrgWindow_Data.new(id,width,height,x,y,skin))
    else
      window.width = width
      window.height = height
      window.x = x
      window.y = y
      window.skin = skin
      window.contents = []
    end
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の設定：キャラ情報
  #    actorはパーティーのn番目ならn,データベースのアクター番号なら100+n
  #--------------------------------------------------------------------------
  def put_parameter(id,actor,kind,x,y, color = 0)
    window = search_window_data(id)
    if window == nil then
      window = OrgWindow_Data.new(id,100,100,100,100)
      $orgwindow_temp.data_array.push(window)
    end
    window.contents.push(OrgWindow_Contents.new(kind,actor,x,y,color))
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の設定：変数
  #--------------------------------------------------------------------------
  def put_variable(id,index,x,y, color = 0)
    window = search_window_data(id)
    if window == nil then
      window = OrgWindow_Data.new(id,100,100,100,100)
      $orgwindow_temp.data_array.push(window)
    end
    window.contents.push(OrgWindow_Contents.new(23,index,x,y,color))
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の設定：テキスト
  #--------------------------------------------------------------------------
  def put_text(id,text,x,y, color = 0)
    window = search_window_data(id)
    if window == nil then
      window = OrgWindow_Data.new(id,100,100,100,100)
      $orgwindow_temp.data_array.push(window)
    end
    window.contents.push(OrgWindow_Contents.new(24,text,x,y,color))
  end 
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の設定：ピクチャー
  #--------------------------------------------------------------------------
  def put_picture(id,filename,x,y)
    window = search_window_data(id)
    if window == nil then
      window = OrgWindow_Data.new(id,100,100,100,100)
      $orgwindow_temp.data_array.push(window)
    end
    window.contents.push(OrgWindow_Contents.new(25,filename,x,y))
  end 
  #--------------------------------------------------------------------------
  # ○ ウィンドウ内容の設定：ゲージ
  #--------------------------------------------------------------------------
  def put_gauge(id,width,height,var1,var2,col1,col2,x,y)
    window = search_window_data(id)
    if window == nil then
      window = OrgWindow_Data.new(id,100,100,100,100)
      $orgwindow_temp.data_array.push(window)
    end
    # OrgWindow_Contents.infoには配列として格納
    window.contents.push(OrgWindow_Contents.new(26,[width,height,var1,var2,col1,col2],x,y))
  end 
  #--------------------------------------------------------------------------
  # ○ 自作ウィンドウ設定のクリア
  #--------------------------------------------------------------------------
  def clear(id)
    window = search_window_data(id)
    if window != nil then
      $orgwindow_temp.data_array.delete(window)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 自作ウィンドウの表示
  #--------------------------------------------------------------------------
  def open(id, wait = 0)
    window = search_window_data(id)
    if window == nil then
      return
    else
      object = search_window_object(id)
      if object == nil then
        $orgwindow_temp.object_array.push(Window_Base_Org.new(window))
        $orgwindow_temp.wait_id = id    if wait == 1            # ウェイト設定
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(id)
    window = search_window_data(id)
    return  if window == nil
    object = search_window_object(id)
    if object == nil
      open(id)
      return
    end
    object.create_contents
    object.draw_contents(window)
  end
  #--------------------------------------------------------------------------
  # ○ 自作ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close(id)
    object = search_window_object(id)
    if object == nil then
      return
    else
      object.dispose
      $orgwindow_temp.object_array.delete(object)
    end
  end
  #--------------------------------------------------------------------------
  # ○ 自作ウィンドウをすべて閉じる
  #--------------------------------------------------------------------------
  def close_all
    $orgwindow_temp.object_array.each do |object|
      object.dispose
      $orgwindow_temp.object_array.delete(object)
    end
    $orgwindow_temp.object_array = []
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ OrgWindow_Data
#------------------------------------------------------------------------------
# 　自作ウィンドウの情報を管理するクラス。
#   $orgwindow_temp.data_arrayにインスタンスの配列が格納される
#==============================================================================

class OrgWindow_Data
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :id                   # ウィンドウID
  attr_accessor   :width                # ウィンドウ幅
  attr_accessor   :height               # ウィンドウ高さ
  attr_accessor   :x                    # 表示位置
  attr_accessor   :y
  attr_accessor   :contents             # ウィンドウ内容
  attr_accessor   :skin                 # ウィンドウスキンの有無
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(id,width,height,x,y, skin = 1)
    @id = id
    @width = width
    @height = height
    @x = x
    @y = y
    @contents = []
    @skin = skin
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ OrgWindow_Contents
#------------------------------------------------------------------------------
# 　自作ウィンドウの内容についてのクラス。
#   OrgWindow_Data.contentsにインスタンスの配列が格納される
#==============================================================================

class OrgWindow_Contents
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :kind                   # コンテンツの種類
  attr_accessor   :info                   # コンテンツ情報
  attr_accessor   :x                      # x座標
  attr_accessor   :y                      # y座標
  attr_accessor   :color                  # 文字色
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(kind,info,x,y, color = 0)
    @kind = kind
    @info = info
    @x = x
    @y = y
    @color = color
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ OrgWindow_Temp
#------------------------------------------------------------------------------
# 　自作ウィンドウ全体を管理するクラス。
#==============================================================================

class OrgWindow_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :data_array            # OrgWindow_Dataの配列
  attr_accessor   :object_array          # ウィンドウオブジェクトの配列
  attr_accessor   :wait_id               # ウェイト表示中ウィンドウのID
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data_array = []
    @object_array = []
    @wait_id = nil
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_Base_Org
#------------------------------------------------------------------------------
# 　自作ウィンドウのクラスです。
#==============================================================================
class Window_Base_Org < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :id            # ウィンドウID
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(window)         # windowはOrgWindow_Dataオブジェクト
    super(window.x,window.y,window.width,window.height)
    self.z = 200
    @id = window.id
    self.opacity = 0  if window.skin == 0         # ウィンドウスキンの有無
    draw_contents(window)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容描画
  #--------------------------------------------------------------------------
  def draw_contents(window)
    window.contents.each do |content|
      # キャラ情報の場合actorオブジェクトを取得
      if content.kind <= 22                 # HPからPREAGIまで
        if content.info <= 4                # パーティー隊列順 1～4
          actor = $game_party.members[content.info - 1]
        elsif content.info >= 101         # データベースのアクター番号
          actor = $game_actors[content.info - 100]
        end
        next if actor == nil                # アクターが存在しなければ描画しない
      end
      # 座標と文字色の取得
      x = content.x
      y = content.y
      self.contents.font.color = text_color(content.color)
      # 描画
      case content.kind
      when 1                # 名前
        self.contents.draw_text(x, y, 108, WLH, actor.name)
      when 2                # レベル
        self.contents.draw_text(x, y, 60, WLH, actor.level, 2)
      when 3                # 職業
        self.contents.draw_text(x, y, 108, WLH, actor.class.name)
      when 4                # 状態
        draw_actor_state(actor, x, y, width = 96)
      when 5                # 顔グラフィック
        draw_actor_face(actor, x, y, size = 96)
      when 6                # HP/最大HP ゲージつき
        draw_actor_hp(actor, x, y, width = 120)
      when 7                # HP現在値
        if content.color == 0 then
          self.contents.font.color = hp_color(actor)
        end
        self.contents.draw_text(x, y, 60, WLH, actor.hp, 2)
      when 8                # HP最大値
        self.contents.draw_text(x, y, 60, WLH, actor.maxhp, 2)
      when 9                # MP/最大MP ゲージつき
        draw_actor_mp(actor, x, y, width = 120)
      when 10               # MP現在値
        if content.color == 0 then
          self.contents.font.color = mp_color(actor)
        end
        self.contents.draw_text(x, y, 60, WLH, actor.mp, 2)
      when 11               # MP最大値
        self.contents.draw_text(x, y, 60, WLH, actor.maxmp, 2)
      when 12               # 攻撃力
        self.contents.draw_text(x, y, 60, WLH, actor.atk, 2)
      when 13               # 守備力
        self.contents.draw_text(x, y, 60, WLH, actor.def, 2)
      when 14               # 精神力
        self.contents.draw_text(x, y, 60, WLH, actor.spi, 2)
      when 15               # 敏捷性
        self.contents.draw_text(x, y, 60, WLH, actor.agi, 2)
      when 16               # 合計経験値
        self.contents.draw_text(x, y, 60, WLH, actor.exp_s, 2)
      when 17               # 次のレベルまでの経験値
        self.contents.draw_text(x, y, 60, WLH, actor.next_rest_exp_s, 2)
      when 18               # 武器
        draw_item_name(actor.equips[0], x , y)
      when 19               # 盾
        draw_item_name(actor.equips[1], x , y)
      when 20               # 兜
        draw_item_name(actor.equips[2], x , y)
      when 21               # 鎧
        draw_item_name(actor.equips[3], x , y)
      when 22               # 装飾品
        draw_item_name(actor.equips[4], x , y)
      when 23               # 変数
        self.contents.draw_text(x, y, 60, 24, $game_variables[content.info], 2)
      when 24               # テキスト
        self.contents.draw_text(x, y, 544, 24, content.info)
      when 25               # ピクチャー
        bitmap = Cache.picture(content.info)
        rect = Rect.new(0, 0, bitmap.width, bitmap.height)
        self.contents.blt(x, y, bitmap, rect)
      when 26               # ゲージ
        width = content.info[0]
        height = content.info[1]
        ver1 = $game_variables[content.info[2]]
        ver2 = $game_variables[content.info[3]]
        gc1 = text_color(content.info[4])
        gc2 = text_color(content.info[5])
        var1 = 1 if ver1 == 0
        gw = width * ver2 / ver1
        self.contents.fill_rect(x, y, width, height, gauge_back_color)
        self.contents.gradient_fill_rect(x, y, gw, height, gc1, gc2)
      end
    end
  end
end