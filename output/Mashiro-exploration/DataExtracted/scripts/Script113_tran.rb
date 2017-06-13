
#~ # ★ バトルレイアウト変更 ネオ・メモ
#~ #   バトルのレイアウトを変更します
#~ #   素材『ステートアイコンのアニメーション表示』の使用をお奨めします
#~ #     ▲ 入れるフォルダは Graphics/System へ

#~ #==============================================================================
#~ # ■ Ziifee
#~ #==============================================================================

#~ module Zii
#~   # ▼ アイコンのナンバーです (縦 × 16 + 横 - 1)
#~   FIGHT = 132                               # 戦う
#~   ESCAPE = 143                              # 逃げる
#~   ATTACK = 1                                # 攻撃 (基本)
#~   GUARD = 52                                # 防御
#~   SKILL = 128                               # スキル
#~   ITEM = 144                                # アイテム
#~   
#~   # ▼ 回転方向 ( "正" か "逆" を入れる )
#~   TURN = "正"
#~   
#~   # ▼ 顔グラフィック (使う場合 "使用" / 使わない場合は "")
#~   STATUS_FACE = "使用"
#~   
#~   # ▼ 表示の設定 ( "名前" を "" にすると 名前を非表示)
#~   STATUS_LINE = ""
#~   
#~   # ▼ △の大きさ ( VX 標準サイズ は 20)
#~   LINE_SIZE = 14
#~   
#~   #--------------------------------------------------------------------------
#~   # ● 通常回転 の判定
#~   #--------------------------------------------------------------------------
#~   def self.turn_normal?
#~     return false if TURN == "逆"
#~     return true  if TURN == "正"
#~     return true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● バトルオプション [顔グラフィック] の判定
#~   #--------------------------------------------------------------------------
#~   def self.battle_face?
#~     return true if STATUS_FACE == "使用"
#~     return false
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● バトルステートオプション [名前] の判定
#~   #--------------------------------------------------------------------------
#~   def self.line_name?
#~     return true if STATUS_LINE == "名前"
#~     return false
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Window_SpinCommand
#~ #------------------------------------------------------------------------------
#~ # 　回転用コマンド選択を行うウィンドウです。
#~ #==============================================================================

