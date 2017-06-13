#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ タイルセット拡張 - KGC_TilesetExtension ◆ VX ◆
#_/    ◇ Last update : 2008/07/13 ◇
#_/----------------------------------------------------------------------------
#_/  タイル画像変更、４方向通行、地形タグなどの機能を追加します。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
module TilesetExtension
  # ◆ タイル画像ファイル名のプレフィックス
  #  タイル画像ファイル名の先頭に必要な文字列。
  TILE_IMAGE_PREFIX = "Tile"

  # ◆ タイル画像のプリセット
  #  [SET <セット名>] で使用可能。
  TILE_PRESET = {}  # ← これは消さないこと！
  # ここから下に、プリセットを定義。
  # ↓は設定例
  TILE_PRESET["魔王の城"] = {
    "A1"=>"A1-Maou",
    "A2"=>"A2-Maou",
    "B"=>"B-Maou",
    "D"=>"D-Maou",
  }
  # 使うときは、マップ名に [SET 魔王の城] を入れる。

  # ◆ ４方向通行・地形タグ確認ボタン (デバッグ用)
  #  このボタンを押すと、プレイヤーが立っている場所の４方向通行設定と
  #  地形タグをダイアログに表示します。
  #  nil にすると、この機能は無効になります。
  #   ※ この機能はテストプレイ中のみ有効になります。
  DEBUG_INFO_BUTTON = Input::F7
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["TilesetExtension"] = true

if $data_mapinfos == nil
  $data_mapinfos = load_data("Data/MapInfos.rvdata")
end

# 方向フラグ (４方向通行フラグ対応)
module DirectionFlag
  DOWN  = 0x01
  LEFT  = 0x02
  RIGHT = 0x04
  UP    = 0x08
end

