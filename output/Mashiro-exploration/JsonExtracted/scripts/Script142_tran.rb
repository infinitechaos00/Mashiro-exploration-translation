=begin
■キャラクター拡大縮小 RGSS2 DAIpage■ v1.1

●機能●
・キャラクタースプライトをにょきにょきと拡大縮小します。

　★使用例★
　※ ステート「小人」などの演出に。
　※ でっかくなるイベントや小っさくなるイベントの演出に。
　※ 宝箱を取った瞬間には宝箱を少しでっかくして強調…みたいな。（無理矢理）

●使い方●
　イベントコマンドのスクリプトで

c_zoom(id, zoom)

　を実行すると指定した id のイベントが zoom の拡大率になります。
　idにはイベントID（-1でプレイヤー、0でこのイベント）を、
　zoomには拡大率（100が標準）を指定。

例：
c_zoom(-1, 50)
　# プレイヤーを半分の大きさに。
c_zoom(5, 150)
　# イベントID 5 を１.５倍に。

また、

c_zoom_2(id, zoom)
　
　のように実行するといきなり指定した大きさになります。

c_zoom_end(id)
を実行すると元に戻ります。

●仕様●
　RGSSの仕様により、イベントキャラの拡大縮小の場合、場所移動によってキャラクター
　情報がリセットされるため、拡大縮小もリセットされます。プレイヤーに関してのみ、
　解除するまで効果が続きます。

●再定義している箇所●

　Game_Character、Sprite_Characterをエイリアス
　※同じ箇所を変更するスクリプトと併用した場合は競合する可能性があります。

●更新履歴●
08/09/15：実行後、メニュー呼出などで画面切替をすると再度拡大縮小の動作が行われる
　　　　　不具合を修正。いきなり拡大機能を追加。
=end
#==============================================================================
# ■ Game_Character
#==============================================================================
class Game_Character
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :c_zoom
  attr_accessor :c_zoom_flg
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias dai_c_zoom_initialize initialize
  def initialize
    dai_c_zoom_initialize
    @c_zoom = 100
    @c_zoom_flg = false
  end
end
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● キャラクターズームの開始
  #--------------------------------------------------------------------------
  def c_zoom(id, zoom)
    character = get_character(id)
    character.c_zoom_flg = true
    character.c_zoom = zoom
  end
  #--------------------------------------------------------------------------
  # ● キャラクターズームの終了
  #--------------------------------------------------------------------------
  def c_zoom_end(id)
    character = get_character(id)
    character.c_zoom_flg = true
    character.c_zoom = 100
  end
  #--------------------------------------------------------------------------
  # ● キャラクターズームの終了
  #--------------------------------------------------------------------------
  def c_zoom_2(id, zoom)
    character = get_character(id)
    character.c_zoom_flg = false
    character.c_zoom = zoom
  end
end
#==============================================================================
# ■ Sprite_Character
#==============================================================================
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias dai_c_zoom_update update
  def update
    dai_c_zoom_update
    zoom_update
  end
  #--------------------------------------------------------------------------
  # ● ズームの更新
  #--------------------------------------------------------------------------
  def zoom_update
    if @character.c_zoom_flg == false
      unless @character.c_zoom == 100
        self.zoom_x = @character.c_zoom * 1.00 / 100
        self.zoom_y = @character.c_zoom * 1.00 / 100
      else @character.c_zoom == 100
        self.zoom_x = 1
        self.zoom_y = 1
      end
    else
      if @character.c_zoom == 100
        if self.zoom_x == 1
          zoom_update_flg
          return
        elsif self.zoom_x < 1
          if self.zoom_x >= 0.9
            a = 0.01
          else
            a = 0.05
          end
        elsif self.zoom_x > 1
          if self.zoom_x <= 1.1
            a = -0.01
          else
            a = -0.05
          end
        end
      elsif @character.c_zoom > 100
        b = self.zoom_x * 100
        if b >= @character.c_zoom
          zoom_update_flg
          return
        elsif self.zoom_x >= (@character.c_zoom * 1.00 / 100) - 0.1
          a = 0.01
        else
          a = 0.05
        end
      elsif @character.c_zoom < 100
        b = self.zoom_x * 100
        if b <= @character.c_zoom
          zoom_update_flg
          return
        elsif self.zoom_x <= (@character.c_zoom * 1.00 / 100) + 0.1
          a = -0.01
        else
          a = -0.05
        end
      end
      self.zoom_x += a
      self.zoom_y += a
      c = self.zoom_x * 100
      unless c.integer?
        c = c.round * 1.00 / 100
        self.zoom_x = c
        self.zoom_y = c
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ズーム実行中フラグをオフ
  #--------------------------------------------------------------------------
  def zoom_update_flg
    if @character.c_zoom_flg
      @character.c_zoom_flg = false
    end
  end
end