#~ class Window_SpinCommand < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● 公開インスタンス変数
#~   #--------------------------------------------------------------------------
#~   attr_reader   :index                    # カーソル位置
#~   attr_reader   :help_window              # ヘルプウィンドウ
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #     cx / cy  : 中心の X座標 / Y座標
#~   #     commands : コマンド配列 (内容 は [name, kind, pull, enabled?])
#~   #     setting  : 設定ハッシュ ("R"=>半径 "S"=>速さ "G"=>背景 "L"=>文字)
#~   #--------------------------------------------------------------------------
#~   def initialize(cx, cy, commands, setting = {})
#~     @radius    = setting.has_key?("R") ? setting["R"] : 40  # 描画半径
#~     @speed     = setting.has_key?("S") ? setting["S"] : 36  # 回転速さ
#~     @spin_back = setting.has_key?("G") ? setting["G"] : ""  # 背景画像
#~     @spin_line = setting.has_key?("L") ? setting["L"] : nil # 文字位置
#~     x, y = cx - @radius - 28, cy - @radius - 28
#~     width = height = @radius * 2 + 56
#~     super(x, y, width, height)
#~     self.opacity = 0
#~     @index = 0
#~     @commands = commands                                    # コマンド
#~     @spin_right = true
#~     @spin_count = 0
#~     update_cursor
#~   end
#~   #--------------------------------------------------------------------------
#~   # ▽ スピン画像を描画する (描画内容 強化用)
#~   #     i  : インデックス
#~   #     cx : 表示 中心位置 X座標
#~   #     cy : 表示 中心位置 Y座標
#~   #--------------------------------------------------------------------------
#~   def draw_spin_graphic(i, cx, cy)
#~     case command_kind(i)
#~     when "icon"
#~       draw_icon(command_pull(i), cx - 12, cy - 12, command_enabled?(i))
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ★ リフレッシュ バグ回避用
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     set_spin
#~   end
#~   #--------------------------------------------------------------------------
#~   # ★ 項目の描画 バグ回避用
#~   #--------------------------------------------------------------------------
#~   def draw_item(index, enabled = true)
#~     @commands[index][3] = enabled
#~     set_spin
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 現在のコマンド名を取得する
#~   #--------------------------------------------------------------------------
#~   def command_name(index = @index)
#~     return "" if index < 0
#~     name = @commands[index][0]
#~     return name != nil ? name : ""
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドの種類を取得
#~   #--------------------------------------------------------------------------
#~   def command_kind(index)
#~     result = @commands[index][1]
#~     return result != nil ? result : ""
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドの引数 を取得
#~   #--------------------------------------------------------------------------
#~   def command_pull(index)
#~     result = @commands[index][2]
#~     return result != nil ? result : ""
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドの有効フラグを取得
#~   #--------------------------------------------------------------------------
#~   def command_enabled?(index)
#~     result = @commands[index][3]
#~     return result != nil ? result : true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 名前の位置に index を設定する
#~   #--------------------------------------------------------------------------
#~   def set_index(name)
#~     n = -1
#~     for i in 0...@commands.size
#~       n = i if @commands[i][0] == name
#~     end
#~     @index = n if n >= 0
#~     update_cursor
#~     call_update_help
#~     set_spin
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● カーソル位置の設定
#~   #     index : 新しいカーソル位置
#~   #--------------------------------------------------------------------------
#~   def index=(index)
#~     @index = index
#~     update_cursor
#~     call_update_help
#~     set_spin
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 中心のX座標を取得
#~   #--------------------------------------------------------------------------
#~   def center_x
#~     return contents.width / 2
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 中心のY座標を取得
#~   #--------------------------------------------------------------------------
#~   def center_y
#~     return contents.height / 2
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 項目数の取得
#~   #--------------------------------------------------------------------------
#~   def item_max
#~     return @commands.size
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 背景の設定 (再定義 向き)
#~   #--------------------------------------------------------------------------
#~   def set_background
#~     return if @spin_back == ""
#~     bitmap = Cache.system(@spin_back)
#~     rect = Rect.new(0, 0, bitmap.width, bitmap.height)
#~     self.contents.blt(12, 12, bitmap, rect)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 文章の設定 (再定義 向き)
#~   #--------------------------------------------------------------------------
#~   def set_text
#~     return if @spin_line == nil
#~     y = center_y - WLH / 2 + @spin_line
#~     self.contents.draw_text(center_x - 48, y, 96, WLH, command_name, 1)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● スピンアイコンの角度の差を取得する
#~   #--------------------------------------------------------------------------
#~   def angle_size
#~     return (Math::PI * 2 / item_max)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● スピンアイコン回転時のカウント を設定する
#~   #--------------------------------------------------------------------------
#~   def set_spin_count
#~     @spin_count = angle_size * 360 / @speed
#~     set_spin(true)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● スピン設定 の実行
#~   #     spin : 回転フラグ (true の時回転中)
#~   #--------------------------------------------------------------------------
#~   def set_spin(spin = false)
#~     self.contents.clear
#~     set_background
#~     angle = spin ? @speed * @spin_count / 360 : 0
#~     angle = @spin_right ? angle : -angle
#~     for i in 0...item_max
#~       n = (i - @index) * angle_size + angle
#~       cx = @radius * Math.sin(n) + center_x
#~       cy = - @radius * Math.cos(n) + center_y
#~       draw_spin_graphic(i, cx, cy)
#~     end
#~     set_text
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● フレーム更新
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     update_cursor
#~     if @spin_count > 0
#~       @spin_count -= 1
#~       set_spin(@spin_count >= 1)
#~       return
#~     end
#~     update_command
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドの移動可能判定
#~   #--------------------------------------------------------------------------
#~   def command_movable?
#~     return false if @spin_count > 0
#~     return false if (not visible or not active)
#~     return false if (index < 0 or index > item_max or item_max == 0)
#~     return false if (@opening or @closing)
#~     return true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドを右に移動
#~   #--------------------------------------------------------------------------
#~   def command_right
#~     @index = (@index + 1) % item_max
#~     @spin_right = true
#~     set_spin_count
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンドを左に移動
#~   #--------------------------------------------------------------------------
#~   def command_left
#~     @index = (@index - 1 + item_max) % item_max
#~     @spin_right = false
#~     set_spin_count
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンド選択の更新
#~   #--------------------------------------------------------------------------
#~   def update_command
#~     if command_movable?
#~       if Input.press?(Input::RIGHT)
#~         Sound.play_cursor
#~         Zii.turn_normal? ? command_right : command_left
#~       end
#~       if Input.press?(Input::LEFT)
#~         Sound.play_cursor
#~         Zii.turn_normal? ? command_left : command_right
#~       end
#~     end
#~     call_update_help
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● カーソルの更新
#~   #--------------------------------------------------------------------------
#~   def update_cursor
#~     if @index < 0
#~       self.cursor_rect.empty
#~     else
#~       rect = Rect.new(0, 0, 24, 24)
#~       rect.x = center_x - rect.width / 2
#~       rect.y = center_y - rect.height / 2 - @radius
#~       self.cursor_rect = rect
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ヘルプウィンドウの設定
#~   #     help_window : 新しいヘルプウィンドウ
#~   #--------------------------------------------------------------------------
#~   def help_window=(help_window)
#~     @help_window = help_window
#~     call_update_help
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ヘルプウィンドウ更新メソッドの呼び出し
#~   #--------------------------------------------------------------------------
#~   def call_update_help
#~     if self.active and @help_window != nil
#~        update_help
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ヘルプウィンドウの更新 (内容は継承先で定義する)
#~   #--------------------------------------------------------------------------
#~   def update_help
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Window_LineHelp
#~ #------------------------------------------------------------------------------
#~ # 　スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#~ #==============================================================================

