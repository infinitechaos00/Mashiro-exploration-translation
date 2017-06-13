#~ =begin
#~ ■残像演出 RGSS2 DAIpage■ v1.1

#~ ●機能●
#~ ・「ピクチャの移動」コマンドに残像を表示します。
#~ ・指定したキャラクターに残像を表示します。
#~ ・飛行船に残像を表示します。

#~ ※なお、「ピクチャー残像演出」の機能を備えているので
#~ 「ピクチャー残像演出」のスクリプトは導入しないで下さい。

#~ ●ピクチャ残像の使い方●
#~ ピクチャ表示後にイベントコマンドのスクリプトで

#~ $game_map.screen.afterimage(ピクチャ番号)

#~ のように実行すると、そのピクチャの移動を行う際に残像を生成します。
#~ この場合はカスタマイズで指定した表示方式となります。

#~ また、以下のように残像表示方式の詳細を指定して実行もできます。

#~ a = 1  # ピクチャー番号
#~ b = 5  # 残像作成の間隔（フレーム）
#~ c = 20 # 表示から消滅までの時間（フレーム）
#~ d = 1  # 合成方式（0:通常 1:加算 2:減算）
#~ $game_map.screen.afterimage(a,b,c,d)

#~ また、

#~ $game_map.screen.afterimage_end(ピクチャ番号)

#~ を実行すると残像は無効化します。

#~ ※実行命令はセーブデータには保存されません。セーブ後には全て無効になります。

#~ ●キャラクター残像の使い方●
#~ イベントコマンドのスクリプトで

#~ character_afterimage(イベントID)

#~ のように実行すると、そのキャラクターの移動を行う際に残像を生成します。
#~ （-1：プレイヤー　0：このイベント）
#~ この場合はカスタマイズで指定した表示方式となります。

#~ また、以下のように残像表示方式の詳細を指定して実行もできます。

#~ a = 1  # ピクチャー番号
#~ b = 5  # 残像作成の間隔（フレーム）
#~ c = 20 # 表示から消滅までの時間（フレーム）
#~ d = 1  # 合成方式（0:通常 1:加算 2:減算）
#~ character_afterimage(a,b,c,d)

#~ プレイヤーキャラを指定した場合、ダッシュ時のみ残像を表示する事も出来ます。
#~ カスタマイズ項目で指定して下さい。

#~ また、

#~ character_afterimage_end(イベントID)

#~ を実行すると残像は無効化します。

#~ ※セーブデータに実行情報は保存されます。
#~ ※イベントの残像はマップ移動を行うとクリアされます。
#~ 　プレイヤーに関しては残像無効化命令をしない限り持続します。

#~ ●飛行船残像の使い方●
#~ カスタマイズで設定して下さい。

#~ ●再定義している箇所●
#~ 　Game_Temp、Game_Picture、Game_Character、Sprite_Picture、
#~ 　Sprite_Characterをエイリアス

#~ ●更新履歴●
#~ 08/09/21：説明文の記述ミスを修正。


#~ 　※同じ箇所を変更するスクリプトと併用した場合は競合する可能性があります。
#~ =end
#~   #--------------------------------------------------------------------------
#~   # ● カスタマイズポイント
#~   #--------------------------------------------------------------------------
#~ module DAI_AFTERIMAGE
#~ #  デフォルトの表示形式を設定。
#~  # 残像一コマを生成する間隔（フレーム数で指定）
#~  FRAME = 3
#~  # 残像表示から消滅までの時間（フレーム数で指定）
#~  TIME = 35
#~  # 合成方式（0:通常 1:加算 2:減算）
#~  BLEND = 1

#~  # キャラクターがプレイヤーの場合、ダッシュ時にしか残像を発生させない。
#~  DASH = true 

#~  # 飛行船に残像を表示するか
#~  AIRSHIP = true
#~  # 飛行船残像作成の間隔（フレーム数で指定）
#~  AIRSHIP_F = 3
#~  # 飛行船残像の表示から消滅までの時間（フレーム数で指定）
#~  AIRSHIP_T = 20
#~  # 飛行船残像の合成方法
#~  AIRSHIP_B = 1
#~  
#~  # ピクチャの表示のたびに残像表示設定をオフにする
#~  RESET_1 = true
#~  # ピクチャの消去のたびに残像表示設定をオフにする
#~  RESET_2 = true

