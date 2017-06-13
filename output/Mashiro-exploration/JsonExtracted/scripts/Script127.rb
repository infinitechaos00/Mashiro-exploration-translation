#==============================================================================
#
#　■ エネミー行動パターン改良　□Ver5.53　□製作者：月紳士
#  
#　・RPGツクールVX用 RGSS2スクリプト
#
#    ●…書き換えメソッド(競合注意)　◎…メソッドのエイリアス　○…新規メソッド
#
#  ※二次配布禁止！配布元には利用規約があります。必ずそちらを見てください。
#------------------------------------------------------------------------------
# 更新履歴（過去の履歴はマニュアルに記載）
# Ver5.53 ○行動条件９が機能しなかった不具合修正。
# Ver5.52 ○記述の見直し(仕様変更無し)
# Ver5.51 ○戦闘行動の強制時にも狙う攻撃をしてしまう不具合を修正。
# 　　　　　詳しくはマニュアルのオプション③をご覧ください。
# Ver5.50 ○スクリプトの簡略化。
# Ver5.00 ○Game_Unit::random_targetを書き換えている他スクリプトに対応。
# Ver4.00 ○拡張スクリプトに対応。
# Ver3.00 ○ターゲットを拡張するスクリプトとの競合を極力避ける様、
# 　　　　　内部仕様を変更しました。基本的な動作は変わりません。
#------------------------------------------------------------------------------
=begin

  このスクリプトの機能は大きくわけて３つあります。
  
  ① 新たな行動条件の追加機能。
　　エネミーの行動パターンに、新たな行動条件を追加します。

    index (Switche No.)       : 条件名
    
        0 (= TOP_SWITCH)     : 付加・解除が有効の対象
        1 (= TOP_SWITCH + 1) : HPが全快でない対象
        2 (= TOP_SWITCH + 2) : HPが1/2以下の対象
        3 (= TOP_SWITCH + 3) : HPが1/5以下の対象
        4 (= TOP_SWITCH + 4) : MPが残っている対象
        5 (= TOP_SWITCH + 5) : 動くことが出来る対象
        6 (= TOP_SWITCH + 6) : 指定indexの対象
        7 (= TOP_SWITCH + 7) : 自分以外の対象
        8 (= TOP_SWITCH + 8) : 味方に戦闘不能無し
        9 (= TOP_SWITCH + 9) : 自分ひとりの時

　② 行動条件を複数設定可能にする機能。
　　ターン指定＋HP指定...　というように
　　ひとつの行動に対して複数の条件を設定できるようになります。
　　それら複数の条件すべてを満たす時のみ、その行動をとります。

　③ 行動パターンの決定方法をルーレット方式へ変更。
　　行動パターンの決定の仕方を変えて、優先度による純粋なルーレット方式にします。
　　独自の方式で行動パターンを組むことができるようになります。

　機能の詳しい説明と、設定の仕方は、マニュアルを参照してください。

=end
#==============================================================================

