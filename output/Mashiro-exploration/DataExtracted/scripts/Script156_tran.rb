#==============================================================================
# ★RGSS2 
# STR22Core_メッセージウィンドウEXT++/本体 v2.2b 09/07/25
#
# ・メッセージ機能を大幅に拡張強化強化します。
# 　詳しい使用方法はSTR22Editを参照してください。
# ・2.0以降に追加された機能の設定は本スクリプトで行います。
#
#------------------------------------------------------------------------------
#
# 更新履歴
# ◇2.2→2.2b
#　倍速メッセージの不具合が直っていなかったのを修正
# ◇2.1→2.2
#　メッセージ表示移動(\MOVE)機能を一応復活 ※未調整です
#　　利用する場合は↓設定項目を参照して、設定を変更してください。
#　倍速メッセージの不具合を修正
# ◇2.0→2.1
#　★全選択肢に、指定した文字を付加する機能を追加(このスクリプト設定項目参照↓)
#　★選択肢のカーソル初期位置を変数で指定できるようになった
#　★ポーズサインを強制的に非表示にする機能を追加
#　　イベントコマンド等で以下のスクリプトを実行すると非表示にできます。
#    $game_message.pause_clear = true # true=非表示 false=表示
#　細かいバグ修正・変更
#　・戦闘中の"背景を暗くする"にしたメッセージが消えないことがある不具合を修正
#　・強制位置・サイズ指定の位置設定が行われない不具合を修正
#　・ルビ、ネームウィンドウに半角スペースを含めると機能が働かない不具合を修正
#　・STR05導入時のカーソル位置を調整した
#　・半角/全角スペース描画時と改行時の1フレームウェイトを無くした
#　・本スクリプト導入前のセーブデータからの再開に対応
# ◇1.3a→2.0
#　一部機能が廃止されました。詳しくはSTR22Editを参照
#　少しだけ動作軽量化
#　STR05のカーソル滑らか移動に対応
#　細かいバグを修正
#　・ふきだしが表示されたままになることがある不具合を修正
#　・文末ポーズサイン位置が正しくない不具合を修正
#　・いろいろ
#
#==============================================================================
# ■ Window_Message
#==============================================================================
class Window_Message < Window_Selectable
  #-------------------------------------------------------------------------#
  # ★ 基本設定(2.1以降追加分)                                              #
  #-------------------------------------------------------------------------#
  # 全ての選択肢に付加する文字 制御文字OK(\は\\で表します)
  CHOICETEXT  = ["\\>", "\\<"] # ["前に付加する文字列", "後に付加する文字列"]
                # これで全ての選択肢を瞬間表示にできます
  CHOICEINDEX = 14       # ◆選択肢のカーソル初期位置指定に利用する変数IDです。
                         # 指定したIDの変数が1以上の時、カーソル初期位置が
                         # 変数の値に対応する位置*になります。
                         # (*上から1,2,3...と順番に対応)
                         # [仕様]一度選択肢を表示すると、変数は0に戻ります
  # 
  MESMOVE_ENABLE = false # \MOVEを利用するか　利用する場合はtrueにしてください
  # メッセージ表示中移動の際にONにするスイッチID
  MESMOVE     = 12       # ◆
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化(エイリアス)
  #--------------------------------------------------------------------------
  alias initialize_str22 initialize
  def initialize
    # 初期設定
    @mwextpp = true             # EXT判定
    @fade_type = FADE_TYPE      # フェードタイプ
    @indent_fx = 0              # 顔グラフィックによるインデント
    @contents_psx = 0           # ポーズサイン用X座標
    @contents_psy = 0           # ポーズサイン用X座標
    @contents_y = 0             # とりあえずZERO
    shake_reset                 # シェイク
    # ポーズサインスプライト
    @pause_window = Sprite_STRPause.new
    # ネームウィンドウ
    name = Cache.system("Window").clone
    name.clear_rect(80, 16, 32, 32)
    @name_sprite = Sprite.new
    @name_d_window = Window.new
    @name_d_window.width = 24
    @name_d_window.height = 24
    @name_d_window.windowskin = name
    @name_sprite.visible = false
    @name_d_window.visible = false
    # ふきだしスプライト
    @popup = Sprite.new
    @popup.bitmap = Cache.system(POPUP_FILE)
    @popup.src_rect.set(0, 0, 32, 64)
    @popup.visible = false
    # ポップアップ位置記憶
    @event_xy = [0, 0, 0, 0]
    # フェイススプライト
    @face_sprite = Sprite_STRFace.new(nil)
    # 呼び戻し
    initialize_str22
    # リサイズ
    self.ox = self.oy = 0
    self.x = WINDOW_RECT.x
    self.y = WINDOW_RECT.y
    self.width = WINDOW_RECT.width
    self.height = WINDOW_RECT.height
    # いろいろ初期化
    @w_opacity = 0              # 不透明度
    @face_lr = 0                # 顔グラフィック位置
    @contents_width = [0]       # 各行の幅
    @contents_y_line = [0]      # 選択肢用縦幅配列
    @e_color = 0                # 縁取りカラーインデックス
    @messe_wait = 2             # タイピングSEウェイト
    @popid = @popid_f = -99     # ポップアップ/ふきだしID
    @name_text = ""             # ネームウィンドウ
    @text_speed = 2             # 文章スピード
    @und_on = @str_on = false   # アンダーライン/打ち消し線ONフラグ
    reset_ext                   # 共通リセット
  end
  #--------------------------------------------------------------------------
  # ● 解放(エイリアス)
  #--------------------------------------------------------------------------
  alias dispose_str22 dispose
  def dispose
    # 呼び戻し
    dispose_str22
    # ポーズサイン・スリムウィンドウ・
    # ネームウィンドウ・フェイススプライト開放
    @pause_window.dispose
    @name_sprite.bitmap.dispose if @name_sprite.bitmap != nil
    @name_sprite.dispose
    @name_d_window.dispose
    @face_sprite.bitmap.dispose if @face_sprite.bitmap != nil
    @face_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新(エイリアス)
  #--------------------------------------------------------------------------
  alias update_str22 update
  def update
    @messe_wait -= 1 if @messe_wait > 0 # SE再生間隔調整ウェイトを進める
    # フェード処理
    update_str22                        # 呼び戻し
    self.opacity = (@background == 0 ? @w_opacity : 0)
    self.contents_opacity = @w_opacity
    update_shake if @shake_duration >= 1 or @shake != 0 # シェイク更新
    return unless $game_message.visible # メッセージ非表示ならリターン
    @pause_window.update if self.pause  # ポーズサイン更新
    # ネームスプライト・フェイススプライトの可視状態設定
    @name_sprite.visible = (self.openness == 255)
    @face_sprite.visible = @name_sprite.visible
    # キャラポップアップ/ふきだし座標更新
    window_xy_update
    window_xy_update_f if self.opacity == 255 and self.openness == 255
    # 数値入力(スクロールに対応させるため)
    number_xy_update if $game_message.num_input_variable_id > 0
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの更新
  #--------------------------------------------------------------------------
  def update_back_sprite
    r = $game_message.xywh
    a = [self.openness, @w_opacity][FADE_TYPE]
    @back_sprite.opacity = a
    @back_sprite.visible = (@background == 1 and $game_message.visible)
    @back_sprite.x = self.x + (self.width / 2)
    @back_sprite.y = self.y + (self.height / 2)
    @back_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● キャラポップ:pos0
  #--------------------------------------------------------------------------
  def popup_pos0(event)
    # キャラクターの高さ
    if event.tile_id > 0 # タイルの場合
      pop_y = 32
    else                 # キャラクターの場合
      b = Cache.character(event.character_name)
      sign = event.character_name[/^[\!\$]./]
      pop_y=((sign != nil and sign.include?('$')) ? b.height / 4:b.height / 8)
      pop_y -= 4 unless sign != nil and sign.include?('!')
    end
    pop_y += 16
    return (event.screen_y - self.height - pop_y)
  end  
  #--------------------------------------------------------------------------
  # ● ポップアップ用座標計算(追加)
  #--------------------------------------------------------------------------
  def window_xy_update
    # IDで分岐
    return if @popid == -99
    case @popid
    when -1 ; event = $game_player                             # プレイヤー
    when  0 ; event = $game_map.events[$game_message.event_id] # このイベント
    else    ; event = $game_map.events[@popid]                 # 指定イベントID
    end
    return if event == nil
    # 対象の座標が変化していなければ更新しない
    if @event_xy[0] != event.screen_x or @event_xy[1] != event.screen_y
      @event_xy[0] = event.screen_x ;@event_xy[1] = event.screen_y
    else
      return
    end
    # X座標設定
    wx = event.screen_x - (self.width / 2)
    position = @position
    # Y座標設定
    if @popid == 0 and $game_message.pos_autoset
      position = ($game_player.screen_y >= event.screen_y ?  0 : 2)
    end
    # ポジション別にY座標計算
    case position
    when 0  # 上
      @gold_window.y = 360
      wy = popup_pos0(event)
    when 1  # 中
      @gold_window.y = 0
      wy = event.screen_y - (self.height / 2)
    when 2  # 下
      @gold_window.y = 0
      wy = event.screen_y + 16
    end
    return if $game_message.xywh.width > 32 and $game_message.xywh.height > 32
    if $game_message.unlock # ウィンドウを画面に収めないとき
      self.x = wx
      self.y = wy
    else                    # ウィンドウを画面に収めるとき
      case position
      when 0
        if wy < 0                         # 下に表示
          @gold_window.y = 0
          wy = event.screen_y + 16
        end
      when 2
        if wy + self.height > STR22900[1] # 上に表示
          @gold_window.y = 360
          wy = popup_pos0(event)
        end
      end
      self.x = [[wx, STR22900[0] - self.width].min, 0].max
      self.y = [[wy, STR22900[1] - self.height].min, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # ● ふきだし座標計算(追加)
  #--------------------------------------------------------------------------
  def window_xy_update_f
    # IDで分岐
    @popup.visible = false 
    return if @popid_f == -99
    case @popid_f
    when -1 ; event = $game_player                             # プレイヤー
    when  0 ; event = $game_map.events[$game_message.event_id] # このイベント
    else    ; event = $game_map.events[@popid_f]               # 指定イベントID
    end
    return if @popid_f == -2 or event == nil
    @popup.visible = true
    # 対象の座標が変化していなければ更新しない
    if @event_xy[2] != event.screen_x or @event_xy[3] != event.screen_y
      @event_xy[2] = event.screen_x ;@event_xy[3] = event.screen_y
    else
      return
    end
    # スリムウィンドウの縮み取得
    sow = 0 ;soh = 0
    if @slim25_window != nil
      sow = STR25S_WINDOW_W / 2
      soh = STR25S_WINDOW_H / 2
    end
    # 座標設定
    src_y = $game_variables[POPUP_TYPE_V] * 64
    if event.screen_y < self.y + (self.height / 2)
      position = 2
      @popup.src_rect.set(32, src_y, 32, 64)
      my = self.y - 32 + soh
    else
      position = 0
      @popup.src_rect.set(0, src_y, 32, 64)
      my = self.y + self.height - 32 - soh
    end
    x = event.screen_x - 16
    mx = self.x + 16 + sow
    mw = self.x + self.width - 48 - sow
    @popup.x = [[x, mw].min, mx].max
    @popup.y = my
    if POPUP_MIRROR
      case position
      when 0 ; @popup.mirror = ((event.screen_x + 2) > @popup.x + 16)
      when 2 ; @popup.mirror = ((event.screen_x + 2) > @popup.x + 16)
      end
      @popup.mirror ^= true if POPUP_LR == 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウ座標セット
  #--------------------------------------------------------------------------
  def number_xy_update
    @number_input_window.x = self.x
    if @face_lr == 0 and not $game_message.face_name.empty?
      @number_input_window.x += FACE_SIZE[0] + FACE_SPACE
    end
    @number_input_window.y = self.y + @contents_y
  end
  #--------------------------------------------------------------------------
  # ● タイピングSE再生
  #--------------------------------------------------------------------------
  def typese_update
    if @messe_wait <= 0 and MESSE
      MESSAGE_SE[$game_variables[MESSE_VNUM]].play 
      @messe_wait = MESSE_WAIT
      vl = MESSE_VWAI
      @messe_wait=($game_variables[vl] > 0 ? $game_variables[vl] : MESSE_WAIT)
    end
  end
  #--------------------------------------------------------------------------
  # ● 文字揃えセット
  #--------------------------------------------------------------------------
  def align_set
    cx = @contents_x
    w = @contents_width[@line_count]
    w += FACE_SIZE[0] + FACE_SPACE if @face_lr == 1
    case @line_align[@line_count]
    when 1 ; @contents_x += (self.width - 32 - cx - w) / 2
    when 2 ; @contents_x += self.width - 32 - cx - w
    end
  end
  #--------------------------------------------------------------------------
  # ● 共通リセット(改ページ/改行)
  #--------------------------------------------------------------------------
  def reset_ext
    @maxtextsize = WLH           # 行中の最大テキストサイズ
    @line_show_fast = false      # 行早送り
    @font_index = 0              # フォントインデックス
    @font_size = DEFAULT_SIZE    # フォントサイズ
    @e_text = false              # 縁取りテキストフラグ
    @font_bold = false           # 太字フラグ
    @font_italic = false         # 斜体フラグ
    @bold_off = false            # 太字OFFフラグ
    @italic_off = false          # 斜体OFFフラグ
    @tx_und = false              # アンダーラインフラグ 
    @tx_str = false              # 打ち消し線フラグ
    @r_mode = false              # ルビ描画モード
    @rbx = 0                     # ルビ開始X座標
    @rbw = 0                     # ルビ幅
  end
  #--------------------------------------------------------------------------
  # ● 改ページ処理(再定義)
  #--------------------------------------------------------------------------
  def new_page
    contents.clear                      # コンテンツクリア
    @contents_x = 0                     # 描画X座標
    @contents_y = 0                     # 描画Y座標
    @line_count = 0                     # 現在の行 
    @show_fast = false                  # 早送り
    @pause_skip = false                 # ポーズを待たない
    # フェイススプライト設定
    @face_sprite.set_face("", 0, FACE_SIZE[0], FACE_SIZE[1])
    unless $game_message.face_name.empty?
      name = $game_message.face_name
      index = $game_message.face_index
      @face_sprite.set_face(name, index, FACE_SIZE[0], FACE_SIZE[1])
      @contents_x = FACE_SIZE[0] + FACE_SPACE if @face_lr == 0
    end
    @indent_fx = @contents_x            # インデント
    contents.font.color = text_color(0) # カラー初期化
    @e_color = 0                        # 縁取りカラー初期化
    @messe_wait = 2                     # タイピングSEウェイト
    @name_text = ""                     # ネームウィンドウを空に
    @text_speed = 2                     # 文章スピード
    reset_ext                           # 共通リセット
    align_set                           # 文字揃えセット
    @event_xy = [0, 0, 0, 0]            # ポップアップ位置記憶
    self.x = self.x                     # ウィンドウを同期
    self.y = self.y                     # ウィンドウを同期
  end
  #--------------------------------------------------------------------------
  # ● 改行処理(再定義)
  #--------------------------------------------------------------------------
  def new_line
    @contents_psx = @contents_x  # ポーズサインX位置設定
    @contents_x = 0              # 描画X座標
    @contents_y += @maxtextsize  # 描画Y座標
    @contents_psy = @contents_y  # ポーズサインY位置設定
    @line_count += 1             # 行を進める
    # フェイスによるインデントを設定
    if not $game_message.face_name.empty? and @face_lr == 0
      @contents_x = FACE_SIZE[0] + FACE_SPACE
    end
    reset_ext                    # 共通リセット
    align_set                    # 文字揃えセット
    self.x = self.x              # ウィンドウを同期
    self.y = self.y              # ウィンドウを同期
  end
  #--------------------------------------------------------------------------
  # ● メッセージの開始(エイリアス)
  #--------------------------------------------------------------------------
  alias start_message_str22 start_message
  def start_message
    start_message_str22
    Graphics.frame_reset if STR22101
  end
  #--------------------------------------------------------------------------
  # ● メッセージの終了(エイリアス)
  #--------------------------------------------------------------------------
  alias terminate_message_str22 terminate_message
  def terminate_message
    @contents_y_line = [0]
    @popid = @popid_f = -99
    terminate_message_str22
  end
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換(エイリアス)
  #--------------------------------------------------------------------------
  alias convert_special_characters_str22 convert_special_characters
  def convert_special_characters
    # 変数・マクロ
    @text.gsub!(/\\V\[([0-9]+)\]/i)    { $game_variables[$1.to_i] }
    @text.gsub!(/\\M\[([0-9]+)\]/i)    { MACRO[$1.to_i] }
    # 呼び戻し
    convert_special_characters_str22
    @text.gsub!(/\\g/)                 { "\x02" }
    # 現在のマップ名
    @text.gsub!(/\\MAP/i)              { $game_map.map_name_strextpp }
    # アイコン・アイテム
    i = [$data_items, $data_weapons, $data_armors, $data_skills]
    @text.gsub!(/\\IT\[([0-9]+),([0-9]+)\]/i)   { 
    "\\IC[#{i[$1.to_i][$2.to_i].icon_index.to_s}]\\IN[#{$1},#{$2}]" }
    @text.gsub!(/\\IC\[([0-9]+)\]/i)            { "\x10[#{$1}]" }
    @text.gsub!(/\\IN\[([0-9]+),([0-9]+)\]/i)   { i[$1.to_i][$2.to_i].name }
    # アニメーション
    @text.gsub!(/\\A\[([0-9]+),([0-9]+)\]/i)    { "\x11[#{[$1]},#{[$2]}]" }
    @text.gsub!(/\\A\[\-1,([0-9]+)\]/i)         { "\x11[9999,#{[$1]}]" }
    # バルーン
    @text.gsub!(/\\U\[([0-9]+),([0-9]+)\]/i)    { "\xb0[#{[$1]},#{[$2]}]" }
    @text.gsub!(/\\U\[\-1,([0-9]+)\]/i)         { "\xb0[9999,#{[$1]}]" }
    # 文字揃え
    @text.gsub!(/\\AL\[([0-9]+)\]/i)            { "\x12[#{$1}]" }
    # ルビ
    @text.gsub!(/\\R\[([^\[\]]+),([^\[\]]+)\]/i){
    "\x98#{$1}\x99[#{$2}]" }
    # ネームウィンドウ
    @text.sub!(/\\NA\[([^\[\]]*)\]/i){ "\x89[#{$1}]]" }
    # フェイス
    @text.gsub!(/\\FR/i)               { "\x13" }
    @text.gsub!(/\\FM/i)               { "\x14" }
    @text.gsub!(/\\FC\[([^\[\]\s]+),([0-9]+)\]/i) { "\xa1[#{$1}][#{$2}]" }
    @text.gsub!(/\\FCM/i)              { "\xa2" }
    # ストップ・ウェイト・文章スピード
    @text.gsub!(/\\MOVE/i)             { "\xa3" }
    @text.gsub!(/\\STOP/i)             { "\x18" }
    @text.gsub!(/\\W\[([0-9]+)\]/i)    { "\x94[#{$1}]" }
    @text.gsub!(/\\S\[([0-9]+)\]/i)    { "\x93[#{$1}]" }
    # フォント
    @text.gsub!(/\\E/i)                { "\x81" }
    @text.gsub!(/\\FS\[([0-9]+)\]/i)   { "\x82[#{$1}]" }
    @text.gsub!(/\\FS\[D\]/i)          { "\xa0" }
    @text.gsub!(/\\B/i)                { "\x83" }
    @text.gsub!(/\\I/i)                { "\x84" }
    @text.gsub!(/\\F\[([0-9]+)\]/i)    { "\x85[#{$1}]" }
    @text.gsub!(/\\CE\[([0-9]+)\]/i)   { "\x86[#{$1}]" }
    @text.gsub!(/\\UND/i)              { "\x95" }
    @text.gsub!(/\\STR/i)              { "\x96" }
    # ポップアップ・ふきだし
    @text.sub!(/\\P\[([0-9]+)\]/i)     { "\x87[#{$1}]" }
    @text.sub!(/\\P\[\-1+\]/i)         { "\x88" }
    @text.sub!(/\\PP\[([0-9]+)\]/i)    { "\x90[#{$1}]" }
    @text.sub!(/\\PP\[\-1+\]/i)        { "\x91" }
    @text.sub!(/\\PP\[\-2+\]/i)        { "\x92" }
    # シェイク
    @text.gsub!(/\\SH\[(\d+),(\d+),(\d+)\]/i) {"\xa4[#{[$1]},#{[$2]},#{[$3]}]"}
    # スイッチ/変数
    @text.gsub!(/\\SW\[(\d+),ON\]/i)      { "\xa5[#{$1}]" }
    @text.gsub!(/\\SW\[(\d+),OFF\]/i)     { "\xa6[#{$1}]" }
    @text.gsub!(/\\SW\[(\d+),RV\]/i)      { "\xa7[#{$1}]" }
    @text.gsub!(/\\VA\[(\d+),(\d+)\]/i)   { "\xa8[#{$1},#{$2}]" }
    @text.gsub!(/\\VA\[(\d+),\-(\d+)\]/i) { "\xa9[#{$1},#{$2}]" }
    # ネクスト
    @text.gsub!(/\\NEXT/i)                { "" }
    # 空白
    @text.gsub!(/\\SPIX\[([0-9]+)\]/i)    { "\x97[#{$1}]" }
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウリセット-F(追加)
  #--------------------------------------------------------------------------
  def reset_window_f
    $game_message.mapstop = false   # 更新ストップオフ
    # 各行の文字揃え
    ar = []
    for i in 0..$game_message.maxlineex do ar[i] = ALIGN end
    @line_align = ar
    # フェイス
    @face_sprite.no_face = false    # カオナシフラグ　アッアッアー
    @face_lr = 0                    # 顔位置
    @face_sprite.mirror = false     # 顔反転
    # バック・ポジション取得
    @background = $game_message.background
    @position   = $game_message.position
    # 透明ウィンドウなら透明に
    if @background != 0
      self.opacity = @w_opacity
      if @background == 1
        @back_sprite.bitmap.dispose
        @back_sprite.bitmap = 
                        Cache.system(MESBACK_LIST[$game_variables[MESBACK_VA]])
        @back_sprite.ox = @back_sprite.bitmap.width / 2
        @back_sprite.oy = @back_sprite.bitmap.height / 2
      end
    end
    # 縦開閉フェードの場合不透明度255
    @w_opacity = 255 if FADE_TYPE == 0
    # 透明度変化フェードの場合オープン度255
    self.openness = 255 if FADE_TYPE == 1
    # オートネームウィンドウの設定
    if not $game_message.face_name.empty?
      name = $game_message.face_name + "_" + $game_message.face_index.to_s
      @name_text = A_N_WINDOW[name] if A_N_WINDOW[name] != nil
      if @name_text[/Actor\[(\d+)\]/i] != nil
        @name_text.sub(/Actor\[(\d+)\]/i, "")
        @name_text = $game_actors[$1.to_i].name
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ネームウィンドウ設定(追加)
  #--------------------------------------------------------------------------
  def name_window_set
    # ネームウィンドウ設定
    @name_sprite.bitmap.dispose if @name_sprite.bitmap != nil
    @name_sprite.bitmap = nil
    unless @name_text.empty?
      # 計算用ダミービットマップ
      bitmap = Cache.system("")
      bitmap.font.name = N_WINDOW_FN
      bitmap.font.size = N_WINDOW_FS
      tw = bitmap.text_size(@name_text).width + 8
      # ビットマップ作成
      bitmap = Bitmap.new(tw, bitmap.font.size + 4)
      bitmap.font.name = N_WINDOW_FN
      bitmap.font.size = N_WINDOW_FS
      bitmap.font.color = N_WINDOW_CO
      unless N_WINDOW_ED
        bitmap.draw_text(0, 0, bitmap.width, bitmap.height, @name_text, 1)
      else
        co = N_WINDOW_CE
        bitmap.draw_text_f(0, 0, bitmap.width, bitmap.height, @name_text, 1,co)
      end
      # スプライト設定
      @name_sprite.bitmap = bitmap
      @name_sprite.ox = bitmap.width / 2
      @name_sprite.oy = bitmap.height / 2
      # ネームウィンドウリサイズ
      @name_d_window.width = bitmap.width + N_WINDOW_WH[0]
      @name_d_window.height = bitmap.height + N_WINDOW_WH[1]
    end
    # ネームウィンドウ可視状態設定
    @name_d_window.visible = (self.visible and not @name_text.empty?)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウリセット
  #--------------------------------------------------------------------------
  def reset_window
    reset_window_f    # ウィンドウリセット-F
    shake_reset       # シェイク
    # いろいろ初期化
    ar = []
    for i in 0..$game_message.maxlineex do ar[i] = 0 end
    @contents_psx = 0                   # ポーズサインX
    @rb_h = ar                          # ルビ高さ
    str_line_size = 0                   # ライン
    contents_x = [0]                    # X配列
    contents_y = [0]                    # Y配列
    text = @text.clone                  # テキスト
    maxtextsize = WLH                   # 最大テキストサイズ
    font_size = DEFAULT_SIZE            # フォントサイズ
    font_index = 0                      # フォント
    e_text = false                      # 縁取り
    font_bold = false                   # 太字
    bold_off = false                    # 太字OFFフラグ
    font_italic = false                 # 斜体
    italic_off = false                  # 斜体OFFフラグ
    #-----------------------------------------------------------
    # ★ 内容先読みループ/ウィンドウサイズ等を正確に割り出す
    loop do
      c = text.slice!(/./m)             # 次の文字を取得
      case c
      when nil ; break                  # 残りの文字が無い場合、ループ中断
      when "\x02"                       # \G  (所持金表示)
      when "\x03"                       # \.  (ウェイト 1/4 秒)
      when "\x04"                       # \|  (ウェイト 1 秒)
      when "\x05"                       # \!  (入力待ち)
      when "\x06"                       # \>  (瞬間表示 ON)
      when "\x07"                       # \<  (瞬間表示 OFF)
      when "\x08"                       # \^  (入力待ちなし)
      when "\x01" ;text.sub!(/\[([0-9]+)\]/, "")   # \C[n]  (文字色変更)
      when "\x81"                                  # \E
      when "\x88" ;@popid = @popid_f =  -1         # \P[-1]
      when "\x91" ;@popid_f = -1                   # \PP[-1]
      when "\x92" ;@popid_f = -2                   # \PP[-2]
      when "\x93" ;text.sub!(/\[([0-9]+)\]/, "")   # \S[n]
      when "\x94" ;text.sub!(/\[([0-9]+)\]/, "")   # \W[n]
      when "\x95"                                  # \UND
      when "\x96"                                  # \STR
      when "\x11" ;text.sub!(/\[([0-9]+)\,([0-9]+)\]/, "")# \A[n]
      when "\xb0" ;text.sub!(/\[([0-9]+)\,([0-9]+)\]/, "")# \U[n]
      when "\x13" ;@face_lr = 1                    # \FR
      when "\x14" ;@face_sprite.mirror = true      # \FM
      when "\x18" ;$game_message.mapstop = true    # \STOP
      when "\x98"                                  # \R
      when "\xa0" ;font_size = DEFAULT_SIZE        # \FS[d]
      when "\xa1" ;text.sub!(/\[([^\[\]\s]+)\]\[([0-9]+)\]/, "")# \FC[n,m]
      when "\xa2"                                  # \FCM
      when "\xa3"                                  # \MOVE
        if MESMOVE_ENABLE
          $game_message.mes_move = $game_switches[MESMOVE] = true
          $game_map.need_refresh = true
        end
      when "\xa4" ;text.sub!(/\[\d+,\d+,\d+\]/, "")# \SH[p,s,d]
      when "\xa5" ;text.sub!(/\[\d+\]/, "")        # \SW[id,ON]
      when "\xa6" ;text.sub!(/\[\d+\]/, "")        # \SW[id,OFF]
      when "\xa7" ;text.sub!(/\[\d+\]/, "")        # \SW[id,RV]
      when "\xa8" ;text.sub!(/\[\d+,\d+\]/, "")    # \VA[id,n]
      when "\xa9" ;text.sub!(/\[\d+,\d+\]/, "")    # \VA[id,n]
      when "\x00"                       # 改行
        if font_italic or italic_off
          contents_x[str_line_size] += font_size / STR22002 + 2
        end
        str_line_size += 1 
        contents_x[str_line_size] = 0
        contents_y[str_line_size] = 0
        contents_y[str_line_size] += maxtextsize + @rb_h[str_line_size - 1]
        maxtextsize = WLH               # 最大テキストサイズ
        font_size = DEFAULT_SIZE        # フォントサイズ
        font_index = 0                  # フォント
        font_bold = bold_off = false    # 太字
        font_italic = italic_off = false# 斜体
        if str_line_size >= $game_message.maxlineex # 行数が最大のとき
          break unless text.empty?      # ループ中断
        end
      when "\x82"                                  # \FS[n]
        text.sub!(/\[([0-9]+)\]/, "")
        font_size = $1.to_i
      when "\x83"                                  # \B
        bold_off = true if font_bold
        font_bold ^= true
      when "\x84"                                  # \I
        italic_off = true if font_italic
        font_italic ^= true
      when "\x85"                                  # \F[n]
        text.sub!(/\[([0-9]+)\]/, "")
        font_index = $1.to_i
      when "\x86"                                  # \CE[n]
        text.sub!(/\[([0-9]+)\]/, "")
        e_color = $1.to_i
      when "\x87"                                  # \P[n]
        text.sub!(/\[([0-9]+)\]/, "")
        @popid = @popid_f = $1.to_i
      when "\x90"                                  # \PP[n]
        text.sub!(/\[([0-9]+)\]/, "")
        @popid_f = $1.to_i
      when "\x89"                                  # \NA[s]
        text.sub!(/\[([^\[\]]*)\]\]/, "")
        @name_text = $1
      when "\x97"                                  # \SPIX[n]
        text.sub!(/\[([0-9]+)\]/, "")
        contents_x[str_line_size] += $1.to_i
      when "\x10"                                  # \IC[n]
        text.sub!(/\[([0-9]+)\]/, "")
        contents_x[str_line_size] += STR22009
      when "\x12"                                  # \AL[n]
        text.sub!(/\[([0-9]+)\]/, "")
        @line_align[str_line_size] = $1.to_i
      when "\x99"                                  # \R
        text.sub!(/\[([^\[\]]+)\]/, "")
        size = (font_size / STR22008)
        @rb_h[str_line_size] = size if size > @rb_h[str_line_size]
      else                                         # 普通の文字
        # 字体別文字幅修正
        unless italic_off
          iw = 0
        else
          iw = contents.font.size / STR22000
          italic_off = false
        end
        if bold_off
          iw += contents.font.size / STR22001
          bold_off = false
        end
        # フォント設定読み込み
        contents.font.name = FONTLIST[font_index]
        contents.font.size = font_size
        contents.font.bold = font_bold
        contents.font.italic = font_italic
        maxtextsize = font_size if font_size > maxtextsize
        wlh = maxtextsize
        contents.font.bold = false
        c_width = contents.text_size(c).width + iw
        contents_x[str_line_size] += c_width
      end
    end
    # ★ 内容先読みループ ここまで
    #-----------------------------------------------------------
    # ネームウィンドウ設定
    name_window_set
    # 顔グラフィックを表示するか
    face = (not $game_message.face_name.empty?)
    # 高さを求める
    h = 0
    for i in contents_y do h += i end
    # フェイス表示時の高さが足りない場合
    h = WINDOW_RECT.height - 32 if face and (32 + h < WINDOW_RECT.height)
    if $game_message.xywh.width > 32 and $game_message.xywh.height > 32
      # 強制位置設定/リサイズ
      self.x = $game_message.xywh.x
      self.y = $game_message.xywh.y
      self.width = $game_message.xywh.width
      self.height = $game_message.xywh.height
    elsif @popid != -99 # ポップアップが有効な場合
      # 幅を求める
      w = contents_x[0]
      if contents_x.size > 2
        for i in 1...contents_x.size do w=contents_x[i] if contents_x[i]>w end
      end
      # 数値入力位置修正
      input = ($game_message.num_input_variable_id > 0)
      input_w = 50 + (16 * $game_message.num_input_digits_max)
      if face
        indent = FACE_SIZE[0] + FACE_SPACE
        w += indent
        w = input_w + indent if input and w < input_w + indent
      else
        w = input_w if input and w < input_w
      end
      # リサイズ
      self.width = 32 + w
      self.height = 32 + h
      window_xy_update
    else
      # 通常ウィンドウ(ポップアップ無し)
      h = WINDOW_RECT.height - 32 if 32 + h < WINDOW_RECT.height
      self.width = WINDOW_RECT.width
      self.height = 32 + h
      self.x = WINDOW_RECT.x
      # ポジション別座標設定
      @gold_window.y = 0
      self.y = 0
      case @position
      when 0 ; @gold_window.y = STR22900[1] - 56
      when 1 ; self.y = (STR22900[1] / 2) - (self.height / 2)
      when 2 ; self.y = STR22900[1] - self.height
      end
    end
    # XY座標幅高さの情報格納
    @contents_width = contents_x
    @contents_y_line[0] = []
    @contents_y_line[1] = contents_y
    for i in 0...contents_y.size
      @contents_y_line[0][i] = 0
      for l in 0..i do @contents_y_line[0][i] += contents_y[l] end
    end
    self.contents.dispose
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
  end
  #--------------------------------------------------------------------------
  # ● メッセージの更新(再定義)
  #--------------------------------------------------------------------------
  def update_message
    loop do
      @wait_count = @text_speed if @wait_count <= 0
      c = @text.slice!(/./m)            # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        finish_message                  # 更新終了
        break
      when "\x00"                       # 改行
        new_line
        if @line_count >= $game_message.maxlineex # 行数が最大のとき
          unless @text.empty?           # さらに続きがあるなら
            self.pause = true           # 入力待ちを入れる
            break
          end
        end
        next
      when "\x06" ;@line_show_fast = true;next    # \>  (瞬間表示 ON)
      when "\x07" ;@line_show_fast = false;next   # \<  (瞬間表示 OFF)
      when "\x08" ;@pause_skip = true             # \^  (入力待ちなし)
      when "\x88" ;next                           # \P[-1]
      when "\x91" ;next                           # \PP[-1]
      when "\x92" ;next                           # \PP[-2]
      when "\x13" ;next                           # \FR  
      when "\x14" ;next                           # \FM
      when "\x18" ;next                           # \STOP
      when "\xa3" ;next                           # \MOVE
      when "\x01"                       # \C[n]  (文字色変更)
        @text.sub!(/\[([0-9]+)\]/, "")
        contents.font.color = text_color($1.to_i)
        next
      when "\x02"                       # \G  (所持金表示)
        @gold_window.refresh
        @gold_window.open
        next
      when "\x03"                       # \.  (ウェイト 1/4 秒)
        @wait_count = 15
        break
      when "\x04"                       # \|  (ウェイト 1 秒)
        @wait_count = 60
        break
      when "\x05"                       # \!  (入力待ち)
        @contents_psx = @contents_x
        @contents_psy = @contents_y + @maxtextsize
        self.x = self.x
        self.y = self.y
        self.pause = true
        break
      when "\x81"                       # \E
        @e_text ^= true
        next
      when "\x82"                       # \FS[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @font_size = $1.to_i
        next
      when "\xa0"                       # \FS[d]
        @font_size = DEFAULT_SIZE
        next
      when "\x83"                       # \B
        @bold_off = true if @font_bold
        @font_bold ^= true
        next
      when "\x84"                       # \I
        @italic_off = true if @font_italic
        @font_italic ^= true
        next
      when "\x85"                       # \F[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @font_index = $1.to_i
        next
      when "\x86"                       # \HC[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @e_color = $1.to_i
        next
      when "\x87"                       # \P[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        next
      when "\x90"                       # \PP[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        next
      when "\x89"                       # \NA[s]
        @text.sub!(/\[([^\[\]]*)\]\]/, "")
        next
      when "\x93"                       # \S[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @text_speed = $1.to_i
        next
      when "\x94"                       # \W[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @wait_count = $1.to_i
        break
      when "\x95"                       # \UND
        @tx_und ^= true
        @und_on = true if @tx_und
        next
      when "\x96"                       # \STR
        @tx_str ^= true
        @str_on = true if @tx_str
        next
      when "\x97"                       # \SPIX[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        @contents_x += $1.to_i
        next
      when "\xa4"                       # \SH[p,s,d]
        @text.sub!(/\[(\d+),(\d+),(\d+)\]/, "")
        start_shake($1.to_i, $2.to_i, $3.to_i)
        next
      when "\xa5"                       # \SW
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_switches[$1.to_i] = true
        $game_map.need_refresh = true
        next
      when "\xa6"                       # \SW
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_switches[$1.to_i] = false
        $game_map.need_refresh = true
        next
      when "\xa7"                       # \SW
        @text.sub!(/\[([0-9]+)\]/, "")
        $game_switches[$1.to_i] ^= true
        $game_map.need_refresh = true
        next
      when "\xa8"                       # \VA
        @text.sub!(/\[([0-9]+),([0-9]+)\]/, "")
        $game_variables[$1.to_i] = $2.to_i
        $game_map.need_refresh = true
        next
      when "\xa9"                       # \VA
        @text.sub!(/\[([0-9]+),([0-9]+)\]/, "")
        $game_variables[$1.to_i] = -($2.to_i)
        $game_map.need_refresh = true
        next
      when "\x10"                       # \IC[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        wlh = @contents_y_line[1][@line_count+1] / 2
        y = @contents_y + @rb_h[@line_count] + wlh - (STR22009 / 2)
        draw_icon($1.to_i, @contents_x, y)
        @contents_x += STR22009
        typese_update
      when "\x11"                       # \A[n,m]
        @text.sub!(/\[([0-9]+)\,([0-9]+)\]/, "")
        case $1.to_i
        when 9999 ; event = $game_player
        when 0    ; event = $game_map.events[$game_message.event_id]
        else      ; event = $game_map.events[$1.to_i]
        end
        event.animation_id = $2.to_i
        next
      when "\xb0"                       # \U[n,m]
        @text.sub!(/\[([0-9]+)\,([0-9]+)\]/, "")
        case $1.to_i
        when 9999 ; event = $game_player
        when 0    ; event = $game_map.events[$game_message.event_id]
        else      ; event = $game_map.events[$1.to_i]
        end
        event.balloon_id = $2.to_i
        next
      when "\x12"                       # \AL[n]
        @text.sub!(/\[([0-9]+)\]/, "")
        next
      when "\xa1"                       # \FC[n,m]
        @text.sub!(/\[([^\"\[\]\s]+)\]\[([0-9]+)\]/, "")
        unless $game_message.face_name.empty?
          @face_sprite.set_face($1, $2.to_i, FACE_SIZE[0], FACE_SIZE[1])
        end
        next
      when "\xa2"                       # \FCM
        @face_sprite.mirror ^= true
        next
      when "\x98"                       # \R
        @r_mode = true
        @rbx = @contents_x
        @rbw = 0
        next
      when "\x99"                       # \R
        @r_mode = false
        @text.sub!(/\[([^\[\]]+)\]/, "")
        contents.font.name = FONTLIST[@font_index]
        contents.font.size = (@font_size / 2)
        contents.font.bold = @font_bold
        contents.font.italic = @font_italic
        rw = @contents_y_line[1][@line_count+1] / 2
        rby = @contents_y + @rb_h[@line_count] + rw - (contents.font.size * 2)
        unless @e_text
          contents.draw_text(@rbx, rby, @rbw, contents.font.size, $1, 1)
        else
          # 縁取りON
          co = EDGE_COLOR[@e_color]
          contents.draw_text_f(@rbx, rby, @rbw, contents.font.size, $1, 1, co)
        end
        next
      else                              # 普通の文字
        # いろいろ
        @maxtextsize = wlh = @contents_y_line[1][@line_count+1]
        iw = font_w
        yy = @contents_y + @rb_h[@line_count]
        ww = @font_size + 8
        # 内容描画
        draw_message22_text(iw,yy,ww,wlh,c)     # 通常文字の描画
        draw_message22_und(iw,wlh,c) if @tx_und # アンダーライン
        draw_message22_str(iw,wlh,c) if @tx_str # 打ち消し線
        typese_update                           # タイピングSE
        # 幅加算
        contents.font.bold = false
        c_width = contents.text_size(c).width + iw
        @contents_x += c_width
        @rbw += c_width if @r_mode              # ルビ用文字幅
        next if c == " " or c == "　"
      end
      break unless @show_fast or @line_show_fast
    end
  end
  #--------------------------------------------------------------------------
  # ● 字体別文字幅修正
  #--------------------------------------------------------------------------
  def font_w
    unless @italic_off
      iw = 0
    else
      iw = contents.font.size / STR22000
      @italic_off = false
    end
    if @bold_off
      iw += contents.font.size / STR22001
      @bold_off = false
    end
    return iw
  end
  #--------------------------------------------------------------------------
  # ● 通常文字の描画
  #--------------------------------------------------------------------------
  def draw_message22_text(iw,yy,ww,wlh,c)
    # フォント設定読み込み
    contents.font.name = FONTLIST[@font_index]
    contents.font.size = @font_size
    contents.font.bold = @font_bold
    contents.font.italic = @font_italic
    # 文字描画
    unless @e_text
      contents.draw_text(@contents_x + iw, yy, ww, wlh, c)
    else
      # 縁取りON
      co = EDGE_COLOR[@e_color]
      contents.draw_text_f(@contents_x + iw, yy, ww, wlh, c, 0, co)
    end
  end
  #--------------------------------------------------------------------------
  # ● アンダーラインの描画
  #--------------------------------------------------------------------------
  def draw_message22_und(iw,wlh,c)
    unless @e_text
      rect = Rect.new(@contents_x + iw,@contents_y+(wlh-2),
                      contents.text_size(c).width + iw,1)
      oc = contents.font.color
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha)
      contents.fill_rect(rect, r_color)
      rect.y += 1
      r_color.alpha /= STR22007
      contents.fill_rect(rect, r_color)
    else
      rect = Rect.new(@contents_x + iw + 1,@contents_y+(wlh-3),
                      contents.text_size(c).width + iw,1)
      oc = EDGE_COLOR[@e_color]
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha - 16)
      contents.fill_rect(rect, r_color)
      rect.x -= 1
      rect.y += 1
      if @und_on
        a = rect.width
        rect.width = 1
        contents.fill_rect(rect, r_color)
        rect.width = a
      end
      rect.x += 2
      contents.fill_rect(rect, r_color)
      rect.x -= 1
      rect.y += 1
      contents.fill_rect(rect, r_color)
      rect.y -= 1
      oc = contents.font.color
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha)
      contents.fill_rect(rect, r_color)
    end
    @und_on = false
  end
  #--------------------------------------------------------------------------
  # ● 打ち消し線の描画
  #--------------------------------------------------------------------------
  def draw_message22_str(iw,wlh,c)
    unless @e_text
      rect = Rect.new(@contents_x + iw,@contents_y+(wlh/2),
                      contents.text_size(c).width + iw,1)
      oc = contents.font.color
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha)
      contents.fill_rect(rect, r_color)
      rect.y += 1
      r_color.alpha /= STR22007
      contents.fill_rect(rect, r_color)
    else
      rect = Rect.new(@contents_x + iw + 1,@contents_y+(wlh/2),
                      contents.text_size(c).width + iw,1)
      oc = EDGE_COLOR[@e_color]
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha - 16)
      contents.fill_rect(rect, r_color)
      rect.x -= 1
      rect.y += 1
      if @str_on
        a = rect.width
        rect.width = 1
        contents.fill_rect(rect, r_color)
        rect.width = a
      end
      rect.x += 2
      contents.fill_rect(rect, r_color)
      rect.x -= 1
      rect.y += 1
      contents.fill_rect(rect, r_color)
      rect.y -= 1
      oc = contents.font.color
      r_color = Color.new(oc.red, oc.green, oc.blue, oc.alpha)
      contents.fill_rect(rect, r_color)
    end
    @str_on = false
  end
  #--------------------------------------------------------------------------
  # ● シェイクの開始
  #--------------------------------------------------------------------------
  def start_shake(power, speed, duration)
    @shake_power = power
    @shake_speed = speed
    @shake_duration = duration
  end
  #--------------------------------------------------------------------------
  # ● シェイクリセット
  #--------------------------------------------------------------------------
  def shake_reset
    @shake = @shake_power = 0
    @shake_speed = @shake_duration = 0
    @shake_direction = 1
  end
  #--------------------------------------------------------------------------
  # ● シェイクの更新
  #--------------------------------------------------------------------------
  def update_shake
    delta = (@shake_power * @shake_speed * @shake_direction) / 10.0
    if @shake_duration <= 1 and @shake * (@shake + delta) < 0
      @shake = 0
    else
      @shake += delta
    end
    @shake_direction = -1 if @shake > @shake_power * 2
    @shake_direction = 1 if @shake < - @shake_power * 2
    @shake_duration -= 1 if @shake_duration >= 1
    self.x = self.x; self.y = self.y
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを開く
  #--------------------------------------------------------------------------
  def open
    a = [self.openness, @w_opacity][FADE_TYPE]
    @opening = true if a < 255
    @closing = false
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close
    a = [self.openness, @w_opacity][FADE_TYPE]
    @closing = true if a > 0
    @opening = false
    if a == 0 and MESMOVE_ENABLE
      t = $game_switches[MESMOVE]
      $game_message.mes_move = $game_switches[MESMOVE] = false
      $game_map.need_refresh = true if t != $game_switches[MESMOVE]
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のメッセージを続けて表示するべきか判定
  #--------------------------------------------------------------------------
  def continue?
    a = [self.openness, @w_opacity][FADE_TYPE]
    return true if $game_message.num_input_variable_id > 0
    return false if $game_message.texts.empty?
    if a > 0 and not $game_temp.in_battle
      return false if @background != $game_message.background
      return false if @position != $game_message.position
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ★ エイリアス
  #--------------------------------------------------------------------------
  alias finish_message_str09m finish_message
  def finish_message
    finish_message_str09m
    @wait_count = F_WAIT
  end
  alias update_message_str09m update_message
  def update_message
    fast = (not $game_switches[PSID] and not $game_switches[FSID] and 
            Input.press?(FAST_B))
    if F_AUTO
      update_message_str09m 
      update_message_str09m if update_message_fast?
      update_message_str09m if update_message_fast? and fast
      update_message_str09m if update_message_fast? and fast
    else
      update_message_str09m
      update_message_str09m if update_message_fast? and fast
    end
  end
  def update_message_fast?
    return (not self.pause and @wait_count <= 0 and @text != nil)
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の開始
  #--------------------------------------------------------------------------
  alias start_choice_str22 start_choice
  def start_choice
    start_choice_str22
    if $game_variables[CHOICEINDEX] != 0
      self.index = [[$game_variables[CHOICEINDEX], @item_max].min, 1].max - 1
      $game_variables[CHOICEINDEX] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 早送りフラグの更新(再定義)
  #--------------------------------------------------------------------------
  def update_show_fast
    return if $game_switches[PSID]
    id = (not $game_switches[SSID])
    a = [self.openness, @w_opacity][FADE_TYPE]
    if self.pause or a < 255
      @show_fast = false
    elsif (Input.trigger?(Input::C) or (Input.press?(SKIP_B) and id))
      @show_fast = true
    elsif not Input.press?(Input::C)
      @show_fast = false
    end
    @wait_count = 0 if @show_fast and @wait_count > 0
  end
  #--------------------------------------------------------------------------
  # ● 文章送りの入力処理(再定義)
  #--------------------------------------------------------------------------
  def input_pause
    id = (not $game_switches[SSID])
    if Input.trigger?(Input::B) or Input.trigger?(Input::C) or 
       (Input.press?(SKIP_B) and id)
      self.pause = false
      if @text != nil and not @text.empty?
        new_page if @line_count >= $game_message.maxlineex
      else
        terminate_message
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新(再定義)
  #--------------------------------------------------------------------------
  def update_cursor
    if @index >= 0
      str05 = (@strcursor != nil and not @f_set)
      r = self.cursor_rect.clone if str05
      x = $game_message.face_name.empty? ? 0 : FACE_SIZE[0] + FACE_SPACE
      y = @contents_y_line[0][$game_message.choice_start + @index]
      h = @contents_y_line[1][$game_message.choice_start + @index + 1]
      ix = (@strcursor != nil ? 24 : 0)
      self.cursor_rect.set(x + ix, y, contents.width - x - ix, h)
      update_cursor_str(r, self.cursor_rect.clone) if str05
      @f_set = false
    else
      self.cursor_rect.empty
    end
  end
  #--------------------------------------------------------------------------
  # ● ダミーウィンドウ同期(追加)
  #--------------------------------------------------------------------------
  # リーダー
  def pause
    @pause_window.pause
  end
  def viewport=(a)
    super
    @name_d_window.viewport = @pause_window.viewport = a
    @face_sprite.viewport = a
  end
  def visible=(a)
    super
    @pause_window.visible = a if self.visible and @pause_window.pause
    @face_sprite.visible = a
  end
  def pause=(a)
    @pause_window.pause = a
  end
  def x=(a)
    a += @shake
    super(a)
    @indent_fx = 0 unless N_WINDOW_IX
    @name_d_window.x = a + N_WINDOW_XY[0] + @indent_fx
    @name_sprite.x = @name_d_window.x + (@name_d_window.width / 2)
    case P_WINDOW
    when 0 ; @pause_window.x = a + (self.width / 2) - 12 + P_WINDOW_XY[0]
    when 1 ; @pause_window.x = a + self.width - 12 + P_WINDOW_XY[0]
    when 2 ; @pause_window.x = a + @contents_psx
    end
    fw = (FACE_SIZE[0] / 2) + FACE_XY[0]
    case @face_lr
    when 0 ; @face_sprite.x = self.x + 16 + fw
    when 1 ; @face_sprite.x = self.x + self.width - 16 - fw
    end
  end
  def y=(a)
    super
    @name_d_window.y = a + N_WINDOW_XY[1]
    @name_sprite.y = (a + N_WINDOW_XY[1]) + (@name_d_window.height / 2)
    case P_WINDOW
    when 2 ; @pause_window.y = a + @contents_psy
    else   ; @pause_window.y = a + self.height - 12 + P_WINDOW_XY[1]
    end
    fy = (FACE_SIZE[1] / 2) + FACE_XY[1]
    case FACE_Y
    when 0 ; @face_sprite.y = self.y + 16 + fy
    when 1 ; @face_sprite.y = self.y + (self.height / 2) + FACE_XY[1]
    when 2 ; @face_sprite.y = self.y + self.height - 16 - fy
    end
  end
  def z=(a)
    super
    @name_sprite.z = a + 6
    @name_d_window.z = a + 5
    @popup.z = a
    @pause_window.z = a + 10
    @face_sprite.z = a + 4
  end
  def opacity=(a)
    super
    if N_WINDOW_1V
      @name_d_window.opacity = a * (N_WINDOW_OPC / 100.0)
    elsif @background == 1
      @name_d_window.opacity = @w_opacity
    else
      @name_d_window.opacity = a * (N_WINDOW_OPC / 100.0)
    end
  end
  def back_opacity=(a)
    super
    @name_d_window.back_opacity = a
  end
  def contents_opacity=(a)
    super
    @name_d_window.contents_opacity = a
    @name_sprite.opacity = @face_sprite.opacity = a
  end
  def openness=(a)
    super
    @name_d_window.openness = a
  end
