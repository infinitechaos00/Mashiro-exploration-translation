#==============================================================================
# ■ [010] 装備/ステート 特殊オプション
#------------------------------------------------------------------------------
# <> UKRA's scripted region: http://ukrascriptvx.bufsiz.jp/
# ※ 《コア機能スクリプト》の導入が必須です。
#------------------------------------------------------------------------------
#   残りHPが特定の区間（％指定）にある場合、与ダメージや被ダメージに補正を掛ける
# スクリプトです。以下の機能を搭載しています。
#------------------------------------------------------------------------------
#   全て \d_opt[キーワード, 残HP区間開始%, 残HP区間終了%, 効果%] で表記します。
#   例：\d_opt[power,0,30,60]    → 残りHP 0～30%の時 与ダメージ+30%
#       \d_opt[shield,80,100,20] → 残りHP 80～100%の時 被ダメージ-20%
#       \d_opt[absorb,0,30,20]   → 残りHP 0～30%の時 与ダメージの20%を回復
#------------------------------------------------------------------------------
# ◆パワフル：ダメージの増幅   キーワード：power   \d_opt[power,0,30,n]
#   残りHPが指定の区間にある場合、与ダメージを n % 増幅します。
#------------------------------------------------------------------------------
# ◆シールド：ダメージの軽減   キーワード：shield    \d_opt[shield,0,30,n]
#   残りHPが指定の区間にある場合、被ダメージを n % 軽減します。
#------------------------------------------------------------------------------
# ◆アブソーブ：ダメージの吸収   キーワード：absorb     \d_opt[absorb,0,30,50]
#   残りHPが指定の区間にある場合、与ダメージの n % を回復します。
#   この回復量は、「スパイク」の反射ダメージと合算されます。
#------------------------------------------------------------------------------
# ◆リカバー：回復量の増幅     キーワード：recover  \d_opt[recover,0,30,50]
#   残りHPが指定の区間にある場合、受ける回復効果を n % 増幅します。
#------------------------------------------------------------------------------
# ◆スパイク：ダメージの反射   キーワード：spike   \d_opt[spike,80,100,20]
#   残りHPが指定の区間にある場合、被ダメージの n % を相手にも与えます。
#   このダメージ量は、「アブソーブ」の吸収効果と合算されます。
#------------------------------------------------------------------------------
# ◆クリティカル：クリティカル率補正   キーワード：cri   \d_opt[cri,0,30,20]
#   残りHPが指定の区間にある場合、クリティカル発生率が n % 増加します。
#------------------------------------------------------------------------------
# ◆イベイド：物理回避率補正   キーワード：eva   \d_opt[eva,0,30,10]
#   残りHPが指定の区間にある場合、物理攻撃に対する回避率が n % 増加します。
#------------------------------------------------------------------------------
# ◆ステート：ステートの付与、治療    キーワード：state
#   残りHPが指定の区間外から指定の区間に突入した場合、効果% で指定したIDの
# ステートについて、以下の効果を適用します。複数記述で複数を同時に適用。
#   (1) 効果% が正の数→そのステートを付与する  例：\d_opt[state,0,25,9]
#   (2) 効果% が負の数→そのステートを解除する  例：\d_opt[state,0,25,-2]
#==============================================================================