#==============================================================================
# ■ エネミー行動パターン向上・モジュール
#==============================================================================
module Extension_Action_Condition

 # カスタマイズ項目------------------------------------------------------------
 
  TOP_SWITCH = 901
       #↑# 「新たな行動条件の追加機能」に使用するスイッチ郡の、
          # 最初の番号をここで指定します。
          # ゲーム中の判定に差し支えない番号にしてください。
                     
  ADDITION_CONDITION_SKILL = 900
       #↑#  敵の行動パターン設定において、条件の追加を設定する際に使用する
          # ダミースキルのidをここで設定します。スキルの名前は任意ですが、
          # "＋追加条件" などとしておくと、わかりやすいと思います。
                     
  CONDITION_ROULETTE = false
       #↑# 「行動パターンの決定方法をルーレット方式へ変更」機能は
          # 少し複雑な機能なので、機能をオフに出来るようにしています。
          # マニュアルを読んでわかりにくいと感じたら、オフにしてください。
          # オンにしたい場合は true、オフにしたい場合は false と書き入れます。

  RE_ACTION_TYPE_DEFAULT = 1
       #↑# スキルを使用した際、
          # ターン開始前の行動決定後～ターン中の行動順番が来るまでの間に
          # 行動条件に合うターゲットを消失した場合の動作を３種類から選べます。
          # 0 …(無鉄砲タイプ)
          #      スキルはそのまま実行し、
          #      スキルのターゲットが単独の場合はランダムに対象を選びます。
          # 1 …(好戦的タイプ)
          #      スキルを中止し、ランダム通常攻撃に切り替えます。
          # 2 …(慎重派タイプ)
          #      スキルを中止し、そのターンは様子を見ます。
          # ※ここでの設定はデフォルトの動作となります。
          # エネミー個別でも設定出来ます。方法はマニュアルを参照してください。

 #-----------------------------------------------------------------------------         

  USE_RANDOM_TARGET = true
       #↑# 条件にあった対象をランダムに選出する処理に、
          # Game_Unitクラスのrandom_targetメソッドを流用するか、否かを選べます。
          # オンにしたい場合は true、オフにしたい場合は false と書き入れます。
          # 詳しくはマニュアルのオプション③の項をご覧ください。
 
  NUMBR_OF_CONDITION = 9
       #↑# 拡張条件のインデックス数を示しています。
          # スクリプト改変し条件を追加する際はこの値は増やす必要がありますが
          # 通常、変更する必要はありません。
 
 # ------------------------------------------------(カスタマイズ項目ここまで)--
 
  SWITCHES_RANGE = TOP_SWITCH...(TOP_SWITCH + NUMBR_OF_CONDITION + 1)
  
 # ----------------------------------------------------------------------------
end

#==============================================================================
# ■ Game_Condition_Members
#------------------------------------------------------------------------------
# “条件にあったメンバー”を選出する処理に
#  Game_Unitクラスのrandom_targetメソッドを流用する為の予備クラスです。
#  上記メソッドを改変する他スクリプトを併用した場合に、
#  その処理が“条件にあったメンバー”の選出に反映される為の工夫です。
#  このクラスのインスタンスは $game_condition_members で参照されます。
#==============================================================================

class Game_Condition_Members < Game_Unit
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :targets
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @targets = []
  end
  #--------------------------------------------------------------------------
  # ○ メンバーの取得
  #--------------------------------------------------------------------------
  def members
    return @targets
  end
  #--------------------------------------------------------------------------
  # ○ 生存しているメンバーの配列取得
  #--------------------------------------------------------------------------
  def existing_members
    return @targets
  end
end
  
#==============================================================================
# ■ RPG::Enemy::Action
#==============================================================================

class RPG::Enemy::Action
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :conditions_arrays                   # 行動条件配列
  #--------------------------------------------------------------------------
  # ◎ オブジェクトの初期化
  #--------------------------------------------------------------------------
  alias tig_eac_initialize initialize
  def initialize
    tig_eac_initialize
    conditions_arrays = nil
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ○ オブジェクトの付加ステート・解除ステートが有効か判定
  #     obj : スキルもしくはアイテム
  #--------------------------------------------------------------------------
  def available_obj_state(obj)
    return false if obj == nil
    ava = false
    minus = obj.minus_state_set
    if minus != []
      for i in minus
        ava = true if state?(i) 
      end
    end
    plus = obj.plus_state_set
    if plus != []
      for i in plus
        ava = true
        ava = false if state?(i)
        ava = false if state_ignore?(i) 
      end
    end
    return ava
  end
  #--------------------------------------------------------------------------
  # ○ ステート [索敵：頻回] 判定
  #--------------------------------------------------------------------------
  def frequent_target? 
    for state in states
      return true if (/[<＜]索敵[:：]頻回[>＞]/) =~ state.note
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ○ ステート [索敵：極稀] 判定
  #--------------------------------------------------------------------------
  def rare_target? 
    for state in states
      return true if (/[<＜]索敵[:：]極稀[>＞]/) =~ state.note
    end
    return false
  end