end
#==============================================================================
# ■ Window_BattleMessage
#==============================================================================
class Window_BattleMessage < Window_Message
  WLH = 6
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_btm_str22 initialize
  def initialize
    initialize_btm_str22
    @mode = (@b_sprite != nil ?  1 : 0)
    @str22maxline = $game_message.maxlineex
    $game_message.maxlineex = 4
    self.opacity = 0 if @mode == 1
    @w_opacity = 255
    btm_str22resize
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias dispose_btm_str22 dispose
  def dispose
    $game_message.maxlineex = @str22maxline
    dispose_btm_str22
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_str22bt update
  def update
    update_str22bt
    self.openness = 255
    self.opacity = 0 if @mode == 1
    @w_opacity = 255
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの背景と位置の設定 (無効化)
  #--------------------------------------------------------------------------
  def reset_window
    super
    self.x = self.y = @position = self.opacity = 0 if @b_sprite != nil
    btm_str22resize
    create_contents
  end
  #--------------------------------------------------------------------------
  # ● メッセージの終了
  #--------------------------------------------------------------------------
  def terminate_message
    super
    btm_str22resize
    @face_sprite.set_face("", 0, FACE_SIZE[0], FACE_SIZE[1])
    @name_sprite.bitmap.dispose if @name_sprite.bitmap != nil
    @name_sprite.bitmap = nil
    @name_d_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リサイズ
  #--------------------------------------------------------------------------
  def btm_str22resize
    self.width = Window_Message::STR22900[0]
    self.height = 128
    self.x = 0
    self.y = (@mode == 0 ? Window_Message::STR22900[1] - 128 : 0)
  end
  #--------------------------------------------------------------------------
  # ● 行の描画
  #     index : 行番号
  #--------------------------------------------------------------------------
  def draw_line(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.x += 4
    rect.y += index * 24
    rect.width = contents.width - 8
    rect.height = 24
    self.contents.clear_rect(rect)
    self.contents.font.color = normal_color
    self.contents.draw_text(rect, @lines[index])
  end
end
#==============================================================================
# ■ Window_NumberInput
#==============================================================================
class Window_NumberInput < Window_Base
  def y=(a)
    super(a-24)
  end
end
#==============================================================================
# ■ Window_Base
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_str22_base update
  def update
    if @mwextpp and @fade_type == 1
      super
      if @opening
        @w_opacity = [[@w_opacity + Window_Message::STR22011, 255].min, 0].max
        @opening = false if @w_opacity == 255
      elsif @closing
        @w_opacity = [[@w_opacity - Window_Message::STR22011, 255].min, 0].max
        @closing = false if @w_opacity == 0
      end
    else
      update_str22_base
    end
  end
end
#==============================================================================
# ■ Bitmap
#==============================================================================
class Bitmap
  #--------------------------------------------------------------------------
  # ● 文字縁取り描画
  #--------------------------------------------------------------------------
  def draw_text_f(x,y,width,height,str,align=0,color=Color.new(64,32,128))
    shadow = self.font.shadow
    b_color = self.font.color.dup
    font.shadow = false
    font.color = color
    draw_text(x + 1, y, width, height, str, align) 
    draw_text(x - 1, y, width, height, str, align) 
    draw_text(x, y + 1, width, height, str, align) 
    draw_text(x, y - 1, width, height, str, align) 
    font.color = b_color
    draw_text(x, y, width, height, str, align)
    font.shadow = shadow
  end
  def draw_text_f_rect(r, str, align = 0, color = Color.new(64,32,128)) 
    draw_text_f(r.x, r.y, r.width, r.height, str, align = 0, color) 
  end
end
#==============================================================================
# ■ Sprite_STRPause
#==============================================================================
class Sprite_STRPause < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    w = Cache.system("Window")
    r = [Rect.new(96, 64, 32, 16), Rect.new(96, 80, 32, 16)]
    bitmap = Bitmap.new(64, 16)
    bitmap.blt(0, 0, w, r[0])
    bitmap.blt(32, 0, w, r[1])
    self.ox = self.oy = -8
    self.bitmap = bitmap
    self.visible = false
    self.src_rect.set(0, 0, 16, 16)
    @count = 0
    @wait = Window_Message::STR22010
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.bitmap.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● ポーズ
  #--------------------------------------------------------------------------
  def pause
    self.visible
  end
  def pause=(a)
    self.opacity = ($game_message.pause_clear ? 0 : 255)
    self.visible = a
    @count = 0 unless self.visible
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    return if not self.visible
    super
    @wait -= 1
    if @wait == 0
      @wait = Window_Message::STR22010
      @count += 1
      @count = 0 if @count * 16 >= self.bitmap.width
      self.src_rect.set(@count * 16, 0, 16, 16)
    end
  end
end
#==============================================================================
# ■ Sprite_STRFace
#==============================================================================
class Sprite_STRFace < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :no_face
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport)
    super(viewport)
    @no_face = false
    @face_name = ""
    self.bitmap = Cache.face("")
  end
  #--------------------------------------------------------------------------
  # ● フェイス設定
  #--------------------------------------------------------------------------
  def set_face(name, index, w, h)
    self.bitmap.dispose if self.bitmap != nil and @face_name != name
    @face_name = name
    self.bitmap = Cache.face(@face_name)
    self.src_rect.x = index % 4 * w
    self.src_rect.y = index / 4 * h
    self.src_rect.width = w
    self.src_rect.height = h
    self.ox = w / 2
    self.oy = h / 2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @no_face
      self.ox = 0
      self.oy = 0
      self.src_rect.set(0,0,0,0)
    end
  end