#==============================================================================
# ◆ver 1.10: 「撃破時オプション」の追加
#   \b_opt[word,x]で指定する、敵を攻撃で撃破した時の追加効果を得るオプションを
# 作成します。
#------------------------------------------------------------------------------
# ◆倒すとＨＰ回復　キーワード：hpheal   \b_opt[hpheal,30]
#   攻撃で敵を倒すと、ＨＰを最大HPに対してx[%]だけ回復します。
#     \b_opt[hpheal,30] → 敵を１体倒すごとにＨＰを最大値の３０％回復
#------------------------------------------------------------------------------
# ◆倒すとＭＰ回復  キーワード：mpheal   \b_opt[mpheal,30]
#   攻撃で敵を倒すと、ＭＰを最大値に対してx[%]だけ回復します。
#     \b_opt[mpheal,30] → 敵を１体倒すごとにＭＰを最大値の３０％回復
#------------------------------------------------------------------------------
# ◆倒すとステートゲット  キーワード：state   \b_opt[state,9]
#   攻撃で敵を倒すと、ステートID x番のステートを得ます。
#   xに負の数を指定すると、そのステートを解除します。
#   また、xに0を指定すると、戦闘不能を含む、データ上に存在する
# 全てのステートを解除します。
#     \b_opt[state,9]  → 敵を１体倒すごとに、自分は９番のステートを得る
#     \b_opt[state,-2] → 敵を１体倒すごとに、自分は２番のステートを解除する
#     \b_opt[state,0]  → 敵を１体倒すごとに、自分は全てのステートを解除する
#------------------------------------------------------------------------------
# ◆倒した敵にステートを与える    \b_opt[gstate,2]
#   攻撃で敵を倒すと、その敵にx番のステートを与えます。
#   倒した敵に対して経験値増のステートを与える時などに使えるかと思い実装。
#==============================================================================

if $ukra_system == nil
  $ukra_system = {}
end
$ukra_system[10] = true