module KGC::TilesetExtension
  # 拡張タイルセットのファイル名
  EX_RVDATA = "TilesetEx.rvdata"

  # 正規表現
  module Regexp
    # 継承
    INHERIT = /\[INHERIT\]/i
    # プリセット
    PRESET = /\[SET ([\w\-]+)\]/i
  end

  # デフォルトタイルセットファイル名
  DEFAULT_FILENAME = {
    "A1"=>"TileA1",
    "A2"=>"TileA2",
    "A3"=>"TileA3",
    "A4"=>"TileA4",
    "A5"=>"TileA5",
    "B"=>"TileB",
    "C"=>"TileC",
    "D"=>"TileD",
    "E"=>"TileE"
  }
  @@__filename = DEFAULT_FILENAME.dup

  module_function
  #--------------------------------------------------------------------------
  # ○ 指定マップのタイル画像ファイル名初期化
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  def init_tileset_filename(map_id)
    @@__filename = get_converted_tileset_filename(map_id)
  end
  #--------------------------------------------------------------------------
  # ○ 変換後のタイル画像ファイル名を取得
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  def get_converted_tileset_filename(map_id)
    info = $data_mapinfos[map_id]
    name = info.original_name
    filename = DEFAULT_FILENAME.dup
    if name =~ Regexp::INHERIT
      # 継承する場合は親を調べる
      parent_id = $data_mapinfos[map_id].parent_id
      if parent_id > 0
        filename = get_converted_tileset_filename(parent_id)
      end
    end
    # 現マップの変換規則を適用
    return convert_tileset_filename(filename, name)
  end
  #--------------------------------------------------------------------------
  # ○ タイル画像ファイル名変換
  #     filename : ファイル名 (Hash)
  #     map_name : マップ名
  #--------------------------------------------------------------------------
  def convert_tileset_filename(filename, map_name)
    name_buf = filename.dup
    # プリセット適用
    presets = map_name.scan(Regexp::PRESET)
    presets.each { |s|
      if TILE_PRESET.has_key?(s[0])
        TILE_PRESET[s[0]].each { |k, v|
          name_buf[k] = TILE_IMAGE_PREFIX + v
        }
      end
    }
    # 置換
    DEFAULT_FILENAME.keys.each { |key|
      if map_name =~ /\[#{key} ([\w\-]+)\]/
        name_buf[key] = TILE_IMAGE_PREFIX + $1
      end
    }
    return name_buf
  end
  #--------------------------------------------------------------------------
  # ○ タイル画像ファイル名取得
  #--------------------------------------------------------------------------
  def get_tileset_filename
    return @@__filename
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
  # ○ 指定座標の地形タグ取得
  #     x : マップの X 座標
  #     y : マップの Y 座標
  #     variable_id : 取得した地形タグを代入する変数の ID
  #--------------------------------------------------------------------------
  def get_terrain_tag(x, y, variable_id = 0)
    tag = $game_map.terrain_tag(x, y)       # 指定位置のタグを取得
    if variable_id > 0
      $game_variables[variable_id] = tag    # 指定された変数に代入
    end
    return tag
  end
  #--------------------------------------------------------------------------
  # ○ 指定イベント ID の位置の地形タグ取得
  #     event_id : イベント ID
  #     variable_id : 取得した地形タグを代入する変数の ID
  #--------------------------------------------------------------------------
  def get_event_terrain_tag(event_id, variable_id = 0)
    event = $game_map.events.values.find { |e| e.id == event_id }
    if event == nil
      # 該当するイベントが無ければ 0
      tag = 0
    else
      tag = $game_map.terrain_tag(event.x, event.y)
    end

    # 指定された変数に代入
    if variable_id > 0
      $game_variables[variable_id] = tag
    end
    return tag
  end
  #--------------------------------------------------------------------------
  # ○ プレイヤーの位置の地形タグ取得
  #     variable_id : 取得した地形タグを代入する変数の ID
  #--------------------------------------------------------------------------
  def get_player_terrain_tag(variable_id = 0)
    tag = $game_map.terrain_tag($game_player.x, $game_player.y)

    # 指定された変数に代入
    if variable_id > 0
      $game_variables[variable_id] = tag
    end
    return tag
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
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# □ RPG::Tileset
#------------------------------------------------------------------------------
#   タイルセットの付加的情報を扱うクラスです。
#==============================================================================

class RPG::Tileset
  #--------------------------------------------------------------------------
  # ○ 定数
  #--------------------------------------------------------------------------
  TABLE_SIZE = 8192                       # 通行・地形タグテーブルのサイズ
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :version                  # 内部バージョン
  attr_accessor :passages                 # 4 方向通行フラグ
  attr_accessor :terrain_tags             # 地形タグ
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @version = 1
    @passages = Table.new(TABLE_SIZE)
    @terrain_tags = Table.new(TABLE_SIZE)
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Map
#==============================================================================

class Game_Map
  LAYERS = [2, 1, 0]
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  alias setup_KGC_TilesetExtension setup
  def setup(map_id)
    @map_id = map_id
    init_tileset_filename

    setup_KGC_TilesetExtension(map_id)
  end
  #--------------------------------------------------------------------------
  # ○ タイルセット画像ファイル名を初期化
  #--------------------------------------------------------------------------
  def init_tileset_filename
    KGC::TilesetExtension.init_tileset_filename(@map_id)
  end
  #--------------------------------------------------------------------------
  # ○ 指定座標の通行フラグ取得
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def passage(x, y)
    LAYERS.each { |i|
      tile_id = @map.data[x, y, i]
      return 0 if tile_id == nil
      return $data_tileset.passages[tile_id]
    }
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ 指定座標の地形タグ取得
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def terrain_tag(x, y)
    LAYERS.each { |i|
      tile_id = @map.data[x, y, i]               # タイル ID を取得
      return 0 if tile_id == nil                 # タイル ID 取得失敗 : タグなし
      tag = $data_tileset.terrain_tags[tile_id]  # 地形タグを取得
      return tag if tag > 0                      # タグが設定してあれば返す
    }
    return 0
  end
  #--------------------------------------------------------------------------
  # ○ 指定方向通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #     d : 移動方向
  #--------------------------------------------------------------------------
  def passable_dir?(x, y, d)
    # 方向 (0,2,4,6,8,10) から 通行フラグ (0,1,2,4,8,0) に変換
    flag = (1 << (d / 2 - 1)) & 0x0F

    LAYERS.each { |i|                         # レイヤーの上から順に調べる
      tile_id = @map.data[x, y, i]            # タイル ID を取得
      return false if tile_id == nil          # タイル ID 取得失敗 : 通行不可
      pass = $data_tileset.passages[tile_id]  # タイルセットの通行属性を取得
      return false if pass & flag != 0x00     # フラグが立っていたら通行不可
    }
    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Character
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # ○ 通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #     d : 移動方向 (省略時: 10)
  #--------------------------------------------------------------------------
  def passable?(x, y, d = 10)
    nx = moved_x(x, d)
    ny = moved_y(y, d)
    nx = $game_map.round_x(nx)                         # 横方向ループ補正
    ny = $game_map.round_y(ny)                         # 縦方向ループ補正
    return false unless $game_map.valid?(nx, ny)       # マップ外？
    return true if @through or debug_through?          # すり抜け ON？
    return false unless map_passable?(x, y, d)         # 指定方向に移動不能？
    return false unless map_passable?(nx, ny, 10 - d)  # 移動先が進入不能？
    return false if collide_with_characters?(nx, ny)   # キャラクターに衝突？
    return true                                        # 通行可
  end
  #--------------------------------------------------------------------------
  # ○ 移動後の X 座標算出
  #     x : X 座標
  #     d : 移動方向
  #    移動後の X 座標を計算する。
  #--------------------------------------------------------------------------
  def moved_x(x, d)
    return x + (d == 6 ? 1 : d == 4 ? -1 : 0)
  end
  #--------------------------------------------------------------------------
  # ○ 移動後の Y 座標算出
  #     y : Y 座標
  #     d : 移動方向
  #    移動後の Y 座標を計算する。
  #--------------------------------------------------------------------------
  def moved_y(y, d)
    return y + (d == 2 ? 1 : d == 8 ? -1 : 0)
  end
  #--------------------------------------------------------------------------
  # ○ マップ通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #     d : 移動方向
  #    指定座標の指定した方向が通行可能かを取得する。
  #--------------------------------------------------------------------------
  def map_passable?(x, y, d)
    return $game_map.passable?(x, y) && $game_map.passable_dir?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # ● 下に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  def move_down(turn_ok = true)
    if passable?(@x, @y, 2)                 # 通行可能
      turn_down
      @y = $game_map.round_y(@y+1)
      @real_y = (@y-1)*256
      increase_steps
      @move_failed = false
    else                                    # 通行不可能
      turn_down if turn_ok
      check_event_trigger_touch(@x, @y+1)   # 接触イベントの起動判定
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 左に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  def move_left(turn_ok = true)
    if passable?(@x, @y, 4)                 # 通行可能
      turn_left
      @x = $game_map.round_x(@x-1)
      @real_x = (@x+1)*256
      increase_steps
      @move_failed = false
    else                                    # 通行不可能
      turn_left if turn_ok
      check_event_trigger_touch(@x-1, @y)   # 接触イベントの起動判定
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 右に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  def move_right(turn_ok = true)
    if passable?(@x, @y, 6)                 # 通行可能
      turn_right
      @x = $game_map.round_x(@x+1)
      @real_x = (@x-1)*256
      increase_steps
      @move_failed = false
    else                                    # 通行不可能
      turn_right if turn_ok
      check_event_trigger_touch(@x+1, @y)   # 接触イベントの起動判定
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 上に移動
  #     turn_ok : その場での向き変更を許可
  #--------------------------------------------------------------------------
  def move_up(turn_ok = true)
    if passable?(@x, @y, 8)                 # 通行可能
      turn_up
      @y = $game_map.round_y(@y-1)
      @real_y = (@y+1)*256
      increase_steps
      @move_failed = false
    else                                    # 通行不可能
      turn_up if turn_ok
      check_event_trigger_touch(@x, @y-1)   # 接触イベントの起動判定
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 左下に移動
  #--------------------------------------------------------------------------
  def move_lower_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) && passable?(@x, @y+1, 4)) ||
       (passable?(@x, @y, 4) && passable?(@x-1, @y, 2))
      @x -= 1
      @y += 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 右下に移動
  #--------------------------------------------------------------------------
  def move_lower_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) && passable?(@x, @y+1, 6)) ||
       (passable?(@x, @y, 6) && passable?(@x+1, @y, 2))
      @x += 1
      @y += 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 左上に移動
  #--------------------------------------------------------------------------
  def move_upper_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) && passable?(@x, @y-1, 4)) ||
       (passable?(@x, @y, 4) && passable?(@x-1, @y, 8))
      @x -= 1
      @y -= 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 右上に移動
  #--------------------------------------------------------------------------
  def move_upper_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) && passable?(@x, @y-1, 6)) ||
       (passable?(@x, @y, 6) && passable?(@x+1, @y, 8))
      @x += 1
      @y -= 1
      increase_steps
      @move_failed = false
    else
      @move_failed = true
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Player
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ○ マップ通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #     d : 移動方向
  #    指定座標の指定した方向が通行可能かを取得する。
  #--------------------------------------------------------------------------
  alias map_passable_KGC_TilesetExtension? map_passable?
  def map_passable?(x, y, d)
    return false unless map_passable_KGC_TilesetExtension?(x, y)

    return $game_map.passable_dir?(x, y, d)
  end

  if $TEST && KGC::TilesetExtension::DEBUG_INFO_BUTTON != nil
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_TilesetExtension update
  def update
    update_KGC_TilesetExtension

    if Input.trigger?(KGC::TilesetExtension::DEBUG_INFO_BUTTON)
      show_passage_and_terrain_tag
    end
  end
  #--------------------------------------------------------------------------
  # ○ プレイヤー位置の通行フラグ・地形タグを表示
  #--------------------------------------------------------------------------
  def show_passage_and_terrain_tag
    passage = $game_map.passage(x, y)
    tag = $game_map.terrain_tag(x, y)

    # デバッグ情報作成
    s = "通行可能: "
    s += "↓" if passage & DirectionFlag::DOWN  == 0x00
    s += "←" if passage & DirectionFlag::LEFT  == 0x00
    s += "→" if passage & DirectionFlag::RIGHT == 0x00
    s += "↑" if passage & DirectionFlag::UP    == 0x00
    s += "  地形タグ: #{tag}"

    p s
  end
  end