end

#==============================================================================
# ■ Game_Message
#==============================================================================
class Game_Message
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :unlock                   # 画面内に収めない(v1.4)
  attr_accessor :pos_autoset              # \P[0]の自動位置設定(v1.4)
  attr_accessor :event_id                 # 表示元イベントID
  attr_accessor :xywh                     # 表示位置/座標
  attr_accessor :mapstop                  # マップ更新停止
  attr_accessor :maxlineex                # 最大行数拡張
  attr_accessor :pause_clear              # ポーズサイン強制不可視
  attr_accessor :mes_move                 # メッセージ表示移動
  def unlock;@unlock = false if @unlock == nil;@unlock;end
  def pos_autoset;@pos_autoset = true if @pos_autoset == nil;@pos_autoset;end
  def event_id;@event_id = false if @event_id == nil;@event_id;end
  def xywh;@xywh = Rect.new(0, 0, 32, 32) if not @xywh.is_a?(Rect) ;@xywh;end
  def mapstop;@mapstop = false if @mapstop == nil;@mapstop;end
  def maxlineex;@maxlineex = 4 if @maxlineex == nil;@maxlineex;end
  def pause_clear;@pause_clear = false if @pause_clear == nil;@pause_clear;end
  def mes_move;@mes_move = false if @mes_move == nil;@mes_move;end
  def visible=(a);@visible = a;@mapstop = a unless a;end
  #--------------------------------------------------------------------------
  # ● クリア(エイリアス)
  #--------------------------------------------------------------------------
  alias clear_str22 clear
  def clear
    clear_str22
    @event_id = 0
    @mes_move = false
  end
  #--------------------------------------------------------------------------
  # ● 改ページ
  #--------------------------------------------------------------------------
  def new_page
    while @texts.size % @maxlineex > 0
      @texts.push("")
    end
  end