#==============================================================================
# ■ module UKRA_010
#==============================================================================
module UKRA_010
  #--------------------------------------------------------------------------
  # ○ カスタマイズポイント
  #--------------------------------------------------------------------------
  # ◆「パワフル」効果の上限　ダメージは何％まで底上げできる？
  POWERFUL_MAX  = 1000
  # ◆「シールド」効果の下限　ダメージは何％までカットできる？
  SHIELD_MIN    = 100
  # ◆「リカバー」効果の上限　回復量は何％まで底上げできる？
  RECOVER_MAX   = 100
  # ◆「リカバー」効果の下限　回復量は何％までカットされる？
  RECOVER_MIN   = 100
  # ◆ ダメージオプションの略語
  WORD_POWERFUL = "power"
  WORD_SHIELD   = "shield"
  WORD_ABSORB   = "absorb"
  WORD_RECOVERY = "recover"
  WORD_STATE    = "state"
  WORD_SPIKE    = "spike"
  WORD_CRITICAL = "cri"
  WORD_EVADE    = "eva"
  # ◆ バスターオプションの略語
  WORD_B_HPHEAL = "hpheal"
  WORD_B_MPHEAL = "mpheal"
  WORD_B_STATE  = "state"
  WORD_B_GIVEST = "gstate"
  #--------------------------------------------------------------------------
  # ○ 正規表現
  #--------------------------------------------------------------------------
  D_OPTION = /\\d_opt\[(.*)\s*,\s*([\d]+)\s*,\s*([\d]+)\s*,\s*([+-]?[\d]+)\]/i
  B_OPTION = /\\b_opt\[(.*)\s*,\s*([+-]?[\d]+)\]/i
  LASTLEAV = /\\lastleave/i
  #--------------------------------------------------------------------------
  # ○ D-OPTION取得
  #--------------------------------------------------------------------------
  def create_d_option
    @d_power, @d_shield, @d_absorb, @d_recover, @d_state, @d_destate, @d_spike = [], [], [], [], [], [], []
    @d_cri, @d_eva = [], []
    #------------------------------------------------------------------------
    # ◆ データ処理
    #------------------------------------------------------------------------
    @note.gsub(/#{D_OPTION}/) {
      case $1
      when WORD_POWERFUL
        @d_power.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_SHIELD
        @d_shield.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_ABSORB
        @d_absorb.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_RECOVERY
        @d_recover.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_STATE
        if $4.to_i > 0
          @d_state.push([$2.to_i, $3.to_i, $4.to_i])
        else
          @d_destate.push([$2.to_i, $3.to_i, $4.to_i.abs])
        end
      when WORD_SPIKE
        @d_spike.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_CRITICAL
        @d_cri.push([$2.to_i, $3.to_i, $4.to_i])
      when WORD_EVADE
        @d_eva.push([$2.to_i, $3.to_i, $4.to_i])
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ B-OPTION 取得
  #--------------------------------------------------------------------------
  def create_b_option
    @b_hpheal, @b_mpheal, @b_astate, @b_dstate, @b_gstate = [], [], [], [], []
    #------------------------------------------------------------------------
    # ◆ データ作成
    #------------------------------------------------------------------------
    @note.gsub(/#{B_OPTION}/) {
      case $1
      when WORD_B_HPHEAL
        @b_hpheal.push($2.to_i)
      when WORD_B_MPHEAL
        @b_mpheal.push($2.to_i)
      when WORD_B_STATE
        if $2.to_i > 0
          @b_astate.push($2.to_i.abs)
        elsif $2.to_i < 0
          @b_dstate.push($2.to_i.abs)
        else
          for i in 1...$data_states.size do @b_dstate.push(i) end
        end
      when WORD_B_GIVEST
        @b_gstate.push($2.to_i.abs)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ○ その他のキャッシュ作成
  #--------------------------------------------------------------------------
  def create_othercache
    @lastleave = false
    @note.gsub(/#{LASTLEAV}/) do @lastleave = true end
  end
  #--------------------------------------------------------------------------
  # ○ パワフル
  #--------------------------------------------------------------------------
  def d_powerful
    create_d_option if @d_power == nil
    return @d_power
  end
  #--------------------------------------------------------------------------
  # ○ シールド
  #--------------------------------------------------------------------------
  def d_shield
    create_d_option if @d_shield == nil
    return @d_shield
  end
  #--------------------------------------------------------------------------
  # ○ アブソーブ
  #--------------------------------------------------------------------------
  def d_absorb
    create_d_option if @d_absorb == nil
    return @d_absorb
  end
  #--------------------------------------------------------------------------
  # ○ リカバリー
  #--------------------------------------------------------------------------
  def d_recovery
    create_d_option if @d_recover == nil
    return @d_recover
  end
  #--------------------------------------------------------------------------
  # ○ ステート
  #--------------------------------------------------------------------------
  def d_state
    create_d_option if @d_state == nil
    return @d_state
  end
  #--------------------------------------------------------------------------
  # ○ ステート解除
  #--------------------------------------------------------------------------
  def d_destate
    create_d_option if @d_destate == nil
    return @d_destate
  end
  #--------------------------------------------------------------------------
  # ○ スパイク
  #--------------------------------------------------------------------------
  def d_spike
    create_d_option if @d_spike == nil
    return @d_spike
  end
  #--------------------------------------------------------------------------
  # ○ クリティカル率補正
  #--------------------------------------------------------------------------
  def d_critical
    create_d_option if @d_cri == nil
    return @d_cri
  end
  #--------------------------------------------------------------------------
  # ○ 回避率補正
  #--------------------------------------------------------------------------
  def d_evade
    create_d_option if @d_eva == nil
    return @d_eva
  end
  #--------------------------------------------------------------------------
  # ○ ラストリーブ
  #--------------------------------------------------------------------------
  def lastleave
    create_othercache if @lastleave == nil
    return @lastleave
  end
  #--------------------------------------------------------------------------
  # ○ 倒してＨＰ回復
  #--------------------------------------------------------------------------
  def b_hpheal
    create_b_option if @b_hpheal == nil
    return @b_hpheal
  end
  #--------------------------------------------------------------------------
  # ○ 倒してＭＰ回復
  #--------------------------------------------------------------------------
  def b_mpheal
    create_b_option if @b_mpheal == nil
    return @b_mpheal
  end
  #--------------------------------------------------------------------------
  # ○ 倒してステートゲット
  #--------------------------------------------------------------------------
  def b_astate
    create_b_option if @b_astate == nil
    return @b_astate.uniq
  end
  #--------------------------------------------------------------------------
  # ○ 倒してステート解除
  #--------------------------------------------------------------------------
  def b_dstate
    create_b_option if @b_dstate == nil
    return @b_dstate.uniq
  end
  #--------------------------------------------------------------------------
  # ○ 倒した敵にステートを与える
  #--------------------------------------------------------------------------
  def b_gstate
    create_b_option if @b_gstate == nil
    return @b_gstate.uniq
  end
end


class RPG::BaseItem
  include UKRA_010
end

class RPG::UsableItem < RPG::BaseItem
  include UKRA_010
end

class RPG::State
  include UKRA_010
end

class RPG::Enemy
  include UKRA_010
end


class Game_Battler
  attr_accessor   :absorbed_hp
  attr_accessor   :absorbed_mp
  attr_accessor   :jbhp
  alias ukra010_bt_initialize initialize
  def initialize
    ukra010_bt_initialize
    @jbhp        = 0
    @absorbed_hp = 0
    @absorbed_mp = 0
  end
  alias ukra010_bt_car clear_action_results
  def clear_action_results
    ukra010_bt_car
    @jbhp        = 0
    @absorbed_hp = 0
    @absorbed_mp = 0
  end
  #--------------------------------------------------------------------------
  # ○ ＨＰ区間一致の計算
  #--------------------------------------------------------------------------
  def calc_hp_range(fig, m, n, type)
    a = maxhp * [m, n].max / 100
    b = maxhp * [m, n].min / 100
    if type == true
      result = (fig >= b && fig <= a)
    elsif type == false
      result = (fig > a or fig < b)
    else
      result = false
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ○ D-OPTION / 本人性能の参照要綱
  #--------------------------------------------------------------------------
  def base_d_option
    return []
  end
  #--------------------------------------------------------------------------
  # ○ B-OPTION / 本人性能の参照
  #--------------------------------------------------------------------------
  def base_b_option
    return []
  end
  #--------------------------------------------------------------------------
  # ○ パワフル計算結果
  #--------------------------------------------------------------------------
  def calc_d_powerful
    n = 100
    # ◆ 装備品
    a = []
    for item in equips.compact
      for i in item.d_powerful.compact do a.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    a_con = (a.size == 0 ? 100 : a.max)
    
    # ◆ ステート
    b = []
    for state in states.compact
      for i in state.d_powerful.compact do b.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    b_con = (b.size == 0 ? 100 : b.max)
    
    # ◆ 本人性能
    c = []
    for obj in self.base_d_option.compact
      for i in obj.d_powerful.compact do c.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    c_con = (c.size == 0 ? 100 : c.max)
    
    # ◆ 行使アビリティ
    d = []
    for obj in [@action.skill, @action.item].compact
      for i in obj.d_powerful.compact do d.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    d_con = (d.size == 0 ? 100 : d.max)
    
    # ◆合算結果
    return [[n*a_con*b_con*c_con*d_con/100000000, UKRA_010::POWERFUL_MAX].min, 1].max
  end
  #--------------------------------------------------------------------------
  # ○ シールド計算結果
  #--------------------------------------------------------------------------
  def calc_d_shield
    n = 100
    # ◆ 装備品
    a = []
    for item in equips.compact
      next if item == nil
      for i in item.d_shield.compact do a.push(100-i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    a_con = (a.size == 0 ? 100 : a.min)
    
    # ◆ ステート
    b = []
    for state in states.compact
      for i in state.d_shield.compact do b.push(100-i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    b_con = (b.size == 0 ? 100 : b.min)
    
    # ◆ 本人性能
    c = []
    for obj in self.base_d_option.compact
      for i in obj.d_shield.compact do c.push(100-i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    c_con = (c.size == 0 ? 100 : c.min)
    
    # ◆ 行使アビリティ
    d = []
    for obj in [@action.skill, @action.item].compact
      for i in obj.d_shield.compact do d.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    d_con = (d.size == 0 ? 100 : d.max)
    
    # ◆合算結果
    return [n*a_con*b_con*c_con*d_con/100000000, UKRA_010::SHIELD_MIN].max
  end
  #--------------------------------------------------------------------------
  # ○ アブソーブ計算結果
  #--------------------------------------------------------------------------
  def calc_d_absorb
    n = 100
    # ◆ 装備品
    a = []
    for item in equips.compact
      next if item == nil
      for i in item.d_absorb.compact do a.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    a_con = (a.size == 0 ? 100 : a.max)
    
    # ◆ ステート
    b = []
    for state in states.compact
      for i in state.d_absorb.compact do b.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    b_con = (b.size == 0 ? 100 : b.max)
    
    # ◆ 本人性能
    c = []
    for obj in self.base_d_option.compact
      for i in obj.d_absorb.compact do c.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    c_con = (c.size == 0 ? 100 : c.max)
    
    # ◆ 行使アビリティ
    d = []
    for obj in [@action.skill, @action.item].compact
      for i in obj.d_absorb.compact do d.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    d_con = (d.size == 0 ? 100 : d.max)
    
    # ◆合算結果
    return (n*a_con*b_con*c_con*d_con / 100000000 - 100)
  end
  #--------------------------------------------------------------------------
  # ○ リカバリー計算結果
  #--------------------------------------------------------------------------
  def calc_d_recovery
    n = 100
    # ◆ 装備品
    a = []
    for item in equips.compact
      for i in item.d_recovery.compact do a.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    a_con = (a.size == 0 ? 100 : a.max)
    
    # ◆ ステート
    b = []
    for state in states.compact
      for i in state.d_recovery.compact do b.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    b_con = (b.size == 0 ? 100 : b.max)
    
    # ◆ 本人性能
    c = []
    for obj in self.base_d_option.compact
      for i in obj.d_recovery.compact do c.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    c_con = (c.size == 0 ? 100 : c.max)
    
    # ◆ 行使アビリティ
    d = []
    for obj in [@action.skill, @action.item].compact
      for i in obj.d_recovery.compact do d.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    d_con = (d.size == 0 ? 100 : d.max)
    
    # ◆合算結
    return [[n*a_con*b_con*c_con*d_con/100000000, UKRA_010::RECOVER_MAX].min, UKRA_010::RECOVER_MIN].max
  end
  #--------------------------------------------------------------------------
  # ○ スパイク計算結果
  #--------------------------------------------------------------------------
  def calc_d_spike
    n = 100
    # ◆ 装備品
    a = []
    for item in equips.compact
      for i in item.d_spike.compact do a.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    a_con = (a.size == 0 ? 100 : a.max)
    
    # ◆ ステート
    b = []
    for state in states.compact
      for i in state.d_spike.compact do b.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    b_con = (b.size == 0 ? 100 : b.max)
    
    # ◆ 本人性能
    c = []
    for obj in self.base_d_option.compact
      for i in obj.d_spike.compact do c.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    c_con = (c.size == 0 ? 100 : c.max)
    
    # ◆ 行使アビリティ
    d = []
    for obj in [@action.skill, @action.item].compact
      for i in obj.d_spike.compact do d.push(100+i[2]) if calc_hp_range(@hp, i[0], i[1], true) end
    end
    d_con = (d.size == 0 ? 100 : d.max)
    
    # ◆合算結果
    return (n * a_con * b_con * c_con * d_con / 100000000 - 100)
  end
  #--------------------------------------------------------------------------
  # ○ ピンチにステート的な
  #--------------------------------------------------------------------------
  def set_reactive_states
    unless @jbhp
      @jbhp = @hp
    end
    for obj in (equips+states+base_d_option+[@action.skill, @action.item]).compact
      for i in obj.d_destate.compact
        if calc_hp_range(@jbhp, i[0], i[1], false) && calc_hp_range(@hp, i[0], i[1], true)
          if state?(i[2])
            remove_state(i[2])
            @removed_states.push(i[2])
          end
        end
      end
      for i in obj.d_state.compact
        if calc_hp_range(@jbhp, i[0], i[1], false) && calc_hp_range(@hp, i[0], i[1], true)
          unless state?(i[2])
            add_state(i[2])
            @added_states.push(i[2])
          end
        end
      end
    end
    for state in states.dup
      if state.lastleave && @hp == 0
        remove_state(1)
        remove_state(state.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ B-OPTIONの効果適用
  #--------------------------------------------------------------------------
  def set_buster_option(target)
    for obj in (equips+states+base_b_option+[@action.skill, @action.item]).compact
      #------------------------------------------------------------------------
      # 倒すとステート解除
      #------------------------------------------------------------------------
      for i in obj.b_dstate.compact
        if state?(i)
          remove_state(i)
          @removed_states.push(i)
        end
      end
      #------------------------------------------------------------------------
      # 倒すとＨＰ回復
      #------------------------------------------------------------------------
      for i in obj.b_hpheal.compact do target.absorbed_hp += maxhp * i / 100 end
      #------------------------------------------------------------------------
      # 倒すとＭＰ回復
      #------------------------------------------------------------------------
      for i in obj.b_mpheal.compact do target.absorbed_mp += maxmp * i / 100 end
      #------------------------------------------------------------------------
      # 倒すとステートゲット
      #------------------------------------------------------------------------
      for i in obj.b_astate.compact
        unless state?(i)
          add_state(i)
          @added_states.push(i)
        end
      end
      #------------------------------------------------------------------------
      # 倒した敵にステートを与える
      #------------------------------------------------------------------------
      for obj in (equips+states+base_b_option+[@action.skill, @action.item]).compact
        for i in obj.b_gstate.compact
          unless target.state?(i)
            target.add_state(i)
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージの反映
  #     user : スキルかアイテムの使用者
  #    呼び出し前に @hp_damage、@mp_damage、@absorbed が設定されていること。
  #--------------------------------------------------------------------------
  alias ukra010_bt_execute_damage execute_damage
  def execute_damage(user)
    # 反応ステート用
    @jbhp = @hp
    user.jbhp = user.hp
    # HPダメージ　パワフル＆シールド
    if @hp_damage > 0
      @hp_damage = @hp_damage * user.calc_d_powerful / 100
      @hp_damage = @hp_damage * calc_d_shield / 100
    # HP回復  リカバー
    elsif @hp_damage < 0
      @hp_damage = @hp_damage * calc_d_recovery / 100
    end
    # MPダメージ　パワフル＆シールド
    if @mp_damage > 0
      @mp_damage = @mp_damage * user.calc_d_powerful / 100
      @mp_damage = @mp_damage * calc_d_shield / 100
    # MP回復  リカバー
    elsif @mp_damage < 0
      @mp_damage = @mp_damage * calc_d_recovery / 100
    end
    # HP/MPダメージ　スパイク
    if calc_d_spike != 0
      hp_spike, mp_spike = 0, 0
      hp_spike = @hp_damage * calc_d_spike / 100 if @hp_damage > 0
      mp_spike = @mp_damage * calc_d_spike / 100 if @mp_damage > 0
      @absorbed_hp -= hp_spike * calc_d_powerful * user.calc_d_shield / 10000
      @absorbed_mp -= mp_spike * calc_d_powerful * user.calc_d_shield / 10000
    end
    # HP/MPダメージ　アブソーブ
    if user.calc_d_absorb != 0
      @absorbed_hp = @hp_damage * user.calc_d_absorb / 100 if @hp_damage > 0
      @absorbed_mp = @mp_damage * user.calc.d_absorb / 100 if @mp_damage > 0
    end
    # 従来のダメージ処理
    ukra010_bt_execute_damage(user)
    # 条件反応によるステート付与
    set_reactive_states
    # 攻撃対象は倒されてしまったかの確認
    if @hp == 0 && @jbhp > 0
      user.set_buster_option(self)    # 撃破時オプションの適用
    end
    # アブソーブ／スパイクの処理
    user.hp += @absorbed_hp if @absorbed_hp != 0
    user.mp += @absorbed_mp if @absorbed_mp != 0
    user.set_reactive_states
  end
end


class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ○ 本人性能の参照
  #--------------------------------------------------------------------------
  def base_d_option
    # パッシブスキルを読み込む
    result = []
    for i in skills
      result.push(i) if i.passive_skill
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 回避率の取得
  #--------------------------------------------------------------------------
  alias ukra010_dopt_actor_eva eva
  def eva
    n = ukra010_dopt_actor_eva
    m = 0
    for item in (equips+states+base_d_option+[@action.skill,@action.item]).compact
      for i in item.d_evade.compact do m += i[2] if calc_hp_range(@hp, i[0], i[1], true) end
    end
    return [n+m, n].max
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias ukra010_dopt_actor_cri cri
  def cri
    n = ukra010_dopt_actor_cri
    m = 0
    for item in (equips+states+base_d_option+[@action.skill,@action.item]).compact
      for i in item.d_critical.compact do m += i[2] if calc_hp_range(@hp, i[0], i[1], true) end
    end
    return [n+m, n].max
  end
end


class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ○ 本人性能の参照
  #--------------------------------------------------------------------------
  def base_d_option
    return [enemy]
  end
end


class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 攻撃
  #--------------------------------------------------------------------------
  def execute_action_attack
    text = sprintf(Vocab::DoAttack, @active_battler.name)
    @message_window.add_instant_text(text)
    targets = @active_battler.action.make_targets
    display_attack_animation(targets)
    wait(20)
    for target in targets
      target.attack_effect(@active_battler)
      display_action_effects(target)
      display_absorb_damage(target) if target.absorbed_hp != 0 or target.absorbed_mp != 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : スキル
  #--------------------------------------------------------------------------
  def execute_action_skill
    skill = @active_battler.action.skill
    text = @active_battler.name + skill.message1
    @message_window.add_instant_text(text)
    unless skill.message2.empty?
      wait(10)
      @message_window.add_instant_text(skill.message2)
    end
    targets = @active_battler.action.make_targets
    display_animation(targets, skill.animation_id)
    @active_battler.mp -= @active_battler.calc_mp_cost(skill)
    $game_temp.common_event_id = skill.common_event_id
    for target in targets
      target.skill_effect(@active_battler, skill)
      display_action_effects(target, skill)
      display_absorb_damage(target) if target.absorbed_hp != 0 or target.absorbed_mp != 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : アイテム
  #--------------------------------------------------------------------------
  def execute_action_item
    item = @active_battler.action.item
    text = sprintf(Vocab::UseItem, @active_battler.name, item.name)
    @message_window.add_instant_text(text)
    targets = @active_battler.action.make_targets
    display_animation(targets, item.animation_id)
    $game_party.consume_item(item)
    $game_temp.common_event_id = item.common_event_id
    for target in targets
      target.item_effect(@active_battler, item)
      display_action_effects(target, item)
      display_absorb_damage(target) if target.absorbed_hp != 0 or target.absorbed_mp != 0
    end
  end
  #--------------------------------------------------------------------------
  # ● アブソーブダメージの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_absorb_damage(target)
    display_hp_absorb_damage(target) if target.absorbed_hp != 0
    display_mp_absorb_damage(target) if target.absorbed_mp != 0
    display_state_changes(@active_battler)
  end
  #--------------------------------------------------------------------------
  # ● アブソーブ HP ダメージ表示
  #     target : 対象者
  #--------------------------------------------------------------------------
  def display_hp_absorb_damage(target)
    return if @active_battler.dead?
    return if target.absorbed_hp == 0
    if target.absorbed_hp > 0
      fmt = @active_battler.actor? ? Vocab::ActorRecovery : Vocab::EnemyRecovery
      text = sprintf(fmt, @active_battler.name, Vocab::hp, target.absorbed_hp)
      Sound.play_recovery
    else
      if @active_battler.actor?
        text = sprintf(Vocab::ActorDamage, @active_battler.name, -target.absorbed_hp)
        Sound.play_actor_damage
        $game_troop.screen.start_shake(5, 5, 10)
      else
        text = sprintf(Vocab::EnemyDamage, @active_battler.name, -target.absorbed_hp)
        Sound.play_enemy_damage
        @active_battler.blink = true
      end
    end
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● アブソーブ MP ダメージ表示
  #     target : 対象者
  #--------------------------------------------------------------------------
  def display_mp_absorb_damage(target)
    return if @active_battler.dead?
    return if target.absorbed_mp == 0
    if @active_battler.absorbed_mp > 0
      fmt = @active_battler.actor? ? Vocab::ActorRecovery : Vocab::EnemyRecovery
      text = sprintf(fmt, @active_battler.name, Vocab::mp, target.absorbed_mp)
      Sound.play_recovery
    else
      fmt = @active_battler.actor? ? Vocab::ActorLoss : Vocab::EnemyLoss
      text = sprintf(fmt, @active_battler.name, Vocab::mp, -target.absorbed_mp)
    end
    @message_window.add_instant_text(text)
    wait(30)
  end
end