#~ class Window_LineHelp < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(-16, 0, 576, WLH + 32)
#~     self.opacity = 0
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● テキスト設定
#~   #     text  : ウィンドウに表示する文字列
#~   #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
#~   #--------------------------------------------------------------------------
#~   def set_text(text, align = 0)
#~     if text != @text or align != @align
#~       self.contents.clear
#~       back_color = Color.new(0, 0, 0, 80)
#~       self.contents.fill_rect(0, y = 12, contents.width, WLH - y, back_color)
#~       self.contents.font.color = normal_color
#~       self.contents.draw_text(20, 0, self.width - 72, WLH, text, align)
#~       @text = text
#~       @align = align
#~     end
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Window_PartyCommand
#~ #==============================================================================

#~ class Window_PartyCommand < Window_SpinCommand
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     s1 = [Vocab::fight,  "icon", Zii::FIGHT,  true]
#~     s2 = [Vocab::escape, "icon", Zii::ESCAPE, $game_troop.can_escape]
#~     setting = {"R"=>40, "S"=>52, "G"=>"Spin40", "L"=>-12}
#~     super(72, 356, [s1, s2], setting)
#~     self.active = false
#~     set_spin
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Window_ActorCommand
#~ #==============================================================================

#~ class Window_ActorCommand < Window_SpinCommand
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     s1 = [Vocab::attack, "icon", Zii::ATTACK, true]
#~     s2 = [Vocab::skill,  "icon", Zii::SKILL,  true]
#~     s3 = [Vocab::guard,  "icon", Zii::GUARD,  true]
#~     s4 = [Vocab::item,   "icon", Zii::ITEM,   true]
#~     setting = {"R"=>40, "S"=>52, "G"=>"Spin40", "L"=>-12}
#~     super(72, 356, [s1, s2, s3, s4], setting)
#~     self.active = false
#~     set_spin
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● セットアップ
#~   #     actor : アクター
#~   #--------------------------------------------------------------------------
#~   def setup(actor)
#~     @commands[0][2] = Zii::ATTACK
#~     @commands[1][0] = Vocab::skill
#~     if actor.weapons[0] != nil
#~       n = actor.weapons[0].icon_index
#~       @commands[0][2] = n if n > 0
#~     end
#~     @commands[1][0] = actor.class.skill_name if actor.class.skill_name_valid
#~     self.index = 0
#~     set_spin
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Window_BattleStatus
#~ #==============================================================================

