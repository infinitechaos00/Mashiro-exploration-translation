#==============================================================================
# RGSS2 ■ ParameterBonus(equips only)  一炊の夢、一酔の幻           by Lyu
#　２０１１０９０２　tamuraが改造。
#　２０１２０３２６　改訂。
#==============================================================================
=begin

割合上昇装備
201100902 tamuraがLyu氏のスクリプトを元に製作。
配布元：http://tamurarpgvx.blog137.fc2.com/
配布記事：http://tamurarpgvx.blog137.fc2.com/blog-entry-104.html

Lyu氏の記事
http://www.tekepon.net/fsm/modules/mainbb/viewtopic.php?viewmode=flat&topic_id=1664&forum=5

【使い方】
スクリプトエディタを開き、左のリストを下にスクロール。
（ここに追加）の下で右クリック・挿入。
空白のファイルが新しく出来るので、
右の広い空白の部分にこのファイルを貼り付けます。

【概要】
装備品のパラメータ変化に、以下の機能を付け加えます。
メモ欄に以下の様に記入すると、次の様な効果があります。

最大HP%[10] :最大ＨＰが１０％増加します。
最大MP%[10] :最大ＭＰが１０％増加します。
攻撃力%[10] :攻撃力が１０％増加します。
防御力%[10] :防御力が１０％増加します。
精神力%[10] :精神力が１０％増加します。
敏捷性%[10] :敏捷性が１０％増加します。
魔法防御%[10]：魔法防御が１０％上昇します（下記参照）。
命中率%[10] :命中率が１０％増加します。
回避率%[10] :回避率が１０％増加します。（例えば回避率４％なら、４の１０％上昇で４．４％の回避率となります。）
クリティカル%[10] :クリティカル発生率が１０％増加します。
狙われやすさ%[10] :狙われやすさという値が１０％増加します。

１０の所は自由に変えられます。マイナスを入れれば減少となります。

ここで、例えば攻撃力とは、
基本攻撃力＋装備の攻撃力＋アイテムによる上昇値　の全てを加算した値のことです。

また、％をつけないと、割合ではなく普通に数値上昇となります。

クリティカル[10]

これはクリティカル率が１０上昇します。

割合上昇を複数装備すると、倍々ではなくて上昇率の足し算となります。
＋１０％、＋２０％、－５％を同時に装備すると、
＋１０＋２０－５＝＋２５％　となります。


【魔法防御パラメーター追加】
・本バージョンは、回想領域様（http://kaisouryouiki.web.fc2.com/）作　
　「魔法防御パラメーター追加」に対応しています。
　上記説明を参照して下さい。
・「魔法防御パラメーター追加」の下に、ＫＧＣ殿の「拡張装備画面」「装備拡張」、
　そのさらに下に、回想領域殿の「装備拡張 + 拡張装備画面 + 魔法防御パラメーター追加」、
　本スクリプトはその下に配置して下さい。

=end