#~   #--------------------------------------------------------------------------
#~   # ● 残像の開放
#~   #--------------------------------------------------------------------------
#~   def afterimage_dispose
#~     for sprite in @after_image
#~       sprite.opacity = 0
#~       sprite.dispose
#~     end
#~     @st = []
#~     @after_image = []
#~     @a_i_f = 0
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Temp
#~ #==============================================================================
#~ class Game_Temp
#~   #--------------------------------------------------------------------------
#~   # ● 公開インスタンス変数
#~   #--------------------------------------------------------------------------
#~   attr_accessor :picture_afterimage
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_initialize initialize
#~   def initialize
#~     dai_afterimage_initialize
#~     @picture_afterimage = []
#~     for i in 0...20
#~       @picture_afterimage.push([false, 0, 0, 0])
#~     end
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Screen
#~ #==============================================================================
#~ class Game_Screen
#~   #--------------------------------------------------------------------------
#~   # ● ピクチャー残像の開始
#~   #--------------------------------------------------------------------------
#~   def afterimage(number, f = DAI_AFTERIMAGE::FRAME, t = DAI_AFTERIMAGE::TIME, b = DAI_AFTERIMAGE::BLEND)
#~     number -= 1
#~     $game_temp.picture_afterimage[number] = [true, f, t, b]
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ピクチャー残像の終了
#~   #--------------------------------------------------------------------------
#~   def afterimage_end(number)
#~     number -= 1
#~     $game_temp.picture_afterimage[number] = [false, 0, 0, 0]
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Picture
#~ #==============================================================================
#~ class Game_Picture
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_initialize initialize
#~   def initialize(number)
#~     dai_afterimage_initialize(number)
#~     if DAI_AFTERIMAGE::RESET_1
#~       number -= 1
#~       $game_temp.picture_afterimage[number] = [false, 0, 0, 0]
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ピクチャの消去
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_erase erase
#~   def erase
#~     dai_afterimage_erase
#~     if DAI_AFTERIMAGE::RESET_2
#~       number = @number - 1
#~       $game_temp.picture_afterimage[number] = [false, 0, 0, 0]
#~     end
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Map
#~ #==============================================================================
#~ class Game_Map
#~   #--------------------------------------------------------------------------
#~   # ● タイル ID の取得
#~   #--------------------------------------------------------------------------
#~   def tile_id(z = 0)
#~     return @map.data[$game_player.x, $game_player.y, z]
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Character
#~ #==============================================================================
#~ class Game_Character
#~   #--------------------------------------------------------------------------
#~   # ● 公開インスタンス変数
#~   #--------------------------------------------------------------------------
#~   attr_accessor :afterimage
#~   attr_accessor :move_speed
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_initialize initialize
#~   def initialize
#~     dai_afterimage_initialize
#~     @afterimage = []
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Event
#~ #==============================================================================
#~ class Game_Event < Game_Character
#~   #--------------------------------------------------------------------------
#~   # ● イベントか否かの判定
#~   #--------------------------------------------------------------------------
#~   def event?
#~     return true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● プレイヤーか否かの判定
#~   #--------------------------------------------------------------------------
#~   def player?
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 飛行船か否かの判定
#~   #--------------------------------------------------------------------------
#~   def airship?
#~     return false
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Vehicle
#~ #==============================================================================
#~ class Game_Vehicle < Game_Character
#~   #--------------------------------------------------------------------------
#~   # ● プレイヤーか否かの判定
#~   #--------------------------------------------------------------------------
#~   def player?
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● イベントか否かの判定
#~   #--------------------------------------------------------------------------
#~   def event?
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 飛行船か否かの判定
#~   #--------------------------------------------------------------------------
#~   def airship?
#~     if @type == 2
#~       return true
#~     else
#~       return false
#~     end
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Player
#~ #==============================================================================
#~ class Game_Player < Game_Character
#~   #--------------------------------------------------------------------------
#~   # ● プレイヤーか否かの判定
#~   #--------------------------------------------------------------------------
#~   def player?
#~     return true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● イベントか否かの判定
#~   #--------------------------------------------------------------------------
#~   def event?
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 飛行船か否かの判定
#~   #--------------------------------------------------------------------------
#~   def airship?
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 乗り物に乗り降りをしているか
#~   #--------------------------------------------------------------------------
#~   def getting?
#~     return true if @vehicle_getting_on
#~     return true if @vehicle_getting_off
#~     return false
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Game_Interpreter
#~ #==============================================================================
#~ class Game_Interpreter
#~   include DAI_AFTERIMAGE
#~   #--------------------------------------------------------------------------
#~   # ● キャラクター残像の開始
#~   #--------------------------------------------------------------------------
#~   def character_afterimage(id, f = FRAME, t = TIME, b = BLEND)
#~     character = get_character(id)
#~     character.afterimage = [true, f, t, b]
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● キャラクター残像の終了
#~   #--------------------------------------------------------------------------
#~   def character_afterimage_end(id)
#~     character = get_character(id)
#~     character.afterimage = [false, 0, 0, 0]
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Sprite_Character
#~ #==============================================================================
#~ class Sprite_Character < Sprite_Base
#~   include DAI_AFTERIMAGE
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_initialize initialize
#~   def initialize(viewport, character = nil)
#~     @st = []
#~     @after_image = []
#~     @a_i_f = 0
#~     @position = [0,0]
#~     dai_afterimage_initialize(viewport, character)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 解放
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_dispose dispose
#~   def dispose
#~     afterimage_dispose
#~     dai_afterimage_dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 残像作成
#~   #--------------------------------------------------------------------------
#~   def create_afterimage
#~     sprite = Sprite.new(self.viewport)
#~     sprite.bitmap = self.bitmap
#~     sprite.src_rect = self.src_rect
#~     sprite.ox = self.ox
#~     sprite.oy = self.oy
#~     sprite.x = self.x
#~     sprite.y = self.y
#~     sprite.z = self.z
#~     sprite.z -= 100
#~     sprite.bush_depth = self.bush_depth
#~     sprite.zoom_x = self.zoom_x
#~     sprite.zoom_y = self.zoom_y
#~     sprite.opacity = self.opacity
#~     sprite.blend_type = @st[3]
#~     sprite.angle = self.angle
#~     sprite.tone = self.tone
#~     @after_image.push(sprite)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● フレーム更新
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_update update
#~   def update
#~     if character.airship?
#~       character.afterimage = [AIRSHIP,AIRSHIP_F,AIRSHIP_T,AIRSHIP_B] 
#~     end
#~     if character.afterimage[0] && @st == []
#~       @st = character.afterimage
#~       afterimage_position_set
#~     end
#~     if (character.player? or character.airship?) && $game_player.getting?
#~       afterimage_position_set
#~     end
#~     if self.visible && character.afterimage[0] && character.moving?
#~       if character.player?
#~         if character.dash? && DASH
#~           create_afterimage if @a_i_f % @st[1] == 0
#~           @a_i_f += 1
#~         elsif !DASH
#~           create_afterimage if @a_i_f % @st[1] == 0
#~           @a_i_f += 1
#~         end
#~       else
#~         create_afterimage if @a_i_f % @st[1] == 0
#~         @a_i_f += 1
#~       end
#~     end