#~ class Window_BattleStatus < Window_Selectable
#~   #--------------------------------------------------------------------------
#~   # ● オブジェクト初期化 改
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(128, 288, 416, 128)
#~     @column_max = 4
#~     refresh
#~     self.active = false
#~     self.opacity = 0
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● ステートの更新 の下地描画
#~   #--------------------------------------------------------------------------
#~   def draw_neomemo7_back
#~     @neomemo7_clear = false
#~     for index in 0...@item_max
#~       x = index * 96
#~       self.contents.clear_rect(x + 72, WLH * 3, 24, 24)
#~       next unless Zii.battle_face?
#~       actor = $game_party.members[index]
#~       next if actor.hp <= 0
#~       bitmap = Cache.face(actor.face_name)
#~       rect = Rect.new(0, 0, 22, 22)
#~       rect.x = actor.face_index % 4 * 96 + 72
#~       rect.y = actor.face_index / 4 * 96 + 72
#~       self.contents.blt(x + 72, WLH * 3, bitmap, rect, 192)
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 項目の描画 改
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     x = index * 96
#~     rect = Rect.new(x, 0, 96, 96)
#~     self.contents.clear_rect(rect)
#~     self.contents.font.color = normal_color
#~     actor = $game_party.members[index]
#~     draw_actor_face(actor, x + 2, 2, 92, 192) if actor.hp > 0 and Zii.battle_face?
#~     draw_actor_state(actor, x + 72, WLH * 3)
#~     if Zii.line_name?
#~       self.contents.font.color = hp_color(actor)
#~       size = Zii::LINE_SIZE
#~       self.contents.font.size = size
#~       self.contents.draw_text(x, WLH * 1 + 20 - size, 80, WLH, actor.name)
#~       self.contents.font.size = 20
#~     end
#~     draw_actor_hp(actor, x, WLH * 2, 80)
#~     draw_actor_mp(actor, x, WLH * 3, 70)
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● カーソルの更新
#~   #--------------------------------------------------------------------------
#~   def update_cursor
#~     if @index < 0                   # カーソル位置が 0 未満の場合
#~       self.cursor_rect.empty        # カーソルを無効とする
#~     else                            # カーソル位置が 0 以上の場合
#~       rect = Rect.new(index * 96, 0, 96, 96)
#~       self.cursor_rect = rect       # カーソルの矩形を更新
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 顔グラフィックの描画 改
#~   #     opacity : 不透明度
#~   #--------------------------------------------------------------------------
#~   def draw_face(face_name, face_index, x, y, size = 96, opacity = 255)
#~     bitmap = Cache.face(face_name)
#~     rect = Rect.new(0, 0, 0, 0)
#~     rect.x = face_index % 4 * 96 + (96 - size) / 2
#~     rect.y = face_index / 4 * 96 + (96 - size) / 2
#~     rect.width = size
#~     rect.height = size
#~     self.contents.blt(x, y, bitmap, rect, opacity)
#~     bitmap.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● アクターの顔グラフィック描画 改
#~   #     opacity : 不透明度
#~   #--------------------------------------------------------------------------
#~   def draw_actor_face(actor, x, y, size = 96, opacity = 255)
#~     draw_face(actor.face_name, actor.face_index, x, y, size, opacity)
#~   end
#~ end

#~ #==============================================================================
#~ # ■ Scene_Battle
#~ #------------------------------------------------------------------------------
#~ # 　バトル画面の処理を行うクラスです。
#~ #==============================================================================