end
#
if Window_Message::MESMOVE_ENABLE
#
#==============================================================================
# ■ Game_Player
#==============================================================================
class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # ● 方向ボタン入力による移動処理(再定義)
  #--------------------------------------------------------------------------
  def move_by_input
    return unless movable?
    # 条件変更
    return if $game_map.interpreter.running? and $game_message.mes_move == false
    case Input.dir4
    when 2;  move_down
    when 4;  move_left
    when 6;  move_right
    when 8;  move_up
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動可能判定(再定義)
  #--------------------------------------------------------------------------
  def movable?
    return false if moving?                     # 移動中
    return false if @move_route_forcing         # 移動ルート強制中
    return false if @vehicle_getting_on         # 乗る動作の途中
    return false if @vehicle_getting_off        # 降りる動作の途中
    # 条件変更
    return false if $game_message.visible and $game_message.mes_move == false
    return false if in_airship? and not $game_map.airship.movable?
    return true
  end
end
#
end
#==============================================================================
# ■ Game_Map
#==============================================================================
class Game_Map
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_str22 update
  def update
    return if $game_message.visible and $game_message.mapstop
    update_str22
  end
  #--------------------------------------------------------------------------
  # ★ マップネーム取得(追加)
  #--------------------------------------------------------------------------
  def map_name_strextpp
    map = load_data("Data/MapInfos.rvdata")
    return map[@map_id].name.sub!(/([^#]*)#*.*/) { "#{$1}" }
  end
end
#==============================================================================
# ■ Game_Interpreter
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  alias clear_str22 clear
  def clear
    clear_str22
    @overline_c = nil
    c_over
  end
  #--------------------------------------------------------------------------
  # ● 文章の表示(再定義)
  #--------------------------------------------------------------------------
  def command_101
    unless $game_message.busy
      # イベントIDを渡す
      $game_message.event_id = @event_id
      #
      $game_message.face_name = @params[0]
      $game_message.face_index = @params[1]
      $game_message.background = @params[2]
      $game_message.position = @params[3]
      # オーバーライン
      next_mes = true
      loop do
        if @list[@index].code == 101 and next_mes and
           $game_message.maxlineex > $game_message.texts.size
          @index += 1
        else
          break
        end
        next_mes = false
        while @list[@index].code == 401       # 文章データ
          next_mes = true if @list[@index].parameters[0][/\\NEXT/i] != nil
          if $game_message.maxlineex > $game_message.texts.size
            $game_message.texts.push(@list[@index].parameters[0])
          end
          @index += 1
        end
      end
      #
      if @list[@index].code == 102          # 選択肢の表示
        setup_choices(@list[@index].parameters)
      elsif @list[@index].code == 103       # 数値入力の処理
        setup_num_input(@list[@index].parameters)
      end
      set_message_waiting                   # メッセージ待機状態にする
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の表示(エイリアス)
  #--------------------------------------------------------------------------
  alias command_102_str22 command_102
  def command_102
    if @overline_c[@indent] > 0
      @overline_c[@indent] -= 1
      return true 
    end
    return command_102_str22
  end
  #--------------------------------------------------------------------------
  # ● 選択肢のセットアップ(再定義)
  #--------------------------------------------------------------------------
  def setup_choices(params)
    if $game_message.texts.size <= $game_message.maxlineex - params[0].size
      # イベントIDを渡す
      $game_message.event_id = @event_id
      # セットアップ
      $game_message.choice_start = $game_message.texts.size
      $game_message.choice_max = params[0].size
      wct = Window_Message::CHOICETEXT
      for s in params[0] do $game_message.texts.push(wct[0] + s + wct[1]) end
      $game_message.choice_cancel_type = params[1]
      if $game_message.choice_cancel_type == 5
        $game_message.choice_cancel_type = 128
      end
      @index += 1
      # オーバーライン
      index = @index
      i = @indent
      cs = 0
      lcs = params[0].size
      loop do
        break if @list[@index] == nil
        params = @list[@index].parameters
        i2 = @list[@index].indent
        # 選択肢表示の場合
        if @list[@index].code == 102 and i == i2 and
           $game_message.texts.size <= $game_message.maxlineex - params[0].size
          $game_message.choice_max += params[0].size
          for s in params[0] do $game_message.texts.push(wct[0]+s+wct[1]) end
          $game_message.choice_cancel_type = params[1]
          if $game_message.choice_cancel_type == 5
            $game_message.choice_cancel_type = 128
          end
          @index += 1
          @overline_c[@indent] += 1
          lcs = params[0].size
        else
          # コード先読み
          code = @list[@index].code
          # 選択肢ID変換
          if code == 402 and i == i2 
            c_param_reset
            @list[@index].parameters[0] += cs
            @list[@index].parameters.push(cs)
          end
          # 選択肢〆
          if code == 404 and i == i2
            if @list[@index+1].code == 102
              params = @list[@index+1].parameters
              txtsize = $game_message.texts.size
              if txtsize <= $game_message.maxlineex - params[0].size
                @index += 1
                cs += lcs
              else
                break
              end
            else
              break
            end
          else
            @index += 1
          end
        end
      end
      # インデックスを戻す
      @index = index
      $game_message.choice_proc = Proc.new { |n| @branch[@indent] = n }
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択肢オーバーラインカウント初期化(追加)
  #--------------------------------------------------------------------------
  def c_over
    if @overline_c == nil
      @overline_c = [] 
      for oc in 0..96 do @overline_c[oc] = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択肢IDを元に戻す(追加)
  #--------------------------------------------------------------------------
  def c_param_reset
    if @list[@index].parameters[2] != nil
      @list[@index].parameters[0] -= @list[@index].parameters[2]
      @list[@index].parameters.delete_at(2)
    end
  end
  #--------------------------------------------------------------------------
  # ● [**] の場合(再定義)
  #--------------------------------------------------------------------------
  def command_402
    if @branch[@indent] == @params[0]       # 該当する選択肢の場合
      @branch.delete(@indent)               # 分岐データを削除
      c_param_reset
      return true                           # 継続
    else                                    # 条件に該当しない場合
      c_param_reset
      return command_skip                   # コマンドスキップ
    end
  end
  #--------------------------------------------------------------------------
  # ● キャンセルの場合(再定義)
  #--------------------------------------------------------------------------
  def command_403
    if @branch[@indent] == 127              # 選択肢キャンセルの場合
      @branch.delete(@indent)               # 分岐データを削除
      return true                           # 継続
    else                                    # 条件に該当しない場合
      return command_skip                   # コマンドスキップ
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値入力のセットアップ(再定義)
  #--------------------------------------------------------------------------
  def setup_num_input(params)
    if $game_message.texts.size < $game_message.maxlineex
      # 行追加(ポップアップ時のサイズ不足対策)
      $game_message.texts.push("")
      #
      $game_message.num_input_variable_id = params[0]
      $game_message.num_input_digits_max = params[1]
      @index += 1
    end
  end
end