end

#==============================================================================
# ■ Game_BattleAction
#------------------------------------------------------------------------------
# 　戦闘行動を扱うクラスです。このクラスは Game_Battler クラスの内部で使用され
# ます。
#==============================================================================

class Game_BattleAction
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :target_conditions_arrays
  #--------------------------------------------------------------------------
  # ◎ クリア
  #--------------------------------------------------------------------------
  alias tig_eac_clear clear
  def clear
    tig_eac_clear
    @target_conditions_arrays = []
  end
  #--------------------------------------------------------------------------
  # ○ 条件にあうターゲットグループの取得
  #--------------------------------------------------------------------------
  def conditions_targets(arrays, skill) 
    if skill != nil and skill.for_friend?
      if skill.for_dead_friend?
        targets = friends_unit.dead_members
      elsif  skill.for_user?
        targets = [@battler]
      else
        targets = friends_unit.existing_members
      end
    else
      targets = opponents_unit.existing_members
    end
    
    for array in arrays
      new_targets = []
      if array[0] == 7
        case array[1]
        when Extension_Action_Condition::TOP_SWITCH
          for target in targets
            next unless target.available_obj_state(skill)
            new_targets.push(target)
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 1)
          for target in targets
            new_targets.push(target) unless target.hp == target.maxhp
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 2)
          for target in targets
            new_targets.push(target) if target.hp < (target.maxhp / 2)
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 3)
          for target in targets
            new_targets.push(target) if target.hp < (target.maxhp / 5)
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 4)
          for target in targets
            new_targets.push(target) unless target.mp == 0
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 5)
          for target in targets
            new_targets.push(target) if target.movable? and not target.confusion?
          end
          targets = new_targets
        when (Extension_Action_Condition::TOP_SWITCH + 6)
          if skill != nil and skill.for_friend?
            targets1 = friends_unit.members
          else
            targets1 = opponents_unit.members
          end
          for i in $game_troop.appoint_target
            new_targets.push(targets1[i])
          end
          targets = new_targets & targets
          targets = [] if targets == nil
        when (Extension_Action_Condition::TOP_SWITCH + 7)
          for target in targets
            new_targets.push(target) if target != @battler
          end
          targets = new_targets
        end
      end
    end
    return targets
  end
  #--------------------------------------------------------------------------
  # ○ 条件ターゲットの作成
  #--------------------------------------------------------------------------
  def make_conditions_targets
    return if @forcing
    c_targets = conditions_targets(@target_conditions_arrays, skill)
    if c_targets != []
      target = roulette(c_targets)
      @target_index = target.index
    end
  end
  #--------------------------------------------------------------------------
  # ○ 条件ターゲット専用、ターゲットルーレット
  #--------------------------------------------------------------------------
  #  ターゲットグループから条件にあったターゲットを選出する為の
  #  専用ルーレットです。
  #--------------------------------------------------------------------------
  def roulette(targets)
    return nil if targets == []
    if Extension_Action_Condition::USE_RANDOM_TARGET
    #- random_targetメソッドを流用する場合
       
      $game_condition_members.targets = targets
      result_target = $game_condition_members.random_target
      unless result_target.frequent_target?  # <頻繁>以外は再ルーレット
        result_target = $game_condition_members.random_target
      end
      if result_target.rare_target?          # <極稀>なら再ルーレット
        result_target = $game_condition_members.random_target
      end
      return result_target
      
    else
    #- このメソッド内で独自の処理をする場合
      
      result_target = nil
      roulette = []
      for target in targets
        target.odds.times do
          roulette.push(target)
        end
      end
      result_target = roulette[rand(roulette.size)]
      unless result_target.frequent_target?  # <頻繁>以外は再ルーレット
        result_target = roulette[rand(roulette.size)]
      end
      if result_target.rare_target?          # <極稀>なら再ルーレット
        result_target = roulette[rand(roulette.size)]
      end
      return result_target
      
    end
  end