end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Sprite_Character
#==============================================================================

class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 指定されたタイルが含まれるタイルセット画像の取得
  #     tile_id : タイル ID
  #--------------------------------------------------------------------------
  def tileset_bitmap(tile_id)
    filename = KGC::TilesetExtension.get_tileset_filename
    set_number = tile_id / 256
    return Cache.system(filename["B"]) if set_number == 0
    return Cache.system(filename["C"]) if set_number == 1
    return Cache.system(filename["D"]) if set_number == 2
    return Cache.system(filename["E"]) if set_number == 3
    return nil
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Map
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● タイルマップの作成
  #--------------------------------------------------------------------------
  def create_tilemap
    filename = KGC::TilesetExtension.get_tileset_filename
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.bitmaps[0] = Cache.system(filename["A1"])
    @tilemap.bitmaps[1] = Cache.system(filename["A2"])
    @tilemap.bitmaps[2] = Cache.system(filename["A3"])
    @tilemap.bitmaps[3] = Cache.system(filename["A4"])
    @tilemap.bitmaps[4] = Cache.system(filename["A5"])
    @tilemap.bitmaps[5] = Cache.system(filename["B"])
    @tilemap.bitmaps[6] = Cache.system(filename["C"])
    @tilemap.bitmaps[7] = Cache.system(filename["D"])
    @tilemap.bitmaps[8] = Cache.system(filename["E"])
    @tilemap.map_data = $game_map.data
    @tilemap.passages = $game_map.passages
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● データベースのロード
  #--------------------------------------------------------------------------
  alias load_database_KGC_TilesetExtension load_database
  def load_database
    load_database_KGC_TilesetExtension

    load_tileset
  end
  #--------------------------------------------------------------------------
  # ○ タイルセット付加情報のロード
  #--------------------------------------------------------------------------
  def load_tileset
    begin
      $data_tileset = load_data("Data/#{KGC::TilesetExtension::EX_RVDATA}")
    rescue
      $data_tileset = RPG::Tileset.new
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_File
#==============================================================================

class Scene_File < Scene_Base
  #--------------------------------------------------------------------------
  # ● セーブデータの読み込み
  #     file : 読み込み用ファイルオブジェクト (オープン済み)
  #--------------------------------------------------------------------------
  alias read_save_data_KGC_TilesetExtension read_save_data
  def read_save_data(file)
    read_save_data_KGC_TilesetExtension(file)

    $game_map.init_tileset_filename
    Graphics.frame_reset
  end
end