#~     if @after_image.size > 0
#~       afterimage_update
#~     end
#~     dai_afterimage_update
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 残像の更新
#~   #--------------------------------------------------------------------------
#~   def afterimage_update
#~     x = @position[0] - ($game_map.display_x / 8)
#~     y = @position[1] - ($game_map.display_y / 8)
#~     for sprite in @after_image
#~       a = self.opacity / @st[2]
#~       b = self.opacity % @st[2]
#~       sprite.x += x
#~       sprite.y += y
#~       if sprite.opacity > b
#~         sprite.opacity -= a
#~       elsif sprite.opacity <= b
#~         sprite.opacity -= 1
#~       end
#~       if sprite.opacity == 0
#~         sprite.dispose
#~         @after_image.delete(sprite)
#~       end
#~     end
#~     afterimage_position_set
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● スクロール位置情報セット
#~   #--------------------------------------------------------------------------
#~    def afterimage_position_set
#~     x = ($game_map.display_x / 8)
#~     y = ($game_map.display_y / 8)
#~     @position = [x, y]
#~   end
#~ end
#~ #==============================================================================
#~ # ■ Sprite_Picture
#~ #==============================================================================
#~ class Sprite_Picture < Sprite
#~   include DAI_AFTERIMAGE
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_initialize initialize
#~   def initialize(viewport, picture)
#~     @st = []
#~     @after_image = []
#~     @a_i_f = 0
#~     dai_afterimage_initialize(viewport, picture)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 解放
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_dispose dispose
#~   def dispose
#~     afterimage_dispose
#~     dai_afterimage_dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 残像作成
#~   #--------------------------------------------------------------------------
#~   def create_afterimage
#~     sprite = Sprite.new(self.viewport)
#~     sprite.bitmap = self.bitmap
#~     if @picture.origin == 0
#~       sprite.ox = 0
#~       sprite.oy = 0
#~     else
#~       sprite.ox = sprite.bitmap.width / 2
#~       sprite.oy = sprite.bitmap.height / 2
#~     end
#~     sprite.x = self.x
#~     sprite.y = self.y
#~     sprite.z = self.z
#~     sprite.z -= 100
#~     sprite.zoom_x = self.zoom_x
#~     sprite.zoom_y = self.zoom_y
#~     sprite.opacity = self.opacity
#~     a = self.opacity / @st[2]
#~     sprite.opacity -= a
#~     sprite.blend_type = @st[3]
#~     sprite.angle = self.angle
#~     sprite.tone = self.tone
#~     @after_image.push(sprite)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● フレーム更新
#~   #--------------------------------------------------------------------------
#~   alias dai_afterimage_update update
#~   def update
#~     if $game_temp.picture_afterimage[@picture.number - 1][0] && @st == []
#~       @st = $game_temp.picture_afterimage[@picture.number - 1]
#~     end
#~     if self.visible && $game_temp.picture_afterimage[@picture.number - 1][0]
#~       create_afterimage if @a_i_f % @st[1] == 0
#~       @a_i_f += 1
#~     end
#~     if @after_image.size > 0
#~       afterimage_update
#~     end
#~     dai_afterimage_update
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 残像の更新
#~   #--------------------------------------------------------------------------
#~   def afterimage_update
#~     for sprite in @after_image
#~       a = self.opacity / @st[2]
#~       b = self.opacity % @st[2]
#~       sprite.opacity -= a
#~       if sprite.opacity <= b
#~         sprite.opacity = 0
#~         sprite.dispose
#~         @after_image.delete(sprite)
#~       end
#~     end
#~   end
#~ end