end
  
#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。このクラスは Game_Troop クラス ($game_troop) の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ◎ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tig_eac_initialize initialize
  def initialize(index, enemy_id)
    tig_eac_initialize(index, enemy_id)
    set_new_condition_type
  end
  #--------------------------------------------------------------------------
  # ○ ターゲット消失時の再行動タイプの取得
  #--------------------------------------------------------------------------
  def re_action_type
    return 0 if enemy.note.include?("<無鉄砲>")
    return 1 if enemy.note.include?("<好戦的>")
    return 2 if enemy.note.include?("<慎重派>")
    return Extension_Action_Condition::RE_ACTION_TYPE_DEFAULT
  end
  #--------------------------------------------------------------------------
  # ○ 追加行動条件のセット
  #--------------------------------------------------------------------------
  def set_new_condition_type
    for action in enemy.actions
      if action.condition_type == 6
        if Extension_Action_Condition::SWITCHES_RANGE.include?(action.condition_param1)
          action.condition_type = 7
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 行動条件合致判定（行動条件配列使用）
  #--------------------------------------------------------------------------
  def array_conditions_met?(arrays, skill)
    for array in arrays
      case array[0]
      when 1  # ターン数
        n = $game_troop.turn_count
        a = array[1]
        b = array[2]
        return false if (b == 0 and n != a)
        return false if (b > 0 and (n < 1 or n < a or n % b != a % b))
      when 2  # HP
        hp_rate = hp * 100.0 / maxhp
        return false if hp_rate < array[1]
        return false if hp_rate > array[2]
      when 3  # MP
        mp_rate = mp * 100.0 / maxmp
        return false if mp_rate < array[1]
        return false if mp_rate > array[2]
      when 4  # ステート
        return false unless state?(array[1])
      when 5  # パーティレベル
        return false if $game_party.max_level < array[1]
      when 6  # スイッチ
        switch_id = array[1]
        return false if $game_switches[switch_id] == false
      when 7  # 拡張行動条件合致判定
        return false if ex_conditions_met?(array[1], skill) == false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 拡張行動条件合致判定
  #--------------------------------------------------------------------------
  def ex_conditions_met?(conditions, skill)
    index = conditions - Extension_Action_Condition::TOP_SWITCH
    case index
    when 5
      if skill != nil and skill.for_friend?
        return false if $game_troop.preemptive
       else
        return false if $game_troop.surprise
      end
    when 8
      return false if @action.friends_unit.dead_members != []
    when 9
      return false if @action.friends_unit.existing_members.size != 1
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ○ 行動条件配列のセット
  #--------------------------------------------------------------------------
  #  ひとつの行動で複数の条件をあつかう為、
  #  後に続く追加行動条件を取得し、配列化して整理します。
  #--------------------------------------------------------------------------
  def set_conditions_arrays(index)
    action = enemy.actions[index]
    action.conditions_arrays = []
    for n in index...enemy.actions.size
      sub_action = enemy.actions[n]
      unless n == index
        break if sub_action.skill_id != Extension_Action_Condition::ADDITION_CONDITION_SKILL
      end
      array = [sub_action.condition_type, sub_action.condition_param1, sub_action.condition_param2]
      action.conditions_arrays.push(array)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成（再定義）
  #--------------------------------------------------------------------------
  def make_action
    @action.clear
    return unless movable? # 行動不能なら中止
    
    #- 初期化
    available_actions = []
    rating_max = 0
    high_rating = 0
    actions_roulette = []
    
    #- 行動リストから行動候補を選出する
    for i in 0...enemy.actions.size
      #- 準備
      action = enemy.actions[i]                     
      skill = action.kind == 1 ? $data_skills[action.skill_id] : nil  
      next if action.kind == 1 and skill.id == Extension_Action_Condition::ADDITION_CONDITION_SKILL
                               # 追加行動条件用項目(ダミースキル)の場合は飛ばす       
      set_conditions_arrays(i) if action.conditions_arrays.nil?
      arrays = action.conditions_arrays
      
      #- 条件を満たさない場合は次の行動候補へ
      next if @action.conditions_targets(arrays, skill) == []  # ターゲット無し
      next unless array_conditions_met?(arrays, skill)         # 行動条件
      next unless skill_can_use?(skill) if action.kind == 1    # スキル使用不可
      
      #- 行動候補へ
      if Extension_Action_Condition::CONDITION_ROULETTE  # ルーレット方式の場合
        next if action.rating < high_rating              # 昇順のみ登録
        action.rating.times do
          actions_roulette.push(action)
        end
        high_rating = action.rating
      else                                               # 本来の処理
        available_actions.push(action)
        rating_max = [rating_max, action.rating].max
      end
    end
    
    #- 行動の決定
    if Extension_Action_Condition::CONDITION_ROULETTE    # ルーレット方式の場合
      return if actions_roulette.empty?
      action = actions_roulette[rand(actions_roulette.size)]
      @action.kind = action.kind
      @action.basic = action.basic
      @action.skill_id = action.skill_id
      @action.decide_random_target
      @action.target_conditions_arrays = action.conditions_arrays
    else                                                 # 本来の処理
      ratings_total = 0
      rating_zero = rating_max - 3
      for action in available_actions
        next if action.rating <= rating_zero
        ratings_total += action.rating - rating_zero
      end
      return if ratings_total == 0
      value = rand(ratings_total)
      for action in available_actions
        next if action.rating <= rating_zero
        if value < action.rating - rating_zero
          @action.kind = action.kind
          @action.basic = action.basic
          @action.skill_id = action.skill_id
          @action.decide_random_target
          @action.target_conditions_arrays = action.conditions_arrays
          return
        else
          value -= action.rating - rating_zero
        end
      end
    end
  end
