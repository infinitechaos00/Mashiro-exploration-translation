=begin
先制確率と不意打ち確率が変動する装備品                2011/07/06  mo-to

ＴＫＯＯＬ　ＣＯＯＬ
http://mototkool.blog.fc2.com/

★概要★
装備することにより戦闘時プレイヤーが先制を取る確率と不意打ちに遭う確率を
変動させる装備品を作れるスクリプトです。
メモ欄の数値を変えることにより装備すると
『不意打ちを完全に防ぐアクセサリ』『先制確率がアップするマント』
『不意打ち確率がアップしてしまうマイナス武器』
『先制と不意打ちが無くなる何だか良く分からない防具』など
組み合わせしだいでいろいろ作れます。

★使用法★
スクリプトの▼ 素材　以下  ▼ メイン　以上にこれをコピーして張り付け
装備品のメモ欄に<先制確率 X%>や<不意打ち確率 X%>などと記入すると
デフォルトの確率にそのX数値分加算される。マイナス(-)の値も可能。
なお、加算した結果、確率が101%以上や-1％以下になった場合、基本的には
それぞれ100%、0%とお考えください。
例1）メモ欄に<先制確率 10%>と記入すると先制確率10%アップ。
例2）メモ欄に<不意打ち確率 10%>と記入すると不意打ち確率10%アップ。
例3）メモ欄に<先制確率 -5%><不意打ち確率 10%>と記入すると
     先制確率5%ダウン、不意打ち確率10%アップ。

↓にツクールデフォルトの先制不意打ち確率を載せて置きますので参考までにどうぞ。　
-----------------------------------------------------------------------------
■デフォルトの先制確率＆不意打ち確率
●プレーヤーの方が敵より敏捷性が高い場合
　先制確率　5%　不意打ち確率　3%
●プレイヤーの方が敵より敏捷性が低い場合
　先制確率　3%　不意打ち確率　5%

※どうやら先制判定を先に行なっているので先制判定が成功した場合
　不意打ち判定が行なわれることはないようです。
　つまり、プレーヤー側がかなり有利な処理のようです。
-----------------------------------------------------------------------------
デフォルトの先制不意打ち確率を変えたい場合は116行目から120行目の数値を
弄って見て下さい。

★注意★
このスクリプトはシンボルエンカウントやボス戦などのイベントを通しての戦闘では
効果がありません。
飽くまでツクールデフォのランダムエンカウントにのみ有効です。
"先制攻撃と不意打ちの確率判定"の"preemptive_or_surprise"を再定義しているので
そこを弄っている場合やエンカウウントの仕様自体を弄っている場合は
高確率で競合します。
=end


class RPG::BaseItem
  #--------------------------------------------------------------------------
  # ○ メモ判定
  #--------------------------------------------------------------------------
  def preemptive_or_surprise_equips_check
    @preempt_check = 0
    @surprise_check = 0
    self.note.each_line { |line|
    case line
    when /<先制確率\s*(\-?\d+)[%％]?>/
      @preempt_check = $1.to_i
    when /<不意打ち確率\s*(\-?\d+)[%％]?>/
      @surprise_check = $1.to_i
    end
    }
  end
  #--------------------------------------------------------------------------
  # ○ preempt_check
  #--------------------------------------------------------------------------
  def preempt_check
    preemptive_or_surprise_equips_check if @preempt_check == nil
    return @preempt_check
  end 
  #--------------------------------------------------------------------------
  # ○ surprise_check
  #--------------------------------------------------------------------------
  def surprise_check
    preemptive_or_surprise_equips_check if @surprise_check == nil
    return @surprise_check
  end  
end

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ○ preempt_checkの取得
  #--------------------------------------------------------------------------
  def preempt_check
    n = 0
    for actor in $game_party.members
      for equip in actor.equips.compact
        n += equip.preempt_check
      end
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ○ surprise_checkの取得
  #--------------------------------------------------------------------------
  def surprise_check
    n = 0
    for actor in $game_party.members
      for equip in actor.equips.compact
        n += equip.surprise_check
      end
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ● 先制攻撃と不意打ちの確率判定 ※再定義
  #--------------------------------------------------------------------------
  def preemptive_or_surprise
    actors_agi = $game_party.average_agi
    enemies_agi = $game_troop.average_agi
    if actors_agi >= enemies_agi
      percent_preemptive = 5
      percent_surprise = 3
    else
      percent_preemptive = 3
      percent_surprise = 5
    end
    
    #デフォのパーセンテージにメモ欄の数値を加算
    percent_preemptive += preempt_check
    percent_surprise += surprise_check
    
    if rand(100) < percent_preemptive
      $game_troop.preemptive = true
    elsif rand(100) < percent_surprise
      $game_troop.surprise = true
    end
  end
end