#============================================================================
#　LYUモジュール
#　（文字列）%[（数字）]　という場所を読み取る。
#============================================================================
module LYU  
  def self.note_check(obj, check_word, type)
    memo = obj.note.scan(/#{check_word}\[(\S+)\]/) if type == 1
    memo = obj.note.scan(/#{check_word}%\[(\S+)\]/) if type == 2
    memo = memo.flatten    
    return (memo != nil && !memo.empty?) ? memo[0].to_i : 0
  end
end


#============================================================================
#　Game_Actorクラス
#
#============================================================================
class Game_Actor < Game_Battler  
  #===============================================================
  #　装備変更メソッド　の変更。
  #　ＨＰ、ＭＰが最大値を超えていたら修正。
  #===============================================================
  alias hpmp_correction_change_equip change_equip  
  def change_equip(equip_type, item, test = false)    
    hpmp_correction_change_equip(equip_type, item, test)    
    @hp, @mp = [@hp, maxhp].min, [@mp, maxmp].min  
  end  
  #===============================================================
  #　パラメータ加算値計算メソッド。
  #　値を受け取り、装備の修正値を読み取って、数値を修正して返す。
  #   n　：　上昇値の元となる値。　基本能力値　＋　アイテム上昇値。
  #   paraname　：　パラメータ名。概要を参照の事。
  #===============================================================
  def para_plus(n, paraname) 
    m = 0
    l = 0
    ret = 0
    for item in equips.compact      
      l += LYU::note_check(item, paraname, 1)      
      m += LYU::note_check(item, paraname, 2)    
    end
    ret += (n + l) * m / 100.0
    return Integer(ret + l)
  end  
  #===============================================================
  #　パラメータ加算値計算メソッド・アイテム単独。
  #　アクターと装備品を受け取り、装備の上昇値を返す。
  #  ショップで能力値変化を表示するときに使用。
  #   n　：　上昇値の元となる値。　基本能力値　＋　アイテム上昇値。
  #   paraname　：　パラメータ名。概要を参照の事。
  #===============================================================
  def para_plus_mono(paraname,item) 
    m = 0
    l = 0
    ret = 0
    param = 0
    case paraname
    when "攻撃力"
      param = self.base_atk
    when "防御力"
      param = self.base_def
    end
    l += LYU::note_check(item, paraname, 1)      
    m += LYU::note_check(item, paraname, 2)    
    ret += ( param + l) * m / 100.0
    return Integer(ret + l)
  end  
  #===============================================================
  #　基本ＨＰの修正。
  #===============================================================
  alias parabonus_base_maxhp base_maxhp  
  def base_maxhp
    pulus = para_plus(parabonus_base_maxhp + @maxhp_plus , "最大HP")
    return parabonus_base_maxhp + pulus
  end  
  #===============================================================
  #　基本ＭＰの修正。
  #===============================================================
  alias parabonus_base_maxmp base_maxmp  
  def base_maxmp
    pulus = para_plus(parabonus_base_maxmp + @maxmp_plus , "最大MP")
    return parabonus_base_maxmp + pulus
  end  
  #===============================================================
  #　基本攻撃力の修正。
  #===============================================================
  alias parabonus_base_atk base_atk
  def base_atk
    pulus = para_plus(parabonus_base_atk + @atk_plus , "攻撃力")
    return parabonus_base_atk + pulus
  end  
  #===============================================================
  #　基本防御力の修正。
  #===============================================================
  alias parabonus_base_def base_def  
  def base_def
    pulus = para_plus(parabonus_base_def + @def_plus , "防御力")
    return parabonus_base_def + pulus
  end  
  #===============================================================
  #　基本精神力の修正。
  #===============================================================
  alias parabonus_base_spi base_spi  
  def base_spi
    pulus = para_plus(parabonus_base_spi + @spi_plus , "精神力")
    return parabonus_base_spi + pulus
  end  
  #===============================================================
  #　基本敏捷性の修正。
  #===============================================================
  alias parabonus_base_agi base_agi  
  def base_agi
    pulus = para_plus(parabonus_base_agi + @agi_plus , "敏捷性")
    return parabonus_base_agi + pulus
  end  
  #===============================================================
  #　命中率の修正。
  #===============================================================
  alias parabonus_hit hit  
  def hit
    pulus = para_plus(parabonus_hit , "命中率")
    return parabonus_hit + pulus
  end  
  #===============================================================
  #　回避率の修正。
  #===============================================================
  alias parabonus_eva eva  
  def eva
    pulus = para_plus(parabonus_eva , "回避率")
    return parabonus_eva + pulus
  end  
  #===============================================================
  #　クリティカルの修正。
  #===============================================================
  alias parabonus_cri cri  
  def cri
    pulus = para_plus(parabonus_cri , "クリティカル")
    return parabonus_cri + pulus
  end  
  #===============================================================
  #　狙われやすさの修正。
  #===============================================================
  alias parabonus_odds odds  
  def odds
    pulus = para_plus(parabonus_odds , "狙われやすさ")
    return parabonus_odds + pulus
  end
end


#==============================================================================
# ■ Window_ShopStatus
#------------------------------------------------------------------------------
# 　ショップ画面で、アイテムの所持数やアクターの装備を表示するウィンドウです。
#==============================================================================
class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● アクターの現装備と能力値変化の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #--------------------------------------------------------------------------
  def draw_actor_parameter_change(actor, x, y)
    return if @item.is_a?(RPG::Item)
    enabled = actor.equippable?(@item)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(x, y, 200, WLH, actor.name)
    if @item.is_a?(RPG::Weapon)
      item1 = weaker_weapon(actor)
    elsif actor.two_swords_style and @item.kind == 0
      item1 = nil
    else
      item1 = actor.equips[1 + @item.kind]
    end
    if enabled
      if @item.is_a?(RPG::Weapon)
        atk1 = item1 == nil ? 0 : item1.atk
        atk1 += actor.para_plus_mono("攻撃力",item1) if item1 != nil
        atk2 = @item == nil ? 0 : @item.atk
        atk2 += actor.para_plus_mono("攻撃力",@item) if @item != nil
        change = atk2 - atk1
      else
        def1 = item1 == nil ? 0 : item1.def
        def1 += actor.para_plus_mono("防御力",item1) if item1 != nil
        def2 = @item == nil ? 0 : @item.def
        def2 += actor.para_plus_mono("防御力",@item) if @item != nil
        change = def2 - def1
      end
      self.contents.draw_text(x, y, 200, WLH, sprintf("%+d", change), 2)
    end
    draw_item_name(item1, x, y + WLH, enabled)
  end
end


class Game_Battler
  #--------------------------------------------------------------------------
  # ● 魔法防御力の設定
  #--------------------------------------------------------------------------
  def mdef=(new_mdef)
    @mdef_plus += new_mdef - self.mdef
    @mdef_plus = [[@mdef_plus, -1 * MDM].max, MDM].min
  end
end

class Game_Actor < Game_Battler  
  #--------------------------------------------------------------------------
  # ● 基本魔法防御力の取得
  #--------------------------------------------------------------------------
  def base_mdef
    n = actor.mdef_parameter(@level)
    for item in equips.compact do n += item.mdef end
    pulus = para_plus(n + @mdef_plus , "魔法防御")
    return n + pulus
  end
end