end

#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　敵グループおよび戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_troop で参照されます。
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # ○ 公開インスタンス変数
  #-------------------------------------------------------------------------- 
  attr_accessor :appoint_target      # ターゲット指定
  #--------------------------------------------------------------------------
  # ◎ オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tig_eac_initialize initialize
  def initialize
    tig_eac_initialize
    @appoint_target = []
  end
end

#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ◎ 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias tig_eac_create_game_objects create_game_objects
  def create_game_objects
    tig_eac_create_game_objects
    $game_condition_members          = Game_Condition_Members.new
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ◎ 戦闘行動の実行
  #  ※ 行動直前にターゲットを再選択する処理を追加。
  #--------------------------------------------------------------------------
  alias tig_eac_execute_action execute_action
  def execute_action
    unless @active_battler.actor?
      @active_battler.action.make_conditions_targets
    end
    tig_eac_execute_action
  end
  #--------------------------------------------------------------------------
  # ◎ 戦闘行動の実行 : スキル
  #  ※ ターゲット消失時の再行動処理を追加。
  #--------------------------------------------------------------------------
  alias tig_eac_execute_action_skill execute_action_skill
  def execute_action_skill
    unless @active_battler.actor?
      arrays = @active_battler.action.target_conditions_arrays
      skill = @active_battler.action.skill
      if @active_battler.action.conditions_targets(arrays, skill) == []
        unless @active_battler.action.forcing
          case @active_battler.re_action_type
          when 1 # 好戦的タイプ
            @active_battler.action.set_attack
            @active_battler.action.skill_id = 0
            return execute_action_attack
          when 2 # 慎重派タイプ
            @active_battler.action.skill_id = 0
            @active_battler.action.kind = 0
            @active_battler.action.basic = 3
            return execute_action_wait
          end
        end
      end
    end
    tig_eac_execute_action_skill
  end
end