#~ class Scene_Battle < Scene_Base
#~   #--------------------------------------------------------------------------
#~   # ● 情報表示ビューポートの作成
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_create_info_viewport :create_info_viewport
#~   def create_info_viewport
#~     neomemo13_create_info_viewport
#~     @info_viewport.rect.set(0, 0, 544, 416)
#~     @status_window.x = 128
#~     @actor_command_window.x = 4
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 情報表示ビューポートの更新
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_update_info_viewport :update_info_viewport
#~   def update_info_viewport
#~     ox = @info_viewport.ox
#~     neomemo13_update_info_viewport
#~     @info_viewport.ox = ox
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● パーティコマンド選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_party_command_selection :start_party_command_selection
#~   def start_party_command_selection
#~     if $game_temp.in_battle
#~       @party_command_window.visible = true
#~       @actor_command_window.visible = false
#~     end
#~     neomemo13_start_party_command_selection
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● パーティコマンド選択の更新
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_update_party_command_selection :update_party_command_selection
#~   def update_party_command_selection
#~     return unless @party_command_window.command_movable?
#~     neomemo13_update_party_command_selection
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● アクターコマンド選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_actor_command_selection :start_actor_command_selection
#~   def start_actor_command_selection
#~     neomemo13_start_actor_command_selection
#~     @party_command_window.visible = false
#~     @actor_command_window.visible = true
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● アクターコマンド選択の更新
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_update_actor_command_selection :update_actor_command_selection
#~   def update_actor_command_selection
#~     return unless @actor_command_window.command_movable?
#~     neomemo13_update_actor_command_selection
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 対象敵キャラ選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_target_enemy_selection :start_target_enemy_selection
#~   def start_target_enemy_selection
#~     x = @info_viewport.rect.x
#~     ox = @info_viewport.ox
#~     neomemo13_start_target_enemy_selection
#~     @info_viewport.rect.x = x
#~     @info_viewport.ox = ox
#~     @target_enemy_window.x = 544 - @target_enemy_window.width
#~     @target_enemy_window.y = 288
#~     @info_viewport.rect.width -= @target_enemy_window.width
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 対象敵キャラ選択の終了
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_end_target_enemy_selection :end_target_enemy_selection
#~   def end_target_enemy_selection
#~     x = @info_viewport.rect.x
#~     ox = @info_viewport.ox
#~     @info_viewport.rect.width += @target_enemy_window.width
#~     neomemo13_end_target_enemy_selection
#~     @info_viewport.rect.x = x
#~     @info_viewport.ox = ox
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 対象アクター対象選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_target_actor_selection :start_target_actor_selection
#~   def start_target_actor_selection
#~     x = @info_viewport.rect.x
#~     ox = @info_viewport.ox
#~     neomemo13_start_target_actor_selection
#~     @target_actor_window.y = 288
#~     @info_viewport.rect.x = x
#~     @info_viewport.ox = ox
#~     @info_viewport.rect.width -= @target_actor_window.width
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 対象アクター選択の終了
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_end_target_actor_selection :end_target_actor_selection
#~   def end_target_actor_selection
#~     x = @info_viewport.rect.x
#~     ox = @info_viewport.ox
#~     @info_viewport.rect.width += @target_actor_window.width
#~     neomemo13_end_target_actor_selection
#~     @info_viewport.rect.x = x
#~     @info_viewport.ox = ox
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● スキル選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_skill_selection :start_skill_selection
#~   def start_skill_selection
#~     neomemo13_start_skill_selection
#~     @skill_window.dispose if @skill_window != nil
#~     @help_window.dispose if @help_window != nil
#~     @help_window = Window_LineHelp.new
#~     @skill_window = Window_Skill.new(8, 64, 528, 216, @active_battler)
#~     @skill_window.help_window = @help_window
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● アイテム選択の開始
#~   #--------------------------------------------------------------------------
#~   alias :neomemo13_start_item_selection :start_item_selection
#~   def start_item_selection
#~     neomemo13_start_item_selection
#~     @item_window.dispose if @item_window != nil
#~     @help_window.dispose if @help_window != nil
#~     @help_window = Window_LineHelp.new
#~     @item_window = Window_Item.new(8, 64, 528, 216)
#~     @item_window.help_window = @help_window
#~   end
#~ end
